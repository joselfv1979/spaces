<template>
  <div id="app">
    <!-- DECLARACIÓN DE COMPONENTES -->
    <menucustom v-on:logout="logoutUser" :username="username" :logged="logged" />
    <router-view @login="doLogin" @update="usernameUpdate" @spaces="setSpaces" :spaces="spaces" />
    <footercustom />
  </div>
</template>

<script>
// IMPORTACIÓN DE COMPONENTES, FUNCIONES Y LIBRERÍAS EXTERNAS
import menucustom from "@/components/MenuCustom.vue";
import footercustom from "@/components/FooterCustom.vue";
import {
  logout,
  getUserName,
  getAuthToken,
  isLoggedIn,
} from "./../../backend/requests/user";

export default {
  name: "App",
  // REGISTRO DE COMPONENTES
  components: {
    menucustom,
    footercustom,
  },
  data() {
    // VARIABLES DE LA VISTA
    return {
      username: "",
      logged: false,
      token: "",
      spaces: [],
    };
  },

  methods: {
    // FUNCIÓN DE DESLOGUEO
    logoutUser() {
      this.username = "";
      this.token = "";
      this.logged = false;
      logout();
      if (this.$route.name !== "Home") {
        this.$router.push("/");
      }
    },
    // INICIALIZACIÓN DE VARIABLES CON LOS DATOS QUE ENVIA LA VISTA LOGIN
    doLogin(result) {
      this.username = result.username;
      this.token = result.token;
      this.logged = true;
    },
    // ACTUALIZACIÓN DE VARIABLE CON LOS DATOS QUE ENVIA LA VISTA UPDATEUSER
    usernameUpdate(result) {
      this.username = result;
    },
    // INICIALIZACIÓN DE VARIABLE CON LOS DATOS QUE ENVIA LA VISTA HOME
    setSpaces(result) {
      this.spaces = result;
    },
  },
  created() {
    // INICIALIZACIÓN DE VARIABLES AL CARGAR LA PÁGINA
    this.username = getUserName();
    if (this.username) {
      this.logged = true;
    }
    this.token = getAuthToken();
    this.spaces = JSON.parse(localStorage.getItem("SPACES"));
  },
};
</script>

<style>
* {
  margin: 0;
  padding: 0;
}

#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  font-size: 0.9rem;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  min-height: 100vh;
  display: flex;
  flex-wrap: wrap;
  flex-direction: column;
  align-items: stretch;
}

#main {
  height: 80vh;
  flex: 1;
  width: 100%;
  display: flex;
  flex-direction: column;
  background-color: whitesmoke;
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
}

.modalBox {
  background-color: whitesmoke;
  margin: 2% auto;
  padding: 3rem;
  width: 400px;
  border: 4px solid black;
  border-radius: 3px;
}

#foot {
  background-color: #3b83bd;
  width: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  font-weight: bold;
  color: #2c3e50;
  align-self: flex-end;
}

a {
  font-weight: bold;
  color: #2c3e50;
  text-decoration: none;
}

a:hover {
  color: cyan;
}

h2 {
  margin-bottom: 10px;
}

h3 {
  margin-top: 20px;
}

button {
  width: 130px;
  border-radius: 10px;
  background: #3b83bd;
  color: white;
  padding: 0.5rem;
  margin: 1.2rem;
  border: none;
  display: inline-block;
}

button:hover {
  cursor: pointer;
  background: dodgerblue;
}

img {
  margin-top: 20px;
  width: 150px;
  height: 100px;
}

ul {
  display: flex;
  flex-wrap: wrap;
  align-items: stretch;
  justify-content: space-around;
}

ul li {
  margin: 0.667rem;
  list-style: none;
}

ul li p {
  display: inline-block;
  padding: 0.667rem;
}

@media screen and (max-width: 600px) {
  .form {
    width: 350px;
    font-size: small;
    background-color: whitesmoke;
  }

  .modalBox {
    width: 250px;
    font-size: small;
  }
}
</style>