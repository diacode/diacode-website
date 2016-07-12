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

## Defining routes, controllers and websocket connection

The structure of the site is pretty simple, just a home page where the user will
introduce his nickname and the room he want to join. Once he submits the form
he'll get redirected to the conversation page. For sake of simplicity we haven't
added any authentication mechanism.

```elixir
# web/router.ex

defmodule Talkex.Router do
  use Talkex.Web, :router

  # ...

  scope "/", Talkex do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/rooms", RoomController, only: [:create, :show]
  end
end
```

In the controller there isn't too much to say. `create` action will attach the
nickname to the session and will redirect the user to the room specified.

```elixir
# web/controllers/room_controller.ex

defmodule Talkex.RoomController do
  use Talkex.Web, :controller

  def create(conn, params) do
    roomname = params["room"]["roomname"]

    conn
    |> put_session(:nickname, params["room"]["nickname"])
    |> redirect(to: "/rooms/#{roomname}")
  end

  def show(conn, params) do
    conn
    |> assign(:nickname, get_session(conn, :nickname))
    |> assign(:room, params["id"])
    |> render("show.html")
  end
end
```

Now let's talk about the user socket module.

```elixir
# web/channels/user_socket.ex

defmodule Talkex.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "room:*", Talkex.RoomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(params, socket) do
    {:ok, assign(socket, :nickname, params["nickname"])}
  end

  def id(_socket), do: nil
end
```

This is really self explanatory. The users are allowed to connect to any room
desired room topic. When the user connects to the socket he's supposed to
provide his nickname which will be attached to the socket assignments.

The key part here is the `RoomChannel` module. Beyond broadcasting messages this
file is responsible of tracking presence in channel. Let's take a look to the
and we'll talk in detail about each of the functions.

```elixir
defmodule Talkex.RoomChannel do
  use Phoenix.Channel
  use Timex
  alias Talkex.Presence

  def join("room:" <> _room_name, _message, socket) do
    send(self, :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)
    {:ok, _} = Presence.track(socket, socket.assigns.nickname, %{
      status: "online"
    })
    {:noreply, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast! socket, "new_msg", %{
      body: body,
      author: socket.assigns.nickname,
      sent_at: DateTime.now |> Timex.format("%H:%M", :strftime) |> elem(1)
    }

    {:noreply, socket}
  end

  def handle_in("new_status", %{"status" => status}, socket) do
    {:ok, _} = Presence.update(socket, socket.assigns.nickname, %{
      status: status
    })
    {:noreply, socket}
  end
end
```

### Tracking when a user joins a room

When we connect to the channel the code inside the `join` function is called. In
a chat that doesn't implement presence it would be enough by returning
`{:ok, socket}` but in this case we also do a `send(self, :after_join)` which
will trigger `handle_info(:after_join, socket)`. In this part first we push to
our own socket the list of users connected to this room topic and second we track
our own user with the status **online** as metadata. By calling `Presence.track`
the application is broadcasting the event `presence_diff` to all clients
connected to this topic. So that the clients will receive a payload with
information about who joined the room.

We can summarize this with an example.

Let's say *JohnDoe* just connected to the topic `room:lobby` then two things
happen in this particular order:

1. Via event `presence_state` *JohnDoe* receives a list in his socket with a
payload containing all connected users to this topic except himself.  
2. Via `presence_diff` *JohnDoe* and **the rest of the clients** connected to
`room:lobby` receive in their socket a payload that says *JohnDoe* has joined
the channel.

The handler for new messages is quite easy to understand and it's covered in
dozens of tutorials about building a chat with Phoenix Framework so let's talk
about the handler for `new_status` event.

### Tracking status change

In our chat we want to change our connection status. In our case we have two:
**connected** and **away**. For that purpose we have a new custom event which we
have called `new_status`. The handler for this event will call `Presence.update`
which will broadcast a new `presence_diff` message to all the clients. The object
that all the clients will receive contains a join entry for the new status and a
leave entry for the old one.

Supposing *JohnDoe* was connected and changed his status to **away** this will
be the object that all clients will receive via `presence_diff` event:

```javascript
{
  "leaves": {
    "JohnDoe": {
      "metas": [{
        "status": "online",
        "phx_ref": "5LRcKhFOmPs="
      }]
    }
  },
  "joins": {
    "JohnDoe": {
      "metas": [{
        "status": "away",
        "phx_ref_prev": "5LRcKhFOmPs=",
        "phx_ref": "q2pngz0qbro="
      }]
    }
  }
}
```

In the next paragraph we are going to explain how to deal with this presence
objects.

## Frontend implementation
