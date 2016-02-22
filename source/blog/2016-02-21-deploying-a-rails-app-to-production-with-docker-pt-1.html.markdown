---
title: Deploying a Rails app to production with Docker (pt.1)
date: 2016-02-21 16:00 UTC
tags:
  - docker
  - docker compose
  - ruby on rails
  - google cloud
excerpt:
  Step by step tutorial on how to deploy a Rails app to production and staging with Docker and Docker Compose.
author: javier
---


> Table of contents:
>
> 1. [Motivation]()
> 2. [Requirements and stack]()
> 3. [Installing Docker on OS X](#installing-docker-on-os-x)
> 4. [Creating a Docker image for our Rails project](#creating-a-docker-image-for-our-rails-project)
> 5. [Running the image locally](#running-the-image-locally)
> 6. Pushing the image to a container registry
> 7. Modularizing our Rails app into different containers
> 8. Adding PostgreSQL & Redis with Docker Compose
> 9. Adding a new container for ActionCable
> 10. Keeping our logs safe with Volumes
> 11. Deploying to Google Compute Engine
> 12. Adding SSL / HTTPS


## 1. Motivation

Since we started working with Rails five years ago we've been using different approaches when it comes deploying our Rails apps to production. We started using normal VMs that we would SSH to install all the required packages (ruby, imagemagick, nginx, etc.), then we moved to Heroku for easier deployments, then to [AWS Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk/) for reduced costs, and finally to [AWS OpsWorks](https://aws.amazon.com/opsworks/) for fine grained control thanks to [Chef](https://www.chef.io/) recipes.

The DevOps world feels a little bit like the front-end world, where there new tools everyday and some of them overlap each other. It's hard to make a decision on which one you should use.

As in the JS world, in the DevOps land there is always a new cool kid on the block. Right now it seems that kiddo is Docker.

Docker got some initial traction as a solution for developments environments but it has become a really great tool for production environments

Recently, [Gudog](https://gudog.co.uk), one of our projects, was accepted into the [Google Cloud Platform for Startups](https://cloud.google.com/developers/startups/) so it was a good reason to move it from AWS OpsWorks into Google Cloud. Google doesn't have something like AWS OpsWorks, instead it encourages you to use Docker for automated provisioning.

## 2. Stack and requirements

As there already a few articles published on how to _dockerize_ simple Rails apps, we're going to see how to deploy an app that mimics the same architecture that a complex app like Gudog has.

This will be our **stack**:

* Rails
* PostgreSQL
* Puma & nginx
* Redis
* Memcached
* Docker
* Docker Compose
* Docker Machine

If you don't need Redis or Memcached you can keep reading and just skip those two steps.

As this is a production deployment we have some extra **requirements** that often are not covered in other tutorials:

* Two environments: production & staging
* SSL / HTTPS for both staging & production
* Persisted data for our database
* Persisted logs 



#### Why Docker Compose and not Kubernetes?

The de facto way to deploy Docker containers to Google Cloud is using [Google Container Engine](https://cloud.google.com/container-engine/), which is based in [Kubernetes](kubernetes.io). In fact, when we started dockerizing Gudog our first attempt was to use Kubernetes, however we faced one major roadblock: when using an HTTPS load balancer Kubernetes was hiding the real IP of the user, meaning that in both our nginx and Rails logs the logged IP was a local IP from Kubernetes. This is explained [here](https://github.com/kubernetes/kubernetes/issues/10921) and [here](https://github.com/kubernetes/kubernetes/issues/3760). 

This problem will be solved in the next version of Kubernetes (v1.2), but it will take some time for that version to be released and available in Google Container Engine.

When we hit that roadblock we looked into other options and we found about Docker Compose. After some testing we realized Docker Compose was less complex than Kubernetes, everything is defined into a single file and it doesn't force you to learn more abstractions (with Kubernetes you need to understand what's a Pod, a ReplicationController, a Service and so on).

It's important to note that while Kubernetes allows you to have a *cluster* of nodes and work with them as if they were a single identity, Docker Compose only takes responsibility for allocating multiple containers into a single node (VM / instance). 

For creating clusters of multiple nodes Docker (the company) offers [Swarm](https://docs.docker.com/swarm/overview/). In theory, putting together Docker Compose and Docker Swarm we could achieve similar results than what Kubernetes offer us, however right now Docker Compose is [not able to deploy containers to more than a single node](https://github.com/docker/compose/blob/c421d23c34fa974df79faeaaf7ca9c15226bfc27/SWARM.md) when using Swarm.

As we decided that one big node would be enough for us, we decided to go with Docker Compose without Swarm.


## <a name="installing-docker-on-os-x"></a>3. Installing Docker on OS X

Docker (often referred as Docker Engine) runs on any Linux machine natively, but for OS X and Windows we'll need a virtual machine. Here we'll focus only on OS X as it is the platform that most Rails developers use. If you have another OS go [here](https://docs.docker.com/engine/installation/) an follow the instructions.

On Mac OS X the easiest way to install Docker is the Docker Toolbox. **Download and install Toolbox from its [website](https://www.docker.com/products/docker-toolbox)**. 

The Toolbox will install with in a few clicks: a [lightweight VirtualBox VM](https://github.com/boot2docker/boot2docker) with Docker (Engine), Docker Compose, Docker Machine and Kitematic (a desktop app for managing your containers). You can find more **detailed installation instructions [here](https://docs.docker.com/mac/step_one/)**.

**Docker Machine** is the command line that will allow us to manage any host that is running Docker Engine. In our case we'll use Docker Machine both for managing our local environment and our production and staging environments on the cloud thanks to its [cloud drivers](https://docs.docker.com/machine/drivers/).

#### Why do I need Docker installed on my machine if I am not gonna use for development?

Even if you're not planning to use Docker for your development environment, you probably still want to install Docker for building your image. 

Technically you could skip installing Docker locally if you use Docker Machine to work with a remote Docker host, but when you're learning Docker you'll probably make a lot of mistakes (as we did) having to re-build your image every time. For this reason we think is more handy to work locally until you get to a point where your image is stable enough to move the building process into a cloud service.


## <a name="creating-a-docker-image-for-our-rails-project"></a>4. Creating a Docker image for our Rails project

**A [Docker image](https://docs.docker.com/engine/userguide/containers/dockerimages/) is like a template for a container**. You can think about it as an ISO file that you use to burn a CD with the difference that a Docker Image can be based into a previous image.

To build an image you can start with a simple container then modify it and save it as a new image, or you can [use a Dockerfile](https://docs.docker.com/engine/userguide/containers/dockerimages/#building-an-image-from-a-dockerfile) – this is the most common way and the one we'll use.

A **Dockerfile** is a single file where we tell Docker what is the base image we wanna use and then we add _layers_ to modify that image. It's like building a skyscraper one floor at a time – you start with Ubuntu as your ground floor and keep adding more stuff (Ruby, nginx, your app's code etc.). Each command in our Dockerfile will create a new layer in our image.

If you were deploying your Rails apps with tools like Capistrano before, you're probably used to deploy new versions of your app by replacing the source code that lives in your server and restarting your web server process (Unicorn, Puma, etc.). However in Docker land the best practice is to keep your containers disposable and [immutable](http://theagileadmin.com/2015/11/24/immutable-delivery/) – in other words, **instead of upgrading your code you'll just create a new container with the new code and kill the old one**. One of the things that enables this approach is that booting up a Docker container is blazing fast. This means **we're gonna include our Rails code into our Docker image**.

To include our Rails code into the Docker image we need to have our Dockerfile in the Rails project's root folder.

The Rails project we're gonna use as an example is the ActionCable example crafted by [DHH](https://twitter.com/dhh) (originally hosted [here](http://github.com/rails/actioncable-examples)). 

We've chosen this example as it requires to have Redis installed and two different process, the web app and the `cable` process. If you're new to Rails 5, ActionCable is the DHH's flavor of WebSocket. The app basically is a simple real time comments board.

This project uses Rails 5.0.0.beta2 but this guide should be easy to apply to any other version of Rails. In fact, Gudog, the project that motivated this guide, is using Rails 3.2.

Let's write our **Dockerfile**:

```dockerfile
# ./Dockerfile
FROM ruby:2.3
# ...
```
The `FROM` keyword tells Docker what to use as base image. Usually this references an image in the [Docker Hub](https://hub.docker.com/) (the official public container registry), but it also can reference an image in any other private container registry.

There is an [official image for Rails](https://hub.docker.com/_/rails/),  as well as some other [non official images](https://hub.docker.com/search/?isAutomated=0&isOfficial=0&page=1&pullCount=0&q=rails&starCount=0), however **we've chosen to start with the official image for Ruby 2.3** and then build all the required dependencies for our Rails project with the Dockerfile to have a more fined grain control.

After defining the base image, we can use `RUN` to execute any command inside our container during the build process. Here we're installing two additional packages to our image: `nginx` and `nodejs`. 

```dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
    nodejs \
    nginx
```

Then using `COPY` we can move files from the folder where our Dockerfile is into the image. We start copying the `Gemfile` and `Gemfile.lock` files, as this is the only thing we need to run `bundle install`. 

```dockerfile
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install --without development test
```

After installing our gems we're gonna precompile our assets. To do so we'll copy only the minimum required files to run the `rake assets:precompile`

```dockerfile
COPY Rakefile .
COPY config config
COPY app/assets app/assets
COPY vendor vendor
RUN bundle exec rake assets:precompile
```

Once we have our gems and our assets we move into copying the configuration for nginx and Puma:

```dockerfile
COPY ./deploy/puma.rb ./config/
COPY ./deploy/nginx.conf /etc/nginx/nginx.conf
```

You can find these two files in our repo: [puma.rb](https://github.com/diacode/rails-docker-example/blob/part-1/deploy/puma.rb) and [nginx.conf](https://github.com/diacode/rails-docker-example/blob/part-1/deploy/nginx.conf).

Then we copy the remaining folders of our Rails app:

```dockerfile
COPY . /usr/src/app
```

You may be wondering why we didn't copy the whole thing from the beginning. Well, remember that each command in our Dockerfile creates a new layer. In addition to this, to save us time Docker has a cache mechanism. This cache avoids running each command if the command didn't change. If the command is `COPY` then Docker we'll check the difference between the previous existing files in the image and the new files, if they have changed it invalidates the cache and all the following commands are executed again.

Imagine you make just a change to a model or a view to your project, you don't want to wait again for the bundle to be installed and the assets to be precompiled. 

Copying the files in this particular order ensures that **gems are only installed when the `Gemfile` changes and assets are only precompiled when they have changed**.

Finally we tell Docker what command should be executed when our image is run into a container:

```dockerfile
CMD ["foreman", "start"]
```

Here we'll use [Foreman](https://github.com/ddollar/foreman) to lunch two process: nginx & puma. You can find the [Procfile](https://github.com/diacode/rails-docker-example/blob/part-1/Procfile) on Github.

Note that while `RUN` allow us to execute commands during the image building process, `CMD` will be executed when the image is started. Also remember that oyu can only have a single `CMD` order in your Dockerfile.

You can find the resulting [Dockerfile on Github](https://github.com/diacode/rails-docker-example/blob/part-1/Dockerfile).

To build our image first we need to make sure our Docker Machine (our VM with  Docker Engine) is running:

```bash
$ docker-machine ls
NAME               ACTIVE   DRIVER       STATE     URL                          SWARM   DOCKER    ERRORS
default            *        virtualbox   Running   tcp://192.168.99.100:2376            v1.10.1
```

If it is not running you can start it with `docker-machine start default`. If it is running but it doesn't appear as ACTIVE (with `*`) you can activate it with `eval $(docker-machine env default)` – this command will setup your terminal so that every `docker` command is run on that Docker Machine.

Finally **we build our Docker image with**:

```bash
$ docker build -t rails-docker-example:latest .
```

Where `rails-docker-example` is the name for our image and `latest` is just a tag. After this you should be able to see your image running `docker images`.

## <a name="running-the-image-locally"></a>5. Running the image locally

To test our image before we push it to the clod we're gonna run it locally:

```bash
$ docker run --name rails-docker-example -e "RAILS_ENV=production" -e "SECRET_KEY_BASE=demo" -p 80:80 -P rails-docker-example:latest
```

With `--name` we assign a name to the new container, `-e` allows us to pass environment variable, and `-p` allows us to expose ports. Finally `rails-docker-example:latest` is the name and tag for our image.

Once we boot up the image into a container, the database will be empty. To create the database open a **new terminal** and run:

```bash
$ eval $(docker-machine env default)
$ docker exec -it rails-docker-example bash
```

This will give you a prompt into your container. Go ahead and run:

```bash
$ bin/rake db:setup
```

To see the app running in your browser you need to find out the IP for your Docker Machine:

```bash
$ docker-machine ip default
192.168.99.100
```

This is my IP, open your browser and go to `http://192.168.99.100`. You should see the Rails app running. Note that the real-time functionality of the app will be broken because we won't have WebSockets with ActionCable yet. We'll get into that in the next part of this guide.

Also the app will be still using SQLite instead of PostgreSQL, we'll cover that too in the next part.

<div class="btn-wrapper">
  <a href="https://github.com/diacode/rails-docker-example/tree/part-1" target="_blank" class="btn"><i class="fa fa-github"></i> Project repository on GitHub</a>
</div>

---

_This is all for today. In the next part we'll cover deploying to Google Cloud, adding PostgreSQL, Redis, and a different container for ActionCable. Stay tunned!_