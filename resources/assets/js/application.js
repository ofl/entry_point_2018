/* eslint no-console:0 */

import 'bootstrap/dist/css/bootstrap.min.css'
import '../sass/application.scss'

import Rails from 'rails-ujs'
Rails.start()

import Vue from 'vue'

import ApolloClient from 'apollo-boost'
import { InMemoryCache } from 'apollo-cache-inmemory'
import VueApollo from 'vue-apollo'
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

var vms = []
var options = {}

let requireContext = require.context('./options', false, /\.js$/)
requireContext.keys().forEach(key => {
  let name = key
    .split('/')
    .pop()
    .split('.')
    .shift()
  let option = requireContext(key).default

  if (option === void 0) {
    return
  }

  option.provide = apolloProvider.provide()
  options[name] = option
})

document.addEventListener('DOMContentLoaded', () => {
  let templates = document.querySelectorAll('[data-vue]')
  for (let el of templates) {
    let vm = new Vue(Object.assign(options[el.dataset.vue], { el }))
    vms.push(vm)
  }
})

document.addEventListener('beforeunload', () => {
  for (let vm of vms) {
    vm.$destroy()
  }
  vms = []
})
