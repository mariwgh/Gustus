const express = require("express");
const sql = require("mssql");
const jwt = require("jsonwebtoken");        //isso será usado para manter o login feito
const SECRET_KEY = "loveMyGirlfriend";      //essa "senha" será usada para ??? mas é necessária

//--------------------------------------------TROCAR TODOS OS DADOS PARA BODY----------------------------------------------------------------------------------
const app = express();
const PORT = 3000;

function validarEmail(email) {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return regex.test(email);
}

// Configuração do banco
const config = {
    user: "BD24140",
    password: "BD24140",
    server: "regulus.cotuca.unicamp.br",   // ou IP/nome do servidor
    database: "BD24140",
    options: {
        encrypt: true, // use true se for Azure, senão pode deixar false
        trustServerCertificate: true
    }
};

// Testando a conexão
sql.connect(config)
    .then(() => console.log("Conectado ao SQL Server ✅"))
    .catch(err => console.error("Erro de conexão ❌:", err));

// Rota de exemplo
app.get("/familiares", async (req, res) => {
    try {
        let result = await sql.query`select * from familiamari.familia`;
        res.json(result.recordset); // Retorna os dados em JSON
    } catch (err) {
        res.status(500).send("Erro ao buscar clientes: " + err);
    }
});

//antes de fzr qualquer funcionalidade é necessário verificar se o token ainda é correspondente
function verificarToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];     //formato: "Bearer TOKEN"

  if (!token) return res.sendStatus(401); // não autorizado

  jwt.verify(token, SECRET_KEY, (err, user) => {
    if (err) return res.sendStatus(403); // token inválido
    req.user = user; // guarda o usuário no request
    next();
  });
}


//cadastrar
app.post("/cadastrar" , async (req, res) => {
    try{
        let {email , senha, user} = req.query

        if (validarEmail(email)){
            let emailExiste = await sql.query`select * from gustus.usuarios where email = ${email}`

            if(emailExiste.recordset.length > 0){       //ja existe um user com esse email
                res.sendStatus(409)     //email ja existe
            }
            
            else{
                await sql.query`insert into gustus.usuarios (usuario, email, senha) values (${user}, ${email}, ${senha})`
                res.sendStatus(201)     //deu certo
            }       
        }
        else{
            res.sendStatus(400)     //email inválido
        }

    }
    catch(erro){
        console.log(erro.message)
        res.sendStatus(500)     //erro interno
    }
})


//login
app.get("/login" , async (req, res)=> {
    let { email, senha } = req.query;

    if (!validarEmail(email)) {
        return res.status(400).json({ sucesso: false, mensagem: "Formato de e-mail inválido" });
    }
    else{
        try{
            let result = await sql.query`select * from gustus.usuarios where email = ${email}`  //verifica se existe usuario com esse email

            if (result.recordset.length > 0){
                let password = await sql.query`select senha from gustus.usuarios where email = ${email} `
                res.json()

                if (password.recordset[0] == senha){
                    res.sendStatus(200) //login ok
                    const token = jwt.sign({ email: email }, SECRET_KEY, { expiresIn: '1h' });  //mantém o login guardado por 1h
                    return res.json({token})    //oq isso faz?
                }
                else{
                    res.sendStatus(401) //login deu erro
                }
            }

            else{
                res.sendStatus(404) //usuário nao cadastrado
            }
        }

        catch (erro){
            console.log(erro.message)
            res.sendStatus(500) //erro no servidor
        }
    }

})

//ver favoritos
app.get("/ver-favoritos" , verificarToken, async (req, res) => {
    let emailUser = req.user.email
    try{
        let idUserSQL = await sql.query`select idUsuario from gustus.usuarios where email=${emailUser}`
        //res.json()
        if (idUserSQL.recordset.length === 0) {
            return res.status(404).json({ mensagem: "Usuário não encontrado" });
        }

        let idUser = idUserSQL.recordset[0].idUsuario
        
        let result = await sql.query`select * from gustus.favoritos where idUsuario = ${idUser}`
        return res.json(result.recordset) 
    }
    catch(erro){
        console.log(erro.message)
        return res.sendStatus(500)      //erro interno
    }
})

