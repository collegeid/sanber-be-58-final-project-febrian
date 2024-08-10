#!/bin/bash

# Konfigurasi dasar
BASE_URL="https://finalproject-production-b09d.up.railway.app/api"
EMAIL="user@example.com"
PASSWORD="password"

# Fungsi untuk mendaftar pengguna baru
function register_user() {
  if [ "$OPTION" -eq 1 ]; then
    read -p "Masukkan email untuk pendaftaran: " REG_EMAIL
    read -p "Masukkan nama lengkap untuk pendaftaran: " REG_FULLNAME
    read -p "Masukkan password untuk pendaftaran: " REG_PASSWORD
    read -p "Masukkan username untuk pendaftaran: " REG_USERNAME
    read -p "Masukkan role (admin/user): " REG_ROLE
  else
    REG_EMAIL="user_$(openssl rand -hex 8)@example.com"
    REG_FULLNAME="User $(openssl rand -hex 8)"
    REG_PASSWORD=$(openssl rand -hex 8)
    REG_USERNAME="user_$(openssl rand -hex 8)"
    REG_ROLE=$([ "$ROLE_OPTION" -eq 1 ] && echo "admin" || echo "user")
  fi

  REG_DATA=$(jq -n \
    --arg email "$REG_EMAIL" \
    --arg fullName "$REG_FULLNAME" \
    --arg password "$REG_PASSWORD" \
    --arg username "$REG_USERNAME" \
    --arg role "$REG_ROLE" \
    '{email: $email, fullName: $fullName, password: $password, username: $username, role: $role}')

  echo "Mendaftar pengguna baru dengan data:"
  echo "$REG_DATA" | jq .

  REG_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/register" \
    -H "Content-Type: application/json" \
    -d "$REG_DATA")

  echo "Respons pendaftaran:"
  echo "$REG_RESPONSE" | jq .

  echo "Pendaftaran berhasil."
}

# Fungsi untuk login pengguna
function login_user() {
  if [ "$OPTION" -eq 1 ]; then
    read -p "Masukkan email untuk login: " LOGIN_EMAIL
    read -p "Masukkan password untuk login: " LOGIN_PASSWORD
  else
    LOGIN_EMAIL=$REG_EMAIL
    LOGIN_PASSWORD=$REG_PASSWORD
  fi

  LOGIN_DATA=$(jq -n \
    --arg email "$LOGIN_EMAIL" \
    --arg password "$LOGIN_PASSWORD" \
    '{email: $email, password: $password}')

  echo "Login dengan data:"
  echo "$LOGIN_DATA" | jq .

  LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/login" \
    -H "Content-Type: application/json" \
    -d "$LOGIN_DATA")

  JWT_TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.data')

  if [ -z "$JWT_TOKEN" ]; then
    echo "Gagal mendapatkan token JWT. Periksa respons login."
    echo "Respons login:"
    echo "$LOGIN_RESPONSE" | jq .
    exit 1
  fi

  USER_ID=$(echo $JWT_TOKEN | jq -R 'split(".") | .[1] | @base64d | fromjson | .id')
 # Simpan email dari respons login
  LOGIN_EMAIL=$(echo "$LOGIN_DATA" | jq -r '.email')

  echo "Token JWT berhasil diperoleh"
  echo "Email login: $LOGIN_EMAIL"
}

# Fungsi untuk mengambil daftar produk
function get_products() {
  echo "Mengambil daftar produk..."
  PRODUCTS_RESPONSE=$(curl -s "$BASE_URL/products")
  echo "Daftar Produk:"
  echo "$PRODUCTS_RESPONSE" | jq .
}

