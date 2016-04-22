---
title: Page specific JavaScript in Phoenix framework
date: 2016-04-22 09:27 UTC
author: ricardo
excerpt:
  Two different approaches for page specific JavaScript in Phoenix projects
tags:
  - elixir
  - phoenix
  - javascript
  - brunch
  - webpack
---

Thanks to our personal experience working on legacy **Rails** applications, we've been
able to see several different approaches on how other developers usually organize
**JavaScript** assets.
Choosing a wrong approach, or not even having one, is probably going give you trouble
in the future, so just requiring everything in your manifest file, relying in multiple document load handlers across serveral files and trusting that everything will just work fine is not a good idea.
For our last projects (both client and internal ones) we've been replacing the **Asset Pipeline**
with **Webpack** to handle asset files requirement and build process, loving the result so far.
That's why the first time I took a look at **Phoenix**'s documentation and discovered
that there was not such a thing as the [Asset Pipeline][55ded47a] I got instantly hooked by it.

## Simple approach using Brunch and ES6

In order to build assets, **Phoenix** initially comes with [Brunch][6ee6be5c] out of the box, and
not only that, it also comes configured to support **ES6** by default, including
its modules syntax. Taking advantage of this, lets generate a very basic project and
see how we can create a better way of organizing the JavaScript instead of putting
everything we might need in `app.js` as if it was a **Rails** project.

### Generating the project

Lets begin by installing the lates version on **Phoenix**:

```
$ mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez && mix local.phoenix

Found existing archive(s): phoenix_new.ez.
Are you sure you want to replace them? [Yn]
* creating /Users/myuser/.mix/archives/phoenix_new.ez
Found existing archive(s): phoenix_new.ez.
Are you sure you want to replace them? [Yn]
* creating /Users/myuser/.mix/archives/phoenix_new.ez
```

Now that we are up to date, lets generate a new **Phoenix** project:

```
$ mix phoenix.new phoenix_template

* creating phoenix_template/config/config.exs
* creating phoenix_template/config/dev.exs
* creating phoenix_template/config/prod.exs
* creating phoenix_template/config/prod.secret.exs
* ...
* ...

We are all set! Run your Phoenix application:

    $ cd phoenix_template
    $ mix phoenix.server

You can also run your app inside IEx (Interactive Elixir) as:

    $ iex -S mix phoenix.server

Before moving on, configure your database in config/dev.exs and run:

    $ mix ecto.create
```

After following the instructions and running the server we can see that the new
application is ready.

![Template 1](https://diacode-blog.s3-eu-west-1.amazonaws.com/2016/04/template-1.jpg)


### Shared common JavaScript between views

Before continuing lets first think about what our good old web application is going
to need. There's probably going to be some shared js functionality shared across
the whole application, like handling pulldown menus in the header, initialazing
third party plugins, etc. Having this in mind we can create our first js module
that will be in charge of all this common functionality that needs to be executed
on every page:

```javascript
// web/static/js/views/main.js

export default class MainView {
  mount() {
    // This will be executed when the document loads...
    console.log('MainView mounted');
  }

  unmount() {
    // This will be executed when the document unloads...
    console.log('MainView unmounted');
  }
}
```

The `MainView` module will basically have to main functions:

  - **mount** which will be called every time the page loads and will contain all the initializing of common functionality needed.
  - **umount** which can be used to add any functionality needed to be executed when the document unloads.

Now lets update the main `app.js` file so it uses the new `MainView` module:

```javascript
// web/static/js/app.js

import 'phoenix_html';
import MainView from './views/main';

function handleDOMContentLoaded() {
  const view = new MainView();
  view.mount();

  window.currentView = view;
}

function handleDocumentUnload() {
  window.currentView.unmount();
}

window.addEventListener('DOMContentLoaded', handleDOMContentLoaded, false);
window.addEventListener('unload', handleDocumentUnload, false);
```

We add an event listener so when the `DOM` is completely loaded it initialzes the
`MainView`, *mounts* it and assigns it globally. We are also doing the same for the
`unload` event of the document. If we now open the web inspector, we can see the log
message and verify everything that is working fine:

![Template 2](https://diacode-blog.s3-eu-west-1.amazonaws.com/2016/04/template-2.jpg)

  [55ded47a]: http://guides.rubyonrails.org/v3.2/asset_pipeline.html "Ruby on Rails Asset Pipeline"
  [6ee6be5c]: http://brunch.io/ "Brunch.io"