//adicionar favoritos
app.post("/add-favoritos" , verificarToken , async (req , res)=>{
    let email = req.user.email      //vem do token
    let idComida = req.query.idPrato        //tem que fazer um jeito que pega o id do que o usuário está visualizando (não sei como)
    try{
        if (!idComida) {
            return res.status(400).json({ mensagem: "ID do prato não informado" });
        }
        let idUserSQL = await sql.query`select idUsuario from gustus.usuarios where email=${email}`
        //res.json()
        if (idUserSQL.recordset.length === 0) {
            return res.status(404).json({ mensagem: "Usuário não encontrado" });
        }

        let idUser = idUserSQL.recordset[0].idUsuario

        await sql.query`insert into gustus.favoritos (idUsuario, idPrato) values (${idUser}, ${idComida})`
        res.sendStatus(200)       //deu certo
    }

    catch(erro){
        console.log(erro.message)
        res.sendStatus(500)
    }
})
 
//remover favoritos
app.delete("/delete-favoritos" , verificarToken , async (req , res)=>{
    let email = req.user.email      //vem do token
    let idComida = req.query.idPrato        //tem que fazer um jeito que pega o id do que o usuário está visualizando (não sei como)
    try{
        if (!idComida) {
            return res.status(400).json({ mensagem: "ID do prato não informado" });
        }
        let idUserSQL = await sql.query`select idUsuario from gustus.usuarios where email=${email}`
        //res.json()
        if (idUserSQL.recordset.length === 0) {
            return res.status(404).json({ mensagem: "Usuário não encontrado" });
        }

        let idUser = idUserSQL.recordset[0].idUsuario

        await sql.query`delete from gustus.favoritos where idUsuario = ${idUser} and idPrato = ${idComida}`
        res.sendStatus(200)       //deu certo
    }

    catch(erro){
        console.log(erro.message)
        res.sendStatus(500)
    }
})

//adicionar na wishlist
app.post("add-wishlist" , verificarToken , async (req , res)=>{
    let email = req.user.email
    let idComida = req.query.idPrato
    try{
        if (!idComida) {
            return res.status(400).json({ mensagem: "ID do prato não informado" });
        }
        let idUserSQL = await sql.query`select idUsuario from gustus.usuarios where email=${email}`
        //res.json()
        if (idUserSQL.recordset.length === 0) {
            return res.status(404).json({ mensagem: "Usuário não encontrado" });
        }

        let idUser = idUserSQL.recordset[0].idUsuario
        await sql.query`insert into gustus.wishlist (idUsuario, idPrato) values (${idUser} , ${idComida})`
        res.sendStatus(200)
    }
    catch(erro){
        console.log(erro.message)
        res.sendStatus(500)
    }
})

//ver a wishlist
app.get("/ver-wishlist" , verificarToken, async (req, res) => {
    let emailUser = req.user.email
    try{
        let idUserSQL = await sql.query`select idUsuario from gustus.usuarios where email=${emailUser}`
        //res.json()
        if (idUserSQL.recordset.length === 0) {
            return res.status(404).json({ mensagem: "Usuário não encontrado" });
        }

        let idUser = idUserSQL.recordset[0].idUsuario
        
        let result = await sql.query`select * from gustus.wishlist where idUsuario = ${idUser}`
        return res.json(result.recordset) 
    }
    catch(erro){
        console.log(erro.message)
        return res.sendStatus(500)      //erro interno
    }
})

