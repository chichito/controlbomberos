/*
CREATE TABLE Usuarios (
	Cedula VARCHAR(100) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
	Password VARCHAR(100) NOT NULL,
    FechaRegistro DATETIME DEFAULT GETDATE(),
	Imei text
);

create table tipoemergencias(
	id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
)

insert into tipoemergencias(nombre) values('estructural')
insert into tipoemergencias(nombre) values('forestal')
insert into tipoemergencias(nombre) values('vehicular')
insert into tipoemergencias(nombre) values('casa')

insert Usuarios (Cedula,Nombre,Email,Password,Imei) values('Admin','Admin','admin','111','emai')

drop table emergencias


CREATE TABLE emergencias(
            id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
            solicitante VARCHAR(100) NOT NULL,
			telefono VARCHAR(50) NOT NULL,
			prioridad VARCHAR(10) NOT NULL,
			idtipoemergencia  UNIQUEIDENTIFIER references tipoemergencias(id),
            direccion VARCHAR(1000) NOT NULL,
            referencia VARCHAR(500) NOT NULL,
            latitud float,
            longitud float,
            observaciones VARCHAR(100) NOT NULL,
            estado VARCHAR(100) Default 'PENDIENTE',
			idUsuarioCreo VARCHAR(100) references usuarios(cedula),
            fechahoraregistro datetime NOT NULL,
)
*/
select * from Usuarios
select * from emergencias
select * from tipoemergencias
