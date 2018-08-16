<template>
  <div id="app">
    <p>{{ message }}</p>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      message: "Hello Vue! xxx"
    }
  }
}
</script>

<style scoped>
p {
  font-size: 4em;
  text-align: center;
}
</style>
