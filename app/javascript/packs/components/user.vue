<template>
  <div id="user">
    <h1> Vue Apollo Example </h1>
    <p v-if="user">{{user.username}}</p>
    <label>name</label>
    <input type="text" v-model="username">
    <a href="#" @click="_createUser">createUser</a>

    <div v-if="createdUser">
      <p>user created</p>
      <p>name: {{createdUser.name}}</p>
    </div>
  </div>
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
const createUserGQL = gql`
  mutation ($username: String!){
    createUser(name: $username) {
      _id
      username
    }
  }
`
export default {
  name: 'user',
  data() {
    return {
      username: '',
      createdUser: null
    };
  },
  apollo: {
    user: {
      query: helloGQL,
    }
  },
  methods: {
    _createUser() {
      this.$apollo.mutate({
        mutation: createUserGQL,
        variables: {
          username: this.username
        }
      }).then(res => {
        console.log(res);
        this.createdUser = res.data.createUser
      }).catch(err => {
        console.error(err);
      })
    }
  }
};
</script>
