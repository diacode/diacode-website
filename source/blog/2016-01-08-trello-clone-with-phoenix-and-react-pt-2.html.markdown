---
title: Trello clone with Phoenix and React (pt.2)
date: 2016-01-08
author: ricardo
excerpt:
tags:
  - elixir
  - phoenix
  - react
---
## Project setup
So now that we have selected our <a href="#">current stack</a> let's start by
creating the new **Phoenix** project. Before doing so we need to have both
**Elixir** and **Phoenix** already installed in our system so check out both
official sites for installation instructions.

### Static assets through Webpack

**Phoenix** doesn't have its own asset pipeline, instead it uses **Brunch** as
the assets build tool which to me feels more modern and flexible. The cool thing
is that you don't even need to use **Brunch** if you don't want to, you can also
use **Webpack**. As I haven't tried **Brunch** before we're going to use
**Webpack** instead. So let's create the new project without it:

```bash
$ mix phoenix.new --no-brunch phoenix_trello
  ...
  ...
  ...
$ cd phoenix_trello
```

Alright, now we have our new project foundation with no assets building tool. Let's
create a new ```pakage.json``` file and install **Webpack** as de dev dependency:

```bash
$ npm start
  ...
  ...
  ...
$ npm i webpack --save-dev
```

Now our ```package.json``` will look something similar to this:

```json
{
  "name": "phoenix_trello",
  "devDependencies": {
    "webpack": "^1.12.9"
  },
  "dependencies": {

  },
}
```

We are going to need a bunch of dependencies in the project so instead of listing
all of them just take a look to the
<a href="https://github.com/bigardone/phoenix-trello/blob/master/package.json">source file</a>
in the project's repository to view them all.

We also need to add a ```webpack.config.js``` configuration file to tell **Webpack**
how to build the assets:

```javascript
'use strict';

var path = require('path');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var webpack = require('webpack');

function join(dest) { return path.resolve(__dirname, dest); }

function web(dest) { return join('web/static/' + dest); }

var config = module.exports = {
  entry: {
    application: [
      web('css/application.sass'),
      web('js/application.js'),
    ],
  },

  output: {
    path: join('priv/static'),
    filename: 'js/application.js',
  },

  resolve: {
    extesions: ['', '.js', '.sass'],
    modulesDirectories: ['node_modules'],
  },

  module: {
    noParse: /vendor\/phoenix/,
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel',
        query: {
          cacheDirectory: true,
          plugins: ['transform-decorators-legacy'],
          presets: ['react', 'es2015', 'stage-2', 'stage-0'],
        },
      },
      {
        test: /\.sass$/,
        loader: ExtractTextPlugin.extract('style', 'css!sass?indentedSyntax&includePaths[]=' + __dirname +  '/node_modules'),
      },
    ],
  },

  plugins: [
    new ExtractTextPlugin('css/application.css'),
  ],
};

if (process.env.NODE_ENV === 'production') {
  config.plugins.push(
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.UglifyJsPlugin({ minimize: true })
  );
}

```

We specify that we're going to have two different entries, one for the javascripts
and the other one for the stylesheets both placed inside the ```web/static``` folder.
Our output files are going to be created in the ```private/static``` folder.
As we are going to use some **ES6/7** and **JSX** features we will use **Babel**
with some presets designed for this.

The final step is to tell Phoenix to start Webpack every time we start our
development server, so it generates the resulting asset files the main layout
is going to reference. To do so we have to add a watcher to the ```config/dev.exs```
file:

```elixir
# config/dev.exs

config :phoenix_trello, PhoenixTrello.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  cache_static_lookup: false,
  check_origin: false,
  watchers: [
    node: ["node_modules/webpack/bin/webpack.js", "--watch", "--color"]
  ]

...
```

If we now start our development server we can see that **Webpack** is also started and
working:

```bash
$ mix phoenix.server
[info] Running PhoenixTrello.Endpoint with Cowboy using http on port 4000
Hash: 93bc1d4743159d9afc35
Version: webpack 1.12.10
Time: 6488ms
              Asset     Size  Chunks             Chunk Names
  js/application.js  1.28 MB       0  [emitted]  application
css/application.css  49.3 kB       0  [emitted]  application
   [0] multi application 40 bytes {0} [built]
    + 397 hidden modules
Child extract-text-webpack-plugin:
        + 2 hidden modules
```

There is just one more thing to do here. If we look into the ```private/static/js```
folder we will find a ```phoenix.js``` file. This file contains everything we need to
use **websockets** and their **channels**, so let's move it to our base source
folder ```web/static/js``` so we can require it where we might need it.

### Front-end basic structure
Now that we have everything ready to start coding, let's begin by creating our
front-end app structure which is going the need the following **npm** packages
among others:

  - **bourbon** and **bourbon-neat**, my all time favorite Sass mixin library.
  - **history** to manage history with JavaScript.
  - **react** and **react-dom**.
  - **redux** and **react-redux** for handling the state.
  - **react-router** as routing library.
  - **redux-simple-router** to keep route changes in the state.

