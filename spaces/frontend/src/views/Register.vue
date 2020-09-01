<!-- VISTA QUE CONTIENE EL FORMULARIO DE REGISTRO DE USUARIO -->
<template>
  <div id="main">
    <!-- TÍTULO PERSONALIZADO CON VUE-HEADFUL -->
    <vue-headful title="Registro" />
    <div class="container">
      <div class="form">
      <h2>Registro</h2>
      <p v-if="!checkIsCompleted" class="red">Rellena los campos marcados en rojo</p>
      <!-- INPUTS VINCULADOS AL DATA CON V-MODEL -->
      <div class="first-box">
        <div class="data">
          <label for="name">nombre completo</label>
          <input
            type="text"
            class="input-text"
            v-model="name"
            :class="{ alert: !checkName }"
            placeholder="Tu nombre y apellidos"
          />
        </div>
        <div class="data">
          <label for="email">email</label>
          <input
            type="email"
            class="input-text"
            v-model="email"
            :class="{ alert: !checkEmail }"
            placeholder="Tu email"
          />
          <span class="red" v-if="!checkEmailIsValid">La cuenta de correo no es válida</span>
          <span class="red" v-else-if="checkEmailExist">La cuenta de correo ya existe</span>
        </div>
        <div class="data">
          <label for="name">nombre de usuario</label>
          <input
            type="text"
            class="input-text"
            v-model="username"
            :class="{ alert: !checkUsername }"
            placeholder="Tu nombre de usuario/a"
          />
          <span class="red" v-if="checkUsernameExist">El usuario ya existe</span>
        </div>
        <div class="data">
          <label for="password">Contraseña</label>
          <input
            id="password"
            class="input-text"
            type="password"
            v-model="password"
            :class="{ alert: !checkPassword }"
            placeholder="Tu contraseña"
          />
          <span
            class="red"
            v-if="!checkPasswordLength"
          >La contraseña debe tener al menos 4 caracteres</span>
          <p id="clear" @click="showPassword()">Ver/ocultar password</p>
        </div>
      </div>
      <div class="second-box">
        <label for="role">Tipo de cuenta</label>
        <input type="radio" id="provider" v-model="role" name="role" value="provider" />
        <label id="provider-label" for="provider">Proveedor</label>
        <input type="radio" id="seeker" v-model="role" name="role" value="seeker" />
        <label id="seeker-label" for="seeker">Buscador</label>
      </div>
      <!-- BOTÓN PARA ENVIAR LOS DATOS DE REGISTRO -->
      <button @click="register()">Enviar</button>
    </div>
    </div>
  </div>
</template>

<script>
// IIMPORTACIÓN DE FUNCIONES Y LIBRERÍAS EXTERNAS
import { registerUser } from "./../../../backend/requests/user";
import Swal from "sweetalert2";

export default {
  name: "Register",
  data() {
    return {
      name: "",
      username: "",
      email: "",
      password: "",
      role: "provider",
      checkIsCompleted: true,
      checkUsername: true, // SI ES FALSE MUESTRA MENSAJE
      checkPassword: true, // SI ES FALSE MUESTRA MENSAJE
      checkName: true, // SI ES FALSE MUESTRA MENSAJE
      checkEmail: true, // SI ES FALSE MUESTRA MENSAJE
      checkEmailIsValid: true,
      checkEmailExist: false,
      checkUsernameExist: false,
      checkPasswordLength: true,
    };
  },
  methods: {
    // FUNCIÓN PARA MOSTRAR LA PASSWORD EN CLARO
    showPassword() {
      let tipo = document.getElementById("password");
      if (tipo.type == "password") {
        tipo.type = "text";
      } else {
        tipo.type = "password";
      }
    },
    // FUNCIÓN PARA VALIDAR LOS DATOS DEL USUARIO
    validateUser() {
      this.checkIsCompleted = true
      this.checkEmailIsValid = true;
      this.checkEmailExist = false;
      this.checkUsernameExist = false;
      this.checkPasswordLength = true;
      this.checkUsername = this.username;
      this.checkPassword = this.password;
      this.checkName = this.name;
      this.checkEmail = this.email;
      if (!this.username || !this.password || !this.name || !this.email) {
        this.checkIsCompleted = false
        return false;
      } else if (this.password.length > 0 && this.password.length < 4) {
        this.checkPasswordLength = false;
        return false;
      } else {
        return true;
      }
    },
    // FUNCIÓN DE REGISTRO
    async register() {
      if (!this.validateUser()) {
        return;
      }
      let user = {
        name: this.name,
        username: this.username,
        email: this.email,
        password: this.password,
        role: this.role,
      };
      // SI PASA LAS VALIDACIONES SOLICITA EL REGISTRO AL SERVIDOR
      let result = await registerUser(user);
      // REGISTRO CORRECTO
      if (result.description) {
        Swal.fire(
          `Registro completado. Se enviará un email de confirmación a la cuenta: ${this.email}`
        );
        this.$router.push({ name: "Login" });
        return;
      }
      // NO CUMPLE VALIDACIONES DEL SERVIDOR
      if (result === "invalidMail") {
        this.checkEmailIsValid = false;
        return;
      }
      if (result === "mailExist") {
        this.checkEmailExist = true;
        return;
      }
      if (result === "usernameExist") {
        this.checkUsernameExist = true;
        return;
      } else {
        Swal.fire("No se ha podido completar el registro. Inténtelo de nuevo");
      }
    },
  },
};
</script>

<style scoped>
.container {
  height: 100vh;
  display: flex;
  vertical-align: center;
  align-items: center;
}
h2 {
  margin-bottom: 20px;
  color: #2c3e50;
}
.form {
  margin-top: 20px;
  margin-bottom: 20px;
  margin-left: auto;
  margin-right: auto;
  width: 400px;
  padding: 16px;
  border-radius: 10px;
  background-color: #ccc;
  color: #2c3e50;
}

.first-box {
  text-align: justify;
  margin-left: 25px;
}

.second-box {
  margin-top: 20px;
  margin-bottom: 20px;
  text-align: justify;
  margin-left: 25px;
}

.second-box label {
  width: 110px;
}

#provider-label,
#seeker-label {
  margin-left: 5px;
  width: 80px;
}

#provider {
  margin-left: 35px;
}

#seeker {
  margin-left: 15px;
}
#seeker,
#provider {
  width: 10px;
}

label {
  width: 142px;
  font-weight: bold;
  display: inline-block;
}

.input-text {
  width: 180px;
  padding: 3px 10px;
  border: 1px solid white;
  border-radius: 3px;
  margin: 8px 0;
  display: inline-block;
}

span {
  text-align: center;
  margin-left: 100px;
}

button {
  width: 90%;
  padding: 8px 16px;
  margin-top: 32px;
  border: 1px solid #2c3e50;
  border-radius: 5px;
  display: block;
  color: #fff;
  background-color: #2c3e50;
}

button:hover {
  cursor: pointer;
  background-color: #2c3e50;
}

#clear {
  cursor: pointer;
  text-align: center;
  margin-left: 110px;
  font-size: 0.8rem;
}

#clear:hover {
  color: #3b83bd;
}

.red {
  color: #d33;
  display: block;
  font-size: 0.8rem;
}

.alert {
  border: 1px solid #d33;
}

</style>