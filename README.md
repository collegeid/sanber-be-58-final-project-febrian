# API Documentation

## Overview

This documentation provides a comprehensive overview of the API endpoints available in our application, along with instructions on how to test each endpoint.

## Base URL

All API endpoints are relative to the following base URL:

```
https://finalproject-production-b09d.up.railway.app/api/
```

## Tutorial Penggunaan Automasi

### Skrip Automasi

Proyek ini menyertakan skrip automasi berikut:

1. **`init.sh`**: Skrip ini digunakan untuk memulai dan menginisialisasi semua file test.

2. **`qa_order.sh`**: Skrip untuk mengelola pesanan. Skrip ini memungkinkan pendaftaran pengguna, login, pembuatan pesanan, dan pengelolaan pesanan (create, read, update, delete). Pilihan pembuatan pesanan dapat berupa pesanan tunggal atau bulk.

3. **`qa_products_categories.sh`**: Skrip untuk mengelola produk dan kategori. Skrip ini membuat kategori dan produk dengan data acak, serta memperbarui dan menghapusnya.

4. **`qa_user.sh`**: Skrip untuk mendaftar pengguna baru dan melakukan login. Pengguna dapat menggunakan data acak atau data yang dimasukkan secara manual.

5. **`tesh.sh`**: Skrip pengujian tambahan (jika diperlukan).

### Langkah-langkah untuk Menggunakan Skrip Automasi

1. **Menyiapkan Skrip**:
   - Pastikan Anda telah menginstal dependensi yang diperlukan seperti `curl` dan `jq`.
   - Ubah variabel `BASE_URL` di dalam skrip sesuai dengan URL API yang digunakan.

2. **Menjalankan Skrip**:
   - Berikan izin eksekusi pada skrip dengan perintah:
     ```bash
     chmod +x skrip.sh
     ```
   - Jalankan skrip sesuai dengan opsi yang diinginkan. Misalnya, untuk mengelola pesanan:
     ```bash
     ./qa_order.sh
     ```

3. **Memilih Opsi**:
   - Ikuti petunjuk di skrip untuk memilih opsi yang sesuai (misalnya, membuat pesanan, mendapatkan daftar produk, dll.).

4. **Memeriksa Hasil**:
   - Lihat output dari skrip untuk memastikan bahwa operasi dilakukan dengan benar.

## Endpoints

### Products

#### Get All Products
- **URL:** `/products`
- **Method:** `GET`
- **Description:** Retrieve a list of all products.
- **Query Parameters:** None
- **Success Response:**
  - **Code:** 200 OK
  - **Content:**
    ```json
    [
      {
        "id": "1",
        "name": "Product Name",
        "price": "19.99",
        "description": "Product Description"
      },
      ...
    ]
    ```
- **Error Response:**
  - **Code:** 500 Internal Server Error
  - **Content:** 
    ```json
    {
      "error": "Failed to retrieve products."
    }
    ```

**Example Request:**
```bash
curl -X GET http://<your-domain>/api/products
```

#### Create a Product
- **URL:** `/products`
- **Method:** `POST`
- **Description:** Create a new product.
- **Authorization:** Admin only (Include JWT token in header)
- **Body Parameters:**
  - `name` (string): Name of the product
  - `price` (string): Price of the product
  - `description` (string): Description of the product
- **Success Response:**
  - **Code:** 201 Created
  - **Content:**
    ```json
    {
      "id": "1",
      "name": "Product Name",
      "price": "19.99",
      "description": "Product Description"
    }
    ```
- **Error Response:**
  - **Code:** 400 Bad Request
  - **Content:** 
    ```json
    {
      "error": "Invalid product data."
    }
    ```

**Example Request:**
```bash
curl -X POST http://<your-domain>/api/products \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <your-token>" \
-d '{
  "name": "New Product",
  "price": "19.99",
  "description": "A new product description."
}'
```

#### Get a Product by ID
- **URL:** `/products/:id`
- **Method:** `GET`
- **Description:** Retrieve a specific product by its ID.
- **Path Parameters:**
  - `id` (string): ID of the product
- **Success Response:**
  - **Code:** 200 OK
  - **Content:**
    ```json
    {
      "id": "1",
      "name": "Product Name",
      "price": "19.99",
      "description": "Product Description"
    }
    ```
