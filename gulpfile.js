var gulp = require('gulp')
var pug = require('gulp-pug')
var sass = require('gulp-sass')
var coffee = require('gulp-coffee')
var minifyCSS = require('gulp-csso')
var gutil = require('gulp-util')
var del = require('del')
var browserify = require('browserify')
var source = require('vinyl-source-stream')
var buffer = require('vinyl-buffer')
var sourcemaps = require('gulp-sourcemaps')

//Configuration
var config = {
  buildDir: './build',
  sourceDir: './src',
  browserifyEntry: './build/js/Main.js',
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

gulp.task('coffee', function(){
  //Compile Coffee
  gulp.src(config.sourceDir+'/coffee/*.coffee')
    .pipe(coffee().on('error', gutil.log))
    .pipe(gulp.dest(config.buildDir + '/js'))

  //Create the browserify instance
  var b = browserify({
    entries: config.browserifyEntry,
    debug: true
  });

  //Bundle JS
  return b.bundle()
    .pipe(source(config.browserifyBundle))
    .pipe(buffer())
    .pipe(sourcemaps.init({loadMaps: true}))
        .on('error', gutil.log)
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(config.buildDir + '/js/'));
});

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
  gulp.watch(config.sourceDir + '/coffee/*.coffee', [ 'coffee' ])
  gulp.watch('./static/**/*.png', [ 'static' ])
})

gulp.task('default', [ 'html', 'css', 'coffee', 'static']);
