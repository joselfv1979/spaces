<!-- VISTA DEL ÁREA PERSONAL CON DIVERSAS FUNCIONALIDADES SEGÚN EL ROL DEL USUARIO -->
<template>
  <div id="main">
    <!-- TÍTULO PERSONALIZADO CON VUE-HEADFUL -->
    <vue-headful title="Área personal" />
    <div class="content">
      <h2>Área personal</h2>
      <div class="box">
        <!-- ELEMENTO PARA ACTUALIZAR EL PERFIL DE USUARIO -->
        <h3>Perfil</h3>
        <p>
          <strong>Actualiza tus datos personales</strong>
        </p>
        <button @click="editUser()">Mi Perfil</button>
      </div>
      <div class="box">
        <!-- ELEMENTO PARA ELIMINAR EL PERFIL DE USUARIO -->
        <h3>Eliminar cuenta</h3>
        <p>
          <strong>Elimina tus datos personales</strong>
        </p>
        <button @click="deleteUser()">Eliminar cuenta</button>
      </div>
      <!-- BOTONES CON V-IF ENLAZADOS SE MUESTRAN SEGÚN EL ROL DE USUARIO -->
      <div v-if="provider">
        <div class="box">
          <!-- ELEMENTO PARA MOSTRAR LOS ESPACIOS DE UN PROVEEDOR -->
          <h3>Mis espacios</h3>
          <p>
            <strong>Gestiona tus espacios</strong>
          </p>
          <button @click="goMySpaces()">Mis Espacios</button>
        </div>
        <!-- ELEMENTO PARA QUE UN PROVEEDOR CREE UN ESPACIO -->
        <div class="box">
          <h3>Añadir espacio</h3>
          <p>
            <strong>Añade un nuevo espacio</strong>
          </p>
          <button @click="addSpace()">Añadir Espacio</button>
        </div>
      </div>
      <!-- ELEMENTO PARA MOSTAR LAS RESERVAS DE UN USUARIO BUSCADOR -->
      <div v-if="seeker">
        <div class="box">
          <h3>Mis reservas</h3>
          <p>
            <strong>Gestiona tus reservas</strong>
          </p>
          <button @click="goMyBooks()">Mis reservas</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
// IMPORTACIÓN DE COMPONENTES, FUNCIONES Y LIBRERÍAS EXTERNOS
import axios from "axios";
import Swal from "sweetalert2";
import { getRole } from "./../../../backend/requests/user";

export default {
  name: "User",
  components: {
    // DECLARACIÓN DEL COMPONENTE
  },
  data() {
    // VARIABLES DE LA VISTA
    return {
      name: "",
      provider: false,
      seeker: false,
    };
  },
  methods: {
    // FUNCIÓN DE REDIRECCIÓN A LA VISTA DE EDICIÓN DE PERFIL
    editUser() {
      this.$router.push({ name: "UpdateUser" });
    },
    // FUNCIÓN PARA BORRAR EL PERFIL DE USUARIO
    deleteUser() {
      Swal.fire({
        text: "Estás seguro de eliminar la cuenta?",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Eliminar!",
      }).then((result) => {
        if (result.value) {
          Swal.fire({
            text: "La cuenta ha sido eliminada.",
            onClose: () => {
              dropUser();
              this.userLogout();
            },
          });
        }
      });
    },
    // FUNCIÓN QUE COMPRUEBA EL ROL DE USUARIO
    checkRole() {
      let rol = getRole();
      if (rol === "provider") {
        this.provider = true;
      } else if (rol === "seeker") {
        this.seeker = true;
      }
    },
    // FUNCIÓN QUE OBTIENE LOS ESPACIOS DE UN PROVEEDOR
    goMySpaces() {
      this.$router.push({ name: "SpaceProviderList" });
    },

    // FUNCIÓN DE REDIRECCIÓN A LA VISTA DE CREACIÓN DE ESPACIOS
    addSpace() {
      this.$router.push({ name: "AddSpace" });
    },
    // FUNCIÓN DE REDIRECCIÓN A LA VISTA DE RESERVAS DE USUARIO
    goMyBooks() {
      this.$router.push({ name: "BookList" });
    },
  },
  created() {
    // LLAMADA A LA FUNCIÓN QUE COMPRUEBA EL ROL DE USUARIO AL CREAR LA VISTA
    this.checkRole();
  },
};
</script>

<style scoped>

h2 {
  margin-top: 20px;
  margin-bottom: 20px;
}

.content {
  margin: auto;
}

h3 {
  margin-bottom: 70px;
}

p {
  margin-bottom: 40px;
}

.box {
  width: 300px;
  height: 250px;
  background-color: white;
  display: inline-block;
  margin: 10px;
  border: 1px solid lightgray;
  border-radius: 10px;
}

button {
  width: 130px;
}

</style>