- **Error Response:**
  - **Code:** 404 Not Found
  - **Content:** 
    ```json
    {
      "error": "Product not found."
    }
    ```

**Example Request:**
```bash
curl -X GET http://<your-domain>/api/products/1
```

#### Update a Product by ID
- **URL:** `/products/:id`
- **Method:** `PUT`
- **Description:** Update a specific product by its ID.
- **Authorization:** Admin only (Include JWT token in header)
- **Path Parameters:**
  - `id` (string): ID of the product
- **Body Parameters:**
  - `name` (string): Updated name of the product
  - `price` (string): Updated price of the product
  - `description` (string): Updated description of the product
- **Success Response:**
  - **Code:** 200 OK
  - **Content:**
    ```json
    {
      "id": "1",
      "name": "Updated Product Name",
      "price": "29.99",
      "description": "Updated description."
    }
    ```
- **Error Response:**
  - **Code:** 400 Bad Request
  - **Content:** 
    ```json
    {
      "error": "Invalid product data."
    }
    ```

**Example Request:**
```bash
curl -X PUT http://<your-domain>/api/products/1 \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <your-token>" \
-d '{
  "name": "Updated Product Name",
  "price": "29.99",
  "description": "Updated description."
}'
```

#### Delete a Product by ID
- **URL:** `/products/:id`
- **Method:** `DELETE`
- **Description:** Delete a specific product by its ID.
- **Authorization:** Admin only (Include JWT token in header)
- **Path Parameters:**
  - `id` (string): ID of the product
- **Success Response:**
  - **Code:** 204 No Content
- **Error Response:**
  - **Code:** 404 Not Found
  - **Content:** 
    ```json
    {
      "error": "Product not found."
    }
    ```

**Example Request:**
```bash
curl -X DELETE http://<your-domain>/api/products/1 \
-H "Authorization: Bearer <your-token>"
```

### Categories

#### Get All Categories
- **URL:** `/categories`
- **Method:** `GET`
- **Description:** Retrieve a list of all categories.
- **Query Parameters:** None
- **Success Response:**
  - **Code:** 200 OK
  - **Content:**
    ```json
    [
      {
        "id": "1",
        "name": "Category Name"
      },
      ...
    ]
    ```
- **Error Response:**
  - **Code:** 500 Internal Server Error
  - **Content:** 
    ```json
    {
      "error": "Failed to retrieve categories."
    }
    ```

**Example Request:**
```bash
curl -X GET http://<your-domain>/api/categories
```

#### Create a Category
- **URL:** `/categories`
- **Method:** `POST`
- **Description:** Create a new category.
- **Authorization:** Admin only (Include JWT token in header)
- **Body Parameters:**
  - `name` (string): Name of the category
- **Success Response:**
  - **Code:** 201 Created
  - **Content:**
    ```json
    {
      "id": "1",
      "name": "Category Name"
    }
    ```
- **Error Response:**
  - **Code:** 400 Bad Request
  - **Content:** 
    ```json
    {
      "error": "Invalid category data."
    }
    ```

**Example Request:**
```bash
curl -X POST http://<your-domain>/api/categories \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <your-token>" \
-d '{
  "name": "New Category"
}'
```

#### Get a Category by ID
- **URL:** `/categories/:id`
- **Method:** `GET`
- **Description:** Retrieve a specific category by its ID.
- **Path Parameters:**
  - `id` (string): ID of the category
- **Success Response:**
  - **Code:** 200 OK
  - **Content:**
    ```json
    {
      "id": "1",
      "name": "Category Name"
    }
    ```
- **Error Response:**
  - **Code:** 404 Not Found
  - **Content:** 
    ```json
    {
      "error": "Category not found."
    }
    ```

**Example Request:**
```bash
curl -X GET http://<your-domain>/api/categories/1
```

#### Update a Category by ID
- **URL:** `/categories/:id`
- **Method:** `PUT`
- **Description:** Update a specific category by its ID.
- **Authorization:** Admin only (Include JWT token in header)
- **Path Parameters:**
  - `id` (string): ID of the category
- **Body Parameters:**
  - `name` (string): Updated name of the category
- **Success Response:**
  - **Code:** 200 OK
  - **Content:**
    ```json
    {
      "id": "1",
      "name": "Updated Category Name"
    }
    ```
