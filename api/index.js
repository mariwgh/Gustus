const express = require("express");
const sql = require("mssql");

const app = express();
const PORT = 3000;

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
        const result = await sql.query`select * from familiamari.familia`;
        res.json(result.recordset); // Retorna os dados em JSON
    } catch (err) {
        res.status(500).send("Erro ao buscar clientes: " + err);
    }
});

app.post("/cadastrar" , async (req, res) => {
    try{

    }
    catch(erro){
        
    }
})

//login
app.post("/login" , async (req, res)=> {

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
