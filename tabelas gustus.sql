
create schema gustus;

---------------------------------------------

create table gustus.usuarios
(
    idUsuario int primary key identity(1,1),
    usuario varchar(50) unique not null,
    email varchar(150) unique not null,
    senha varchar(100) not null
);

---------------------------------------------

create table gustus.pratos
(
    idPrato int primary key identity(1,1),
    prato varchar(100) unique not null,
    descricao text,
    linkReceita varchar(max)
);

---------------------------------------------

create table gustus.favoritos
(
    idFavorito int primary key identity(1,1),
    idUsuario int not null foreign key references gustus.usuarios(idUsuario),
    idPrato int not null foreign key references gustus.pratos(idPrato)
);

---------------------------------------------

create table gustus.degustados
(
    idDegustado int primary key identity(1,1),
    idUsuario int not null foreign key references gustus.usuarios(idUsuario),
    idPrato int not null foreign key references gustus.pratos(idPrato),
    nota int check (nota between 1 and 5),
    descricao text
);

select 
    u.usuario,
    p.prato,
    d.nota,
    d.descricao as comentario,
    d.idDegustado
from gustus.degustados d
inner join gustus.usuarios u on u.idUsuario = d.idUsuario
inner join gustus.pratos p on p.idPrato = d.idPrato
where u.idUsuario = @idUsuario;

---------------------------------------------

create table gustus.wishlist
(
    idWishlist int primary key identity(1,1),
    idUsuario int not null foreign key references gustus.usuarios(idUsuario),
    idPrato int not null foreign key references gustus.pratos(idPrato)
);

---------------------------------------------