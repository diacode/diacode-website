---
title: How we estimate projects
date: 2015-07-27 09:28 UTC
tags:
 - diacode
author: javier
excerpt: Since we started consultancy we have been improving our approach to project estimation. Here is how we do it nowadays.
---

Clients do not have an infinite budget. Before they make the decision of building a project, they obviously need to be sure they will be able to cover its cost. As we charge our clients per hour of work, often people ask me how do we approach project estimation – how do we avoid clients going crazy when we tell them we're not giving them an exact price.

This process has changed quite a lot in the five years we have doing consultancy work, but for the last two we have been using a process like the one described below.

## First meeting

After the first contact with a potential client (a *lead*), we usually arrange an in person meeting or a Skype call. Before this meeting I try to get some info about the new lead such as: how he/she found about us, who he is working for, where he is based, etc. In other words, I try to understand what is his "context".

During the meeting I'd explain what is Diacode, a little bit about our history and our approach to remote work and project management. After that we move into the details of the future project and **I'd try to answer the following questions**:

* What's the project about?
* What's the target market?
* Is there any competitor for that market?
* If there is any competitor: what does make this project different?
* How does he plan to make money with this project? 
* Why did he decide to go with Ruby?
* Does he have any other developer o designer we should / could collaborate with?

If the client wants to build a **startup** from scratch:

* Will he be committed full-time to the project?
* Is there any other founder in the team?
* How does he plan to finance the project?
* Does he has previous experience running startup-like projects?

If the client is part of an **organization with an existing development team**:

* How does his dev team looks like?
* What's their tech stack?
* What's their approach to project management? Do they use scrum?
* Do they have a test suite?
* Why have they decided to look for external help?

Then we would move into the details of the components of the project that could be more tricky such as payments, external APIs or services, etc. My goal here is to identify those technical components that are gonna require more time.

Finally I ask the client to send me any useful documentation he already has about the project, such as a mockups, designs, slides, etc. Some clients here would require us to sign an NDA here before sending us documentation – we're ok with this as long as the NDA is mutual. 

## Internal review

After the first meeting I usually talk with Victor, our CTO, and share with him all the information I have collected. This is a key part because Victor often will start asking me questions about the project that I didn't think about during my meeting with the client. We make a list of new questions for the client and we either mail them or get him on the phone to answer them.

During this meeting Victor and me we also discuss other things such as how this project could fit into our calendar, what frameworks, libraries or technologies would make sense to use in this project, and how similar it is to previous things we have built (in order to improve our future estimation).

## Writing user stories and estimating them

Once we have sorted out our main questions and concerns with the client, we move into writing [user stories](https://en.wikipedia.org/wiki/User_story). Often we create a draft project in [Pivotal Tracker](http://pivotaltracker.com/) with all the stories. We add them labels to group user stories into bigger units of functionality such as *users*, *payments*, *orders*, *backoffice* and so on. 

Then we do an estimation using [Estimation Party](http://estimationparty.com/). Often we ask someone else from our team to join the estimation session, to have some "fresh" input.

We estimate the complexity of each story with either 0, 1, 2, or 3 points. Very roughly 1 point would be half a day of work, 2 points a full day, and 3 points 2 days of work. If we see something that looks like is going to be more than 3 points, we split it into more than one story.

Once we have all the user stories estimated, we add some more for project overhead, such as *Project bootstrap* (creating repositories, staging environments, etc.) or *Creating mockups* (if we don't have them yet).

## Defining a price range

With all the stories estimated, we sum up all the points and divide them by our *internal velocity* – the number of points we are able to deliver per week and per developer (from previous projects). That give us the number of weeks the project would require. Example:

> Total points: 120 

> Internal velocity per week: 12 points

> `120 / 12 = 10 weeks`

At this point we have an estimation in weeks for the whole project. However our experience tell us that by this time we still only know less than a half of the details of the project – the rest either the client hasn't been able to communicate it with us, or he just doesn't know. **Clients always discover their own projects in the process of building them**. Keeping that in mind we increase our estimation to something like

> **Time Estimate: between 10 and 14 weeks**

Then we multiply that by the average number of hours we bill per day and per developer, which is around 7 (we work 8 hours, but we only invoice for productive time of work), and finally multiply that for our hourly price:

> `10 weeks * 5 days * 7 hours * $100 = $35.000`

> `14 weeks * 5 days * 7 hours * $100 = $49.000`

> **Cost Estimate: between $35.000 and $49.000**

Here we also decide how many developers would make sense for the project depending on how many stories can be worked in parallel. If we find we can have two people working in parallel we divide the time estimate, but obviously the cost estimate would be the same.

## Sending the estimate

Finally we send the client either a simple PDF document (just a few pages) or an email with all the user stories and their estimations, and the final time and cost estimate. We try to avoid spending too much time on fancy documents here, we don't see any value on that.

In this email we make clear that what we are sending is an estimation made with the information we have at this point. We also explain the client that he will have total freedom to change the course of the project without having to discuss with us why that wasn't defined at the beginning of the project. The only rule we have for managing changes to the scope is that they should happen at the beginning of the week (during the sprint notification), not in the middle of it.

## Reviewing estimations before each sprint

Once the project has been approved and work has started, at the beginning of every week (we normally do weekly sprints), we'll have a *sprint planning* hangout where we decide which stories we will work that week and what info do we need from the product owner (the client) to implement them. Here often we discover new details about some story so we change the estimation of those.

With weekly sprints and daily scrums (our equivalent to the a daily [Stand-up meeting](https://en.wikipedia.org/wiki/Stand-up_meeting)) we ensure the client has totally visibility of the progress of the project, what has been accomplished, what's left, and how close are we from the original estimation. This way there can't by any surprises.

Note that we require our clients to designate a product owner from their team who needs to be present in every daily scrum and sprint planning. This is a must for us.

## Conclusion

Project estimation is a key part of a project, but it's something we do not charge for and sometimes we cannot close a deal for the project, therefore our main goal for the whole process is to keep it as lightweight as possible, avoid any possible overhead, while trying to be as accurate as possible with our estimation.