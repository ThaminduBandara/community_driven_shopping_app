# Community Driven Shopping App

A full-stack Flutter & Node.js application that enables community-driven product discovery with location-based search, reviews, and ratings.

## 🎯 Features

### Core Features
- ✅ **User Authentication** - Secure JWT-based login/signup with password validation
- ✅ **Product Listings** - Browse products with detailed information and images
- ✅ **Location-Based Search** - Find products near you using GPS coordinates
- ✅ **Reviews & Ratings** - Rate and review products with detailed comments
- ✅ **Advanced Filtering** - Search by category, brand, model, town, price, and warranty
- ✅ **Image Gallery** - View product images with loading indicators and galleries
- ✅ **Sorting Options** - Sort by price, warranty, and distance

### Robustness Features
- ✅ **Input Validation** - Comprehensive frontend and backend validation
- ✅ **Error Handling** - Global error handlers with user-friendly messages
- ✅ **Automatic Retry** - Network requests retry 3 times with exponential backoff
- ✅ **Timeout Protection** - 30-second request timeout to prevent hangs
- ✅ **Error Boundaries** - Flutter error catching with recovery UI
- ✅ **Network Error Dialogs** - Clear error messages with retry options

## 🛠 Tech Stack

### Frontend
- **Framework**: Flutter 3.x
- **State Management**: Provider
- **HTTP Client**: Custom ApiClient with retry logic
- **Location**: Geolocator 11.0.0
- **Storage**: shared_preferences

### Backend
- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB Atlas (Cloud)
- **Authentication**: JWT (jsonwebtoken)
- **Password Security**: bcrypt

## 📁 Project Structure

```
community_driven_shopping_app/
├── lib/                          # Flutter frontend
│   ├── models/                   # Data models
│   │   ├── product.dart
│   │   ├── review.dart
│   │   ├── user.dart
│   │   └── product_image.dart
│   ├── providers/                # State management
│   │   ├── auth_provider.dart
│   │   └── product_provider.dart
│   ├── screens/                  # UI screens
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── signup_screen.dart
│   │   └── home/
│   │       ├── home_screen.dart
│   │       └── product_detail_screen.dart
│   ├── services/                 # Business logic
│   │   └── product_service.dart
│   ├── utils/                    # Utilities
│   │   ├── api_client.dart       # HTTP client with retry
│   │   └── validators.dart       # Input validation
│   ├── widgets/                  # Reusable widgets
│   │   ├── error_boundary.dart
│   │   └── network_error_dialog.dart
│   └── main.dart
├── backend/                      # Node.js backend
│   ├── controllers/              # Request handlers
│   │   ├── userController.js
│   │   └── productController.js
│   ├── middleware/               # Middleware
│   │   ├── auth.js               # JWT auth
│   │   └── errorHandler.js       # Global error handler
│   ├── models/                   # Database models
│   │   ├── User.js
│   │   └── Product.js
│   ├── routes/                   # API routes
│   │   ├── users.js
│   │   └── products.js
│   ├── config/
│   │   └── database.js
│   ├── server.js                 # Express app setup
│   ├── package.json
│   └── test-robustness.sh        # Validation tests
├── ROBUSTNESS_IMPROVEMENTS.md    # Detailed robustness docs
├── pubspec.yaml                  # Flutter dependencies
└── README.md
```

## 🚀 Getting Started

### Backend Setup

1. **Navigate to backend directory:**
   ```bash
   cd backend
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Create `.env` file:**
   ```env
   MONGODB_URI=your_mongodb_atlas_uri
   JWT_SECRET=your_jwt_secret_key
   PORT=8080
   ```

4. **Start the server:**
   ```bash
   npm start
   ```

   Server will run on `http://localhost:8080`

### Frontend Setup

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Run the app:**
   ```bash
   flutter run -d chrome  # For web
   flutter run -d android # For Android
   flutter run -d ios     # For iOS
   ```

## 🧪 Testing Robustness

### Run Backend Validation Tests

```bash
cd backend
./test-robustness.sh
```

This will test:
- ✓ User signup validation
- ✓ Product category validation
- ✓ Price validation
- ✓ Product name length validation
- ✓ Geolocation coordinate validation
- ✓ Authentication error handling

