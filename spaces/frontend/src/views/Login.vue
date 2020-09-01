<!-- VISTA QUE CONTIENE EL FORMULARIO DE LOGIN DE USUARIO -->
<template>
  <div id="main">
    <!-- TÍTULO PERSONALIZADO CON VUE-HEADFUL -->
    <vue-headful title="Login" />
    <div class="container">
      <div class="form">
        <h2>Inicia sesión</h2>
        <!-- INPUTS VINCULADOS AL DATA CON V-MODEL -->
        <span class="red" v-if="!logged">Usuario o contraseña incorrectos</span>
        <div class="user">
          <input
            type="text"
            v-model="username"
            :class="{ alert: !checkUsername }"
            placeholder="Tu nombre de usuario"
          />
          <span class="red" v-if="!checkUsername">Escribe tu usuario</span>
        </div>
        <div class="user">
          <input
            id="password"
            type="password"
            v-model="password"
            :class="{ alert: !checkPassword }"
            placeholder="Tu contraseña"
          />
          <span class="red" v-if="!checkPassword">Escribe tu password</span>
        </div>
        <!-- BOTÓN PARA MOSTRAR LA PASSWORD EN CLARO -->
        <div>
          <span id="clear" @click="showPassword()">Ver/ocultar</span>
        </div>
        <!-- BOTÓN PARA LOGUEARSE -->
        <div class="button-box">
          <button @click="loginUser()">Login</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
// IMPORTACIÓN DE COMPONENTES, FUNCIONES Y LIBRERÍAS EXTERNAS
import { setAuthToken, userLogin } from "./../../../backend/requests/user";
import spinner from "@/components/Spinner.vue";

export default {
  name: "Login",
  components: {
    spinner,
  },
  props: {},
  data() {
    // VARIABLES DE LA VISTA
    return {
      username: "",
      password: "",
      checkUsername: true, // SI ES FALSE MUESTRA MENSAJE
      checkPassword: true, // SI ES FALSE MUESTRA MENSAJE
      logged: true, // SI ES FALSE MUESTRA MENSAJE
    };
  },

  methods: {
    // FUNCIÓN PARA MOSTRAR LA PASSWORD EN CLARO
    showPassword() {
      let tipo = document.getElementById("password");
      if (tipo.type == "password") {
        tipo.type = "text";
      } else {
        tipo.type = "password";
      }
    },

    // FUNCIÓN DE LOGIN, SI ES CORRECTO REDIRIGE AL ÁREA PERSONAL
    async loginUser() {
      this.checkUsername = this.username;
      this.checkPassword = this.password;
      if (this.checkUsername && this.checkPassword) {
        this.checkUsername = true;
        this.checkPassword = true;
        const result = await userLogin(this.username, this.password);
        if (result) {
          // EMITO EVENTO CON DATOS OBTENIDOS
          this.$emit("login", result);
          // REDIRECCIÓN AL ÁREA PERSONAL
          this.$router.push({ name: "User" });
        } else {
          this.logged = false;
        }
      }
    },
  },
};
</script>

<style scoped>
.container {
  height: 100vh;
  display: flex;
  align-items: center;
  vertical-align: center;
}

.form {
  margin-bottom: 20px;
  margin-left: auto;
  margin-right: auto;
  width: 400px;
  padding: 16px;
  border-radius: 10px;
  background-color: #ccc;
  color: #2c3e50;
}

button {
  width: 50%;
  padding: 8px 16px;
  margin-top: 20px;
  border: 1px solid #2c3e50;
  border-radius: 5px;
  display: block;
  color: #fff;
  background-color: #2c3e50;
  display: inline-block;
}

button:hover {
  cursor: pointer;
  background-color: #2c3e50;
}

input {
  border-radius: 3px;
  padding: 0.3rem;
  margin: 0.3rem;
  border: none;
  border-bottom: 2px solid #3b83bd;
  border-top: 2px solid transparent;
  border-right: 2px solid transparent;
  border-left: 2px solid transparent;
  /* transition: all 0.4s; */
}

input:hover {
  border: 2px solid #3b83bd;
  cursor: pointer;
}

#clear {
  cursor: pointer;
}

#clear:hover {
  color: #3b83bd;
}

.red {
  color: #d33;
  display: block;
  font-size: 0.8rem;
}

.alert {
  border: 1px solid #d33;
}

.user {
  margin: 15px;
}
</style>