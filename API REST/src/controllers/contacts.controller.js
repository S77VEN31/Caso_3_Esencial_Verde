import {getConnection, sql} from '../database/connection';
import { queries } from '../database/querys';
import pool from '../database/connection';

export const getContacts = async (req, res) => {    //Con pool
    const [type, quantity] = req.params.parametros.split('_');
    pool.connect((err, connection) => {
      if (err) {
        console.error('Database Connection Failed! Bad Config: ', err);
        return;
      }
      connection
        .request()
        .input('type', sql.VarChar, type)
        .input('quantity', sql.Int, quantity)
        .query(queries.getLast10ContactsByType)
        .then((result) => {
          console.log(result);
          res.json(result.recordset);
          connection.release();
        })
        .catch((err) => {
          console.error('Failed to retrieve data: ', err);
          connection.release();
        });
    });
  };

export const getLast10Contacts = async (req, res) => {  //Sin pool
    const connection = await getConnection();
    const result = await connection.request().query(queries.getLast10Contacts);
    console.log(result);
    connection.close();
    res.json(result.recordset);
};

export const createNewContact = async (req, res) => {  //Sin pool
    const {name, surname1, surname2, email, phone, notes, contactType} = req.body;
    
    if (name == null || surname1 == null || contactType == null) {
        return res.status(400).json({msg: 'Bad Request. Please fill all fields'});
    }

    const connection = await getConnection();

    await connection.request()
    .input('name', sql.VarChar, name)
    .input('surname1', sql.VarChar, surname1)
    .input('surname2', sql.VarChar, surname2)
    .input('email', sql.VarChar, email)
    .input('phone', sql.VarChar, phone)
    .input('notes', sql.VarChar, notes)
    .input('contactType', sql.VarChar, contactType)
    .query(queries.createNewContact);

    const result = await connection.request().query(queries.getLast10Contacts);
    res.json(result.recordset);
    console.log(name, surname1, surname2, email, phone, notes, contactType);
    console.log('New contact created');
    connection.close();
}

