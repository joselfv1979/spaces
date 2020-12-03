<!-- VISTA QUE RECIBE UN ARRAY DE ESPACIOS Y LOS MUESTRA EN UNA LISTA -->
<template>
  <div id="main">
    <!-- TÍTULO PERSONALIZADO CON VUE-HEADFUL -->
    <vue-headful title="Espacios" />
    <div>
      <router-link :to="{ name: 'Home' }">
        <button>Volver</button>
      </router-link>
      <div class="space-content">
        <h2>Espacios encontrados:</h2>
        <!-- DECLARACIÓN DEL COMPONENTE QUE MUESTRA LA LISTA DE LOS ESPACIOS-->
        <div class="space-list" v-if="seeSpaces">
          <spacecard :space="space" v-for="space in spaces" :key="space.id" />
        </div>
        <div v-else>
          <p>No se encontraron resultados, pruebe con otra búsqueda</p>
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
import spacecard from "@/components/SpaceCard.vue";

export default {
  name: "SpaceList",
  components: {
    // REGISTRO DE COMPONENTES
    spacecard,
  },
  data() {
    return {};
  },
  props: {
    spaces: Array,
  },
  computed: {
    seeSpaces() {
      return this.spaces.length;
    },
  },
  methods: {},

  created() {},
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
