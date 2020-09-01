<!-- COMPONENTE DINÁMICO QUE RECIBE UN ARRAY DE VALORACIONES Y LOS MUESTRA EN UNA LISTA -->
<template>
  <div>
    <ul>
      <!-- V-FOR: PARA RECORRER EL ARRAY Y MOSTRAR CADA ELEMENTO -->
      <li v-for="score in scores" :key="score.id">
        <div class="box">
          <p>
            <strong># {{ score.username }}</strong>
          </p>
          <p class="push">Puntuación: {{ score.rating }}</p>
        </div>
        <div class="data">
          <p class="comment">comentario: {{ score.review }}</p>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: "ScoresList", // EXPORTACIÓN DEL COMPONENTE
  props: {
    // DECLARACIÓN DEL ARRAY QUE RECIBE EL COMPONENTE
    scores: Array,
  },
};
</script>

<style scoped>
li {
  border: none;
  width: 50%;
}

.box {
  display: flex;
}

.data {
  text-align: justify;
  word-wrap: break-word;
}

.comment {
    width: 100%;
}

.push {
  margin-left: auto;
}

</style>