function create_order() {
  local QUANTITY=1
  local TOTAL_AMOUNT=0

  if [ -z "$JWT_TOKEN" ]; then
    echo "Token JWT tidak ditemukan. Pastikan login berhasil."
    exit 1
  fi

  # Ambil ID produk
  get_products
  read -p "Masukkan nomor produk yang ingin dipilih: " PRODUCT_NUMBER
  PRODUCT_ID=$(echo "$PRODUCTS_RESPONSE" | jq -r ".data[$((PRODUCT_NUMBER - 1))]._id")

  echo "Produk yang dipilih: $PRODUCT_ID"

  PRODUCT_PRICE=$(curl -s "$BASE_URL/products/$PRODUCT_ID" | jq -r '.data.price')
  PRODUCT_NAME=$(curl -s "$BASE_URL/products/$PRODUCT_ID" | jq -r '.data.name')
  TOTAL_AMOUNT=$(echo "$PRODUCT_PRICE * $QUANTITY" | bc)

  GRAND_TOTAL=$TOTAL_AMOUNT  

ORDER_DATA=$(jq -n \
  --arg user "$USER_ID" \
  --argjson orderItems "[{\"productId\": \"$PRODUCT_ID\", \"name\": \"$PRODUCT_NAME\", \"quantity\": $QUANTITY, \"price\": $PRODUCT_PRICE}]" \
  --argjson totalAmount "$TOTAL_AMOUNT" \
  --argjson grandTotal "$GRAND_TOTAL" \
  --arg createdByEmail "$LOGIN_EMAIL" \
  --arg status "pending" \
  '{user: ($user | fromjson), orderItems: $orderItems, totalAmount: $totalAmount, grandTotal: $grandTotal, createdByEmail: $createdByEmail, status: $status}')

  echo "Data Order:"
  echo $ORDER_DATA | jq .

  RESPONSE=$(curl -s -X POST "$BASE_URL/orders" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $JWT_TOKEN" \
    -d "$ORDER_DATA")

  echo "Respons Order:"
  echo "$RESPONSE" | jq .
}

function create_bulk_orders() {
  if [ -z "$JWT_TOKEN" ]; then
    echo "Token JWT tidak ditemukan. Pastikan login berhasil."
    exit 1
  fi

  # Ambil daftar produk
  get_products

  # Loop untuk membuat beberapa pesanan
  for i in {1..3}; do
    # Pilih produk secara acak
    PRODUCT_NUMBER=$(shuf -i 1-$(echo "$PRODUCTS_RESPONSE" | jq '.data | length') -n 1)
    PRODUCT_ID=$(echo "$PRODUCTS_RESPONSE" | jq -r ".data[$((PRODUCT_NUMBER - 1))]._id")
    PRODUCT_PRICE=$(curl -s "$BASE_URL/products/$PRODUCT_ID" | jq -r '.data.price')
    PRODUCT_NAME=$(curl -s "$BASE_URL/products/$PRODUCT_ID" | jq -r '.data.name')

    # Randomkan kuantitas (lebih dari stok yang tersedia untuk pengujian)
    QUANTITY=$((RANDOM % 4 + 1))
    TOTAL_AMOUNT=$(echo "$PRODUCT_PRICE * $QUANTITY" | bc)
    GRAND_TOTAL=$TOTAL_AMOUNT  # Misalkan grandTotal sama dengan totalAmount

   ORDER_DATA=$(jq -n \
  --arg user "$USER_ID" \
  --argjson orderItems "[{\"productId\": \"$PRODUCT_ID\", \"name\": \"$PRODUCT_NAME\", \"quantity\": $QUANTITY, \"price\": $PRODUCT_PRICE}]" \
  --argjson totalAmount "$TOTAL_AMOUNT" \
  --argjson grandTotal "$GRAND_TOTAL" \
  --arg createdByEmail "$LOGIN_EMAIL" \
  --arg status "pending" \
  '{user: ($user | fromjson), orderItems: $orderItems, totalAmount: $totalAmount, grandTotal: $grandTotal, createdByEmail: $createdByEmail, status: $status}')

    echo "Data Order #$i:"
    echo $ORDER_DATA | jq .

    RESPONSE=$(curl -s -X POST "$BASE_URL/orders" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $JWT_TOKEN" \
      -d "$ORDER_DATA")

    echo "Respons Order #$i:"
    echo "$RESPONSE" | jq .

    # Tunggu beberapa detik sebelum membuat pesanan berikutnya
    sleep 2
  done
}


# Fungsi untuk mendapatkan semua order (khusus admin)
function get_all_orders() {
  if [ "$ROLE_OPTION" -eq 1 ]; then
    echo "Mengambil semua order (khusus admin)..."
    RESPONSE=$(curl -s -X GET "$BASE_URL/orders" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $JWT_TOKEN")
    echo "Daftar Order:"
    echo "$RESPONSE" | jq .
  else
    echo "Anda bukan admin. Tidak dapat mengambil semua order."
  fi
}

# Fungsi untuk mendapatkan order berdasarkan ID
function get_order_by_id() {
  echo "Mengambil order berdasarkan ID..."
  RESPONSE=$(curl -s -X GET "$BASE_URL/orders/$ORDER_ID" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $JWT_TOKEN")
  echo "Detail Order:"
  echo "$RESPONSE" | jq .
}

# Fungsi untuk memperbarui order
function update_order() {
  echo "Memperbarui order..."
  UPDATED_DATA=$(jq -n \
    --arg status "completed" \
    '{status: $status}')
  
  RESPONSE=$(curl -s -X PUT "$BASE_URL/orders/$ORDER_ID" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $JWT_TOKEN" \
    -d "$UPDATED_DATA")
  
  echo "Respons Update Order:"
  echo "$RESPONSE" | jq .
}

# Fungsi untuk menghapus order (khusus admin)
function delete_order() {
  if [ "$ROLE_OPTION" -eq 1 ]; then
    echo "Menghapus order..."
    RESPONSE=$(curl -s -X DELETE "$BASE_URL/orders/$ORDER_ID" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $JWT_TOKEN")
    echo "Respons Hapus Order:"
    echo "$RESPONSE" | jq .
  else
    echo "Anda bukan admin. Tidak dapat menghapus order."
  fi
}

# Menu utama
echo "Pilih opsi untuk data pendaftaran dan login:"
echo "1) Data dinamis (input manual)"
echo "2) Data acak"
read -p "Masukkan pilihan (1 atau 2): " OPTION

if [ "$OPTION" -eq 2 ]; then
  echo "Pilih role untuk data acak:"
  echo "1) Admin"
  echo "2) User"
  read -p "Masukkan role (1 / 2): " ROLE_OPTION
fi

register_user
login_user


# Pilih skema order
echo "Pilih skema order otomatis:"
echo "1. Order Valid Quantity"
echo "2. Order Bulk Quantity"
echo "3. Ambil Semua Order (Admin)"
echo "4. Ambil Order Berdasarkan ID"
echo "5. Perbarui Order"
echo "6. Hapus Order (Admin)"
read -p "Masukkan pilihan (1-5): " ORDER_OPTION

case $ORDER_OPTION in
  1)
    create_order
    ;;
  2)
    create_bulk_orders
    ;; 
  3)
    get_all_orders
    ;;
  4)
    read -p "Masukkan ID Order: " ORDER_ID
    get_order_by_id
    ;;
  5)
    read -p "Masukkan ID Order: " ORDER_ID
    update_order
    ;;
  6)
    read -p "Masukkan ID Order: " ORDER_ID
    delete_order
    ;;
  *)
    echo "Pilihan tidak valid."
    ;;
esac
