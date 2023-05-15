import express from 'express'; 
import config from './config';

import containersRoutes from './routes/containers.routes';
import contactsRoutes from './routes/contacts.routes';

const app = express();

// settings
app.set('port', config.port);


//middlewares
app.use(express.json());
app.use(express.urlencoded({extended: false}));

// routes
app.use(containersRoutes);
app.use(contactsRoutes);

export default app;