- **Error Response:**
  - **Code:** 400 Bad Request
  - **Content:** 
    ```json
    {
      "error": "Invalid category data."
    }
    ```

**Example Request:**
```bash
curl -X PUT http://<your-domain>/api/categories/1 \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <your-token>" \
-d '{
  "name": "Updated Category Name"
}'
```

#### Delete a Category by ID
- **URL:** `/categories/:id`
- **Method:** `DELETE`
- **Description:** Delete a specific category by its ID.
- **Authorization:** Admin only (Include JWT token in header)
- **Path Parameters:**
  - `id` (string): ID of the category
- **Success Response:**
  - **Code:** 204 No Content
- **Error Response:**
  - **Code:** 404 Not Found
  - **Content:** 
    ```json
    {


      "error": "Category not found."
    }
    ```

**Example Request:**
```bash
curl -X DELETE http://<your-domain>/api/categories/1 \
-H "Authorization: Bearer <your-token>"
```

### Authentication

#### User Login
- **URL:** `/auth/login`
- **Method:** `POST`
- **Description:** Authenticate a user and return a JWT token.
- **Body Parameters:**
  - `username` (string): Username of the user
  - `password` (string): Password of the user
- **Success Response:**
  - **Code:** 200 OK
  - **Content:**
    ```json
    {
      "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
    }
    ```
- **Error Response:**
  - **Code:** 401 Unauthorized
  - **Content:** 
    ```json
    {
      "error": "Invalid credentials."
    }
    ```

**Example Request:**
```bash
curl -X POST http://<your-domain>/api/auth/login \
-H "Content-Type: application/json" \
-d '{
  "username": "exampleuser",
  "password": "examplepassword"
}'
```

#### User Registration
- **URL:** `/auth/register`
- **Method:** `POST`
- **Description:** Register a new user.
- **Body Parameters:**
  - `username` (string): Username of the user
  - `password` (string): Password of the user
  - `email` (string): Email of the user
- **Success Response:**
  - **Code:** 201 Created
  - **Content:**
    ```json
    {
      "id": "1",
      "username": "exampleuser",
      "email": "user@example.com"
    }
    ```
- **Error Response:**
  - **Code:** 400 Bad Request
  - **Content:** 
    ```json
    {
      "error": "Invalid registration data."
    }
    ```

**Example Request:**
```bash
curl -X POST http://<your-domain>/api/auth/register \
-H "Content-Type: application/json" \
-d '{
  "username": "newuser",
  "password": "newpassword",
  "email": "newuser@example.com"
}'
```

#### Get User Profile
- **URL:** `/auth/me`
- **Method:** `GET`
- **Description:** Retrieve the profile information of the logged-in user.
- **Authorization:** Requires JWT token (Include JWT token in header)
- **Success Response:**
  - **Code:** 200 OK
  - **Content:**
    ```json
    {
      "id": "1",
      "username": "exampleuser",
      "email": "user@example.com"
    }
    ```
- **Error Response:**
  - **Code:** 401 Unauthorized
  - **Content:** 
    ```json
    {
      "error": "Unauthorized access."
    }
    ```

**Example Request:**
```bash
curl -X GET http://<your-domain>/api/auth/me \
-H "Authorization: Bearer <your-token>"
```

#### Update User Profile
- **URL:** `/auth/profile`
- **Method:** `PUT`
- **Description:** Update the profile information of the logged-in user.
- **Authorization:** Requires JWT token (Include JWT token in header)
- **Body Parameters:**
  - `email` (string): Updated email of the user
  - `password` (string): Updated password of the user
- **Success Response:**
  - **Code:** 200 OK
  - **Content:**
    ```json
    {
      "id": "1",
      "username": "exampleuser",
      "email": "updatedemail@example.com"
    }
    ```
- **Error Response:**
  - **Code:** 400 Bad Request
  - **Content:** 
    ```json
    {
      "error": "Invalid update data."
    }
    ```

**Example Request:**
```bash
curl -X PUT http://<your-domain>/api/auth/profile \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <your-token>" \
-d '{
  "email": "updatedemail@example.com",
  "password": "updatedpassword"
}'
```

### Orders

### Create an Order

