<!-- VISTA QUE CONTIENE EL FORMULARIO DE EDICIÓN DE PERFIL DE USUARIO -->
<template>
  <div id="main">
    <vue-headful title="Pefil de usuario" />
    <div class="form">
      <h3>Edita tu perfil:</h3>
      <p v-if="!isComplete" class="red">Rellena los campos marcados en rojo</p>
      <div class="data">
        <div>
          <!-- INPUTS VINCULADOS AL DATA CON V-MODEL -->
          <label for="name">nombre completo</label>
          <input type="text" placeholder="Nombre y apellidos" v-model="newName" :class="{ alert: !checkName }" />
        </div>
        <div>
          <label for="name">nombre de usuario</label>
          <input type="text" placeholder="Nombre de usuario" v-model="newUsername" :class="{ alert: !checkUsername }" />
        </div>
        <div>
          <label for="name">email</label>
          <input type="email" placeholder="Email del usuario" v-model="newEmail" :class="{ alert: !checkEmail }" />
        </div>
      </div>
      <div class="button-box">
        <!-- BOTÓN PARA ACTUALIZAR PERFIL -->
        <button @click="updateProfile()">Guardar</button>
        <!-- BOTÓN PARA CANCELAR LA OPERACIÓN -->
        <button @click="cancel()">Cancelar</button>
      </div>
    </div>
  </div>
</template>

<script>
// IIMPORTACIÓN DE FUNCIONES Y LIBRERÍAS EXTERNAS
import axios from "axios";
import Swal from "sweetalert2";
import {
  getId,
  getAuthToken,
  updateUser,
  getUser,
  logout,
} from "./../../../backend/requests/user";

export default {
  name: "UpdateUser",
  data() {
    // VARIABLES DE LA VISTA
    return {
      users: [],
      userId: "",
      newName: "",
      newUsername: "",
      newEmail: "",
      isComplete: true,
      checkUsername: true, // SI ES FALSE MUESTRA MENSAJE
      checkName: true, // SI ES FALSE MUESTRA MENSAJE
      checkEmail: true, // SI ES FALSE MUESTRA MENSAJE
    };
  },
  methods: {
    // FUNCIÓN QUE OBTIENE EL PERFIL DE USUARIO
    async getDataClient() {
      let userId = getId();
      let token = getAuthToken();
      const user = await getUser(userId, token);
      this.showUserData(user);
    },
    // FUNCIÓN QUE CARGA EL PERFIL DE USUARIO
    showUserData(user) {
      this.newName = user.name;
      this.newUsername = user.username;
      this.newEmail = user.email;
    },
    // FUNCIÓN PARA ACTUALIZAR EL PERFIL DE USUARIO
    async updateProfile() {
      this.checkUsername = this.newUsername;
      this.checkName = this.newName;
      this.checkEmail = this.newEmail;
      if (!this.newName || !this.newUsername || !this.newEmail) {
        this.isComplete = false
        return;
      }
      let userId = getId();
      let token = getAuthToken();
      let name = this.newName;
      let username = this.newUsername;
      let email = this.newEmail;
      await updateUser(userId, name, username, email, token);
      Swal.fire({
        text: "Perfil actualizado",
        onClose: () => {
          this.$emit("update", this.newUsername);
          this.$router.push({ name: "User" });
        },
      });
    },
    // FUNCIÓN QUE CANCELA LA OPERACIÓN
    cancel() {
      this.$router.push({ name: "User" });
    },
  },
  created() {
    // LLAMADA A LA FUNCIÓN PARA OBTENER EL PERFIL DE USUARIO AL CREAR LA VISTA
    this.getDataClient();
  },
};
</script>

<style scoped>
#main {
  background: linear-gradient(white,#2c3e50);
}

.form {
  width: 400px;
  padding: 16px;
  border-radius: 10px;
  margin: auto;
  background-color: #ccc;
  color: #2c3e50;
}

button {
  background-color: #2c3e50;
}

.data {
  text-align: justify;
  margin-left: 25px;
}

.data div {
  margin-top: 15px;
}

.button-box {
  margin-top: 20px;
}

h3 {
  margin-bottom: 20px;
}

label {
  width: 142px;
  font-weight: bold;
  display: inline-block;
}

input {
  width: 180px;
  padding: 3px 10px;
  border-radius: 3px;
  border: 1px solid #f6f6f6;
}

input:hover {
  cursor: pointer;
}

.red {
  color: #d33;
  display: block;
  font-size: 0.8rem;
}

.alert {
  border: 1px solid #d33;
}

</style>