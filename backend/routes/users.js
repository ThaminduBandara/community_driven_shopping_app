const express = require('express');
const router = express.Router();
const { signup, login, getUserProfile } = require('../controllers/userController');

router.post('/signup', signup);
router.post('/login', login);
router.get('/:id', getUserProfile);

module.exports = router;
