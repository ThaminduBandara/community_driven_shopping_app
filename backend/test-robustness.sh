#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

API_URL="http://localhost:8080/api"
USER_TOKEN=""

echo -e "${BLUE}=== Community Shopping App API Tests ===${NC}\n"

# Test 1: User Signup with Validation
echo -e "${YELLOW}Test 1: User Signup${NC}"
SIGNUP_RESPONSE=$(curl -s -X POST "$API_URL/users/signup" \
  -H "Content-Type: application/json" \
  -d '{
    "username":"'$(date +%s%N | md5sum | cut -c1-8)'",
    "email":"test_'$(date +%s%N)'@example.com",
    "password":"TestPass@123"
  }')

USER_TOKEN=$(echo $SIGNUP_RESPONSE | jq -r '.token' 2>/dev/null)
if [ "$USER_TOKEN" != "null" ] && [ ! -z "$USER_TOKEN" ]; then
  echo -e "${GREEN}✓ Signup successful${NC}"
  echo "Token: ${USER_TOKEN:0:50}..."
else
  echo -e "${RED}✗ Signup failed${NC}"
  echo "$SIGNUP_RESPONSE" | jq .
  exit 1
fi

echo -e "\n"

# Test 2: Product Validation - Empty Category
echo -e "${YELLOW}Test 2: Product Validation - Missing Category${NC}"
VALIDATION_RESPONSE=$(curl -s -X POST "$API_URL/products" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $USER_TOKEN" \
  -d '{
    "category":"",
    "brand":"TestBrand",
    "model":"Model-X",
    "name":"ValidProductName",
    "price":"9999",
    "warranty":12,
    "shopName":"Test Shop",
    "shopAddress":"123 Main Street",
    "shopTown":"Colombo",
    "shopLatitude":6.9271,
    "shopLongitude":80.7789
  }')

if echo "$VALIDATION_RESPONSE" | jq -e '.errors[] | select(. == "Category is required")' > /dev/null 2>&1; then
  echo -e "${GREEN}✓ Category validation working${NC}"
  echo "$VALIDATION_RESPONSE" | jq .errors
else
  echo -e "${RED}✗ Validation not working properly${NC}"
  echo "$VALIDATION_RESPONSE" | jq .
fi

echo -e "\n"

# Test 3: Product Validation - Invalid Price
echo -e "${YELLOW}Test 3: Product Validation - Invalid Price${NC}"
PRICE_RESPONSE=$(curl -s -X POST "$API_URL/products" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $USER_TOKEN" \
  -d '{
    "category":"Electronics",
    "brand":"TestBrand",
    "model":"Model-X",
    "name":"ValidProductName",
    "price":"not-a-number",
    "warranty":12,
    "shopName":"Test Shop",
    "shopAddress":"123 Main Street",
    "shopTown":"Colombo",
    "shopLatitude":6.9271,
    "shopLongitude":80.7789
  }')

if echo "$PRICE_RESPONSE" | jq -e '.errors[] | select(. == "Price must be a positive number")' > /dev/null 2>&1; then
  echo -e "${GREEN}✓ Price validation working${NC}"
  echo "$PRICE_RESPONSE" | jq .errors
else
  echo -e "${RED}✗ Price validation failed${NC}"
  echo "$PRICE_RESPONSE" | jq .
fi

echo -e "\n"

# Test 4: Product Validation - Short Product Name
echo -e "${YELLOW}Test 4: Product Validation - Short Product Name${NC}"
NAME_RESPONSE=$(curl -s -X POST "$API_URL/products" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $USER_TOKEN" \
  -d '{
    "category":"Electronics",
    "brand":"TestBrand",
    "model":"Model-X",
    "name":"ab",
    "price":"5000",
    "warranty":12,
    "shopName":"Test Shop",
    "shopAddress":"123 Main Street",
    "shopTown":"Colombo",
    "shopLatitude":6.9271,
    "shopLongitude":80.7789
  }')

if echo "$NAME_RESPONSE" | jq -e '.errors[] | select(. == "Product name must be at least 3 characters")' > /dev/null 2>&1; then
  echo -e "${GREEN}✓ Product name validation working${NC}"
  echo "$NAME_RESPONSE" | jq .errors
else
  echo -e "${RED}✗ Product name validation failed${NC}"
  echo "$NAME_RESPONSE" | jq .
fi

echo -e "\n"

# Test 5: Product Validation - Invalid Coordinates
echo -e "${YELLOW}Test 5: Product Validation - Invalid Coordinates${NC}"
COORDS_RESPONSE=$(curl -s -X POST "$API_URL/products" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $USER_TOKEN" \
  -d '{
    "category":"Electronics",
    "brand":"TestBrand",
    "model":"Model-X",
    "name":"ValidProductName",
    "price":"5000",
    "warranty":12,
    "shopName":"Test Shop",
    "shopAddress":"123 Main Street",
    "shopTown":"Colombo",
    "shopLatitude":150,
    "shopLongitude":80.7789
  }')

if echo "$COORDS_RESPONSE" | jq -e '.errors[] | select(. == "Shop latitude must be between -90 and 90")' > /dev/null 2>&1; then
  echo -e "${GREEN}✓ Latitude validation working${NC}"
  echo "$COORDS_RESPONSE" | jq .errors
else
  echo -e "${RED}✗ Coordinate validation failed${NC}"
  echo "$COORDS_RESPONSE" | jq .
fi

echo -e "\n"

# Test 6: Invalid Authentication Token
echo -e "${YELLOW}Test 6: Invalid Authentication Token${NC}"
AUTH_RESPONSE=$(curl -s -X POST "$API_URL/products" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer invalid_token_12345" \
  -d '{"category":"test"}')

if echo "$AUTH_RESPONSE" | jq -e '.message | select(. == "Not authorized, token failed")' > /dev/null 2>&1; then
  echo -e "${GREEN}✓ Authentication error handling working${NC}"
else
  echo -e "${RED}✗ Auth validation failed${NC}"
  echo "$AUTH_RESPONSE" | jq .
fi

echo -e "\n${BLUE}=== All Tests Complete ===${NC}"