//remover da wishlist
app.delete("/delete-wishlist" , verificarToken , async (req , res)=>{
    let email = req.user.email      //vem do token
    let idComida = req.query.idPrato        //tem que fazer um jeito que pega o id do que o usuário está visualizando (não sei como)
    try{
        if (!idComida) {
            return res.status(400).json({ mensagem: "ID do prato não informado" });
        }
        let idUserSQL = await sql.query`select idUsuario from gustus.usuarios where email=${email}`
        //res.json()
        if (idUserSQL.recordset.length === 0) {
            return res.status(404).json({ mensagem: "Usuário não encontrado" });
        }

        let idUser = idUserSQL.recordset[0].idUsuario

        await sql.query`delete from gustus.wishlist where idUsuario = ${idUser} and idPrato = ${idComida}`
        res.sendStatus(200)       //deu certo
    }

    catch(erro){
        console.log(erro.message)
        res.sendStatus(500)
    }
})

//adicionar a degustados
/*
insert into gustus.degustados (idUsuario, idPrato, nota, descricao) values
(1, 2, 5, 'Muito saboroso, bem temperado.');
*/ 
app.post("/add-degustar" , verificarToken , async (req , res)=>{
    let email = req.user.email
    let idComida = req.query.idPrato
    let nota = req.query.nota       //a nota não é obrigatória
    let descricao = req.query.descricao
    try{
        if (!idComida) {
            return res.status(400).json({ mensagem: "ID do prato não informado" });
        }
        let idUserSQL = await sql.query`select idUsuario from gustus.usuarios where email=${email}`
        //res.json()
        if (idUserSQL.recordset.length === 0) {
            return res.status(404).json({ mensagem: "Usuário não encontrado" });
        }

        let idUser = idUserSQL.recordset[0].idUsuario
        await sql.query`insert into gustus.degustados (idUsuario, idPrato, nota, descricao) values (${idUser} , ${idComida}, ${nota}, ${descricao})`
        res.sendStatus(201)
    }
    catch(erro){
        console.log(erro.message)
        res.sendStatus(500)
    }
})

//ver degustados
app.get("/ver-degustar" , verificarToken,  async (req, res) => {
    let emailUser = req.user.email
    try{
        let idUserSQL = await sql.query`select idUsuario from gustus.usuarios where email=${emailUser}`
        //res.json()
        if (idUserSQL.recordset.length === 0) {
            return res.status(404).json({ mensagem: "Usuário não encontrado" });
        }

        let idUser = idUserSQL.recordset[0].idUsuario
        
        let result = await sql.query`select * from gustus.degustados where idUsuario = ${idUser}`
        return res.json(result.recordset) 
    }
    catch(erro){
        console.log(erro.message)
        return res.sendStatus(500)      //erro interno
    }
})

//pesquisar comidas
app.get("/pesquisar", verificarToken, async(req, res)=>{
    let nomeComida = req.query.prato
    try {
        let result = await sql.query`select * from gustus.pratos where prato = ${nomeComida}`
        res.json(result.recordset)
    } 
    catch (error) {
        console.log(erro.message)
        res.sendStatus(500)
    }
})

//adicionar avaliação
app.post("/avaliar" , verificarToken, async(req,res)=>{
    let emailUser = req.user.email
    let comida = req.query.idPrato
    let nota = req.query.nota
    let descricao = req.query.descricao

    try{
        if (!comida) {
            return res.status(400).json({ mensagem: "ID do prato não informado" });
        }
        let idUserSQL = await sql.query`select idUsuario from gustus.usuarios where email=${emailUser}`
        //res.json()
        if (idUserSQL.recordset.length === 0) {
            return res.status(404).json({ mensagem: "Usuário não encontrado" });
        }

        let idUser = idUserSQL.recordset[0].idUsuario

        await sql.query`insert into gustus.degustados (nota, descricao) values(${nota}, ${descricao}) where idUsuario = ${idUser} and idPrato = ${comida} `
        res.sendStatus(200)
    }
    catch(erro){
        console.log(erro.message)
        res.sendStatus(500)
    }
})

//ver receita
app.get("/ver-receita" , async(req, res)=>{

})

app.listen(PORT, () => {
    console.log(`Servidor rodando em http://localhost:${PORT}`);
});
