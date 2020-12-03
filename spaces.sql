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

insert into spaces values 
(1,"sala 5","Hotel Puente",'Pontevedra',"Calle 1","Sitio bonito y tranquilo",30.00,1,1,1,1,0,1,1,0,0,'fc4bab68-3864-435f-862f-cfdc18bb76e7.jpeg','c06119a7-e49d-4585-a57d-67e1fe005adc.jpeg',10,22,1),
(2,"sala 2","Hotel Centro",'Pontevedra',"Calle 2","Sitio bonito y tranquilo",40.00,1,0,1,1,0,1,1,1,0,'9e18b010-c6b2-4d7b-bd82-15e7136f8307.jpeg','8ed69700-8abf-42ae-a3ce-65b00793bdfb.jpeg',10,23,1),
(3,"sala 3","Hotel Ríos",'Santiago',"Calle 1","Sitio bonito y tranquilo",30.00,1,1,1,1,0,1,1,1,0,'956bb9b3-7498-4a27-82a4-a24d80304594.jpg','7b0cd616-5160-41d9-ad36-eae12796d92a.jpg',10,22,2),
(4,"sala 2","Hotel Botafumeiro",'Santiago',"Calle 1","Sitio bonito y tranquilo",40.00,1,1,1,1,0,1,1,1,1,'3b942b76-f56e-47df-8ce1-3f019ed248b3.jpg','6cb89fb1-6dac-46b1-a92c-36cfd67d0af4.jpg',10,23,2),
(5,"sala 1","Hotel Brisamar",'Coruña',"Calle 1","Sitio bonito y tranquilo",40.00,0,1,1,1,0,1,1,1,0,'d02b43c2-802b-4e69-b2fa-5e435817071f.jpeg','5871f490-8db3-4574-8148-9a59b3e0a50e.jpeg',10,22,1),
(6,"sala 2","Hotel Centro",'Coruña',"Calle 1","Sitio bonito y tranquilo",30.00,1,0,1,0,0,1,1,1,0,'cef0f899-0fa3-474d-9a8b-fe9b6beff7fb.jpeg','2a07482c-eccb-420d-a12c-32509f5cd138.jpeg',10,22,1),
(7,"sala 2","Hotel Playa",'Vigo',"Calle 1","Sitio bonito y tranquilo",30.00,1,1,1,1,0,1,1,1,0,'28eddf0d-9bd2-4a8e-9b4f-0e53562c74a3.jpg','e54529cc-7f3e-4d73-ab8c-a9d01130804c.jpg',10,22,2),
(8,"sala 4","Hotel Juan",'Vigo',"Calle 1","Sitio bonito y tranquilo",40.00,0,1,1,1,0,1,1,1,0,'35e9fd00-702e-4439-bf4d-faf71d447fca.jpg','a31ba8e6-719b-4d37-ac81-ce829426c878.jpg',10,22,2),
(10,"Sala 1","Hotel BB",'Ourense',"Calle 3","Lugar confortable y bien situado.",60.00,1,1,1,1,1,1,1,1,1,'c1a98fa7-461f-48be-be2d-744e98424800.jpeg','888efc5b-e08d-4810-a51c-cd13a77ec20d.jpeg',10,23,13),
(11,"Sala 1","Hotel AM",'Ourense',"Calle 4","Sitio agradable y con todos los servicios.",25.00,1,0,1,0,0,1,1,0,0,'ef72994c-5a61-4991-99d8-1e08f74a90f5.jpg','448f4eb1-5ed1-438b-9ca8-04e206a42a48.jpg',10,22,13),
(12,"Sala 2","Hotel BB",'Ourense',"Calle 3","Sitio tranquilo y cerca del centro.",30.00,1,1,1,1,1,1,1,1,1,'94875ae9-5553-49b9-aa36-6a33260391b4.jpg','140a8951-ffed-4e72-bb46-df537bdac764.jpg',10,23,13),
(13,"Sala3","Hotel CC",'Vigo',"Calle 5","Sala amplia y confortable.",40.00,1,0,1,1,1,1,1,1,1,'01f2f913-e928-4439-a78d-8dee5e38e8b2.jpeg','edf0e28c-0ca7-49b7-84b1-cea0da5fc321.jpeg',10,23,14),
(14,"sala3","Hotel Paraíso",'Vigo',"calle 7","Lugar perfecto para celebrar tus eventos y reuniones. Con todo el equipamiento que necesites",40.00,1,0,1,1,0,1,1,1,1,'ee6af362-3178-43da-a0a5-cf3f8cdbba6f.jpeg','37200d21-8ea3-4eba-8272-7b48c75c563b.jpeg',9,22,1),
(15,"sala2","Hotel Luna",'Pontevedra',"calle 7","Lugar ideal para celebrar tus eventos y reuniones. Bien comunicado",40.00,1,0,1,1,0,1,1,0,1,'b98c0941-6e18-4b65-994d-1a3976ca2c90.jpeg','6d8b99d9-ff43-4b48-bc44-a9df4966b0d6.jpeg',10,22,1),
(16,"sala2","Hotel Iglesias",'Santiago',"calle 7","Lugar ideal para celebrar tus eventos y reuniones.",40.00,1,1,0,1,1,1,1,0,1,'c4bd0148-1509-4b4f-a26d-b02787342cba.jpg','1169f505-8fee-49db-b855-04ae54f6dc19.jpeg',10,22,4),
(17,"sala 3","Hotel Iglesias",'Santiago',"calle 7","Lugar ideal para celebrar tus eventos y reuniones.",40.00,1,1,0,1,1,1,1,0,1,'125b5ee1-c0fc-494b-be98-77c2539c0c23.jpg','aaceeea7-b07f-4d1a-8c3f-6ba35cda376d.jpeg',10,22,4),
(18,"sala 3","Hotel Burgas",'Ourense',"calle 7","Lugar ideal para celebrar tus eventos y reuniones.",40.00,1,1,0,1,1,1,1,0,1,'37b6d630-4337-40a3-8235-552e78bbc47e.jpg','22627576-c568-40e4-8d85-8a564ab1b9d6.jpg',10,22,4),
(19,"sala 3","Hotel Riazor",'Coruña',"calle 7","Lugar ideal para celebrar tus eventos y reuniones.",40.00,1,1,0,1,1,1,1,0,1,'c1ea60de-c18d-4f35-8c2c-b211efd5662d.jpeg','e59b116a-84b9-47d2-aad1-828ab89313fd.jpg',10,22,8),
(20,"sala 2","Hotel Riazor",'Coruña',"calle 7","Lugar ideal para celebrar tus eventos y reuniones.",30.00,1,1,0,1,1,1,1,0,1,'eeb0ab5c-d28c-4242-8eb0-483b266b2a6f.jpg','cfb297c5-0955-44cf-a012-48514059350b.jpg',10,22,8),
(39,"Sala 2","Hotel Vigo",'Vigo',"Calle 2","Buen sitio.",45.00,1,0,1,0,0,1,1,0,0,'80210479-ac5f-4d3d-883b-8988d1335945.jpg','2eaccb2c-5dc0-48f7-8a00-28f5f1106979.jpg',10,22,13);


SET FOREIGN_KEY_CHECKS = 1;
