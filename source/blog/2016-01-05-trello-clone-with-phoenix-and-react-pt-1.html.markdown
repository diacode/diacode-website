---
title: Trello tribute with Phoenix and React (pt.1)
date: 2016-01-05
author: ricardo
excerpt:
tags:
  - elixir
  - phoenix
  - react
---
[Trello][455d6e81] is one of my favorite web applications of all time. I've been using
it since it's very beginning and I love the way it works, it's simpleness and
flexibility. Every time I start learning a new technology I like
to create a real-case application so I can put in practice everything I'm learning
into possible real-life problems and test out how to solve them.
So when I started to learn [Elixir][0cff6a5b] and it's [Phoenix][86fc0250]
framework it was clear to me: I had to put in practice all the awesome stuff I'm
learning and share it as a tutorial on how to code a simple, but functional,
tribute to **Trello**.

## What are we going to build
Basically we are going to code a single-page application where existing users are
going to be able to sign in, create some boards, share them with other existing
users and add lists and cards to them. While viewing a board, connected users will
be displayed and any modification done will be automatically reflected on every
connected user's browser in real-time a la Trello style.

### The current stack

**Phoenix** manages static assets with **npm** and builds them using **brunch** or
**webpack** out of the box, so it's pretty simple to really separate both the
front-end and the back-end, while having them in the same codebase. So for the back-end
we are going to use:

  - Elixir.
  - Phoenix framework.
  - Ecto.
  - PostgreSQL.

And to build the single-page front-end we are going for:

  - Webpack.
  - Sass for the stylesheets.
  - React.
  - React router.
  - Redux.
  - ES6/ES7 JavaScript.

Where are also going to use some more **Elixir** dependencies and **npm** packages, but
I will talk about them as soon as we use them.

### Why this stack?
**Elixir** is a very fast and powerful functional language based on **Erlang** and with friendly
syntax very similar to **Ruby**. It's very robust and specialized in concurrency so it can
automatically manage thousands of concurrent processes thanks to the **Erlang VM**.
I'm an Elixir newbie so I still have a lot to learn, but I can say that what I have
tested so far is really impressive.

We are going to use **Phoenix** which is Elixir's most popular
framework right now which not only uses some of the parts and standards **Rails**
brought to web development, but also if offers many other cool features like the
way it manages static assets I mentioned before and, the most important to me,
**real-time** functionality out of the box through **websockets** easy as pie and no
need of any external dependency (and trust me, it works like a charm).

On the other hand we are using **React**, **react-router** and **Redux** because
I just love this combination to create single-page applications and manage the their
state. Instead of using **Coffeescript** as I always do, this new year I want to start using **ES6** and
**ES7**, so it's the perfect occasion to start doing so and get used to it.

### The final result
The application will consist of four different screens.
The first two are the sign up and sign in screens.

![][sign_in_image]

The main screen will consist of the list of owned boards by the user and the list of
boards he's been added as member by other users:

![][boards]

And finally the board screen where all users will be able to see who is connected,
and manage lists and cards around.

![][show_board]

So that's enough talk for now. Let's leave it here so I can start preparing the second
part in which we will see how to create a new **Phoenix** project and what changes we
need to make in order to use webpack instead of brunch and how to setup the front-end scaffold.

Happy coding!


  [455d6e81]: https://trello.com/ "Trello"
  [0cff6a5b]: http://elixir-lang.org/ "Elixir"
  [86fc0250]: http://www.phoenixframework.org/ "Phoenix framework"
  [sign_in_image]: /images/blog/trello_tribute_pt_1/sign-in.jpg "Users sign in"
  [boards]: /images/blog/trello_tribute_pt_1/boards.jpg "Boards"
  [show_board]: /images/blog/trello_tribute_pt_1/show-board.jpg "Boards"
