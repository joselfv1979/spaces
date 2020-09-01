<!-- VISTA QUE MUESTRA INFORMACIÓN DETALLADA DE CADA ESPACIO -->
<template>
  <div id="main">
    <!-- TÍTULO PERSONALIZADO CON VUE-HEADFUL -->
    <vue-headful title="Espacios" />
    <div>
      <router-link :to="{ name: 'User' }">
        <button>Volver</button>
      </router-link>
      <div class="space-content">
        <h2>Espacios encontrados:</h2>
        <!-- DECLARACIÓN DEL COMPONENTE QUE MUESTRA LA LISTA DE LOS ESPACIOS-->
        <div class="space-list" v-if="seeSpaces">
          <spacecard
            :space="space"
            @edit="editSpace"
            @delete="deleteSpace"
            v-for="space in spaces"
            :key="space.id"
          />
        </div>
        <div v-else>
          No hay ningún espacio registrado
        </div>
      </div>
    </div>
  </div>
</template>

<script>
// IMPORTACIÓN DE COMPONENTES, FUNCIONES Y LIBRERÍAS EXTERNAS
import Swal from "sweetalert2";
import moment from "moment";
import { getRole, getAuthToken } from "./../../../backend/requests/user";
import {
  getPlaces,
  setSpaceId,
  deleteSpace,
} from "./../../../backend/requests/space";
import spacecard from "@/components/SpaceCard.vue";

export default {
  name: "SpaceProviderList",
  components: {
    // REGISTRO DE COMPONENTES
    spacecard,
  },
  data() {
    return {
      spaces: [],
    };
  },
  computed: {
    seeSpaces() { 
      return this.spaces.length;
    },
  },
  methods: {
    // FUNCIÓN PARA PEDIR LOS ESPACIOS AL SERVIDOR
    async getSpaces() {
      let token = getAuthToken();
      const result = await getPlaces(token);
      this.spaces = result.data;
    },
    // REDIRECCIÓN A LA VISTA PARA EDITAR UN ESPACIO
    editSpace(spaceId) {
      setSpaceId(spaceId);
      this.$router.push({ name: "UpdateSpace" });
    },
    // FUNCIÓN PARA ELIMINAR UN ESPACIO
    async deleteSpace(spaceId) {
      let token = getAuthToken();
      Swal.fire({
        text: "Estás seguro de el espacio?",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Eliminar!",
      }).then((result) => {
        if (result.value) {
          Swal.fire({
            text: "El espacio ha sido eliminado.",
            onClose: () => {
              deleteSpace(spaceId, token).then(() => this.getSpaces());
            },
          });
        }
      });
    },
  },
  // SE CARGAN LOS ESPACIOS DEL PROVEEDOR AL CREAR LA VISTA
  created() {
    this.getSpaces();
  },
};
</script>

<style scoped>
.space-content {
  min-height: 460px;
  padding-left: 50px;
  padding-right: 50px;
}

.space-list {
  display: flex;
  flex-wrap: wrap;
  align-items: stretch;
  justify-content: space-around;
}

</style>