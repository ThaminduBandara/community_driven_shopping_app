# Quick Start Guide

## 🚀 Running the App

### Option 1: With Backend (Recommended)
1. Start your backend servers:
   - Users API: `http://localhost:9090/api/users`
   - Products API: `http://localhost:8080/api/products`

2. Run the Flutter app:
   ```bash
   cd community_driven_shopping_app
   flutter run
   ```

### Option 2: Testing UI Only (Without Backend)
The app will show errors when calling APIs, but you can still test the UI flow.

## 📲 Test Flow

1. **Launch App** → Login Screen appears
2. **Click "Sign Up"** → Create an account
3. **Login** with your credentials
4. **Home Screen** → See product list (if backend has data)
5. **Click Filter Icon** → Try different sorting options
6. **Click Product** → View details
7. **Click "+"** → Add a new product

## 🔧 Configuration

### Update API URLs
If your backend is not on localhost, update these files:

**lib/models/user.dart:**
```dart
static const String baseUrl = "http://YOUR_IP:9090/api/users";
```

**lib/models/product.dart:**
```dart
static const String baseUrl = "http://YOUR_IP:8080/api/products";
```

### For Android Emulator
Use `10.0.2.2` instead of `localhost`:
```dart
static const String baseUrl = "http://10.0.2.2:9090/api/users";
```

### For iOS Simulator
Use your computer's IP address:
```dart
static const String baseUrl = "http://192.168.1.xxx:9090/api/users";
```

## 🎨 Features to Try

✅ **Login/Signup** - Full authentication flow
✅ **View Products** - See all products from backend  
✅ **Filter Products** - By type (laptop, smartphone, etc.)
✅ **Sort Products** - By price, warranty, or distance
✅ **Add Product** - Create new product listing
✅ **View Details** - See full product information

## 📝 Sample Test Data

### Test User
```json
{
  "username": "testuser",
  "email": "test@example.com",
  "password": "test123"
}
```

### Test Product
```
Product Name: Dell XPS 13
Category: laptop
Brand: Dell
Model: XPS 13
Price: 125000
Warranty: 24 months
Shop Name: Tech Store Colombo
Address: 123 Main St, Colombo
Town: Colombo
Latitude: 6.9271
Longitude: 79.8612
```

## 🐛 Troubleshooting

### Can't connect to backend
- Check if backend servers are running
- Update API URLs to use correct IP
- Check firewall settings
- For emulator, use `10.0.2.2` instead of `localhost`

### Dependencies errors
```bash
flutter pub get
flutter clean
flutter pub get
```

### Build errors
```bash
flutter clean
flutter pub get
flutter run
```

## 📱 Next Development Tasks

1. **Connect Real Backend** - Update API URLs
2. **Test All CRUD Operations** - Add, view, update, delete products
3. **Add Image Upload** - Integrate with Cloudinary/Firebase
4. **Add Location Services** - Get user's current location
5. **Add Reviews** - Implement rating system

---

**Need Help?** Check [IMPLEMENTATION.md](IMPLEMENTATION.md) for detailed documentation.
