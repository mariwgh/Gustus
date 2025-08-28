const express = require("express");
const sql = require("mssql");

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
