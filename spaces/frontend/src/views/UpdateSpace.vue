<template>
  <div class="container">
    <!-- TÍTULO PERSONALIZADO CON VUE-HEADFUL -->
    <vue-headful title="Espacios" />
    <div class="form">
      <h3>Actualiza tu espacio</h3>
      <!-- INPUTS VINCULADOS AL DATA CON V-MODEL -->
      <div class="data">
        <div>
          <label for="name">Nombre del hotel</label>
          <input
            type="text"
            v-model="hotel"
            class="field"
            placeholder="Hotel"
          />
        </div>
        <div>
          <label for="name">Ciudad</label>
          <input
            type="text"
            v-model="city"
            class="field"
            placeholder="Ciudad"
          />
        </div>
        <div>
          <label for="name">Dirección</label>
          <input
            type="text"
            v-model="address"
            class="field"
            placeholder="Dirección"
          />
        </div>
        <div>
          <label for="name">Nombre de la sala</label>
          <input type="text" v-model="name" class="field" placeholder="Sala" />
        </div>
        <div>
          <label for="name">Precio por hora</label>
          <input
            type="number"
            v-model="price"
            class="field"
            placeholder="Precio"
          />
        </div>
      </div>
      <div class="bordered-box">
        <div class="group">
          <div class="options">
            <h4>Disposición</h4>
            <div>
              <label for="uLayout">
                <input type="checkbox" v-model="uLayout" />En U
              </label>
            </div>
            <div>
              <label for="classLayout">
                <input type="checkbox" v-model="classLayout" />En escuela
              </label>
            </div>
            <div>
              <label for="theaterLayout">
                <input type="checkbox" v-model="theaterLayout" />En teatro
              </label>
            </div>
          </div>
          <div class="options">
            <h4>Tipo</h4>
            <div>
              <label for="meetingType">
                <input type="checkbox" v-model="meetingType" />Reuniones
              </label>
            </div>
            <div>
              <label for="hallType">
                <input type="checkbox" v-model="hallType" />Eventos
              </label>
            </div>
          </div>
        </div>
      </div>
      <div class="bordered-box">
        <div class="group">
          <div class="options">
            <h4>Apertura</h4>
            <div class="hour">
              <input type="time" v-model="openTime" />
            </div>
            <h4>Cierre</h4>
            <div class="hour">
              <input type="time" v-model="closeTime" />
            </div>
          </div>
          <div class="options">
            <h4>Equipamiento</h4>
            <div>
              <label for="furniture">
                <input type="checkbox" v-model="furniture" />Muebles
              </label>
            </div>
            <div>
              <label for="wifi">
                <input type="checkbox" v-model="wifi" />WI-FI
              </label>
            </div>
            <div>
              <label for="projector">
                <input type="checkbox" v-model="projector" />Proyector
              </label>
            </div>
            <div>
              <label for="screen">
                <input type="checkbox" v-model="screen" />Pantalla
              </label>
            </div>
          </div>
        </div>
      </div>
      <div class="last-box">
        <div class="box-image">
          <textarea
            v-model="description"
            placeholder="Descripción de la sala"
            class="field"
            rows="5"
            cols="30"
          ></textarea>
          <div>
            <input
              type="file"
              @change="onFileSelected"
              ref="images"
              name="spaces"
              id="img"
              multiple
            />
          </div>
        </div>
        <div>
          <!-- BOTÓN PARA ENVIAR LOS DATOS -->
          <button @click="editSpace()">Enviar Datos</button>
          <button @click="cancel()">Cancelar</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Swal from "sweetalert2";
