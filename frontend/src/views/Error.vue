<template>
  <div>
      <vue-headful title="Error"/>
      <div class="error">
        <h1>Error 404</h1>
        <p>La página solicitada no existe</p>
      </div>
  </div>
</template>

<script>
export default {
name: 'Error'
}
</script>

<style scoped>
.error{
  height: auto;
  min-height: 80vh;
}

h1 {
  margin-top: 20px;
}
</style>