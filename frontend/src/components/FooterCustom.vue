<!-- COMPONENTE ESTÁTICO QUE CONTIENE EL FOOTER DE LA APLICACIÓN -->
<template>
  <div id="foot">
    <footer >
        <p>Created by Jose 2020</p>
    </footer>
  </div>
</template>

<script>
export default {
  name: "FooterCustom"
};
</script>

<style scoped>

#foot {
  font-size: 20px;
  color: #2c3e50;
  background-color: #3b83bd;
  font-weight: bold;
  height: 80px;
  width: 100%;
  display: flex;
  align-self: flex-end;
  align-items: center;
}

</style>