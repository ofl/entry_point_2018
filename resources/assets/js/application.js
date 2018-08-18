import 'bootstrap/dist/css/bootstrap.min.css'
import '../sass/application.scss'

import Rails from 'rails-ujs'
import Vue from 'vue'
import ApolloClient from 'apollo-boost'
import { InMemoryCache } from 'apollo-cache-inmemory'
import VueApollo from 'vue-apollo'

Rails.start()
Vue.use(VueApollo)

const apolloClient = new ApolloClient({
  uri: '/graphql',
  request: operation => {
    operation.setContext({
      headers: { 'X-CSRF-Token': Rails.csrfToken() }
    })
  },
  fetchOptions: { credentials: 'same-origin' },
  cache: new InMemoryCache()
})

const apolloProvider = new VueApollo({ defaultClient: apolloClient })

// see https://qiita.com/midnightSuyama/items/efc5441a577f3d3abe74

const options = {}

const requireContext = require.context('./options', false, /\.js$/)
requireContext.keys().forEach(key => {
  const name = key
    .split('/')
    .pop()
    .split('.')
    .shift()

  const option = requireContext(key).default
  if (!option) {
    return
  }

  option.provide = apolloProvider.provide()
  options[name] = option
})

let vms = []

document.addEventListener('DOMContentLoaded', () => {
  const templates = document.querySelectorAll('[data-vue]')
  templates.forEach(el => {
    const vm = new Vue(Object.assign(options[el.dataset.vue], { el }))
    vms.push(vm)
  })
})

document.addEventListener('beforeunload', () => {
  vms.forEach(vm => {
    vm.$destroy()
  })
  vms = []
})
