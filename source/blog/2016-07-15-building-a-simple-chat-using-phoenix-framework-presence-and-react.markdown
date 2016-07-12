---
title: Building a simple chat using Phoenix Framework’s Presence and React
date: 2016-07-15 18:00 UTC
author: victor
excerpt:
tags:
  - elixir
  - phoenix
  - presence
  - react
---

One of the most important and exciting new features included in the recent release of Phoenix Framework 1.2 is the Presence module. This new addition makes it super easy to track users connected to a room along with some metadata like the status and more stuff that you may want to track.

Despite 1.2 version was released about three weeks ago (as of the publishing of this post) the guides haven’t changed too much. Although the documentation is really helpful and updated to cover this feature we missed a specific guide about this particular topic so here is our attempt to explain how to use Presence module in one of the most typical scenarios, a chat application.

This post will start a series of posts where we'll build **Talkex**, a complete
messaging application with WebRTC videocalls included. But for now let's start
with the chat part.

## Setting up Presence configuration

Using Presence module is pretty straight forward.

In first place we have to add the file `lib/talkex/presence.ex`.

```elixir
defmodule Talkex.Presence do
  use Phoenix.Presence, otp_app: :talkex, pubsub_server: Talkex.PubSub
end
```

By default Phoenix applications are configured to use `Phoenix.PubSub.PG2` as
backend for PubSub but you can use something different like Redis or even your
own implementation. In case you want to know more about it you can check
[Phoenix PubSub documentation](https://hexdocs.pm/phoenix/Phoenix.PubSub.html).
For our application we'll use the elixir based backend solution which is
configured by default in `config/config.exs`.

Once we have our `Talkex.Presence` module in place the next thing to do is
adding the supervisor to the application tree in `lib/talkex.ex`.

```elixir
defmodule Talkex do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Talkex.Repo, []),
      # Start the endpoint when the application starts
      supervisor(Talkex.Endpoint, []),
      # Presence supervisor
      supervisor(Talkex.Presence, [])
      # Start your own worker by calling: Talkex.Worker.start_link(arg1, arg2, arg3)
      # worker(Talkex.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Talkex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Talkex.Endpoint.config_change(changed, removed)
    :ok
  end
end
```

## Frontend implementation
