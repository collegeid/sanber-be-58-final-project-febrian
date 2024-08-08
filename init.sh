#!/bin/bash

# Fungsi untuk menjalankan skrip
function run_script() {
  local script=$1
  if [ -f "$script" ]; then
    echo "Menjalankan $script..."
    bash "$script"
  else
    echo "File $script tidak ditemukan!"
  fi
}

# Menu utama
while true; do
  clear
  echo "Pilih skrip yang ingin dijalankan:"
  echo "1) qa_user.sh"
  echo "2) qa_products_categories.sh"
  echo "3) qa_order.sh"
  echo "4) Keluar"
  read -p "Masukkan pilihan (1-4): " choice

  case $choice in
    1)
      run_script "qa_user.sh"
      ;;
    2)
      run_script "qa_products_categories.sh"
      ;;
    3)
      run_script "qa_order.sh"
      ;;
    4)
      echo "Keluar..."
      exit 0
      ;;
    *)
      echo "Pilihan tidak valid. Silakan coba lagi."
      ;;
  esac

  # Tunggu input dari pengguna sebelum melanjutkan
  read -p "Tekan [Enter] untuk kembali ke menu..."
done
