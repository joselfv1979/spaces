<!-- VISTA QUE CONTIENE EL FORMULARIO PARA REALIZAR UNA RESERVA NUEVA-->
<template>
  <div id="main">
    <div>
      <!-- TÍTULO PERSONALIZADO CON VUE-HEADFUL -->
      <vue-headful title="Reservas" />
      <div class="container">
        <div class="form">
          <h3>Realiza tu reserva</h3>
          <p v-if="!checkFilled" class="red">Rellena los campos marcados en rojo</p>
          <p v-else-if="!checkAvailability" class="red">El horario no está disponible</p>
          <div class="time">
            <div id="date">
              <h4>Fecha</h4>
              <input type="date" v-model="date" :class="{ alert: !checkDate }" />
            </div>
            <div id="in">
              <h4>Entrada</h4>
              <input type="time" v-model="start" :class="{ alert: !checkStart }" />
            </div>
            <div id="out">
              <h4>Salida</h4>
              <input type="time" v-model="end" :class="{ alert: !checkEnd }" />
            </div>
            <p v-if="!checkCorrectDate" class="red">Fecha incorrecta</p>
            <p v-else-if="!checkCorrectTime" class="red">Horario incorrecto</p>
          </div>
          <div class="bordered-box">
            <div class="group">
              <div class="options">
                <h4 class="check">Tipo</h4>
                <div>
                  <label for="meetingType">
                    <input type="radio" id="meetingType" v-model="type" value="reunion" checked />Reuniones
                  </label>
                </div>
                <div>
                  <label for="hallType">
                    <input type="radio" id="hallType" v-model="type" value="evento" />Eventos
                  </label>
                </div>
              </div>
              <div class="options">
                <div>
                  <label for="uLayout">
                    <h4 class="check">Disposición</h4>
                    <input type="radio" v-model="layout" value="en U" checked />En U
                  </label>
                </div>
                <div>
                  <label for="classLayout">
                    <input type="radio" v-model="layout" value="classLayout" />En escuela
                  </label>
                </div>
                <div>
                  <label for="theaterLayout">
                    <input type="radio" v-model="layout" value="theaterLayout" />En teatro
                  </label>
                </div>
              </div>
            </div>
          </div>
          <div class="bordered-box">
            <div class="group">
              <div class="options">
                <h4 class="check">Equipamiento</h4>
                <div>
                  <label for="furniture">
                    <input type="checkbox" v-model="furniture" value="amueblado" />Muebles
                  </label>
                </div>
                <div>
                  <label for="wifi">
                    <input type="checkbox" v-model="wifi" value="wifi" />WI-FI
                  </label>
                </div>
                <div>
                  <label for="projector">
                    <input type="checkbox" v-model="projector" value="proyector" />Proyector
                  </label>
                </div>
                <div>
                  <label for="screen">
                    <input type="checkbox" v-model="screen" value="pantalla" />Pantalla
                  </label>
                </div>
              </div>
              <div class="options">
                <h4 class="check">Nº asistentes</h4>
                <input
                  id="attendees"
                  type="number"
                  v-model="attendees"
                  placeholder="Número de asistentes"
                  :class="{ alert: !checkAttendees }"
                />
              </div>
            </div>
          </div>
          <div class="buttons">
            <!-- BOTÓN PARA ENVIAR LOS DATOS -->
            <button @click="addBook()">Realizar reserva</button>
            <!-- BOTÓN PARA CANCELAR LA OPERACIÓN -->
            <button @click="cancel()">Cancelar</button>
          </div>
        </div>
      </div>
      <!-- MODAL PARA VER EL RESUMEN DE UNA RESERVA -->
      <div v-show="modal" class="modal">
        <div class="modalBox">
          <!-- DECLARACIÓN DEL COMPONENTE QUE MUESTRA EL RESUMEN DE LA RESERVA -->
          <bookdetail :book="book" />
          <!-- BOTÓN PARA ESCONDER EL MODAL -->
          <button @click="hide()">Ok</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
