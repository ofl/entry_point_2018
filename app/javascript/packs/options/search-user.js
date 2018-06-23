import ApolloClient from 'apollo-boost'
import { InMemoryCache } from 'apollo-cache-inmemory'

import Vue from 'vue'
import VueApollo from 'vue-apollo'
import App from '../components/user.vue'
import { csrfToken } from 'rails-ujs'

Vue.use(VueApollo)

const uri = '/graphql'

const apolloClient = new ApolloClient({
  uri: uri,
  fetchOptions: {
    credentials: 'same-origin',
  },
  request: (operation) => {
    operation.setContext({
      headers: { "X-CSRF-Token": csrfToken() }
    })
  },
  cache: new InMemoryCache(),
})

const apolloProvider = new VueApollo({ defaultClient: apolloClient })

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#user',
    provide: apolloProvider.provide(),
    render: h => h(App),
  })
})
