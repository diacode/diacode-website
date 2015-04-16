---
title: 'How we improved our newsletter: a love story with Ember.js and Hubot'
date: '2014-05-01'
tags:
  - diacode
  - ember js
  - diacode picks
author: victor
---

As many of you know since 2013 we have a newsletter called **Diacode Weekly** where we publish links that we consider interesting or helpful. It was meant to be released on weekly basis, as his name indicates, but the reality was very different.

## What was the problem?

The problems were basically two: schedule and writing the compilation.

* **Schedule**: Being a Rails shop means that most of the time we are dealing with projects of our clients so there are periods when we are pretty busy and it's complicated to put on hold a project and focus on something not so important.
* **Writing and Publishing the compilation**: This is the key part of the problem and we are going to explain how we collected the links and how we published them in the following two sections of the post.

## Collecting the links

As we've said before [Hipchat](http://hipchat.com) is like our office so we spent most of the time there when we are working. Each time a member of Diacode finds anything interesting he shares the link in Diacode Weekly's room so the rest of us can notice.

## Publishing

Once there were enough links we compiled them and using WordPress we wrote a post which was somehow integrated with our MailChimp list.

In a bunch of lines it could sound like a good solution but the truth is that it was a really tedious and time consuming task. Every time we wanted to publish a new release we had to distinguish what links have been already published and what not, check all the links getting rid of the less interesting, and finally writing the post with WordPress editor which is an excellent solution for writing a post like this but not for a list of links with a specific set of html tags (such as dl, dt or dd in our case).

## How we planned to solve it?

Ember.js + Hubot to the rescue!

## Ember.js

[![emberjs-logo](https://diacode-blog.s3-eu-west-1.amazonaws.com/2014/04/emberjs-logo.png)](https://diacode-blog.s3-eu-west-1.amazonaws.com/2014/04/emberjs-logo.png)

Developing a separate application to manage the newsletter was a pretty straight forward idea that came up as we wanted to runaway from the WordPress painfully approach, but, what kind of app? Just a Rails app or something else?

In the last times there's been a lot of buzz around **Ember.js** and Javascript MVC frameworks in general thus we thought it was a good moment to give it a shot. So the choice was Ember.js backed by a Rails API.

Being honest, our start with Ember was tougher than we initially thought. Having a strong Rails background is kind of a baggage when you are about to start. Both frameworks have similar elements like Routes, Controllers and Views but in the practice they are really different concepts which is annoying, however it isn't the only roadblock we stumbled on. Since Ember.js is in constant evolution its API has changed significantly from 0.x to 1.x becoming a pain in the ass finding updated resources. Another downside is **Ember Data**, the persistence library for Ember, which is still not production ready, however 1.0 betas do the job with REST APIs.

Despite all of the above, with some patience we managed to make progress with the development of the app. Basically it consists in two parts: a **link buffer** and a **compilation manager**.

The link buffer shows you all the links that haven't been used yet giving you the ability of inline editing the title and the description of each one. Once you have enough links you can make a selection and create a new compilation with all of them. Obviously you are able to add links from this screen too. Regarding this, it's worth mentioning that every time a link is added the API inspects the url consequently attaching the title and the meta description of the link to the object created. This feature relies on Jaime Iniesta's 
[metainspector gem](https://github.com/jaimeiniesta/metainspector).

On the other hand, the compilation manager is basically a view where you can see all the compilations and publish them. Each compilation is in the practice one of our newsletter.

## Hubot

[![hubot](https://diacode-blog.s3-eu-west-1.amazonaws.com/2014/04/hubot.png)](https://diacode-blog.s3-eu-west-1.amazonaws.com/2014/04/hubot.png)

It wasn't enough having a separate application to manage the newsletter, there was something else we didn't want to put aside. Sharing the links on Hipchat was essential for us so we needed to connect our Hipchat room with the application somehow and that's where **Hubot** went on stage.


[Hubot](https://hubot.github.com/) is a bot developed by GitHub written in CoffeeScript shipped with a bunch of useful scripts that you can extend with [others provided by the community](https://github.com/github/hubot-scripts). There are [adapters](https://github.com/github/hubot/blob/master/docs/adapters.md) for Campfire, Hipchat or even IRC amongst many others.

In this case Hubot suits perfectly our needs. We just had to create a new script that puts the bot to listen for links in a specific room. Every time the bot identifies a new link he sends it to our application via its API. This way our app is always synced with our HipChat room.

## Demo

<iframe width="666" height="374" src="//www.youtube.com/embed/T-D-u_x8eIU" frameborder="0" allowfullscreen="allowfullscreen"></iframe>

## Wrap up

That was pretty much how we solved the problem with our newsletter. There still are some details pending to implement but most of it is fully functional. If you are interested in knowing more about the internals of the project or collaborating we have it available in our [GitHub page](http://github.com/diacode/picks).

The Hubot script is also available [here](https://github.com/diacode/picks-hubot-script).

PS: Please, note that we have rebranded the newsletter to **Diacode Picks** as we are not going to publish it on weekly basis anymore.
