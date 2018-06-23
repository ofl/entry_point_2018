<template>
  <h2 id="currentUser" v-if="currentUser">
    こんにちは{{currentUser.username}}さん
  </h2>
</template>

<script>
import gql from 'graphql-tag';
const helloGQL = gql`
  query {
    currentUser {
      id
      username
    }
  }
`;
export default {
  name: 'currentUser',
  data() {
    return {
      currentUser: null,
    };
  },
  apollo: {
    currentUser: {
      query: helloGQL,
    }
  },
};
</script>
