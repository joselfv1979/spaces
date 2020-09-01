<!-- COMPONENTE ESTÁTICO QUE CONTIENE EL MENU DE NAVEGACIÓN --> 
<template>
  <div class="menu">
    <div class="box">
      <div class="first-box">
        <!-- MENÚ DE NAVEGACIÓN CON LAS RUTAS DE CADA VISTA DECLARADAS EN ROUTER/INDEX.JS. LINKS DINÁMICOS-->
        <router-link :to="{ name: 'Home' }">Salas</router-link>|
        <router-link :to="{ name: 'User' }">Área Personal</router-link>|
        <router-link :to="{ name: 'Register' }">Registro</router-link>
      </div>
      <div class="second-box">
        <span class="title">Spaces</span>
      </div>
      <div class="third-box">
        <!-- SE MUESTRA MIENTRAS EL USUARIO ESTÁ LOGUEADO -->
        <div v-if="logged">
          <span id="name">Hola, {{ username }}</span>
          <!-- BOTÓN PARA DESLOGUEARSE -->
          <span id="logout" @click="logout()">
            Salir
            <img class="shutdown" src="./../assets/shutdown.png" alt />
          </span>
        </div>
        <div v-else>
          <router-link :to="{ name: 'Login' }">Login</router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { logout, getRole } from "./../../../backend/requests/user";

export default {
  name: "MenuCustom",
  props: {
    username: String,
    logged: Boolean,
  },

  methods: {
    logout() {
      this.$emit("logout");
    },
  },
};
</script>

<style scoped>
.menu {
  width: 100%;
  height: 60px;
  align-self: flex-start;
  background-color: #3b83bd;
  flex-shrink: 0;
  display: flex;
}

.box {
  width: 100%;
  margin: auto;
  display: flex;
  vertical-align: center;
  flex-wrap: wrap;
  align-content: space-around;
}

.first-box,
.second-box,
.third-box {
  align-self: center;
  width: 33%;
}

.first-box a {
  margin: 10px;
}

.title {
  font-size: 1.5rem;
}

.shutdown {
  height: 16px;
  width: 16px;
  margin-top: 0;
  margin-bottom: 0;
  margin-left: 5px;
  vertical-align: middle;
  cursor: pointer;
}

#name {
  margin: 10px;
}

#logout {
  margin: 5px;
  margin-left: 30px;
}

span {
  font-weight: bold;
}

#logout {
  cursor: pointer;
}

#logout:hover {
  color: cyan;
}

@media screen and (max-width: 600px) {
  .menu {
    height: 140px;
  }
  .first-box,
  .second-box,
  .third-box {
    width: 100%;
    margin: 10px;
  }
  .second-box {
    order: -1;
  }
}
</style>