var gulp = require('gulp');
var gutil = require('gulp-util');
var coffee = require('gulp-coffee');

gulp.task('build', function() {
  return gulp.src('*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('.'));
});

gulp.task('watch', function() {
  gulp.watch('*.coffee', ['build']);
});