### Test Invalid Requests

```bash
# Test missing category
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{"category":"", ...}'

# Response includes specific validation errors
{
  "message": "Validation failed",
  "errors": ["Category is required"]
}
```

## 📱 API Endpoints

### Users
- `POST /api/users/signup` - Create new user
- `POST /api/users/login` - Login user
- `GET /api/users/profile` - Get user profile (auth required)

### Products
- `GET /api/products` - List all products (with filtering/sorting)
- `GET /api/products/:id` - Get product details
- `POST /api/products` - Create product (auth required)
- `PUT /api/products/:id` - Update product (auth required)
- `DELETE /api/products/:id` - Delete product (auth required)
- `POST /api/products/:id/reviews` - Add review (auth required)
- `GET /api/products/:id/reviews` - Get reviews

## 🔍 Input Validation

### Frontend Validators
- Email format validation
- Password strength (min 6 chars, uppercase, number)
- Username (3-30 chars, alphanumeric + _ -)
- Product name (3-200 chars)
- Price (positive, max 100M)
- Warranty (0-120 months)
- Geolocation (lat -90/90, lon -180/180)

### Backend Validation
All inputs validated on server with detailed error messages:
- Required field checks
- Length constraints
- Type validation
- Range validation
- Format validation

## 🌍 Location Features

### User Location
- Automatic location permission request on app startup
- GPS coordinates stored and used for distance calculation
- Haversine formula for accurate distance calculation

### Distance Sorting
- "Nearest" sort option shows products closest to user
- Distance calculated in kilometers
- Disabled when location unavailable

### Town Filtering
- Filter products by shop location town
- Case-insensitive search
- Combined with other filters

## 📸 Image Handling

- Multiple images per product (up to 10)
- Image count badge on product cards
- Full-screen image gallery with PageView
- Loading indicators and error fallbacks
- Optimized for mobile viewing

## 🔐 Security Features

- JWT token-based authentication
- Password hashing with bcrypt
- Token expiration (7 days)
- Protected API routes
- Input sanitization and validation
- CORS enabled for secure requests

## ⚠️ Error Handling

### Network Errors
- Automatic retry (3 attempts)
- Exponential backoff (2-second delays)
- User-friendly error messages
- Retry dialogs with clear CTAs

### Validation Errors
- Field-specific error messages
- Client-side validation
- Server-side validation
- Detailed error arrays in responses

### Server Errors
- Global error handler middleware
- Mongoose validation errors
- Duplicate key errors with field identification
- JWT error handling
- 404 and 5xx error responses

## 📊 Performance Features

- Image lazy loading with loading indicators
- Pagination for product lists
- Location-based query optimization
- Efficient sorting algorithms
- Request timeout protection (30s)
- Request size limits (10MB)

## 🎨 UI/UX Features

- Glassmorphism design throughout
- Dark theme (primary: #1a1a2e, accent: #00D4FF)
- Responsive layout
- Loading states and spinners
- Error boundaries with recovery
- Smooth transitions and animations
- Accessible color contrast ratios

## 📚 Documentation

- [Robustness Improvements](./ROBUSTNESS_IMPROVEMENTS.md) - Detailed validation and error handling
- [Implementation Guide](./IMPLEMENTATION.md) - Setup and deployment
- [Testing Guide](./TESTING_GUIDE.md) - Test procedures
- [Quick Start](./QUICKSTART.md) - Quick setup guide

## 🐛 Troubleshooting

### Backend Connection Issues
```bash
# Check if MongoDB is connected
curl http://localhost:8080/

# Response should be: {"message":"Community Shopping API is running"}
```

### Flutter Build Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Authentication Errors
- Ensure token is passed in Authorization header
- Check token hasn't expired (valid for 7 days)
- Verify JWT_SECRET in backend .env matches

## 🤝 Contributing

To add new features:
1. Create feature branch
2. Add validation rules for new fields
3. Test with validation test script
4. Update error handler if needed
5. Document new API endpoints

## 📝 License

This project is developed for educational purposes.

## 👨‍💻 Developer

Built with Flutter & Node.js by Thaminda Bandara

