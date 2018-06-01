/* eslint no-console: 0 */

import Vue from 'vue/dist/vue.esm'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '.password-required',
    data: {
      user: {
        password: ''
      }
    },
    computed: {
      passwordIsEmpty() {
        const user = this.user
        return !!!user.password
      }
    }
  })
})
