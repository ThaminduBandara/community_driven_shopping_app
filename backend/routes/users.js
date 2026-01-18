const express = require('express');
const router = express.Router();
const { signup, login, getUserProfile, updateProfile } = require('../controllers/userController');

router.post('/signup', signup);
router.post('/login', login);
router.get('/:id', getUserProfile);
router.put('/:id', updateProfile);

module.exports = router;
