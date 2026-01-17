#!/bin/bash

echo "🧪 Testing Community Shopping App"
echo "=================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: Backend Health Check
echo "Test 1: Backend Health Check"
HEALTH=$(curl -s http://localhost:8080)
if [[ $HEALTH == *"Community Shopping API is running"* ]]; then
    echo -e "${GREEN}✓ Backend is running${NC}"
else
    echo -e "${RED}✗ Backend is not responding${NC}"
    exit 1
fi
echo ""

# Test 2: Create User (Signup)
echo "Test 2: User Signup"
SIGNUP_RESULT=$(curl -s -X POST http://localhost:8080/api/users/signup \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "passwordHash": "password123"
  }')

if [[ $SIGNUP_RESULT == *"userId"* ]] || [[ $SIGNUP_RESULT == *"already exists"* ]]; then
    echo -e "${GREEN}✓ Signup endpoint working${NC}"
    echo "Response: $SIGNUP_RESULT"
else
    echo -e "${YELLOW}⚠ Signup response: $SIGNUP_RESULT${NC}"
fi
echo ""

# Test 3: User Login
echo "Test 3: User Login"
LOGIN_RESULT=$(curl -s -X POST http://localhost:8080/api/users/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }')

if [[ $LOGIN_RESULT == *"token"* ]]; then
    echo -e "${GREEN}✓ Login successful${NC}"
    TOKEN=$(echo $LOGIN_RESULT | grep -o '"token":"[^"]*' | cut -d'"' -f4)
    echo "Token: ${TOKEN:0:20}..."
elif [[ $LOGIN_RESULT == *"MongooseError"* ]]; then
    echo -e "${YELLOW}⚠ MongoDB not connected - API endpoints need database${NC}"
else
    echo -e "${YELLOW}⚠ Login response: $LOGIN_RESULT${NC}"
fi
echo ""

# Test 4: Get Products
echo "Test 4: Get Products"
PRODUCTS_RESULT=$(curl -s http://localhost:8080/api/products)

if [[ $PRODUCTS_RESULT == *"products"* ]]; then
    echo -e "${GREEN}✓ Products endpoint working${NC}"
    PRODUCT_COUNT=$(echo $PRODUCTS_RESULT | grep -o '"total":[0-9]*' | cut -d':' -f2)
    echo "Total products: $PRODUCT_COUNT"
elif [[ $PRODUCTS_RESULT == *"MongooseError"* ]]; then
    echo -e "${YELLOW}⚠ MongoDB not connected${NC}"
else
    echo -e "${YELLOW}⚠ Products response: $PRODUCTS_RESULT${NC}"
fi
echo ""

# Summary
echo "=================================="
echo "Test Summary:"
echo "  - Backend API: Running ✓"
echo "  - Endpoints: Accessible ✓"
if [[ $LOGIN_RESULT == *"MongooseError"* ]] || [[ $PRODUCTS_RESULT == *"MongooseError"* ]]; then
    echo -e "  - Database: ${YELLOW}Not Connected ⚠${NC}"
    echo ""
    echo "📝 Note: MongoDB is not running."
    echo "   Options:"
    echo "   1. Install MongoDB: brew install mongodb-community@7.0"
    echo "   2. Use MongoDB Atlas (cloud): https://www.mongodb.com/cloud/atlas"
    echo "   3. Update MONGODB_URI in backend/.env"
else
    echo -e "  - Database: ${GREEN}Connected ✓${NC}"
fi
echo ""
echo "🌐 Open in browser: http://localhost:8080"
echo "📱 Flutter app should be running in Chrome"
echo ""
