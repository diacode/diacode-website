---
title: 'Making sense of Amazon Web Services: Introduction for noobs'
date: '2015-04-03'
tags:
  - remote
author: javier
excerpt: Artur relates his experience working remotely from India these last months.
---

Nowadays there are tons of options to deploy web apps. If you're a Ruby developer probably you have been using Heroku, which is definitely a great platform, however if your budget is tight or your app has become complex and requires fine-grained control of your infrastructure, Heroku may not be your best option. By the way, Heroku actually uses Amazon behind the scenes, but that's another story.

For tight budgets or complex requirements probably the best option nowadays is Amazon Web Services (AWS). However **moving to AWS is not an easy task until you have made sense of all the different services they offer**. Their [documentation](http://aws.amazon.com/) is often confusing and infested with buzzwords that probably are interesting for business people but not very helpful for actual developers.

We would like you help you in your adventure but making a **quick summary of the services that Amazon offers and we are using in production** in different projects. This doesn't intend to be an extensive description, just a quick overview from an actual developer perspective.

Here is a summary of what we'll be covering today:

*   [EC2](#ec2) (Virtual Private Servers, the core of AWS)
    * [Availability Zones](#availability_zones)
    * [Instance Types](#instance_types)
    * [AMIs](#amis)
    * [EBS vs Instance Storage](#ebs)
    * [Security Groups](#security_groups)
    * [Elastic IPs](#elastic_ip)
    * [Elastic Load Balancers](#elastic_load_balaner)
*   [S3](#s3) (Storage for static files)
*   [RDS](#rds) (Databases)
*   [ElastiCache](#elasticache) (Memcached and Redis storage)
*   [SQS](#sqs) (Message queuing service)
*   [Elastic Beanstalk](#beanstalk) (Heroku-like deployments)
*   [OpsWorks](#opsworks) (Chef based DevOps layer)

<a class="anchor" name="ec2"></a>
## EC2 (Elastic Compute Cloud)

[EC2](http://aws.amazon.com/ec2/) is the core service of AWS: it allows you to create Virtual Private Servers (VPS) hosted in Amazon datacenters. Amazon calls each VPS an "EC2 instance".

When you create a new instance **you have to make three important decisions**:

* <a class="anchor" name="availability_zones"></a>**Availability Zone**: Amazon has multiple datacenters or [availability zones](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html) (actually 9) distributed all over the world. You can launch your EC2 instance in any of them, but probably you would want it to be the closest possible to your users. So if your main audience is in Europe go for Ireland (`eu-west-1`) or Frankfurt (`eu-central-1`). Frankfurt is a little bit more expensive, so we usually use Ireland.


*   <a class="anchor" name="instance_types"></a>**Instance Type**: this is the technical specification for your new instance. It's very important to select the right instance type as it will have a direct impact in your app's performance as well as your budget: each instance type has a different price. Here you have a [list with the pricing and specification for each type](http://ec2pricing.net/). 
    
    We normally use c3.large for Rails apps, but if you're app doesn't have heavy traffic you can definitely go for something cheaper.

*   <a class="anchor" name="amis"></a>**Amazon Machine Image (AMI)**: this is the operative system and distrution you want to use in your instance. The most common options are [Amazon Linux AMI](http://aws.amazon.com/amazon-linux-ami/), or Ubuntu Server. If you think you'll need to do a lot of SSH for manual management of your instance and you're used to work with Ubuntu, go for Ubuntu. If you're going to use another Amazon service for deployments (such as Beanstalk or OpsWorks) go with the Amazon one (which is similar to CentOs).

  You also need to know that besides of the operative system, there are two types of AMIs: EBS backed and Instance Storage. Read the EBS explanation below to understand the difference.

Finally, here are **other concepts that you will have to understand when dealing with EC2**:

*   <a class="anchor" name="ebs"></a>**EBS (Elastic Block Store)**. There are two types of storage for EC2 instances: [Instance Storage](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/InstanceStorage.html) (aka *ephemeral*) and [EBS](http://aws.amazon.com/ebs/). The first one is free but it's temporary, i.e. if you reboot your EC2 instance you'll loose all the files. If you need your files (or some of them) to be persisted you have to go with EBS, which is not free but still quite [cheap](http://aws.amazon.com/ebs/pricing/).

*   <a class="anchor" name="security_groups"></a>**[Security Groups](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html)** allows you to open and close ports for your EC2 instances right from the AWS console (the web admin for AWS). They maybe confusing when you're starting but they're definitely helpful in the long run.


* <a class="anchor" name="elastic_ip"></a>**[Elastic IPs](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html)**. When you create a new EC2 instance, it gets assigned a public IP, but this IP may change. If you need a static IP for your EC2 instance you need to create a new Elastic IP and assign it to your instance. You can get one [Elastic IP for free](http://aws.amazon.com/ec2/pricing/#Elastic_IP_Addresses) for each **running** instance. Note that if you stop the EC2 instance you'll have to delete (release) the Elastic IP if you don't want to be charged for it.


*   <a class="anchor" name="elastic_load_balaner"></a>**[Elastic Load Balancers](http://aws.amazon.com/elasticloadbalancing/)**. If you want to have multiple EC2 instance serving the same web app, you'll need to use a Load Balancer to distribute each requests to a different instance. 

    To do so you can create a new EC2 instance with something like [HAProxy](http://www.haproxy.org/) or you can go with the "Amazon-way" and use an Elastic Load Balancer. This allows you to point your domain to Amazon with a CNAME record instead of pointing it directly to an Elastic IP. Once a user tries to access your site, the DNS record will resolve to a different instance's IP depending on your app's current load.

<a class="anchor" name="s3"></a>
## S3 (Simple Storage Service)

[S3](http://aws.amazon.com/s3/) is probably the second most famous service from AWS, as it is used by apps hosted entirely on AWS as well as apps hosted somewhere else. It provides [ultra cheap](http://aws.amazon.com/s3/pricing/) storage for static files such as uploads (images, videos) and assets (JavaScript files, CSS, fonts). 

Each file hosted in S3 will be stored in a *bucket* which basically is like a root folder. You can have upto 100 buckets per Amazon account. We like to create a new bucket for each app or for each app and environment (*myapp_production*, *myapp_staging*).

The URL for your files with look something like this:

`<bucket-name>.s3-website-<AWS-region>.amazonaws.com/<file>`

This means that your static files will be loaded by the browser from a different and [cookieless domain](http://www.ravelrumba.com/blog/static-cookieless-domain/), which is a great performance boost, as the browser will be able to download more files in parallel.

For Rails apps we use S3 for hosting image uploads. Thanks to [Carrierwave](https://github.com/carrierwaveuploader/carrierwave#using-amazon-s3) the integration takes only 5 seconds. 

<a class="anchor" name="rds"></a>
## RDS (Relational Database Service)

When it comes to decide where to put your database you'll have three options:

1.  Place your **database in the same EC2 instance** as your web app: this is the most straightforward and cheap solution but definitely not recommended. If you do this and in the future you need to scale your infrastructure, i.e. create more EC2 instance serving your web app, this option won't be a good idea.

2.  Place your **database in a different EC2 instance** which main role is to serve as database. This is a common option, where you can have multiple EC2 instances serving your app and all of them talking to the same database.

    If you use Rails, note that in order to be able to execute Rails migrations you will also need to install Ruby on your database instance and deploy your app there (even if you won't have a web server in this instance).

3.  Use **Amazon RDS**.

    [RDS](http://aws.amazon.com/rds/) is a layer of abstraction on top of EC2, this means that using RDS will actually create "special" EC2 instances for you, but you'll have multiple benefits such as automatic backups, an easy setup for master-slave databases.

    RDS supports MySQL, PostgreSQL, Oracle, SQL Server and [Aurora](http://aws.amazon.com/rds/aurora/) (which is MySQL compatible).

    If you prefer a NoSQL database, take a look to [Amazon DynamoDB](http://aws.amazon.com/dynamodb/).

<a class="anchor" name="elasticache"></a>
## ElastiCache

[ElastiCache](http://aws.amazon.com/elasticache/) is the Amazon's solution for in-memory cache stores / databases. It supports Memcached and Redis. As we explained previously, in the same manner you can use directly EC2 for storing your database, you could do the same with Memcached and Redis, however the "Amazon-way" to do share a Redis node or Memcached node is to use ElastiCache. 

ElastiCache is [a bit more expensive](http://aws.amazon.com/elasticache/pricing/) than using a normal EC2 instance, but you'll save a lot of time on configuration and management of your Redis / Memcached.

We normally install Memcached in our web app instances, as they don't need to share the same Memcached, and then we use ElastiCache for having a shared Redis database across all the web app instances.

<a class="anchor" name="sqs"></a>
## SQS (Simple Queue Service)
If you have a Rails app with background jobs chances are that you're using something like Delayed Jobs, Resque, or Sidekiq. These libraries usually use Redis as backend to store the queues. This means that if you're planning to move to AWS, you'll need to either setup an EC2 instance for Redis or use ElastiCache as we've explained.

The "Amazon-way" to do this is to use SQS. Note that SQS is just the backend for your queues, this means that your app will have to talk to SQS somehow. In Rails the de-facto way to use SQS is the gem [Shoryuken](https://github.com/phstc/shoryuken).

SQS is free upto 1 million requests per month, and then $0.50 per extra million of requests. So it's definitely quite cheap. In other words: if you're using Redis only for queues, go for SQS.

There are only two major limitations when using SQS: you can only [delay messages](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-delay-queues.html) up to 15 minutes and [messages are retained](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/MessageLifecycle.html) only for 14 days. Depending on your app's logic this may be an issue or not.

<a class="anchor" name="beanstalk"></a>
## Elastic Beanstalk
[Elastic Beanstalk](http://aws.amazon.com/elasticbeanstalk/) is an abstraction layer over other AWS services such as EC2, S3, or RDS. This means that is free, you will only pay for the resources you use (EC2 instances, S3 buckets, etc.)

As a Rails developer, probably the best way to describe Beanstalk is to say that **it's similar to Heroku**, meaning that it takes care of creating and provisioning EC2 instances and **deploying with a single command** (`eb deploy`).

In the same manner Heroku, it can save you a lot of time at the beginning, as you won't have to spend time doing `apt-get install` for everything through SSH. However when you're app starts having complex requirements maybe you'll need some more fined-grain control and Beanstalk could become a problem more than a solution. If that's your case, we recommend OpsWorks (read below).

It currently supports apps in Ruby (Rails), Python, PHP, Node.js, Java, .NET and Docker containers.

<a class="anchor" name="opsworks"></a>
## OpsWorks
[OpsWorks](http://aws.amazon.com/opsworks/) is the last service from AWS we have added to our toolchain and we have currently a major app in production using it. As Beanstalk, **OpsWorks is a free abstraction layer that takes cares of creating, provisioning and deploying your apps**. The main difference is that it's **based on [Chef](https://www.chef.io/chef/)**, a configuration management tool written in Ruby.

OpsWorks has a nice web interface that allows you to create Stacks (an app, that could have multiple codebases or apps itself), Layers (roles for your instances), Apps, and EC2 Instances. It plays very nice with other services such as RDS, ElastiCache, or Elastic Load Balancers.

Currently OpsWorks comes with support for Rails, PHP, Node.js, Java and Static webs. However you can create your own custom Layers to support any other technology.

We're planning to write a full blog post covering how to deploy a complex Ruby on Rails app into OpsWorks, stay tunned!




