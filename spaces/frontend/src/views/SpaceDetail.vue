<!-- COMPONENTE DINÁMICO QUE RECIBE UN OBJETO ESPACIO Y LO MUESTRA -->
<template>
  <div id="main">
    <router-link :to="{ name: 'SpaceList' }">
      <button>Volver</button>
    </router-link>
    <!-- POR DEFECTO SE MUESTRA EL DIV DEL ESPACIO, AL PEDIR LAS VALORACIONES SE ESCONDE -->
    <div v-if="seeSpace">
      <h1>Detalles del espacio:</h1>
      <ul>
        <li>
          <div>
            <img class="img-1" :src="space.image_1" />
            <img class="img-2" :src="space.image_2" />
          </div>
          <div>
            <strong>
              <p>Hotel: {{ space.hotel }}</p>
            </strong>
            <strong>
              <p>Sala: {{ space.name }}</p>
            </strong>
          </div>
          <div>
            <p>Ciudad: {{ space.city }}</p>
            <p>Dirección: {{ space.address }}</p>
          </div>
          <div>
            <p>Horario: {{ space.open_hour+':00' }} - {{ space.close_hour+':00' }}</p>
            <p>Precio: {{ space.price }} €/h</p>
          </div>
          <div>
            <p>{{ space.description }}</p>
          </div>
          <div>
            <button @click="book()">Reservar</button>
            <button @click="getScores()">Ver valoraciones</button>
          </div>
        </li>
      </ul>
    </div>
    <div v-else>
      <!-- DECLARACIÓN DEL COMPONENTE QUE MUESTRA LAS VALORACIONES DE UN ESPACIO -->
      <h2>Valoraciones de usuarios:</h2>
      <!-- SE MUESTRA SI EXISTEN VALORACIONES -->
      <scoreslist v-if="seeScores" :scores="scores" />
      <!-- SINO EXISTEN -->
      <p v-else>No existen valoraciones</p>
    </div>
  </div>
</template>

<script>
import Swal from "sweetalert2";
import scoreslist from "@/components/ScoresList.vue";
import {
  getSpaceById,
  setSpaceId,
  listScores,
} from "./../../../backend/requests/space";
import { getRole, getAuthToken } from "./../../../backend/requests/user";
export default {
  name: "SpaceDetail", // EXPORTACIÓN DEL COMPONENTE
  components: {
    // REGISTRO DE COMPONENTES
    scoreslist,
  },
  data() {
    return {
      space: {},
      scores: [],
      seeSpace: true,
      spaceId: "",
    };
  },
  computed: {
    // PARA SABER SI EXISTEN VALORACIONES
    seeScores() {
      return this.scores.length;
    },
  },
  methods: {
    // FUNCIÓN QUE OBTIENE UN ESPACIO DEL SERVIDOR
    async getSpace() {
      let result = await getSpaceById(this.$route.params.id);
      this.space = result.data[0];
      this.spaceId = this.space.id;
      setSpaceId(this.spaceId);
    },
    // FUNCIÓN QUE RECUPERA LAS VALORACIONES DE UN ESPACIO Y DESCUBRE EL COMPONENTE QUE LAS MUESTRA
    async getScores() {
      this.scores = await listScores(this.spaceId);
      this.seeSpace = false;
    },
    // FUNCIÓN QUE COMPRUEBA LA AUTENTICACIÓN Y REDIRIGE AL USUARIO A LA VISTA DE RESERVA NUEVA O AL LOGIN
    book() {
      if (getRole() === "provider") {
        Swal.fire("Debes registrarte como usuario buscador");
        return;
      }
      if (getAuthToken() && getRole() === "seeker") {
        this.$router.push({ name: "AddBook" });
      } else {
        this.$router.push({ name: "Login" });
      }
    },
  },
  // SE OBTIENE EL ESPACIO AL CARGAR LA VISTA
  created() {
    this.getSpace();
  },
};
</script>

<style scoped>
li {
  width: auto;
  background-color: white;
  border: 1px solid lightgray;
  border-radius: 10px;
}

img {
  display: inline-block;
  margin: 0;
  height: 150px;
  width: 200px;
}

.img-1 {
  border-top-left-radius: 10px;
  margin-right: 1px;
}

.img-2 {
  border-top-right-radius: 10px;
  margin-left: 1px;
}

@media screen and (max-width: 600px) {
  .img-1 {
    border-top-left-radius: 0;
  }
  .img-2 {
    border-top-right-radius: 0;
  }
}
</style>