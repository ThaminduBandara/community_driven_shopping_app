const express = require('express');
const router = express.Router();
const {
  getAllProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
  addReview,
  getReviews,
} = require('../controllers/productController');
const { protect } = require('../middleware/auth');

router.route('/')
  .get(getAllProducts)
  .post(protect, createProduct);

router.route('/:id')
  .get(getProductById)
  .put(protect, updateProduct)
  .delete(protect, deleteProduct);

router.route('/:id/reviews')
  .get(getReviews)
  .post(protect, addReview);

module.exports = router;
