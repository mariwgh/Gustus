const express = require("express");
const sql = require("mssql");
const jwt = require("jsonwebtoken");        //isso será usado para manter o login feito
const SECRET_KEY = "loveMyGirlfriend";      //essa "senha" será usada para ??? mas é necessária


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
app.get("/ver-favoritos" , async (req, res) => {
    
})

//adicionar favoritos
app.post("/favoritar" , verificarToken , async (req , res)=>{
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
//adicionar na wishlist
//ver a wishlist
//remover da wishlist
//adicionar a degustados
//ver degustados
//pesquisar comidas
//adicionar avaliação

//ver receita

app.listen(PORT, () => {
    console.log(`Servidor rodando em http://localhost:${PORT}`);
});
