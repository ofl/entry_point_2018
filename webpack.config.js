const path = require('path')
const glob = require('glob')
const webpack = require("webpack")
const bundlePath = path.join(__dirname, 'public/packs')
const cleanupPath = process.env.CLEANUP ? [bundlePath] : []

const ManifestPlugin = require('webpack-manifest-plugin')
const MiniCssExtractPlugin = require("mini-css-extract-plugin")
const VueLoaderPlugin = require('vue-loader/lib/plugin')
const CleanWebpackPlugin = require('clean-webpack-plugin')

let getEntry = () => {
  const src = path.join(__dirname, 'app', 'javascript', 'packs')

  const targets = glob.sync(path.join(src, '**/*.{js,vue,jsx,ts,tsx}'))
  const entry = targets.reduce((entry, target) => {
    const bundle = path.relative(src, target)
    const ext = path.extname(bundle)

    return Object.assign({}, entry, {
      [bundle.replace(ext, '')]: path.join(src, bundle),
    })
  }, {})

  return entry
}

module.exports = {
  entry: getEntry(),
  output: {
    filename: '[name]-[chunkhash].js',
    chunkFilename: '[name]-[chunkhash].chunk.js',
    hotUpdateChunkFilename: '[id]-[hash].hot-update.js',
    path: bundlePath,
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
        use: [{
          loader: 'babel-loader'
        }]
      },
      {
        test: /\.vue$/,
        use: [{
          loader: 'vue-loader'
        }]
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
        loader: process.env.DEBUG ? 'file-loader?name=[name].[ext]' : 'file-loader?name=[name]-[hash].[ext]',
        options: {
          outputPath: 'images/'
        }
      }
    ]
  },
  plugins: [
    new webpack.EnvironmentPlugin({
      NODE_ENV: 'development',
      DEBUG: false,
      CLEANUP: false
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
    new CleanWebpackPlugin(cleanupPath)
  ]
}
