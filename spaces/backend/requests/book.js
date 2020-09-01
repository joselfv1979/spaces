// IMPORTACIÓN DE LIBRERÍAS EXTERNAS
import axios from "axios";
import moment from "moment";

// VARIABLE QUE GUARDA LA DIRECCIÓN DEL SERVIDOR
const ENDPOINT = 'http://localhost:8000'

// FUNCIÓN PARA GUARDAR EL ID DEL ESPACIO EN EL LOCALSTORAGE
export function setBookId(bookId) {
    localStorage.setItem("BOOKID", bookId);
}
// FUNCIÓN PARA RECUPERAR EL ID DESDE EL LOCALSTORAGE
export function getBookId() {
    return localStorage.getItem("BOOKID");
}
// FUNCIÓN PARA BORRAR EL ID DEL LOCALSTORAGE
export function removeBookId() {
    localStorage.removeItem("BOOKID")
}

// FUNCIÓN QUE REALIZA LA PETICIÓN PARA CREAR UNA RESERVA NUEVA
export async function createBook(token, spaceId, newBook) {

    try {
        const result = await axios.post(`${ENDPOINT}/books`, {
            newBook, spaceId
        },
            {
                headers: { 'Authorization': `${token}` }
            })

        if (result.data.unavailable) {
            throw result.data.unavailable
        } else {
            return result.data;
        }

    } catch (error) {
        return error
    }
}

// FUNCIÓN QUE REALIZA LA PETICIÓN PARA RECUPERAR UNA RESERVA DETERMINADA
export async function getBook(token, spaceId, bookId) {

    try {
        const book = await axios
            .get(`${ENDPOINT}/books/seekers/${bookId}?spaceId=${spaceId}`,
                {
                    headers: { 'Authorization': `${token}` }
                })
        const formatBook = dateFormat(book.data);
        return formatBook
    } catch (error) {
        console.log(error);
    }
}


export async function removeBook(id, token) {
    try {
        await axios.delete(`${ENDPOINT}/books/${id}`,
            {
                headers: { 'Authorization': `${token}` }
            })
        return true
    } catch (error) {
        console.log(error);
    }

}

// FUNCIÓN PARA FORMATEAR LAS FECHAS DE LA RESERVA RECIBIDA
const dateFormat = data => {
    let bookDate = moment(data.book_date)
        .utcOffset(120)
        .format("DD-MM-YYYY HH:mm");
    let startTime = moment(data.start_time)
        .utcOffset(120)
        .format("DD-MM-YYYY HH:mm");
    let endTime = moment(data.end_time)
        .utcOffset(120)
        .format("DD-MM-YYYY HH:mm");
    data.book_date = bookDate;
    data.start_time = startTime;
    data.end_time = endTime;
    return data;
}

// FUNCIÓN QUE REALIZA LA PETICIÓN PARA RECUPERAR LAS RESERVAS DE UN USUARIO
export async function getBooks(token) {

    try {
        const books = await axios
            .get(`${ENDPOINT}/books/seekers`,
                {
                    headers: { 'Authorization': `${token}` }
                })
        console.log(books.data);
        return books;
    } catch (error) {
        console.log(error);
    }
}

// FUNCIÓN PARA AÑADIR UNA VALORACIÓN
export async function addScore(token, index, rating, review) {
    try {
        if (await axios
            .post(`${ENDPOINT}/books/${index}`,
                {
                    rating, review
                },
                {
                    headers: { 'Authorization': `${token}` }
                })) {
            return true
        }
    } catch (error) {
        console.log(error);
    }
}