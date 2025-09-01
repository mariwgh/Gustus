const express = require("express");
const jwt = require("jsonwebtoken");
const { Pool } = require('pg'); // Usando a biblioteca do PostgreSQL
const SECRET_KEY = "loveMyGirlfriend";

const app = express();
const PORT = 3000;

app.use(express.json());

function validarEmail(email) {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email);
}

// Configuração do Pool de conexões do PostgreSQL
const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: {
        rejectUnauthorized: false
    }
});

console.log("Pool de conexões com PostgreSQL configurado ✅");

// Rota de exemplo
app.get("/familiares", async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM familiamari.familia');
        res.json(result.rows);
    } catch (err) {
        console.error(err.message);
        res.status(500).send("Erro ao buscar dados: " + err.message);
    }
});

// Middleware de verificação de token
function verificarToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) return res.sendStatus(401);

    jwt.verify(token, SECRET_KEY, (err, user) => {
        if (err) return res.sendStatus(403);
        req.user = user;
        next();
    });
}

//cadastrar
app.post("/cadastrar", async (req, res) => {
    const { email, senha, user } = req.body;

    if (!validarEmail(email)) {
        return res.status(400).json({ mensagem: "Formato de e-mail inválido." });
    }

    try {
        const emailExisteResult = await pool.query('SELECT * FROM usuarios WHERE email = $1', [email]);

        if (emailExisteResult.rows.length > 0) {
            return res.status(409).json({ mensagem: "E-mail já cadastrado." });
        }

        await pool.query('INSERT INTO usuarios (usuario, email, senha) VALUES ($1, $2, $3)', [user, email, senha]);
        res.status(201).json({ mensagem: "Usuário criado com sucesso." });

    } catch (erro) {
        console.error(erro.message);
        res.status(500).json({ mensagem: "Erro interno no servidor." });
    }
});

//login
app.post("/login", async (req, res) => {
    const { email, senha } = req.body;

    if (!validarEmail(email)) {
        return res.status(400).json({ sucesso: false, mensagem: "Formato de e-mail inválido" });
    }

    try {
        const result = await pool.query('SELECT * FROM usuarios WHERE email = $1', [email]);

        if (result.rows.length > 0) {
            const usuario = result.rows[0];
            if (usuario.senha === senha) {
                const token = jwt.sign({ email: email }, SECRET_KEY, { expiresIn: '1h' });
                return res.status(200).json({ token: token });
            } else {
                return res.status(401).json({ mensagem: "Senha incorreta." });
            }
        } else {
            return res.status(404).json({ mensagem: "Usuário não encontrado." });
        }
    } catch (erro) {
        console.error(erro.message);
        res.status(500).json({ mensagem: "Erro interno no servidor." });
    }
});

// Função auxiliar para obter ID do usuário a partir do email (evita repetição de código)
async function getUserIdByEmail(email) {
    const userResult = await pool.query('SELECT idUsuario FROM usuarios WHERE email = $1', [email]);
    if (userResult.rows.length === 0) {
        return null;
    }
    // Lembre-se que o PostgreSQL geralmente retorna nomes de colunas em minúsculo.
    return userResult.rows[0].idusuario;
}


//ver favoritos
app.get("/ver-favoritos", verificarToken, async (req, res) => {
    try {
        const idUser = await getUserIdByEmail(req.user.email);
        if (!idUser) {
            return res.status(404).json({ mensagem: "Usuário não encontrado" });
        }

        const result = await pool.query('SELECT * FROM favoritos WHERE idUsuario = $1', [idUser]);
        return res.json(result.rows);

    } catch (erro) {
        console.error(erro.message);
        return res.status(500).json({ mensagem: "Erro interno no servidor." });
    }
});

//adicionar favoritos
app.post("/add-favoritos", verificarToken, async (req, res) => {
    const { idPrato } = req.body;
    try {
        if (!idPrato) {
            return res.status(400).json({ mensagem: "ID do prato não informado" });
        }
        const idUser = await getUserIdByEmail(req.user.email);
        if (!idUser) {
            return res.status(404).json({ mensagem: "Usuário não encontrado" });
        }

        await pool.query('INSERT INTO favoritos (idUsuario, idPrato) VALUES ($1, $2)', [idUser, idPrato]);
        res.status(200).json({ mensagem: "Adicionado aos favoritos." });
    } catch (erro) {
        console.error(erro.message);
        res.status(500).json({ mensagem: "Erro interno no servidor." });
    }
});

//remover favoritos
app.delete("/delete-favoritos", verificarToken, async (req, res) => {
    const { idPrato } = req.body;
    try {
        if (!idPrato) {
            return res.status(400).json({ mensagem: "ID do prato não informado" });
        }
        const idUser = await getUserIdByEmail(req.user.email);
        if (!idUser) {
            return res.status(404).json({ mensagem: "Usuário não encontrado" });
        }

        await pool.query('DELETE FROM favoritos WHERE idUsuario = $1 AND idPrato = $2', [idUser, idPrato]);
        res.status(200).json({ mensagem: "Removido dos favoritos." });
    } catch (erro) {
        console.error(erro.message);
        res.status(500).json({ mensagem: "Erro interno no servidor." });
    }
});

