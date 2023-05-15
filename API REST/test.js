
const express = require('express');
const sql = require('mssql');

const app = express();

// Configuración de la conexión a la base de datos
const config = {
    user: 'sa',
    password: 'Pablito09',
    server: 'JPABLIX',
    database: 'caso3',
    options: {
        encrypt: true,
        trustServerCertificate: true,
    },
};

// Endpoint para obtener todos los países usando una conexión de pool
app.get('/countries/pool', async (req, res) => {
  try {
    const pool = await new sql.ConnectionPool(config).connect(); // Crear una nueva conexión de pool
    const result = await pool.request().query('SELECT TOP 10 * FROM contacts ORDER BY contactId DESC');
    res.send(result.recordset);
  } catch (error) {
    console.error(error);
    res.status(500).send('Error al obtener los contactos');
  }
});

// Endpoint para obtener todos los países sin usar una conexión de pool
app.get('/countries/nopool', async (req, res) => {
  try {
    const connection = await sql.connect(config); // Crear una nueva conexión sin pool
    const result = await connection.request().query('SELECT TOP 10 * FROM contacts ORDER BY contactId DESC');
    res.send(result.recordset);
  } catch (error) {
    console.error(error);
    res.status(500).send('Error al obtener los contactos');
  }
});

// Iniciar el servidor
app.listen(3000, () => {
  console.log('Servidor iniciado en el puerto 3000');
});
