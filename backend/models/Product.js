const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  productId: {
    type: String,
    unique: true,
  },
  category: {
    type: String,
    required: true,
    enum: ['laptop', 'smartphone', 'camera', 'tablet', 'other'],
  },
  brand: {
    type: String,
    required: true,
  },
  model: {
    type: String,
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  price: {
    type: Number,
    required: true,
    min: 0,
  },
  warranty: {
    type: Number,
    required: true,
    min: 0,
  },
  customerService: {
    type: String,
  },
  addedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  shopName: {
    type: String,
    required: true,
  },
  shopAddress: {
    type: String,
    required: true,
  },
  shopTown: {
    type: String,
    required: true,
  },
  shopLatitude: {
    type: Number,
    required: true,
  },
  shopLongitude: {
    type: Number,
    required: true,
  },
  images: [{
    type: String,
  }],
  reviews: [{
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    username: {
      type: String,
      required: true,
    },
    rating: {
      type: Number,
      required: true,
      min: 1,
      max: 5,
    },
    comment: {
      type: String,
      required: true,
    },
    serviceRating: {
      type: Number,
      min: 1,
      max: 5,
    },
    createdAt: {
      type: Date,
      default: Date.now,
    },
  }],
  averageRating: {
    type: Number,
    default: 0,
    min: 0,
    max: 5,
  },
  reviewCount: {
    type: Number,
    default: 0,
    min: 0,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
});

// Create index for geospatial queries
productSchema.index({ shopLatitude: 1, shopLongitude: 1 });
productSchema.index({ category: 1, brand: 1 });
productSchema.index({ price: 1 });
productSchema.index({ warranty: -1 });

// Auto-generate productId
productSchema.pre('save', function (next) {
  if (!this.productId) {
    this.productId = this._id.toString();
  }
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model('Product', productSchema);