// IMPORTACIÓN DE COMPONENTES, FUNCIONES Y LIBRERÍAS EXTERNAS
import Swal from "sweetalert2";
import moment from "moment";
import { createBook, getBook } from "./../../../backend/requests/book";
import { getAuthToken } from "./../../../backend/requests/user";
import { getSpaceId, removeSpaceId } from "./../../../backend/requests/space";
import bookdetail from "@/components/BookDetail.vue";
export default {
  name: "AddBook",
  components: {
    bookdetail, // REGISTRO DE COMPONENTES
  },
  data() {
    // VARIABLES DE LA VISTA
    return {
      modal: false,
      book: {},
      date: "",
      start: "",
      end: "",
      attendees: "",
      type: "reunion",
      layout: "en U",
      furniture: 0,
      wifi: 0,
      projector: 0,
      screen: 0,
      checkDate: true,
      checkCorrectDate: true,
      checkCorrectTime: true,
      checkStart: true,
      checkEnd: true,
      checkAttendees: true,
      checkFilled: true,
      checkAvailability: true,
    };
  },

  methods: {
    getDate() {
      const now = moment().format("YYYY-MM-DD");
      return now;
    },
    validateBook() {
      this.checkCorrectDate = true,
      this.checkFilled = true;
      this.checkDate = true;
      this.checkStart = true;
      this.checkEnd = true;
      this.checkAttendees = true;
      this.checkDate = this.date;
      this.checkCorrectTime = true,
      this.checkEnd = this.end;
      this.checkStart = this.start;
      this.checkAttendees = this.attendees;
      if (!this.date || !this.start || !this.end || !this.attendees) {
        this.checkFilled = false;
        return false;
      } else if (this.date < this.getDate()) {
        this.checkCorrectDate = false
        return false
      } else if (this.start >= this.end) {
        this.checkCorrectTime = false
        return false
      } else {
        return true
      }
    },

    // FUNCIÓN PARA REALIZAR LA RESERVA
    async addBook() {
      if (!this.validateBook()) {
        return;
      }
      let token = getAuthToken();
      let spaceId = getSpaceId();
      let startTime = this.date + " " + this.start;
      let endTime = this.date + " " + this.end;
      let newBook = {
        type: this.type,
        layout: this.layout,
        furniture: this.furniture,
        wifi: this.wifi,
        projector: this.projector,
        screen: this.screen,
        attendees: this.attendees,
        startTime,
        endTime,
      };

      let result = await createBook(token, spaceId, newBook);

      if (result === "unavailable") {
        this.checkAvailability = false;
        return;
      } else {
        let bookId = result;
        // RECUPERO LA RESERVA Y OTROS DATOS PARA MOSTRARLOS UNA VEZ CREADA
        const response = await getBook(token, spaceId, bookId);
        this.book = response;
        this.modal = true;
      }
    },
    cancel() {
      // REDIRECCIÓN AL HOME
      removeSpaceId();
      this.$router.push("/");
    },
    hide() {
      // OCULTACIÓN DEL MODAL Y REDIRECCIÓN AL HOME
      this.modal = false;
      removeSpaceId();
      this.$router.push("/");
    },
  },
};
</script>

<style scoped>
.container {
  display: flex;
  justify-content: center;
}

.form {
  width: 500px;
  padding: 16px;
  border-radius: 10px;
  margin: auto;
  padding-top: 20px;
  margin-top: 20px;
  margin-bottom: 20px;
  background-color: #ccc;
  color: #2c3e50;
}

.red {
  color: #d33;
  display: block;
  font-size: 0.8rem;
}

.alert {
  border: 1px solid #d33;
}

input {
  padding: 3px 10px;
  border: 1px solid #f6f6f6;
  border-radius: 3px;
  background-color: #f6f6f6;
  margin: 8px;
}

#date,
#in,
#out {
  display: inline-block;
  margin: 10px;
}

.time {
  text-align: center;
  padding-top: 20px;
  margin-bottom: 20px;
}

.bordered-box {
  border-top: 1px solid lightgray;
}

.group {
  margin-top: 20px;
  margin-bottom: 20px;
  display: flex;
  align-items: flex-start;
  justify-content: center;
}

.options {
  padding-left: 20px;
  display: inline-block;
  width: 200px;
  text-align: justify;
}

.check {
  padding-bottom: 10px;
  padding-left: 23px;
}

.buttons {
  text-align: center;
}

#attendees {
  width: 150px;
}
</style>