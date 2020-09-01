-- Spaces BBDD

-- users (#id, name, username, email, password, role)
-- books (#id, type, layout, furniture, wifi, projector, screen, attendees, book_date, start_time, end_time, rating, review, price, -user_id, -space_id)
-- spaces (#id, name, hotel, city, address, description, price, meeting_type, hall_type, u_layout, class_layout, theater_layout, image1, image2, -user_id)

-- La tabla 'users' almacena usuarios de tipo proveedor de espacios (providers), buscador de espacios (seekers) 
-- El campo 'role' se utiliza para diferenciarlos y junto con el id de usuario forman parte del token que se le entrega al usuario una vez logueado, 
-- para poder acceder posteriormente a diferentes funcionalidades de la aplicación. Las contraseñas de los usuarios se cifran mediante la método SHA1() en
-- la consulta 'insert' de la función de registro de usuario.

-- La tabla 'books' guarda las resevas realizadas sobre un espacio determinado, tiene como claves ajenas el id de usuario de la tabla 'users', para identificar
-- al usuario que realiza cada reserva y el id del espacio (tabla 'spaces') sobre el que se realiza la reserva. EL 'rating' y el 'review' de usuario se guarda
-- en esta tabla, si a posteriori el usuario quiere realizar una valoración sobre su experiencia de la reserva, mediante una consulta 'update'. 

-- La tabla 'spaces' almacena los espacios añadidos por los usuarios proveedores a la aplicación, tiene como clave ajena el id del usuario proveedor del espacio, 
-- el resto de campos son las características que ofrecen cada espacio. Las imágenes se almacenan en un campo de tipo varchar que referencia la ruta del sistema
-- que las va a guardar.

CREATE DATABASE spaces;
CREATE USER spaces IDENTIFIED BY 'spaces';
GRANT ALL PRIVILEGES ON spaces.* TO spaces;

USE spaces;

SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE users (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    username VARCHAR(50),
    email VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
    role VARCHAR(30) NOT NULL
);

CREATE TABLE books (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(30),
    layout VARCHAR(30),
    furniture BOOLEAN,
    wifi BOOLEAN,
    projector  BOOLEAN,
    screen BOOLEAN,
    attendees INT DEFAULT 0,
    book_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    start_time DATETIME,
    end_time DATETIME,
    rating INT DEFAULT NULL,
    review TEXT,
    price decimal(5,2) DEFAULT 0, -- decimal
    user_id INT UNSIGNED,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    space_id INT UNSIGNED,
    FOREIGN KEY (space_id) REFERENCES spaces(id) ON DELETE SET NULL
);

CREATE TABLE spaces (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    hotel VARCHAR(50),
    city VARCHAR(30),
    address VARCHAR(50),
    description TEXT,
    price decimal(5,2) DEFAULT 0, -- decimal
    meeting_type BOOLEAN,
    hall_type BOOLEAN,
    u_layout BOOLEAN,
    class_layout BOOLEAN,
    theater_layout BOOLEAN,
    furniture BOOLEAN,
    wifi BOOLEAN,
    projector  BOOLEAN,
    screen BOOLEAN,
    image_1 VARCHAR(500),
    image_2 VARCHAR(500),
    open_hour int,
    close_hour int,
    user_id INT UNSIGNED,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO users(name, username, email, password, role) VALUES
('Juan Costa Fernández', 'proveedor1', 'jc@gmail.com', SHA1('1234'), 'provider'),
('Ana Ríos Lemos', 'proveedor2', 'al@gmail.com', SHA1('1234'), 'provider'),
('Lara Suárez Lago', 'buscador1', 'la@gmail.com', SHA1('1234'), 'seeker');

INSERT INTO spaces(id, name, hotel, city, address, description, price, meeting_type, hall_type, u_layout, class_layout, theater_layout,
 furniture, wifi, projector, screen, image_1, image_2, open_hour, close_hour, user_id) VALUES
 (1, 'sala 1', 'Hotel Puentes', 'Pontevedra', 'Calle 1', 'Sitio bonito y tranquilo', 30, true, true, true, true, false, true, true, true, false,
 'https://images.unsplash.com/photo-1497366616365-e78dd380d3dd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
 'https://images.unsplash.com/photo-1528238646472-f2366160b6c1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60', 10, 22, 1),
  (2, 'sala 2', 'Hotel Esperanza', 'Pontevedra', 'Calle 2', 'Sitio bonito y tranquilo', 40, false, true, true, true, false, true, true, true, false,
 'https://images.unsplash.com/photo-1510074377623-8cf13fb86c08?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
 'https://images.unsplash.com/photo-1528238646472-f2366160b6c1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60', 10, 23, 1),
  (3, 'sala 3', 'Hotel Ríos', 'Santiago', 'Calle 1', 'Sitio bonito y tranquilo', 35, false, true, true, true, false, true, true, true, false,
 'https://images.unsplash.com/photo-1517502884422-41eaead166d4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
 'https://images.unsplash.com/photo-1528238646472-f2366160b6c1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60', 10, 22, 2),
 (4, 'sala 2', 'Hotel Botafumeiro', 'Santiago', 'Calle 1', 'Sitio bonito y tranquilo', 40, false, true, true, true, false, true, true, true, true,
 'https://images.unsplash.com/photo-1549637642-90187f64f420?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
 'https://images.unsplash.com/photo-1528238646472-f2366160b6c1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60', 10, 23, 2),
 (5, 'sala 1', 'Hotel Brisamar', 'Coruña', 'Calle 1', 'Sitio bonito y tranquilo', 40, false, true, true, true, false, true, true, true, false,
 'https://images.unsplash.com/photo-1497366616365-e78dd380d3dd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
 'https://images.unsplash.com/photo-1528238646472-f2366160b6c1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60', 10, 22, 1),
 (6, 'sala 2', 'Hotel Centro', 'Coruña', 'Calle 1', 'Sitio bonito y tranquilo', 30, false, true, true, true, false, true, true, true, false,
 'https://images.unsplash.com/photo-1497366616365-e78dd380d3dd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
 'https://images.unsplash.com/photo-1528238646472-f2366160b6c1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60', 10, 22, 1),
 (7, 'sala 2', 'Hotel Playa', 'Vigo', 'Calle 1', 'Sitio bonito y tranquilo', 40, false, true, true, true, false, true, true, true, false,
 'https://images.unsplash.com/photo-1497366616365-e78dd380d3dd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
 'https://images.unsplash.com/photo-1528238646472-f2366160b6c1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60', 10, 22, 2),
 (8, 'sala 4', 'Hotel Juan', 'Vigo', 'Calle 1', 'Sitio bonito y tranquilo', 40, false, true, true, true, false, true, true, true, false,
 'https://images.unsplash.com/photo-1497366616365-e78dd380d3dd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
 'https://images.unsplash.com/photo-1528238646472-f2366160b6c1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60', 10, 22, 2);


SET FOREIGN_KEY_CHECKS = 1;