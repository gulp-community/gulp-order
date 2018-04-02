# gulp-order

The gulp plugin `gulp-order` allows you to reorder a stream of files using the same syntax as of `gulp.src`.

## Motivation

Assume you want to concatenate the following files in the given order (with `gulp-concat`):

- `vendor/js1.js`
- `vendor/**/*.{coffee,js}`
- `app/coffee1.coffee`
- `app/**/*.{coffee,js}`

You'll need two streams:

- A stream that emits the JavaScript files, and
- a stream that emits the compiled CoffeeScript files.

To combine the streams you can pipe into another `gulp.src` or use `es.merge` (from `event-stream`). But you'll notice that in both cases the files are emitted in the same order as they come in - and this can seem very random. With `gulp-order` you can reorder the files.

## Usage

`require("gulp-order")` returns a function that takes an array of patterns (as `gulp.src` would take).

```javascript
var order = require("gulp-order");
var coffee = require("gulp-coffee");
var concat = require("gulp-concat");

gulp
  .src("**/*.coffee")
  .pipe(coffee())
  .pipe(gulp.src("**/*.js")) // gulp.src passes through input
  .pipe(order([
    "vendor/js1.js",
    "vendor/**/*.js",
    "app/coffee1.js",
    "app/**/*.js"
  ]))
  .pipe(concat("all.js"))
  .pipe(gulp.dest("dist"));

  // When passing gulp.src stream directly to order, don't include path source/scripts in the order paths.
  // They should be relative to the /**/*.js.
  gulp
  .src("source/scripts/**/*.js")
  .pipe(order([
    "vendor/js1.js",
    "vendor/**/*.js",
    "app/coffee1.js",
    "app/**/*.js"
  ]))
  .pipe(concat("all.js"))
  .pipe(gulp.dest("dist"));
```

## Options

```javascript
gulp
  .src("**/*.coffee")
  // ...
  .pipe(order([...], options))
```

### `base`

Some plugins might provide a wrong `base` on the Vinyl file objects. `base` allows you to set a base directory (for example: your application root directory) for all files.

### `rank`

Although this plugin solves most of the order problems with minimatch, sometimes you might need to use a custom ranking function.
The params received by the rank function are:

- `matchers` The order param mapped as minimatch matchers
- `files` vinyl pipeline files

This function **must** return a rank number for the given file.

A usage example would be:

```javascript

function customRank(matcher, file){
  for(const i in matchers){
    if(matchers[i].match(file.path)){
      return i;
    }
  }
  return matchers.length;
}

const files = [
  "C:/files/script.js",
  "C:/files/*.config.js",
  "C:/files/*.run.js"
  "C:/files/*.module.js",
  "C:/files/**/*.controller.js",
];

gulp
  .src(files)
  // ...
  .pipe(order(files, {rank: customRank}))  // this should keep the same order of the files array
```

## Features

Uses [`minimatch`](https://github.com/isaacs/minimatch) for matching.

## Tips

- Try to move your ordering out of your `gulp.src(...)` calls into `order(...)` instead.
- You can see the order of the outputted files with [`gulp-print`](https://github.com/alexgorbatchev/gulp-print)

## Troubleshooting

If your files aren't being ordered in the manner that you expect, try adding the [`base`](#base) option.

## Alternative Approaches

- [`gulp-if`](https://github.com/robrich/gulp-if)

## Contributors

- [Marcel Jackwerth](http://twitter.com/sirlantis)

## License

MIT - Copyright © 2014 Marcel Jackwerth
