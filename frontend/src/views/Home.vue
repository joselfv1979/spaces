<!-- VISTA DE INICIO DE LA APLICACIÓN CON BUSCADOR DE ESPACIOS -->
<template>
  <div id="main">
    <!-- TÍTULO PERSONALIZADO CON VUE-HEADFUL -->
    <vue-headful title="Spaces - Inicio" />
    <div id="image" v-if="seeImage">
      <div class="search-list">
        <!-- INPUTS VINCULADOS AL DATA CON V-MODEL -->
        <div>
          <input type="search" v-model="city" placeholder="Buscar por ciudad" />
        </div>
        <div>
          <input type="search" v-model="hotel" placeholder="Buscar por hotel" />
        </div>
      </div>
      <!-- BOTÓN PARA REALIZAR LA BÚSQUEDA -->
      <div>
        <button @click="buscar()">Buscar</button>
      </div>
      <!-- BOTÓN PARA MOSTRAR LOS FILTROS DE BÚSQUEDA -->
      <div>
        <button @click="seeFilter()">Más filtros</button>
      </div>
    </div>
    <!-- ELEMENTO QUE CONTIENE LOS FILTROS DE BÚSQUEDA -->
    <div class="container" v-else>
      <div class="form">
        <!-- <button @click="hideFilter()">Volver</button> -->
        <div class="time">
          <div id="date">
            <label>
              <h4>Fecha</h4>
            </label>
            <input class="date" type="date" v-model="date" />
          </div>
          <div id="in">
            <label>
              <h4>Entrada</h4>
            </label>
            <input type="time" v-model="startTime" />
          </div>
          <div id="out">
            <label>
              <h4>Salida</h4>
            </label>
            <input type="time" v-model="endTime" />
          </div>
        </div>
        <div class="border">
          <div class="group">
            <div class="options">
              <label>
                <h4 class="check">Tipo</h4>
              </label>
              <label>
                <input type="radio" v-model="type" name="type" value="2" />Reuniones
              </label>
              <br />
              <label for="hallType">
                <input type="radio" v-model="type" name="type" value="1" />Eventos
              </label>
            </div>
            <div class="options">
              <label>
                <h4 class="check">Disposición</h4>
              </label>
              <label for="uLayout">
                <input type="radio" v-model="layout" value="1" />En U
              </label>
              <br />
              <label for="classLayout">
                <input type="radio" v-model="layout" value="2" />En escuela
              </label>
              <br />
              <label for="theaterLayout">
                <input type="radio" v-model="layout" value="3" checked />En teatro
              </label>
            </div>
          </div>
        </div>
        <div class="border">
          <div class="group">
            <div class="options">
              <label for>
                <h4 class="check">Equipamiento</h4>
              </label>
              <label for="furniture">
                <input type="checkbox" v-model="furniture" value="1" />Muebles
              </label>
              <br />
              <label for="wifi">
                <input type="checkbox" v-model="wifi" value="2" />WI-FI
              </label>
              <br />
              <label for="projector">
                <input type="checkbox" v-model="projector" value="3" />Proyector
              </label>
              <br />
              <label for="screen">
                <input type="checkbox" v-model="screen" value="4" />Pantalla
              </label>
            </div>
            <div class="options">
              <label for>
                <h4 class="check">Precio</h4>
              </label>
              <input id="price" type="number" v-model="price" placeholder="Precio máximo" />
            </div>
          </div>
        </div>
        <div class="apply-button">
          <button @click="buscar()">Aplicar</button>
          <button @click="hideFilter()">Volver</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
// IMPORTACIÓN DE COMPONENTES, FUNCIONES Y LIBRERÍAS EXTERNAS
import axios from "axios";
import Swal from "sweetalert2";
import { getFilteredSpaces } from "./../../../backend/requests/space";

