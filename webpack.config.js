const DEBUG = process.env.NODE_ENV === 'development' || process.env.NODE_ENV === undefined
const path = require('path')
const webpack = require("webpack")
const ManifestPlugin = require('webpack-manifest-plugin')
const MiniCssExtractPlugin = require("mini-css-extract-plugin")
const VueLoaderPlugin = require('vue-loader/lib/plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin')

module.exports = {
  mode: 'development',
  entry: {
    application: '/usr/src/entry_point_2018/app/javascript/packs/application.js',
    'components/app': '/usr/src/entry_point_2018/app/javascript/packs/components/app.vue',
    'components/hello': '/usr/src/entry_point_2018/app/javascript/packs/components/hello.vue',
    'options/hello_vue': '/usr/src/entry_point_2018/app/javascript/packs/options/hello_vue.js',
    'options/hello': '/usr/src/entry_point_2018/app/javascript/packs/options/hello.js',
    'options/password-required': '/usr/src/entry_point_2018/app/javascript/packs/options/password-required.js'
  },
  output: {
    filename: '[name]-[chunkhash].js',
    chunkFilename: '[name]-[chunkhash].chunk.js',
    hotUpdateChunkFilename: '[id]-[hash].hot-update.js',
    path: '/usr/src/entry_point_2018/public/packs',
    publicPath: '/packs/',
    pathinfo: true
  },
  devtool: 'cheap-module-source-map',
  resolve: {
    modules: [path.join(__dirname, 'src'), 'node_modules'],
    extensions: [
      '.js', '.vue', '.sass', '.scss', '.css'
    ],
    alias: {
      'vue$': 'vue/dist/vue.esm.js',
    },
  },
  cache: true,
  module: {
    rules: [{
        test: /\.js$/,
        exclude: /node_modules/,
        use: [
          { loader: 'babel-loader' }
        ]
      },
      {
        test: /\.vue$/,
        use: [
          { loader: 'vue-loader' }
        ]
      },
      {
        test: /\.(sass|scss|css)$/,
        use: [
          MiniCssExtractPlugin.loader,
          {
            loader: "css-loader",
            options: {
              minimize: {
                safe: true
              }
            }
          },
          {
            loader: "postcss-loader",
            options: {
              autoprefixer: {
                browsers: ["last 2 versions"]
              },
              plugins: () => [
                require('autoprefixer')
              ]
            },
          },
          {
            loader: "sass-loader",
            options: {}
          }
        ]
      },
      {
        test: /\.svg(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'url-loader?mimetype=image/svg+xml'
      },
      {
        test: /\.woff(\d+)?(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'url-loader?mimetype=application/font-woff'
      },
      {
        test: /\.eot(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'url-loader?mimetype=application/font-woff'
      },
      {
        test: /\.ttf(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'url-loader?mimetype=application/font-woff'
      },
      {
        test: /\.(jpg|png|gif)$/,
        loader: DEBUG ? 'file-loader?name=[name].[ext]' : 'file-loader?name=[name]-[hash].[ext]',
        options: {
          outputPath: 'images/'
        }
      }
    ]
  },
  plugins: [
    new webpack.EnvironmentPlugin({
      keys: [Object],
      defaultValues: [Object]
    }),
    new MiniCssExtractPlugin({
      filename: '[name]-[chunkhash].css',
      chunkFilename: '[name]-[chunkhash].chunk.css',
    }),
    new ManifestPlugin({
      fileName: 'manifest.json',
      publicPath: '/packs/',
      writeToFileEmit: true
    }),
    new VueLoaderPlugin(),
    new CleanWebpackPlugin(['/usr/src/entry_point_2018/public/packs/'])
  ]
}
