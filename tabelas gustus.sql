
select * from gustus.usuarios
select * from gustus.pratos
select * from gustus.favoritos
select * from gustus.degustados
select * from gustus.wishlist

--------------------------------------------

create schema gustus;

---------------------------------------------

create table gustus.usuarios
(
    idUsuario int primary key identity(1,1),
    usuario varchar(50) unique not null,
    email varchar(150) unique not null,
    senha varchar(100) not null
);

--inserts
insert into gustus.usuarios 
(usuario, email, senha) 
values
('Mariana', 'mariana@email.com', '123456'),
('Joao', 'joao@email.com', 'senha123'),
('Rafaelly', 'rafaelly@email.com', 'segredo321');


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
	foto varchar(max) not null,  -- link para a foto
    descricao text,
    linkReceita varchar(max)
);


--inserts
insert into gustus.pratos 
(prato, foto, descricao, linkReceita) 
values
('Risoto de Camarão', 'https://picsum.photos/200/risoto', 'Prato italiano cremoso com camarões frescos.', 'https://www.tudogostoso.com.br/receita/185493-risoto-de-camarao-sem-frescura.html'),
('Ratatouille', 'https://picsum.photos/200/ratatouille', 'Receita francesa com legumes assados.', 'https://www.tudogostoso.com.br/receita/135302-ratatouille.html'),
('File Mignon', 'https://picsum.photos/200/filemignon', 'Corte nobre de carne ao molho madeira.', 'https://www.tudogostoso.com.br/categorias/1116-file-mignon'),
('Açaí', 'https://picsum.photos/200/acai', 'Sobremesa brasileira servida gelada.', 'https://www.tudogostoso.com.br/receita/296086-acai.html'),
('Lasanha à Bolonhesa', 'https://picsum.photos/200/lasanha', 'Massa em camadas com molho à bolonhesa e queijo gratinado.', 'https://www.tudogostoso.com.br/receita/876-lasanha-de-carne-moida.html'),
('Brigadeiro', 'https://picsum.photos/200/brigadeiro', 'Doce brasileiro feito com leite condensado, chocolate e granulado.', 'https://www.tudogostoso.com.br/receita/114-brigadeiro.html'),
('Sushi', 'https://picsum.photos/200/sushi', 'Prato japonês com arroz temperado e peixe cru.', 'https://www.tudogostoso.com.br/receita/37091-sushi.html'),
('Pizza Margherita', 'https://picsum.photos/200/pizza', 'Pizza tradicional italiana com molho de tomate, mussarela e manjericão.', 'https://www.tudogostoso.com.br/receita/91718-pizza-marguerita-super-facil.html');


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
drop table gustus.favoritos;

--inserts
-- Mariana favoritou Risoto e Açaí
insert into gustus.favoritos (idUsuario, idPrato) values
(1, 1),
(1, 4);

-- Joao favoritou Ratatouille e File Mignon
insert into gustus.favoritos (idUsuario, idPrato) values
(2, 2),
(2, 3);

-- Ana favoritou apenas Risoto
insert into gustus.favoritos (idUsuario, idPrato) values
(3, 1);


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
drop table gustus.degustados;

--inserts
-- Mariana degustou Ratatouille e avaliou
insert into gustus.degustados (idUsuario, idPrato, nota, descricao) values
(1, 2, 5, 'Muito saboroso, bem temperado.');

-- Joao degustou Risoto
insert into gustus.degustados (idUsuario, idPrato, nota, descricao) values
(2, 1, 4, 'Bom, mas poderia ter mais camarão.');

-- Ana degustou Açaí
insert into gustus.degustados (idUsuario, idPrato, nota, descricao) values
(3, 4, 5, 'Perfeito para dias quentes!');


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

drop table gustus.wishlist;

--inserts
-- Mariana quer experimentar File Mignon
insert into gustus.wishlist (idUsuario, idPrato) values
(1, 3);

-- Joao quer experimentar Açaí
insert into gustus.wishlist (idUsuario, idPrato) values
(2, 4);

-- Ana quer experimentar Ratatouille
insert into gustus.wishlist (idUsuario, idPrato) values
(3, 2);


--pagina wishlist do usuario--

---------------------------------------------