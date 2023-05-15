import {getConnection, sql} from '../database/connection';
import { queries } from '../database/querys';

export const getContainers = async (req, res) => {
    const pool = await getConnection();
    const result = await pool.request().query(queries.getAllContainers);
    console.log(result);
    pool.close();
    res.json(result.recordset);
};

export const getContainersByWaste = async (req, res) => {
    const {id} = req.params;
    try{
        const pool = await getConnection()
        const result = await pool.request()
            .input('Id', sql.Int, id)
            .query(queries.getContainersByWaste)
        res.json(result.recordset);
        pool.close();
    } catch (error) {
        res.status(500);
        res.send(error.message);
    }
    
}
