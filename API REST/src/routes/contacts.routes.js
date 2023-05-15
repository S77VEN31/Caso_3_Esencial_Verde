import { Router } from 'express';
import { getContacts, createNewContact } from '../controllers/contacts.controller';

const router = Router()


router.get('/contacts/:parametros', getContacts);

router.post('/contacts', createNewContact);

router.get('/contacts/', );

router.delete('/contacts', );

router.put('/contacts', );

router.get('/contacts', );

export default router;