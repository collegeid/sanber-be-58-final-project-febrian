#!/bin/bash

# URL dasar API
BASE_URL="https://finalproject-production-b09d.up.railway.app/api"

# Fungsi untuk menghasilkan string acak
generate_random_string() {
  tr -dc A-Za-z0-9 </dev/urandom | head -c 10
}

# Fungsi untuk menghasilkan password acak
generate_random_password() {
  tr -dc A-Za-z0-9 </dev/urandom | head -c 12
}

# Fungsi untuk menghasilkan data acak
generate_random_data() {
  local EMAIL="user_$(generate_random_string)@example.com"
  local FULL_NAME="User $(generate_random_string)"
  local USERNAME="user_$(generate_random_string)"
  local PASSWORD=$(generate_random_password)
  local ROLES="user"  # Role default adalah "user"

  # Opsi untuk role admin
  if [ "$1" -eq 1 ]; then
    ROLES="admin"  # Ubah role menjadi "admin" jika opsi dipilih
  fi

  echo "$EMAIL,$FULL_NAME,$PASSWORD,$USERNAME,$ROLES"
}

# Pilihan untuk data dinamis atau acak
echo "Pilih opsi untuk data pendaftaran dan login:"
echo "1) Data dinamis (input manual)"
echo "2) Data acak"
read -p "Masukkan pilihan (1 atau 2): " OPTION

if [ "$OPTION" -eq 1 ]; then
  # Input data pendaftaran pengguna
  read -p "Masukkan email untuk pendaftaran: " EMAIL
  read -p "Masukkan nama lengkap: " FULL_NAME
  read -p "Masukkan password: " PASSWORD
  read -p "Masukkan username: " USERNAME
  read -p "Masukkan role (pisahkan dengan koma jika lebih dari satu, contohnya 'user,admin'): " ROLES
  ROLES_JSON=$(echo "$ROLES" | jq -R -s 'split(",")')  # Format array JSON menggunakan jq
elif [ "$OPTION" -eq 2 ]; then
  # Pilih role untuk data acak
  echo "Pilih role untuk data acak:"
  echo "1) Admin"
  echo "2) User"

  read -p "Masukkan role (1 / 2): " ROLE_OPTION

  # Menghasilkan data acak dengan role yang dipilih
  DATA=$(generate_random_data "$ROLE_OPTION")
  IFS=',' read -r EMAIL FULL_NAME PASSWORD USERNAME ROLES <<< "$DATA"
  ROLES_JSON=$(echo "$ROLES" | jq -R -s .)  # Format sebagai string menggunakan jq
else
  echo "Opsi tidak valid. Keluar..."
  exit 1
fi

# Data pengguna baru
REGISTER_DATA=$(jq -n \
  --arg email "$EMAIL" \
  --arg fullName "$FULL_NAME" \
  --arg password "$PASSWORD" \
  --arg username "$USERNAME" \
  --argjson role "$ROLES_JSON" \
  '{email: $email, fullName: $fullName, password: $password, username: $username, role: $role}')

echo "Mendaftar pengguna baru dengan data:"
echo "$REGISTER_DATA" | jq .

REGISTER_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d "$REGISTER_DATA")

# Input data login
if [ "$OPTION" -eq 1 ]; then
  read -p "Masukkan email untuk login: " LOGIN_EMAIL
  read -p "Masukkan password untuk login: " LOGIN_PASSWORD
else
  LOGIN_EMAIL=$EMAIL
  LOGIN_PASSWORD=$PASSWORD
fi

# Data login
LOGIN_DATA=$(jq -n \
  --arg email "$LOGIN_EMAIL" \
  --arg password "$LOGIN_PASSWORD" \
  '{email: $email, password: $password}')

echo "Login dengan data:"
echo "$LOGIN_DATA" | jq .

LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d "$LOGIN_DATA")

# Ekstrak token JWT dari respons login
JWT_TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.data')

if [ -z "$JWT_TOKEN" ]; then
  echo "Gagal mendapatkan token JWT. Periksa respons login."
  echo "Respons login:"
  echo "$LOGIN_RESPONSE" | jq .
  exit 1
fi

echo "Token JWT berhasil diperoleh"


# Tes endpoint '/auth/me'
echo "Mengambil data pengguna..."
USER_ME_RESPONSE=$(curl -s -X GET "$BASE_URL/auth/me" -H "Authorization: Bearer $JWT_TOKEN")

echo "Respons data pengguna:"
echo "$USER_ME_RESPONSE" | jq .
