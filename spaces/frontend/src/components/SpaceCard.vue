<!-- COMPONENTE DINÁMICO QUE RECIBE UN ARRAY DE ESPACIOS Y LOS MUESTRA EN UNA LISTA -->
<template>
  <div>
    <div class="card">
      <img :src="'/images/'+space.image_1" />
      <div>
        <strong><p>{{ space.hotel }}</p></strong>
        <strong><p>{{ space.name }}</p></strong>
      </div>
      <div>
        <p>{{ space.city }}</p>
        <p>{{ space.price }} €/h</p>
      </div>
      <div v-if="provider && route === 'SpaceProviderList'">
        <button class="button-provider" @click="editSpace()">Editar</button>
        <button class="button-provider" @click="deleteSpace()">Eliminar</button>
      </div>
      <div v-else>
        <router-link :to="{ name: 'SpaceDetail', params: { id: space.id } }">
          <button>Ir al detalle</button>
        </router-link>
      </div>
    </div>
  </div>
</template>

<script>
// IMPORTACIÓN DE FUNCIONES EXTERNAS
import { getRole } from "./../../../backend/requests/user";
import { setSpaceId } from "./../../../backend/requests/space";

export default {
  name: "SpaceCard", // EXPORTACIÓN DEL COMPONENTE
  props: {
    space: Object, // DECLARACIÓN DEL ARRAY QUE RECIBE EL COMPONENTE
  },
  data() {
    return {
      provider: false,
    };
  },
  methods: {
    // FUNCIÓN QUE LANZA UN EVENTO Y ACTIVA UNA FUNCIÓN EN LA VISTA, ENVIÁNDOLE UN ÍNDICE COMO PARÁMETRO
    editSpace() {
      let spaceId = this.space.id;
      this.$emit("edit", spaceId);
    },
    deleteSpace() {
      let spaceId = this.space.id;
      this.$emit("delete", spaceId);
    },
    checkRole() {
      let role = getRole();
      if (role === "provider") {
        this.provider = true;
      }
    },
  },
  created() {
    this.checkRole();
    this.route = this.$route.name;
  },
};
</script>

<style scoped>
.card {
  background-color: white;
  border: 1px solid lightgray;
  border-radius: 10px;
  margin: 0.667rem;
  list-style: none;
  height: auto;
  width: auto;
}

.card p{
  display: inline-block;
  padding: 0.667rem;
}

img {
  margin: 0;
  border-top-left-radius: 10px;
  border-top-right-radius: 10px;
  width: 240px;
  height: 160px;
}

.button-provider {
  width: 80px;
}
</style>