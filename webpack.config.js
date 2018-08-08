module.exports = {
  mode: 'development',
  output: {
    filename: '[name]-[chunkhash].js',
    chunkFilename: '[name]-[chunkhash].chunk.js',
    hotUpdateChunkFilename: '[id]-[hash].hot-update.js',
    path: '/usr/src/entry_point_2018/public/packs',
    publicPath: '/packs/',
    pathinfo: true
  },
  resolve: {
    extensions: [
      '.js',
      '.vue',
      '.sass',
      '.scss',
      '.css',
      '.module.sass',
      '.module.scss',
      '.module.css',
      '.png',
      '.svg',
      '.gif',
      '.jpeg',
      '.jpg'
    ],
    modules: ['/usr/src/entry_point_2018/app/javascript', 'node_modules']
  },
  resolveLoader: {
    modules: ['node_modules']
  },
  node: {
    dgram: 'empty',
    fs: 'empty',
    net: 'empty',
    tls: 'empty',
    child_process: 'empty'
  },
  cache: true,
  devtool: 'cheap-module-source-map',
  devServer: {
    clientLogLevel: 'none',
    compress: true,
    quiet: false,
    disableHostCheck: true,
    host: 'localhost',
    port: 3035,
    https: false,
    hot: false,
    contentBase: '/usr/src/entry_point_2018/public/packs',
    inline: true,
    useLocalIp: false,
    public: 'localhost:3035',
    publicPath: '/packs/',
    historyApiFallback: {
      disableDotRule: true
    },
    headers: {
      'Access-Control-Allow-Origin': '*'
    },
    overlay: true,
    stats: {
      errorDetails: true
    },
    watchOptions: {
      ignored: '/node_modules/'
    }
  },
  entry: {
    application: '/usr/src/entry_point_2018/app/javascript/packs/application.js',
    'components/app': '/usr/src/entry_point_2018/app/javascript/packs/components/app.vue',
    'components/hello': '/usr/src/entry_point_2018/app/javascript/packs/components/hello.vue',
    'options/hello_vue': '/usr/src/entry_point_2018/app/javascript/packs/options/hello_vue.js',
    'options/hello': '/usr/src/entry_point_2018/app/javascript/packs/options/hello.js',
    'options/password-required': '/usr/src/entry_point_2018/app/javascript/packs/options/password-required.js'
  },
  module: {
    strictExportPresence: true,
    rules: [
      [Object],
      [Object],
      [Object],
      [Object],
      [Object],
      [Object],
      [Object]
    ]
  },
  plugins: [EnvironmentPlugin {
      keys: [Object],
      defaultValues: [Object]
    },
    CaseSensitivePathsPlugin {
      options: {},
      pathCache: {},
      fsOperations: 0,
      primed: false
    },
    MiniCssExtractPlugin {
      options: [Object]
    },
    WebpackAssetsManifest {
      hooks: [Object],
      options: [Object],
      assets: {},
      assetNames: Map {},
      currentAsset: null,
      compiler: null,
      stats: null,
      hmrRegex: null
    }
  ]
}