I'm not going to waste any time on talking about stylesheets as I'm still modifying
them at this moment but what I'd like to mention is that for creating a suitable
structure of **Sass** files I usually use <a href="http://css-burrito.com/">css-burrito</a>
which in my personal opinion is very useful.

Now we need to configure our Redux store so let's create the following file:

```javascript
//web/static/js/store/index.js

import { createStore, applyMiddleware } from 'redux';
import createLogger from 'redux-logger';
import thunkMiddleware from 'redux-thunk';
import reducers from '../reducers';

const loggerMiddleware = createLogger({
  level: 'info',
  collapsed: true,
});

const createStoreWithMiddleware = applyMiddleware(thunkMiddleware, loggerMiddleware)(createStore);

export default function configureStore() {
  return createStoreWithMiddleware(reducers);
}
```

Basically we are configuring the **Store** with two middlewares:

  - **redux-thunk** to dispatch async actions.
  - **redux-logger** to log any action and state changes through the browser's console.

We also need to pass all the combined state reducers, so let's create a basic
version of that file:

```javascript
//web/static/js/reducers/index.js

import { combineReducers }  from 'redux';
import { routeReducer }     from 'redux-simple-router';
import session              from './session';

export default combineReducers({
  routing: routeReducer,
  session: session,
});
```

As starting point we are only going to need two reducers, the ```routeReducer```
which will automatically set routing changes into the state and a session reducer
which looks like this:

```javascript
//web/static/js/reducers/session.js

const initialState = {
  currentUser: null,
  socket: null,
  error: null,
};

export default function reducer(state = initialState, action = {}) {
  return state;
}
```

So it's initial state will consists of the ```currentUser``` object which we will
set after authentication, the ```sockect``` that we will use for connecting to
channels and an ```error``` to keep track of any issue while authenticating
the user.

Having all this prepared now we can go to our main ```application.js``` file and
render de root component:

```javascript
//web/static/js/application.js

import React                    from 'react';
import ReactDOM                 from 'react-dom';
import createBrowserHistory     from 'history/lib/createBrowserHistory';
import { syncReduxAndRouter }   from 'redux-simple-router';
import configureStore           from './store';
import Root                     from './containers/root';

const store  = configureStore();
const history = createBrowserHistory();

syncReduxAndRouter(history, store);

const target = document.getElementById('main_container');
const node = <Root routerHistory={history} store={store}/>;

ReactDOM.render(node, target);
```

We get the store and history, sync both of them so the previous ```routeReducer```
works fine and we render the ```Root``` component in the main application
layout which will be a **Redux** ```Provider``` wrapper for the ```routes```:

```javascript
//web/static/js/containers/root.js

import React              from 'react';
import { Provider }       from 'react-redux';
import { Router }         from 'react-router';
import invariant          from 'invariant';
import { RoutingContext } from 'react-router';
import routes             from '../routes';

export default class Root extends React.Component {
  _renderRouter() {
    invariant(
      this.props.routingContext || this.props.routerHistory,
      '<Root /> needs either a routingContext or routerHistory to render.'
    );

    if (this.props.routingContext) {
      return <RoutingContext {...this.props.routingContext} />;
    } else {
      return (
        <Router history={this.props.routerHistory}>
          {routes}
        </Router>
      );
    }
  }

  render() {
    return (
      <Provider store={this.props.store}>
        {this._renderRouter()}
      </Provider>
    );
  }
}
```

Now let's define our, very basic, routes file:

```javascript
//web/static/js/routes/index.js

import { IndexRoute, Route }  from 'react-router';
import React                  from 'react';
import MainLayout             from '../layouts/main';
import RegistrationsNew       from '../views/registrations/new';

export default (
  <Route component={MainLayout}>
    <Route path="/" component={RegistrationsNew} />
  </Route>
);
```

The final version of this file is a bit more complex due to  the authentication
mechanism we are going to implement, but we'll talk about it on the next post.

Finally we need to add the html container where we'll render the ```Root``` component
in the main **Phoenix** application layout:

```html
<!-- web/templates/layout/app.html.eex -->

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="ricardo@codeloveandboards.com">

    <title>Phoenix Trello</title>
    <link rel="stylesheet" href="<%= static_path(@conn, "/css/application.css") %>">
  </head>

  <body>
    <main id="main_container" role="main"></main>
    <script src="<%= static_path(@conn, "/js/application.js") %>"></script>
  </body>
</html>
```

Note both the link and the script tags referencing the static
assets generated by **Webpack**.

As we are going manage our routing on the front-end, we need to tell **Phoenix**
to handle any http request through the ```index``` action of the ```PageController```
which will just render the main layout and our ```Root``` component:

```elixir
# master/web/router.ex

defmodule PhoenixTrello.Router do
  use PhoenixTrello.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", PhoenixTrello do
    pipe_through :browser # Use the default browser stack

    get "*path", PageController, :index
  end
end
```

That's it for now. On the next post we'll create our first migration, the ```User```
model and all the functionality regarding creating new user accounts.

Happy coding!
