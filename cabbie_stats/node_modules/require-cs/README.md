# require-cs

A [CoffeeScript](http://jashkenas.github.com/coffee-script/) loader plugin
that may work with module loaders like [RequireJS](http://requirejs.org),
[curl](https://github.com/unscriptable/curl) and
[backdraft](http://bdframework.org/bdLoad/docs/bdLoad-tutorial/bdLoad-tutorial.html).

It has been _adapted_ to work as an npm package. It is known to work with RequireJS 1.0+.

This loader plugin makes it easy to write your JS functionality in CoffeeScript,
and easily use it in the browser, Node or Rhino. Plus, if you use the RequireJS
optimizer, your CoffeeScript files can be translated to JavaScript, and inlined
into optimized layers for fast performance.

In development, it uses XMLHttpRequest to fetch the .coffee files, so you can only
fetch files that are on the same domain as the HTML page, and most browsers place
restrictions on using XMLHttpRequest from local file URLs, so use a web server to
serve your .coffee files.

## Install <a name="install"></a>

### npm

To install with [npm](http://npmjs.com):

```
  npm install require-cs
```

## Usage <a name="usage".</a>

Reference CoffeeScript files via the cs! plugin name. For example, to load
the `app.coffee` file that is in your baseUrl directory:

    require(['cs!app'], function (app) {

    });

Or, if creating a module that depends on `util.coffee`:

    define(['cs!util'], function (util) {
        util.doSomething();
    });

If you are using define() in a module written with CoffeeScript:

    define ['cs!util'], (util) ->
        util.doSomething

[Literate CoffeeScript](http://coffeescript.org/#literate) was introduced in CoffeeScript 1.5.0.
To utilize this feature with this plugin you will need to have downloaded >= 1.5.0
of CoffeeScript and qualify the file (with extension) of the literate module you wish to use.

A dependency on the literate module `app.litcoffee`:

    require ['cs!app.litcoffee'], (litapp) ->
      litapp.foo()
      # ...

Or a dependency on the literate module `util.coffee.md`:

    define ['cs!util.coffee.md'], (litutil) ->
      litutil.doSomething()
      # ...

Note: This plugin supports a mixture of literate and regular CoffeeScript files in the
same project.

**VERY IMPORTANT**: Only define anonymous modules using CoffeeScript. Otherwise,
the optimization work will not happen correctly -- the name of the module is changed
to allow inlining of the translated JS content.

## License <a name="license"></a>

Available via the MIT or new BSD license.
