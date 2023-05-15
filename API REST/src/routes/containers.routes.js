import {Router} from 'express';

import {getContainers, getContainersByWaste} from '../controllers/containers.controller';

const router = Router()

router.get('/containers', getContainers);

router.post('/containers', );

router.get('/containers/:id',getContainersByWaste);

router.delete('/containers', );

router.put('/containers', );

router.get('/containers', );

export default router;