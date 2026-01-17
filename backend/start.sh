#!/bin/bash

echo "🚀 Starting Community Shopping Backend..."
echo ""

# Check if MongoDB is running
if ! pgrep -x "mongod" > /dev/null; then
    echo "⚠️  MongoDB is not running!"
    echo ""
    echo "Please start MongoDB first:"
    echo "  Option 1: brew services start mongodb-community"
    echo "  Option 2: mongod --config /opt/homebrew/etc/mongod.conf"
    echo ""
    echo "Or use MongoDB Atlas (cloud):"
    echo "  1. Go to https://www.mongodb.com/cloud/atlas"
    echo "  2. Create free cluster"
    echo "  3. Update MONGODB_URI in .env"
    echo ""
    exit 1
fi

echo "✅ MongoDB is running"
echo ""

# Start the server
npm start
