# gulp-order

The gulp plugin `gulp-order` allows you to reorder a stream of files using the same syntax as of `gulp.src`.

## Motivation

Assume you want to concatenate the following files in the given order (with `gulp-concat`):

- vendor/js1.js
- vendor/**/*.{coffee,js}
- app/coffee1.coffee
- app/**/*.{coffee,js}

You'll need two streams:

- A stream that emits the JavaScript files, and
- a stream that emits the compiled CoffeeScript files.
 
To combine the streams you can use `es.merge` (from `event-stream`) but you'll notice that `es.merge` just emits the files in the same order as they come in. This can be quite random. With `gulp-order` you can reorder the files.

## Usage

`require("gulp-order")` returns a function that takes an array of patterns (as `gulp.src` would take).

```javascript
var order = require("gulp-order");
var es = require("event-stream");
var concat = require("gulp-concat");

var coffeeFiles = gulp.src("**/*.coffee");
var jsFiles = gulp.src("**/*.js");

es
  .merge(coffeeFiles, jsFiles)
  .pipe(order([
    "vendor/js1.js",
    "vendor/**/*.js",
    "app/coffee1.js",
    "app/**/*.js"
  ]))
  .pipe(concat("all.js"))
  .pipe(gulp.dest("dist"));
```

## Features

Uses [`minimatch`](https://github.com/isaacs/minimatch) for matching.

## Tips

- Try to move your ordering out of your `gulp.src(...)` calls into `order(...)` instead.

## Contributors

- [Marcel Jackwerth](http://twitter.com/sirlantis)

## License

MIT - Copyright © 2014 Marcel Jackwerth