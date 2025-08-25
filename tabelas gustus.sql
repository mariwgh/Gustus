
create schema gustus;

---------------------------------------------

create table gustus.usuarios
(
    idUsuario int primary key identity(1,1),
    usuario varchar(50) unique not null,
    email varchar(150) unique not null,
    senha varchar(100) not null
);

--adicionar, alterar e excluir--
--add
insert into gustus.usuarios 
(usuario, email, senha)
values 
('Mariana', 'mariana@email.com', '123456');

--alter
update gustus.usuarios
set senha = 'novaSenha123'
where idUsuario = 1;

--delete
delete from gustus.usuarios
where idUsuario = 1;

---------------------------------------------

create table gustus.pratos
(
    idPrato int primary key identity(1,1),
    prato varchar(100) unique not null,
    descricao text,
    linkReceita varchar(max)
);

--pagina inicial todos os produtos--

--pagina do produto com favoritar, adicionar e remover da wishlist e experimentar--

--pesquisar pratos--

---------------------------------------------

create table gustus.favoritos
(
    idFavorito int primary key identity(1,1),
    idUsuario int not null foreign key references gustus.usuarios(idUsuario),
    idPrato int not null foreign key references gustus.pratos(idPrato)
);

--um usuario so pode ter 2 favoritos--
select count(*) 
from gustus.favoritos 
where idUsuario = @idUsuario;


--pagina favoritos do usuario--

---------------------------------------------

create table gustus.degustados
(
    idDegustado int primary key identity(1,1),
    idUsuario int not null foreign key references gustus.usuarios(idUsuario),
    idPrato int not null foreign key references gustus.pratos(idPrato),
    nota int check (nota between 1 and 5),
    descricao text
);

--pagina avaliar--


--pagina degustados do usuario--

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

--pagina wishlist do usuario--

---------------------------------------------