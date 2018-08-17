const mix = require('laravel-mix')

mix.setPublicPath('public')
  .disableSuccessNotifications()
  .sourceMaps(false)
  .js('resources/assets/js/application.js', 'public/js')
  .sass('resources/assets/sass/application.scss', 'public/css')
  .copy('resources/assets/images', 'public/images')

// TODO: mix-manifest.jsonに画像を登録して欲しいのだが、うまく行かない
// mix.version(['public/images'])

if (mix.inProduction()) {
  mix.version()
} else {
  mix.browserSync({
    proxy: 'http://localhost:3000',
    browser: 'google chrome',
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
    open: 'external',
    reloadOnRestart: true
  })

  mix.webpackConfig({
    module: {
      rules: [{ // JavaScript Prettier Setting
          test: /\.js$/,
          loader: 'prettier-loader',
          options: { // Prettier Options https://prettier.io/docs/en/options.html
            singleQuote: true,
            semi: false,
            parser: 'babylon'
          }
        },
        { // Sass Prettier Setting
          test: /\.scss$/,
          loader: 'prettier-loader',
          options: {
            parser: 'css'
          }
        },
      ]
    }
  })
}