export default {
  name: "Home",
  components: {},
  data() {
    // VARIABLES DE LA VISTA
    return {
      seeImage: true,
      spaces: [],
      city: "",
      hotel: "",
      date: "",
      startTime: "",
      endTime: "",
      price: "",
      type: "",
      layout: "",
      furniture: "",
      wifi: "",
      projector: "",
      screen: "",
    };
  },
  methods: {
    seeFilter(){
      this.seeImage = false
    },
    hideFilter(){
      this.seeImage = true
    },
    // LLAMADA A LA FUNCIÓN PARA OBTENER LOS ESPACIOS
    async buscar() {
      const result = await this.getSpaces();
      this.$emit("spaces", result);
      this.$router.push({ name: "SpaceList" });
    },
    // FUNCIÓN PARA CONSEGUIR LOS ESPACIOS FILTRADOS
    async getSpaces() {
      let parameters = "";
      let count = 0;
      if (this.city) {
        parameters += "?city=" + this.city;
        count++;
      }
      if (this.hotel) {
        if (count === 0) parameters += "?hotel=" + this.hotel;
        else parameters += "&hotel=" + this.hotel;
        count++;
      }
      if (this.date) {
        console.log(this.date);
        console.log(typeof this.date);
      }
      if (this.startTime) {
        let start = this.startTime.slice(0, 2);
        if (count === 0) parameters += "?startTime=" + start;
        else parameters += "&startTime=" + start;
        count++;
      }
      if (this.endTime) {
        let end = this.endTime.slice(0, 2);
        if (count === 0) parameters += "?endTime=" + end;
        else parameters += "&endTime=" + end;
        count++;
      }

      if (this.price) {
        if (count === 0) parameters += "?price=" + this.price;
        else parameters += "&price=" + this.price;
        count++;
      }
      if (this.type) {
        if (count === 0) parameters += "?type=" + this.type;
        else parameters += "&type=" + this.type;
        count++;
      }
      if (this.layout) {
        if (count === 0) parameters += "?layout=" + this.layout;
        else parameters += "&layout=" + this.layout;
        count++;
      }
      if (this.furniture) {
        if (count === 0) parameters += "?furniture=1";
        else parameters += "&furniture=1";
        count++;
      }
      if (this.wifi) {
        if (count === 0) parameters += "?wifi=1";
        else parameters += "&wifi=1";
        count++;
      }
      if (this.projector) {
        if (count === 0) parameters += "?projector=1";
        else parameters += "&projector=1";
        count++;
      }
      if (this.screen) {
        if (count === 0) parameters += "?screen=1";
        else parameters += "&screen=1";
        count++;
      }

      const response = await getFilteredSpaces(parameters);
      this.spaces = response.data;
      localStorage.setItem("SPACES", JSON.stringify(this.spaces));
      return response.data;
    },
  },
};
</script>

<style scoped>
.search-list {
  margin-top: 100px;
}

.search-list input{
  margin: 10px;
}

input {
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

.form input {
  padding: 3px 10px;
  border: 1px solid #f6f6f6;
  border-radius: 3px;
  background-color: #f6f6f6;
  margin: 8px;
}

.box {
  display: flex;
}

.container {
  display: flex;
  justify-content: center;
  background: radial-gradient(circle, black, white);
  /* background-image: url("./../assets/sala13.jpg");
  background-repeat: no-repeat;
  background-position: center;
  background-size: cover; */
}

.form {
  width: 500px;
  padding: 16px;
  border-radius: 10px;
  margin-top: 20px;
  margin-bottom: 20px;
  background-color: #ccc;
  color: #2c3e50;
}

#date,
#in,
#out {
  display: inline-block;
  margin: 10px;
}

.time {
  margin-bottom: 10px;
}

.border {
  border-top: 1px solid lightgray;
}

.group {
  padding-top: 15px;
  padding-left: 70px;
  height: 135px;
  margin-bottom: 15px;
  display: flex;
  align-items: flex-start;
  justify-content: center;
}

.options {
  padding-top: 10px;
  display: inline-block;
  width: 100%;
  height: 120px;
  text-align: justify;
}

#image {
  height: 800px;
  background-image: url("./../assets/sala.jpg");
  background-repeat: no-repeat;
  background-position: center;
  background-size: cover;
}

input {
  border: 2px solid #3b83bd;
}

.check {
  padding-bottom: 10px;
  padding-left: 23px;
}

.apply-button {
  text-align: center;
}

#price {
  width: 110px;
}
</style>
