let mix = require('laravel-mix');

/*
 |--------------------------------------------------------------------------
 | Mix Asset Management
 |--------------------------------------------------------------------------
 |
 | Mix provides a clean, fluent API for defining some Webpack build steps
 | for your Laravel application. By default, we are compiling the Sass
 | file for the application as well as bundling up all the JS files.
 |
 */

mix.setPublicPath('public')
  .js('resources/assets/js/application.js', 'public/js')
  .sass('resources/assets/sass/application.scss', 'public/css');

if (mix.inProduction()) {
  mix.version();
} else {
  mix.sourceMaps();

  mix.browserSync({
    proxy: "http://localhost:3000",
    browser: "google chrome",
    port: 3007,
    ui: {
      port: 3008
    },
    files: [
      './app/**/*.rb',
      './app/**/*.slim',
      './public/js/application.js',
      './public/css/application.css',
      './public/images/**/*.png',
      './public/images/**/*.jpg',
      './public/images/**/*.jpeg'
    ],
    watchOptions: {
      usePolling: true,
      interval: 500
    },
    open: "external",
    reloadOnRestart: true
  });
}
