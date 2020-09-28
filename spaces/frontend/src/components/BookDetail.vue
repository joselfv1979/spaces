<!-- COMPONENTE DINÁMICO QUE RECIBE UN OBJETO RESERVA Y LO MUESTRA -->
<template>
  <div>
    <h1>Detalles de la reserva:</h1>
    <ul>
      <li>
        <p>
          <strong>Reserva a nombre de:</strong>
          {{ book.name }}
        </p>
        <p />
        <p v-if="!list">
          <strong>Lugar:</strong>
          {{ book.place }}
        </p>
        <p v-else>
          <strong>Lugar:</strong>
          {{ book.hotel }}
        </p>
        <p>
          <strong>Dirección:</strong>
          {{ book.address }}
        </p>
        <p>
          <strong>Precio:</strong>
          {{ book.price }}
        </p>
        <p>
          <strong>Asistentes:</strong>
          {{ book.attendees }}
        </p>
        <p>
          <strong>Tipo:</strong>
          {{ book.type }}
        </p>
        <p>
          <strong>Distribución:</strong>
          {{ book.layout }}
        </p>
        <p>
          <strong>Equipamiento:</strong>
          {{ book.equipment }}
        </p>
        <p>
          <strong>Entrada:</strong>
          {{ book.start_time }}
        </p>
        <p>
          <strong>Salida:</strong>
          {{ book.end_time }}
        </p>
        <p>
          <strong>Fecha de reserva:</strong>
          {{ book.book_date }}
        </p>
        <p v-if="!list">
          Le llegará un
          <strong>email de confirmación</strong> de la reserva a la
        </p>
        <p v-if="!list">
          <strong>dirección de correo:</strong>
          {{ book.email }}
        </p>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: "BookDetail", // EXPORTACIÓN DEL COMPONENTE
  props: {
    book: Object, // OBJETO QUE RECIBE EL COMPONENTE
    list: Boolean,
  },
};
</script>

<style scoped>
li {
  text-align: justify;
}
</style>