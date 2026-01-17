# Community Shopping Backend API

## Quick Start

### 1. Install Dependencies
```bash
cd backend
npm install
```

### 2. Setup MongoDB
Make sure MongoDB is installed and running:
```bash
# Install MongoDB (macOS)
brew tap mongodb/brew
brew install mongodb-community

# Start MongoDB
brew services start mongodb-community
```

Or use MongoDB Atlas (cloud):
- Go to https://www.mongodb.com/cloud/atlas
- Create free cluster
- Get connection string
- Update MONGODB_URI in .env

### 3. Start Server
```bash
npm run dev
```

Server will run on http://localhost:8080

## API Endpoints

### Authentication
```
POST /api/users/signup
POST /api/users/login
GET  /api/users/:id
```

### Products
```
GET    /api/products
GET    /api/products/:id
POST   /api/products          (Auth required)
PUT    /api/products/:id      (Auth required)
DELETE /api/products/:id      (Auth required)
```

## API Usage Examples

### Signup
```bash
curl -X POST http://localhost:8080/api/users/signup \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john",
    "email": "john@example.com",
    "passwordHash": "password123"
  }'
```

### Login
```bash
curl -X POST http://localhost:8080/api/users/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

### Create Product
```bash
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "category": "laptop",
    "brand": "Dell",
    "model": "XPS 13",
    "name": "Dell XPS 13 Laptop",
    "price": 125000,
    "warranty": 24,
    "customerService": "Excellent",
    "shopName": "Tech Store",
    "shopAddress": "123 Main St",
    "shopTown": "Colombo",
    "shopLatitude": 6.9271,
    "shopLongitude": 79.8612,
    "images": ["https://example.com/image.jpg"]
  }'
```

### Get All Products
```bash
curl http://localhost:8080/api/products
```

### Filter & Sort Products
```bash
# Filter by category
curl http://localhost:8080/api/products?category=laptop

# Filter by price range
curl http://localhost:8080/api/products?minPrice=50000&maxPrice=150000

# Sort by price
curl http://localhost:8080/api/products?sortBy=price

# Sort by warranty
curl http://localhost:8080/api/products?sortBy=warranty

# Combined
curl "http://localhost:8080/api/products?category=laptop&brand=Dell&sortBy=price"
```

## Testing with Flutter App

Update your Flutter model URLs to:
```dart
// lib/models/user.dart
static const String baseUrl = "http://localhost:8080/api/users";

// lib/models/product.dart
static const String baseUrl = "http://localhost:8080/api/products";
```

For Android Emulator:
```dart
static const String baseUrl = "http://10.0.2.2:8080/api/users";
```

## Project Structure
```
backend/
├── config/
│   └── database.js       # MongoDB connection
├── controllers/
│   ├── userController.js      # User logic
│   └── productController.js   # Product logic
├── middleware/
│   └── auth.js           # JWT authentication
├── models/
│   ├── User.js           # User schema
│   └── Product.js        # Product schema
├── routes/
│   ├── users.js          # User routes
│   └── products.js       # Product routes
├── .env                  # Environment variables
├── .gitignore
├── package.json
└── server.js             # Main entry point
```

## Environment Variables
```
PORT=8080
MONGODB_URI=mongodb://localhost:27017/shopping_app
JWT_SECRET=your_secret_key
JWT_EXPIRE=7d
```

## Features
✅ User authentication (signup/login)
✅ JWT token-based auth
✅ Product CRUD operations
✅ Filter by category, brand, price
✅ Sort by price, warranty, newest
✅ Pagination
✅ User ownership validation
✅ Password hashing with bcrypt
✅ MongoDB indexes for performance

## Status
🟢 Backend MVP Complete and Ready!
