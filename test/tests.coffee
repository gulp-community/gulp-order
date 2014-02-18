order = require "../src"
path = require "path"
{ File } = require "gulp-util"
{ expect } = require "chai"
require "mocha"

newFile = (filepath) ->
  base = "/home/johndoe/"
  
  new File
    path: path.join(base, filepath)
    base: base
    cwd: base
    contents: new Buffer("")

describe "gulp-order", ->
  describe "order()", ->
    it "should order files", (done) ->
      stream = order(["foo.js", "bar.js"])
      
      files = []
      stream.on "data", files.push.bind(files)
      stream.on "end", ->
        expect(files.length).to.equal 4
        expect(files[0].relative).to.equal "foo.js"
        expect(files[1].relative).to.equal "bar.js"
        expect(files[2].relative).to.equal "baz-a.js"
        expect(files[3].relative).to.equal "baz-b.js"
        done()

      stream.write newFile("baz-b.js")      
      stream.write newFile("bar.js")  
      stream.write newFile("baz-a.js")
      stream.write newFile("foo.js")
      stream.end()
    
    it "should support globs", (done) ->
      stream = order(["vendor/**/*", "app/**/*"])
      
      files = []
      stream.on "data", files.push.bind(files)
      stream.on "end", ->
        expect(files.length).to.equal 5
        expect(files[0].relative).to.equal "vendor/f/b.js"
        expect(files[1].relative).to.equal "vendor/z/a.js"
        expect(files[2].relative).to.equal "app/a.js"
        expect(files[3].relative).to.equal "other/a.js"
        expect(files[4].relative).to.equal "other/b/a.js"
        done()
        
      stream.write newFile("vendor/f/b.js")
      stream.write newFile("app/a.js")
      stream.write newFile("vendor/z/a.js")
      stream.write newFile("other/a.js")
      stream.write newFile("other/b/a.js")
      stream.end()