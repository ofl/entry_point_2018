export default {
  data: { password: '' },
  computed: {
    passwordIsEmpty() {
      return !!!this.password
    }
  }
}
