<!-- COMPONENTE DINÁMICO QUE RECIBE UN OBJETO ESPACIO Y MUESTRA LA VISTA DETALLADA -->
<template>
  <div id="main">
    <!-- POR DEFECTO SE MUESTRA EL DIV DEL ESPACIO, AL PEDIR LAS VALORACIONES SE ESCONDE -->
    <div v-if="seeSpace">
      <router-link :to="{ name: 'SpaceList' }">
        <button>Volver</button>
      </router-link>
      <h1>Detalles del espacio:</h1>
      <ul>
        <li>
          <div>
            <img class="img-1" :src="'/images/'+space.image_1" />
            <img class="img-2" :src="'/images/'+space.image_2" @error="imageLoadError" />
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
            <p class="description">{{ space.description }}</p>
          </div>
          <div>
            <button @click="book()">Reservar</button>
            <button @click="getScores()">Ver valoraciones</button>
          </div>
        </li>
      </ul>
    </div>
    <div id="score" v-else>
      <!-- DECLARACIÓN DEL COMPONENTE QUE MUESTRA LAS VALORACIONES DE UN ESPACIO -->
      <h2>Valoraciones de usuarios:</h2>
      <!-- SE MUESTRA SI EXISTEN VALORACIONES -->
      <scoreslist v-if="seeScores" :scores="scores" />
      <!-- SINO EXISTEN -->
      <p v-else>No existen valoraciones</p>
      <button @click="hide()">Volver</button>
    </div>
  </div>
</template>

<script>
import Swal from "sweetalert2";
import scoreslist from "@/components/ScoresList.vue";
import {
  getSpaceById,
  setSpaceId,
  listScores
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
      spaceId: ""
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
    imageLoadError(error) {
      console.log("Image failed to load");
      console.log(error);
    },
    async getSpace() {
      let result = await getSpaceById(this.$route.params.id);
      this.space = result.data[0];
      console.log(this.space,'detail');
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
    hide() {
      this.seeSpace = true;
    },
  },
  // SE OBTIENE EL ESPACIO AL CARGAR LA VISTA
  created() {
    this.getSpace();
  },
};
</script>

<style scoped>
#score {
  height: 80vh;
  background-image: url("./../assets/sala3.jpg");
  background-repeat: no-repeat;
  background-position: center;
  background-size: cover;
}

h2 {
  margin-top: 20px;
}

li {
  width: auto;
  max-width: 402px;
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

.description {
  text-align: justify;
  margin-left: 20px;
  margin-right: 20px;
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


