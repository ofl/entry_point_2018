<template>
  <h2 id="user" v-if="user">
    こんにちは{{user.username}}さん
  </h2>
</template>

<script>
import gql from 'graphql-tag';
const helloGQL = gql`
  query {
    user(username: "testuser") {
      id
      username
    }
  }
`;
export default {
  name: 'user',
  data() {
    return {
      user: null,
    };
  },
  apollo: {
    user: {
      query: helloGQL,
    }
  },
};
</script>
