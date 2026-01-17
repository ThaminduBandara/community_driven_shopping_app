const Product = require('../models/Product');

// Helper function to calculate distance between two coordinates (Haversine formula)
const calculateDistance = (lat1, lon1, lat2, lon2) => {
  const R = 6371; // Radius of the Earth in km
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a = 
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c; // Distance in km
};

// @desc    Get all products
// @route   GET /api/products
// @access  Public
const getAllProducts = async (req, res) => {
  try {
    const {
      category,
      brand,
      model,
      town,
      minPrice,
      maxPrice,
      minWarranty,
      sortBy,
      userLat,
      userLon,
      maxDistance,
      page = 1,
      limit = 20,
    } = req.query;

    // Build query
    const query = {};
    if (category) query.category = category;
    if (brand) query.brand = new RegExp(brand, 'i');
    if (model) query.model = new RegExp(model, 'i');
    if (town) query.shopTown = new RegExp(town, 'i');
    if (minPrice || maxPrice) {
      query.price = {};
      if (minPrice) query.price.$gte = Number(minPrice);
      if (maxPrice) query.price.$lte = Number(maxPrice);
    }
    if (minWarranty) query.warranty = { $gte: Number(minWarranty) };

    // Fetch products
    let products = await Product.find(query)
      .populate('addedBy', 'username email')
      .limit(limit * 1)
      .skip((page - 1) * limit);

    // If user location provided, calculate distances and filter by maxDistance
    if (userLat && userLon) {
      const lat = Number(userLat);
      const lon = Number(userLon);
      
      products = products.map(product => {
        const distance = calculateDistance(lat, lon, product.shopLatitude, product.shopLongitude);
        return {
          ...product.toObject(),
          distance: distance.toFixed(2)
        };
      });

      // Filter by max distance if provided
      if (maxDistance) {
        products = products.filter(p => Number(p.distance) <= Number(maxDistance));
      }

      // Sort by distance if requested
      if (sortBy === 'nearest') {
        products.sort((a, b) => Number(a.distance) - Number(b.distance));
      }
    }

    // Build sort for non-distance sorting
    if (sortBy && sortBy !== 'nearest') {
      let sort = {};
      switch (sortBy) {
        case 'price':
          products.sort((a, b) => a.price - b.price);
          break;
        case 'warranty':
          products.sort((a, b) => b.warranty - a.warranty);
          break;
        case 'newest':
          products.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
          break;
        default:
          products.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
      }
    } else if (!sortBy && !userLat) {
      // Default sort by newest if no sorting specified
      products.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
    }

    const count = await Product.countDocuments(query);

    res.json({
      products,
      totalPages: Math.ceil(count / limit),
      currentPage: page,
      total: count,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// @desc    Get single product
// @route   GET /api/products/:id
// @access  Public
const getProductById = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id).populate('addedBy', 'username email');

    if (product) {
      res.json(product);
    } else {
      res.status(404).json({ message: 'Product not found' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// @desc    Create new product
// @route   POST /api/products
// @access  Private
const createProduct = async (req, res) => {
  try {
    const {
      category,
      brand,
      model,
      name,
      price,
      warranty,
      customerService,
      shopName,
      shopAddress,
      shopTown,
      shopLatitude,
      shopLongitude,
      images,
    } = req.body;

    // Validation
    if (!category || !brand || !model || !name || !price || !warranty || !shopName || !shopAddress || !shopTown || shopLatitude === undefined || shopLongitude === undefined) {
      return res.status(400).json({ message: 'Please provide all required fields' });
    }

    const product = await Product.create({
      category,
      brand,
      model,
      name,
      price,
      warranty,
      customerService: customerService || '',
      addedBy: req.user._id,
      shopName,
      shopAddress,
      shopTown,
      shopLatitude,
      shopLongitude,
      images: images || [],
    });

    res.status(201).json(product);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// @desc    Update product
// @route   PUT /api/products/:id
// @access  Private
const updateProduct = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);

    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }

    // Check if user owns the product
    if (product.addedBy.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: 'Not authorized to update this product' });
    }

    const updatedProduct = await Product.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    );

    res.json(updatedProduct);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// @desc    Delete product
// @route   DELETE /api/products/:id
// @access  Private
const deleteProduct = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);

    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }

    // Check if user owns the product
    if (product.addedBy.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: 'Not authorized to delete this product' });
    }

    await product.deleteOne();

    res.json({ message: 'Product removed' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// @desc    Add review to product
// @route   POST /api/products/:id/reviews
// @access  Private
const addReview = async (req, res) => {
  try {
    const { rating, comment, serviceRating } = req.body;

    // Validation
    if (!rating || !comment) {
      return res.status(400).json({ message: 'Please provide rating and comment' });
    }

    if (rating < 1 || rating > 5) {
      return res.status(400).json({ message: 'Rating must be between 1 and 5' });
    }

    const product = await Product.findById(req.params.id);

    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }

    // Check if user already reviewed
    const alreadyReviewed = product.reviews.find(
      (review) => review.userId.toString() === req.user._id.toString()
    );

    if (alreadyReviewed) {
      return res.status(400).json({ message: 'You have already reviewed this product' });
    }

    // Add review
    const review = {
      userId: req.user._id,
      username: req.user.username,
      rating: Number(rating),
      comment,
      serviceRating: serviceRating ? Number(serviceRating) : undefined,
      createdAt: Date.now(),
    };

    product.reviews.push(review);
    product.reviewCount = product.reviews.length;
    product.averageRating = 
      product.reviews.reduce((acc, item) => item.rating + acc, 0) / product.reviews.length;

    await product.save();

    res.status(201).json({ message: 'Review added', product });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// @desc    Get reviews for a product
// @route   GET /api/products/:id/reviews
// @access  Public
const getReviews = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id).select('reviews averageRating reviewCount');

    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }

    res.json({
      reviews: product.reviews,
      averageRating: product.averageRating,
      reviewCount: product.reviewCount,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

module.exports = {
  getAllProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
  addReview,
  getReviews,
};