import {
  getSpaceById,
  getSpaceId,
  updateSpace,
  saveImage,
} from "./../../../backend/requests/space";
import { getUserId, getAuthToken } from "./../../../backend/requests/user";
export default {
  name: "UpdateSpace",
  data() {
    return {
      id: "",
      hotel: "", // VARIABLES DE LA VISTA
      city: "",
      address: "",
      name: "",
      price: "",
      openTime: "",
      closeTime: "",
      uLayout: 0,
      classLayout: 0,
      theaterLayout: 0,
      meetingType: 0,
      hallType: 0,
      furniture: 0,
      wifi: 0,
      projector: 0,
      screen: 0,
      image1: "",
      image2: "",
      newImage1: null,
      newImage2: null,
      description: "",
    };
  },
  methods: {
    // FUNCIÓN PARA OBTENER UN ESPACIO
    async getSpace(id) {
      let result = await getSpaceById(id);
      let space = result.data[0];
      this.showSpaceInfo(space);
    },
    // FUNCIÓN PARA CARGAR LOS DATOS DEL ESPACIO
    showSpaceInfo(space) {
      let rest = ":00";
      this.id = space.id;
      this.hotel = space.hotel;
      this.city = space.city;
      this.address = space.address;
      this.name = space.name;
      this.price = space.price;
      this.openTime = space.open_hour + rest;
      this.closeTime = space.close_hour + rest;
      this.description = space.description;
      this.hallType = space.hall_type;
      this.meetingType = space.meeting_type;
      this.uLayout = space.u_layout;
      this.classLayout = space.class_layout;
      this.theaterLayout = space.theater_layout;
      this.furniture = space.furniture;
      this.wifi = space.wifi;
      this.screen = space.screen;
      this.projector = space.projector;
      this.image1 = space.image_1;
      this.image2 = space.image_2;
      this.newImage1 = null;
      this.newImage2 = null;
    },
    onFileSelected() {
      this.newImage1 = this.$refs.images.files[0];
      this.newImage2 = this.$refs.images.files[1];
    },
    validateSpace() {
      if (
        !this.hotel ||
        !this.city ||
        !this.address ||
        !this.name ||
        !this.price ||
        !this.openTime ||
        !this.closeTime ||
        !this.description
      ) {
        Swal.fire("No puedes dejar campos vacíos");
        return;
      } else {
        return true;
      }
    },
    // FUNCIÓN ACTUALIZAR EL ESPACIO
    async editSpace() {
      if (!this.validateSpace()) {
        return;
      }
      let token = getAuthToken();
      let open = this.openTime.slice(0, 2);
      let close = this.closeTime.slice(0, 2);
      if (this.newImage1) {
        this.image1 = await saveImage(this.newImage1);
      }
      if (this.newImage2) {
        this.image2 = await saveImage(this.newImage2);
      }
      let space = {
        hotel: this.hotel,
        city: this.city,
        address: this.address,
        name: this.name,
        price: this.price,
        open,
        close,
        uLayout: this.uLayout,
        classLayout: this.classLayout,
        theaterLayout: this.theaterLayout,
        meetingType: this.meetingType,
        hallType: this.hallType,
        furniture: this.furniture,
        wifi: this.wifi,
        projector: this.projector,
        screen: this.screen,
        image1: this.image1,
        image2: this.image2,
        description: this.description,
      };

      if (await updateSpace(token, this.id, space)) {
        Swal.fire("Espacio actualizado");
        this.$router.push({ name: "SpaceProviderList" });
      }
    },
    cancel() {
      this.$router.push({ name: "SpaceProviderList" });
    },
  },
  // SE OBTIENE EL ID DEL ESPACIO DEL LOCALSTORAGE Y SE PIDE EL ESPACIO AL SERVIDOR
  created() {
    this.id = getSpaceId();
    this.getSpace(this.id);
  },
};
</script>

<style scoped>
.container {
  background: linear-gradient(white, #2c3e50);
  width: 100%;
  display: flex;
  justify-content: center;
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

h3 {
  margin-bottom: 20px;
}

.group {
  display: flex;
  align-items: flex-start;
  justify-content: center;
}

.data {
  text-align: justify;
  padding-left: 70px;
}

.bordered-box {
  border-top: 1px solid lightgray;
  margin-top: 25px;
  margin-bottom: 20px;
}

#img {
  width: 310px;
}

.last-box {
  border-top: 1px solid lightgray;
}
.box-image {
  margin-top: 15px;
  margin-bottom: 15px;
}

.data label {
  width: 142px;
  font-weight: bold;
  display: inline-block;
}

.data input {
  width: 180px;
  padding: 3px 10px;
  border: 1px solid #f6f6f6;
  border-radius: 3px;
  background-color: #f6f6f6;
  margin: 8px 0;
  display: inline-block;
}

.box-image input {
  width: 180px;
  padding: 3px 10px;
  border: 1px solid #f6f6f6;
  border-radius: 3px;
  background-color: #f6f6f6;
  margin: 8px 0;
  display: inline-block;
}

.options {
  padding-top: 10px;
  padding-left: 20px;
  display: inline-block;
  width: 200px;
  text-align: justify;
}

.last-box {
  text-align: center;
}

input[type="time"],
textarea {
  padding: 3px 10px;
  border: 1px solid #f6f6f6;
  border-radius: 3px;
  background-color: #f6f6f6;
}

textarea {
  width: 310px;
}

h4 {
  padding-left: 45px;
}

input {
  margin: 8px;
}

.hour {
  padding-left: 30px;
}

label {
  padding-left: 16px;
}
</style>
