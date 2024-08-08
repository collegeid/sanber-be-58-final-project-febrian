#!/bin/bash

# URL dasar API
BASE_URL="https://finalproject-production-b09d.up.railway.app/api"

# Fungsi untuk menghasilkan string acak
generate_random_string() {
  tr -dc A-Za-z0-9 </dev/urandom | head -c 10
}

# Fungsi untuk menghasilkan data kategori acak
generate_random_category_data() {
  local NAME="Category $(generate_random_string)"
  echo "$NAME"
}

# Fungsi untuk menghasilkan data produk acak
generate_random_product_data() {
  local NAME="Product $(generate_random_string)"
  local DESCRIPTION="Description $(generate_random_string)"
  local PRICE=$((RANDOM % 1000))
  local CATEGORY_ID=$1
  local IMAGES='["default.jpg"]'  # Gambar default
  local QTY=$((RANDOM % 3 + 1))

  echo "$NAME,$DESCRIPTION,$PRICE,$CATEGORY_ID,$IMAGES,$QTY"
}

echo "Mengelola kategori..."

# Create categories
CATEGORY_IDS=()
for i in {1..3}; do
  CATEGORY_NAME=$(generate_random_category_data)
  CATEGORY_JSON=$(printf '{"name": "%s"}' "$CATEGORY_NAME")
  echo "Membuat kategori $i..."
  CATEGORY_RESPONSE=$(curl -s -X POST $BASE_URL/categories -H "Content-Type: application/json" -d "$CATEGORY_JSON")
  echo "$CATEGORY_RESPONSE" | jq .
  CATEGORY_ID=$(echo $CATEGORY_RESPONSE | jq -r '.data._id')
  CATEGORY_IDS+=($CATEGORY_ID)
  echo "Kategori berhasil dibuat: $CATEGORY_ID"
done

# Create product with one of the categories
CATEGORY_ID=${CATEGORY_IDS[0]}  # Ambil kategori pertama untuk produk

PRODUCT_DATA=$(generate_random_product_data $CATEGORY_ID)
IFS=',' read -r NAME DESCRIPTION PRICE CATEGORY_ID IMAGES QTY <<< "$PRODUCT_DATA"

PRODUCT_JSON=$(printf '{
  "name": "%s",
  "description": "%s",
  "price": %d,
  "category": "%s",
  "images": %s,
  "qty": %d
}' "$NAME" "$DESCRIPTION" "$PRICE" "$CATEGORY_ID" "$IMAGES" "$QTY")

echo "Membuat produk baru..."
CREATE_PRODUCT_RESPONSE=$(curl -s -X POST $BASE_URL/products -H "Content-Type: application/json" -d "$PRODUCT_JSON")
echo "$CREATE_PRODUCT_RESPONSE" | jq .

# Extract Product ID from response
PRODUCT_ID=$(echo $CREATE_PRODUCT_RESPONSE | jq -r '.data._id')

echo "Produk berhasil dibuat dengan ID: $PRODUCT_ID"

# Read product
echo "Mengambil produk dengan ID $PRODUCT_ID..."
curl -s -X GET $BASE_URL/products/$PRODUCT_ID | jq .

# Update product
echo "Memperbarui produk dengan ID $PRODUCT_ID..."
UPDATE_PRODUCT_DATA=$(printf '{
  "price": %d
}' $((RANDOM % 1000)))
curl -s -X PUT $BASE_URL/products/$PRODUCT_ID -H "Content-Type: application/json" -d "$UPDATE_PRODUCT_DATA" | jq .

# Delete product
echo "Menghapus produk dengan ID $PRODUCT_ID..."
curl -s -X DELETE $BASE_URL/products/$PRODUCT_ID | jq .

# Delete categories
for CATEGORY_ID in "${CATEGORY_IDS[@]}"; do
  echo "Menghapus kategori dengan ID $CATEGORY_ID..."
  curl -s -X DELETE $BASE_URL/categories/$CATEGORY_ID | jq .
done
