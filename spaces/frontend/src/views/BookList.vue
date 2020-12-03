<!-- VISTA QUE MUESTRA INFORMACIÓN DETALLADA DE CADA RESERVA -->
<template>
  <div id="main">
    <!-- TÍTULO PERSONALIZADO CON VUE-HEADFUL -->
    <vue-headful title="Reservas" />
    <router-link :to="{ name: 'User' }">
      <button>Volver</button>
    </router-link>
    <!-- DECLARACIÓN DEL COMPONENTE QUE MUESTRA LAS RESERVAS -->
    <h3>Lista de reservas:</h3>
    <div class="book-list" v-if="seeBooks">
      <bookcard
        @score="getIndex"
        @remove="deleteBook"
        @see="seeDetail"
        v-for="book in books"
        :key="book.id"
        :book="book"
      />
    </div>
    <div v-else>
      <p>No hay ninguna reserva</p>
    </div>
    <div v-show="modal" class="modal">
        <div class="modalBox">
          <!-- DECLARACIÓN DEL COMPONENTE QUE MUESTRA EL RESUMEN DE LA RESERVA -->
          <bookdetail :book="book" :list="list"/>
          <!-- BOTÓN PARA ESCONDER EL MODAL -->
          <button @click="hide()">Ok</button>
        </div>
      </div>
    <!-- MODAL PARA REALIZAR LA VALORACIÓN DE UNA RESERVA -->
    <div v-show="seeModal" class="modal">
      <div class="modalBox">
        <h3>Añade tu valoración:</h3>
        <!-- INPUTS VINCULADOS AL DATA CON V-MODEL -->
        <div class="score-box">
          <input type="number" min="0" max="5" placeholder="Puntuación de 0-5" v-model="score" />
        </div>
        <div class="score-box">
          <input type="text" placeholder="Añade un comentario" v-model="comment" />
        </div>
        <!-- BOTÓN PARA CANCELAR LA OPERACIÓN Y OCULTAR EL MODAL -->
        <button @click="cancel()">Cancelar</button>
        <!-- BOTÓN PARA ENVIAR LA VALORACIÓN -->
        <button @click="send()">Enviar</button>
      </div>
    </div>
  </div>
</template>

<script>
// IMPORTACIÓN DE COMPONENTES, FUNCIONES Y LIBRERÍAS EXTERNAS
import axios from "axios";
import moment from "moment";
import Swal from "sweetalert2";
import {
  getBooks,
  addScore,
  setBookId,
  removeBook,
} from "./../../../backend/requests/book";
import { getAuthToken } from "./../../../backend/requests/user";
import bookcard from "@/components/BookCard.vue";
import bookdetail from '@/components/BookDetail.vue'

export default {
  name: "BookList",
  components: {
    // REGISTRO DE COMPONENTES
    bookcard, bookdetail
  },
  computed: {
    seeBooks() {
      return this.books.length;
    },
  },
  data() {
    // VARIABLES DE LA VISTA
    return {
      list: true,
      books: [],
      book: {},
      score: "",
      comment: "",
      seeModal: false,
      bookIndex: "",
      modal: false
    };
  },
  methods: {
    // FUNCIÓN PARA OBTENER EL ÍNDICE DE UNA RESERVA Y MOSTRAR EL MODAL
    getIndex(id) {
      this.seeModal = true;
      this.bookIndex = id;
    },
    // FUNCIÓN QUE OBTIENE LAS RESERVAS DE UN USUARIO
    async getUserBooks() {
      let token = getAuthToken();
      const result = await getBooks(token);
      localStorage.setItem("BOOKS", JSON.stringify(result.data));

      const now = new Date()    
      this.books = result.map((item) => {
        const newDate = new Date(item.end);       
        if (newDate < now) {
          item.status = "Reserva consumida";
        } else {
          item.status = "Reserva pendiente";
        } 
        return item
      });
    },
    // EL RESUMEN DE LA RESERVA
    seeDetail(bookId){
      let item = this.books.filter(item => item.id === bookId)
      this.book = item[0]
      this.modal = true
    },
    hide() {
      // OCULTACIÓN DEL MODAL Y REDIRECCIÓN AL HOME
      this.modal = false;
    },
    // FUNCIÓN PARA CANCELAR UNA RESERVA
    async deleteBook(id) {
      let token = getAuthToken();
      Swal.fire({
        text: "Estás seguro de eliminar la reserva?",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Eliminar",
      }).then((result) => {
        if (result.value) {
          Swal.fire({
            text: "Reserva cancelada.",
            onClose: () => {
              removeBook(id, token)
              .then(() => this.getUserBooks())
            },
          });
        }
      })
    },
    // FUNCIÓN PARA ENVIAR LA VALORACIÓN
    async send() {
      if (!this.score || !this.comment) {
        Swal.fire("Rellena los 2 campos");
        return;
      }
      if (this.score < 0 || this.score > 5) {
        Swal.fire("La puntuación debe estar entre 0 y 5");
        return;
      }
      let token = getAuthToken();
      if (await addScore(token, this.bookIndex, this.score, this.comment)) {
        Swal.fire({
          text: "Valoración enviada.",
          onClose: () => {
            this.score = "";
            this.comment = "";
            this.seeModal = false;
          },
        });
      }
    },
    cancel() {
      this.seeModal = false;
      this.score = "";
      this.comment = "";
    },
  },
  created() {
    // CARGA DE LAS RESERVAS DE UN USUARIO AL CREAR LA VISTA
    this.getUserBooks();
    console.log(this.$route.name);
  },
};
</script>

<style scoped>
#main {
  background: linear-gradient(white,#2c3e50);
}
.book-list {
  display: flex;
  flex-wrap: wrap;
  align-items: stretch;
  justify-content: center;
}

h3 {
  margin-bottom: 20px;
}

.score-box {
  margin: 20px;
}

input {
  width: 150px;
  border-radius: 3px;
  padding: 0.3rem;
  margin: 0.3rem;
  border: none;
  border-bottom: 2px solid #3b83bd;
  border-top: 2px solid transparent;
  border-right: 2px solid transparent;
  border-left: 2px solid transparent;
  transition: all 0.4s;
}

input:hover {
  border: 2px solid #3b83bd;
  cursor: pointer;
}
</style>
