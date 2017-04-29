var gulp = require('gulp')
var pug = require('gulp-pug')
var sass = require('gulp-sass')
var coffee = require('gulp-coffee')
var minifyCSS = require('gulp-csso')
var gutil = require('gulp-util')
var del = require('del')
var browserify = require('browserify')
var coffeeify = require('coffeeify')
var watchify = require('watchify')
var source = require('vinyl-source-stream')
var buffer = require('vinyl-buffer')
var sourcemaps = require('gulp-sourcemaps')

//Configuration
var config = {
  buildDir: './build',
  sourceDir: './src',
  browserifyEntry: './src/coffee/Main.coffee',
  browserifyBundle: 'bundle.js'
}

gulp.task('html', function(){
  return gulp.src(config.sourceDir + '/*.pug')
    .pipe(pug().on('error', gutil.log))
    .pipe(gulp.dest(config.buildDir))
});

gulp.task('css', function(){
  return gulp.src(config.sourceDir+'/sass/*.sass')
    .pipe(sass().on('error', gutil.log))
    .pipe(minifyCSS())
    .pipe(gulp.dest(config.buildDir + '/css'))
});

gulp.task('watchify', function(){
  var args = watchify.args
  args.extensions = ['.coffee']
  args.debug = true
  bundler = watchify(browserify(config.browserifyEntry, args), args)
  bundler.transform(coffeeify)

  rebundle = function(){
    gutil.log(gutil.colors.green('Rebundling...'))
    bundler.bundle()
      .on("error", gutil.log.bind(gutil, "Browserify Error"))
      .pipe(source(config.browserifyBundle))
      .pipe(buffer())
        .pipe(sourcemaps.init({loadMaps: true}))
        .pipe(sourcemaps.write('./'))
      .pipe(gulp.dest(config.buildDir + "/js"))
    gutil.log(gutil.colors.green('Rebundled'))
  }

  bundler.on("update", rebundle)
  rebundle()
})

gulp.task('scripts', function(){
  var args = {}
  args.extensions = ['.coffee']
  args.debug = true

  bundler = browserify(config.browserifyEntry, args)
  bundler.transform(coffeeify)
  bundler.bundle()
    .on("error", gutil.log.bind(gutil, "Browserify Error"))
    .pipe(source(config.browserifyBundle))
    .pipe(buffer())
      .pipe(sourcemaps.init({loadMaps: true}))
      .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(config.buildDir + "/js"))
})

gulp.task('static', function() {
  return gulp.src('./static/**/*.png')
    .pipe(gulp.dest('build/static'))
})

gulp.task('clean', function() {
  return del([
    'build'
  ])
});

gulp.task('watch', function() {
  gulp.watch(config.sourceDir + '/sass/*.sass',     [ 'css' ])
  gulp.watch(config.sourceDir + '/*.pug',           [ 'html' ])
  gulp.watch(config.sourceDir + '/coffee/*.coffee', [ 'scripts' ])
  gulp.watch('./static/**/*.png', [ 'static' ])
})

gulp.task('default', [ 'html', 'css', 'static']);