//adicionar na wishlist
app.post("/add-wishlist", verificarToken, async (req, res) => {
    const { idPrato } = req.body;
    try {
        if (!idPrato) {
            return res.status(400).json({ mensagem: "ID do prato não informado" });
        }
        const idUser = await getUserIdByEmail(req.user.email);
        if (!idUser) {
            return res.status(404).json({ mensagem: "Usuário não encontrado" });
        }

        await pool.query('INSERT INTO wishlist (idUsuario, idPrato) VALUES ($1, $2)', [idUser, idPrato]);
        res.status(200).json({ mensagem: "Adicionado à wishlist." });
    } catch (erro) {
        console.error(erro.message);
        res.status(500).json({ mensagem: "Erro interno no servidor." });
    }
});

//ver a wishlist
app.get("/ver-wishlist", verificarToken, async (req, res) => {
    try {
        const idUser = await getUserIdByEmail(req.user.email);
        if (!idUser) {
            return res.status(404).json({ mensagem: "Usuário não encontrado" });
        }

        const result = await pool.query('SELECT * FROM wishlist WHERE idUsuario = $1', [idUser]);
        return res.json(result.rows);
    } catch (erro) {
        console.error(erro.message);
        return res.status(500).json({ mensagem: "Erro interno no servidor." });
    }
});

//remover da wishlist
app.delete("/delete-wishlist", verificarToken, async (req, res) => {
    const { idPrato } = req.body;
    try {
        if (!idPrato) {
            return res.status(400).json({ mensagem: "ID do prato não informado" });
        }
        const idUser = await getUserIdByEmail(req.user.email);
        if (!idUser) {
            return res.status(404).json({ mensagem: "Usuário não encontrado" });
        }

        await pool.query('DELETE FROM wishlist WHERE idUsuario = $1 AND idPrato = $2', [idUser, idPrato]);
        res.status(200).json({ mensagem: "Removido da wishlist." });
    } catch (erro) {
        console.error(erro.message);
        res.status(500).json({ mensagem: "Erro interno no servidor." });
    }
});

//adicionar a degustados
app.post("/add-degustar", verificarToken, async (req, res) => {
    const { idPrato, nota, descricao } = req.body;
    try {
        if (!idPrato) {
            return res.status(400).json({ mensagem: "ID do prato não informado" });
        }
        const idUser = await getUserIdByEmail(req.user.email);
        if (!idUser) {
            return res.status(404).json({ mensagem: "Usuário não encontrado" });
        }

        await pool.query('INSERT INTO degustados (idUsuario, idPrato, nota, descricao) VALUES ($1, $2, $3, $4)', [idUser, idPrato, nota, descricao]);
        res.status(201).json({ mensagem: "Prato degustado adicionado." });
    } catch (erro) {
        console.error(erro.message);
        res.status(500).json({ mensagem: "Erro interno no servidor." });
    }
});

//ver degustados
app.get("/ver-degustar", verificarToken, async (req, res) => {
    try {
        const idUser = await getUserIdByEmail(req.user.email);
        if (!idUser) {
            return res.status(404).json({ mensagem: "Usuário não encontrado" });
        }

        const result = await pool.query('SELECT * FROM degustados WHERE idUsuario = $1', [idUser]);
        return res.json(result.rows);
    } catch (erro) {
        console.error(erro.message);
        return res.status(500).json({ mensagem: "Erro interno no servidor." });
    }
});

//pesquisar comidas
app.get("/pesquisar", verificarToken, async (req, res) => {
    const { prato } = req.query;
    try {
        const result = await pool.query('SELECT * FROM pratos WHERE prato ILIKE $1', [`%${prato}%`]);
        res.json(result.rows);
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ mensagem: "Erro interno no servidor." });
    }
});

//adicionar/atualizar avaliação
app.post("/avaliar", verificarToken, async (req, res) => {
    const { idPrato, nota, descricao } = req.body;
    try {
        if (!idPrato) {
            return res.status(400).json({ mensagem: "ID do prato não informado" });
        }
        const idUser = await getUserIdByEmail(req.user.email);
        if (!idUser) {
            return res.status(404).json({ mensagem: "Usuário não encontrado" });
        }

        await pool.query('UPDATE degustados SET nota = $1, descricao = $2 WHERE idUsuario = $3 AND idPrato = $4', [nota, descricao, idUser, idPrato]);
        res.status(200).json({ mensagem: "Avaliação atualizada com sucesso." });
    } catch (erro) {
        console.error(erro.message);
        res.status(500).json({ mensagem: "Erro interno no servidor." });
    }
});

//ver receita
app.get("/ver-receita", async (req, res) => {
    const { comida } = req.query;
    try {
        if (!comida) {
            return res.status(400).json({ mensagem: "Nome da comida não informado" });
        }
        const result = await pool.query('SELECT linkReceita FROM pratos WHERE prato = $1', [comida]);
        res.json(result.rows);
    }
    catch (erro) {
        console.error(erro.message);
        res.status(500).json({ mensagem: "Erro interno no servidor." });
    }
});

app.get("/usuarios", async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM usuarios');
        res.json(result.rows);
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ mensagem: "Erro interno no servidor." });
    }
})

app.listen(PORT, () => {
    console.log(`Servidor rodando em http://localhost:${PORT}`);
});