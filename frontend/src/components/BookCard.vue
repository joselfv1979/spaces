<!-- COMPONENTE DE CADA RESERVA EN FORMA DE TARJETA -->
<template>
  <div>
    <div class="card">
      <div>
        <strong><p>{{ book.hotel }}</p></strong>
      </div>
      <div>
        <p>{{ book.end_time }}</p>
      </div>
      <div>
        <p>
          <strong><span :class=" { green: book.status === 'Reserva pendiente'}">{{ book.status }}</span></strong>
        </p>
      </div>
      <!-- BOTÓN QUE LLAMA A LA FUNCIÓN PARA ENVIAR EL ÍNDICE DE LA RESERVA Y LANZA EL EVENTO DE VALORAR -->
      <button @click="score" :class=" { hidden: book.status === 'Reserva pendiente' }">Valorar</button>
      <button @click="remove" :class="{ hidden: book.status === 'Reserva consumida' }">Cancelar</button>
      <button @click="detail">
        Ver
      </button>
    </div>
  </div>
</template>

<script>
import { setBookId } from "../../../backend/requests/book";
export default {
  name: "BookCard", // EXPORTACIÓN DEL COMPONENTE
  props: {
    book: Object, // DECLARACIÓN DEL ARRAY QUE RECIBE EL COMPONENTE
  },
  data() {
    return {};
  },
  methods: {
    // FUNCIÓN QUE LANZA UN EVENTO Y ACTIVA UNA FUNCIONES EN LA VISTA, ENVIÁNDOLE UN ÍNDICE COMO PARÁMETRO
    score() {
      let bookId = this.book.id;
      this.$emit("score", bookId);
    },
    remove() {
      let bookId = this.book.id;
      this.$emit("remove", bookId);
    },
    detail() {
      let bookId = this.book.id;
      this.$emit("see", bookId);
    }
  },
};
</script>

<style scoped>
.card {
  background-color: white;
  border: 1px solid lightgray;
  border-radius: 10px;
  margin: 0.667rem;
  width: auto;
  min-width: 300px;
}

.card p {
  display: inline-block;
  padding: 0.667rem;
}
.hidden {
  display: none;
}

.green {
  color: green;
}

button {
  width: 80px;
}

</style>