- **URL:** `/orders`
- **Method:** `POST`
- **Description:** Create a new order.
- **Authorization:** Requires JWT token (Include JWT token in the header)
- **Body Parameters:**
  - `productId` (string): ID of the product
  - `quantity` (number): Quantity of the product
- **Success Response:**
  - **Code:** 201 Created
  - **Content:**
    ```json
    {
      "data": {
        "createdByEmail": "user_46a2c9e7b8070f15@example.com",
        "orderItems": {
          "productId": "66a23f57764df537e268865b",
          "name": "Kemeja dengan Kategori",
          "price": 15000,
          "quantity": 4,
          "_id": "66b537ff948e62c95791f166"
        },
        "grandTotal": 60000,
        "status": "pending",
        "_id": "66b537ff948e62c95791f165",
        "createdAt": "2024-08-08T21:26:23.578Z",
        "updatedAt": "2024-08-08T21:26:23.578Z",
        "__v": 0
      },
      "message": "Order created successfully"
    }
    ```


**Example Request:**
```bash
curl -X POST http://<your-domain>/api/orders \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <your-token>" \
-d '{
  "productId": "123",
  "quantity": 2
}'
```

#### Get All Orders
- **URL:** `/orders`
- **Method:** `GET`
- **Description:** Retrieve a list of all orders.
- **Authorization:** Requires JWT token (Include JWT token in header)
- **Success Response:**
  - **Code:** 200 OK
  - **Content:**
    ```json
    [
      {
        "id": "1",
        "productId": "123",
        "quantity": "2",
        "status": "Pending"
      },
      ...
    ]
    ```
- **Error Response:**
  - **Code:** 500 Internal Server Error
  - **Content:** 
    ```json
    {
      "error": "Failed to retrieve orders."
    }
    ```

**Example Request:**
```bash
curl -X GET http://<your-domain>/api/orders \
-H "Authorization: Bearer <your-token>"
```

#### Get Order by ID
- **URL:** `/orders/:id`
- **Method:** `GET`
- **Description:** Retrieve a specific order by its ID.
- **Authorization:** Requires JWT token (Include JWT token in header)
- **Path Parameters:**
  - `id` (string): ID of the order
- **Success Response:**
  - **Code:** 200 OK
  - **Content:**
    ```json
    {
      "id": "1",
      "productId": "123",
      "quantity": "2",
      "status": "Pending"
    }
    ```
- **Error Response:**
  - **Code:** 404 Not Found
  - **Content:** 
    ```json
    {
      "error": "Order not found."
    }
    ```

**Example Request:**
```bash
curl -X GET http://<your-domain>/api/orders/1 \
-H "Authorization: Bearer <your-token>"
```

#### Update Order by ID
- **URL:** `/orders/:id`
- **Method:** `PUT`
- **Description:** Update a specific order by its ID.
- **Authorization:** Requires JWT token (Include JWT token in header)
- **Path Parameters:**
  - `id` (string): ID of the order
- **Body Parameters:**
  - `quantity` (number): Updated quantity of the product
  - `status` (string): Updated status of the order
- **Success Response:**
  - **Code:** 200 OK
  - **Content:**
    ```json
    {
      "id": "1",
      "productId": "123",
      "quantity": "3",
      "status": "Shipped"
    }
    ```
- **Error Response:**
  - **Code:** 400 Bad Request
  - **Content:** 
    ```json
    {
      "error": "Invalid order data."
    }
    ```

**Example Request:**
```bash
curl -X PUT http://<your-domain>/api/orders/1 \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <your-token>" \
-d '{
  "quantity": 3,
  "status": "Shipped"
}'
```

#### Delete Order by ID
- **URL:** `/orders/:id`
- **Method:** `DELETE`
- **Description:** Delete a specific order by its ID.
- **Authorization:** Requires JWT token (Include JWT token in header)
- **Path Parameters:**
  - `id` (string): ID of the order
- **Success Response:**
  - **Code:** 204 No Content
- **Error Response:**
  - **Code:** 404 Not Found
  - **Content:** 
    ```json
    {
      "error": "Order not found."
    }
    ```

**Example Request:**
```bash
curl -X DELETE http://<your

-domain>/api/orders/1 \
-H "Authorization: Bearer <your-token>"
