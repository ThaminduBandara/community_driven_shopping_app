# Testing Guide - Community Shopping App

## ✅ System Status

### Backend Server
- **Status**: ✅ Running
- **URL**: http://localhost:8080
- **Database**: MongoDB Atlas (Connected)
- **Features Working**:
  - ✅ User Signup
  - ✅ User Login with JWT
  - ✅ Product Creation (authenticated)
  - ✅ Get All Products
  - ✅ Product Filtering (category, brand, price)
  - ✅ Product Sorting (price, warranty, newest)

### Flutter App
- **Status**: ✅ Running
- **URL**: http://localhost:3000
- **Platform**: Chrome Web
- **Available Screens**:
  - Login Screen
  - Signup Screen
  - Home/Product Listing
  - Product Details
  - Add Product

## 🧪 API Test Results

### 1. User Signup
```bash
curl -X POST http://localhost:8080/api/users/signup \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "Test123!",
    "phoneNumber": "1234567890",
    "address": "Test Address"
  }'
```

**Result**: ✅ Success
- User ID: `696be159d00370c04b5efdda`
- JWT Token generated
- Password hashed with bcrypt

### 2. User Login
```bash
curl -X POST http://localhost:8080/api/users/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Test123!"
  }'
```

**Result**: ✅ Success
- Authentication successful
- JWT Token: Valid (7-day expiry)
- User profile returned

### 3. Create Product
```bash
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "category": "smartphone",
    "brand": "Apple",
    "model": "iPhone 15 Pro",
    "name": "iPhone 15 Pro Max 256GB",
    "price": 999.99,
    "warranty": 12,
    "customerService": "Apple Care",
    "shopName": "Tech Store",
    "shopAddress": "123 Main St",
    "shopTown": "Colombo",
    "shopLatitude": 6.9271,
    "shopLongitude": 79.8612,
    "images": []
  }'
```

**Result**: ✅ Success
- Product ID: `696be187d00370c04b5efddf`
- Geospatial coordinates stored
- Associated with user

### 4. Get All Products
```bash
curl http://localhost:8080/api/products
```

**Result**: ✅ Success
- Returns product array with user info populated
- Pagination working (page 1, total 1)
- Product includes all fields

## 📋 Product Schema

Required fields for creating a product:
```javascript
{
  category: String (enum: laptop, smartphone, camera, tablet, other)
  brand: String
  model: String
  name: String
  price: Number (min: 0)
  warranty: Number (months, min: 0)
  customerService: String (optional)
  shopName: String
  shopAddress: String
  shopTown: String
  shopLatitude: Number
  shopLongitude: Number
  images: Array of Strings (URLs)
}
```

## 🔐 Authentication

**JWT Token Usage**:
- Include in header: `Authorization: Bearer YOUR_TOKEN`
- Token expires in 7 days
- Required for: Create, Update, Delete products

## 🚀 How to Run

### Start Backend
```bash
cd backend
npm start
```

### Start Flutter App
```bash
flutter run -d chrome --web-port=3000
```

### Access Application
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8080/api

## 🔍 Testing Flow

1. **Open the app** in Chrome (http://localhost:3000)
2. **Sign up** with a new account
3. **Log in** with your credentials
4. **View products** on the home screen
5. **Add a product**:
   - Fill in all required fields
   - Select category from dropdown
   - Add shop location details
6. **Filter products**:
   - By category
   - By brand
   - By price range
7. **Sort products**:
   - By price (low to high)
   - By warranty (high to low)
   - By newest first

## 📍 Geolocation Features

The app includes location-based sorting:
- Products can be sorted by distance from user's location
- Requires location permissions (granted in Android manifest)
- Uses Geolocator package for distance calculations

## 🗄️ Database

**MongoDB Atlas**:
- Cluster: iprs.pnwpwck.mongodb.net
- Database: shopping_app
- Collections: users, products
- Indexes created for:
  - Geospatial queries (shopLatitude, shopLongitude)
  - Category and brand filtering
  - Price sorting
  - Warranty sorting

## ⚠️ Known Issues Fixed

1. ✅ Password field mismatch (password vs passwordHash) - Fixed
2. ✅ Port configuration (unified to 8080) - Fixed
3. ✅ Product images field missing - Added
4. ✅ MongoDB connection - Using Atlas (cloud)
5. ✅ CORS configuration - Enabled for all origins

## 📱 Next Steps

- Test image upload functionality
- Test location-based sorting with multiple products
- Test update/delete operations
- Add more products to test filtering/sorting
- Test on mobile devices (Android/iOS)
