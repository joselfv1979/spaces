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
          <p class="push"><span>Puntuación:</span> {{ score.rating }}/5</p>
        </div>
        <div class="data">
          <p class="comment"><span>Comentario:</span> {{ score.review }}</p>
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
  width: 50%;
  background-color: white;
  border: 1px solid lightgray;
  border-radius: 10px;
}

.box {
  display: flex;
}

span {
  color: #3b83bd;
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