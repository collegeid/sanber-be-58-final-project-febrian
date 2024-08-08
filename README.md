# API Documentation

## Overview

This documentation provides a comprehensive overview of the API endpoints available in our application, including the various operations related to products, categories, orders, and user authentication.

## Base URL

All API endpoints are relative to the following base URL:

```
https://finalproject-production-b09d.up.railway.app/api/
```

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
curl -X GET http://your-domain/api/products
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
curl -X POST http://your-domain/api/products \
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
curl -X GET http://your-domain/api/products/1
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
curl -X PUT http://your-domain/api/products/1 \
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
curl -X DELETE http://your-domain/api/products/1 \
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
curl -X GET http://your-domain/api/categories
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
curl -X POST http://your-domain/api/categories \
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
curl -X GET http://your-domain/api/categories/1
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
curl -X PUT http://your-domain/api/categories/1 \
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

**Example Request:

**
```bash
curl -X DELETE http://your-domain/api/categories/1 \
-H "Authorization: Bearer <your-token>"
```

### Orders

#### Create an Order
- **URL:** `/orders`
- **Method:** `POST`
- **Description:** Create a new order.
- **Authorization:** Admin and User (Include JWT token in header)
- **Body Parameters:**
  - `product_id` (string): ID of the product being ordered
  - `quantity` (integer): Quantity of the product
  - `status` (string): Status of the order (e.g., "pending")
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
curl -X POST http://your-domain/api/orders \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <your-token>" \
-d '{
  "product_id": "1",
  "quantity": 1,
  "status": "pending"
}'
```

#### Get All Orders
- **URL:** `/orders`
- **Method:** `GET`
- **Description:** Retrieve a list of all orders.
- **Authorization:** Admin only (Include JWT token in header)
- **Success Response:**
  - **Code:** 200 OK
  - **Content:**
    ```json
    [
      {
        "id": "1",
        "product_id": "1",
        "quantity": 1,
        "status": "pending"
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
curl -X GET http://your-domain/api/orders \
-H "Authorization: Bearer <your-token>"
```

#### Get an Order by ID
- **URL:** `/orders/:id`
- **Method:** `GET`
- **Description:** Retrieve a specific order by its ID.
- **Authorization:** Admin and User (Include JWT token in header)
- **Path Parameters:**
  - `id` (string): ID of the order
- **Success Response:**
  - **Code:** 200 OK
  - **Content:**
    ```json
    {
      "id": "1",
      "product_id": "1",
      "quantity": 1,
      "status": "pending"
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
curl -X GET http://your-domain/api/orders/1 \
-H "Authorization: Bearer <your-token>"
```

#### Update an Order by ID
- **URL:** `/orders/:id`
- **Method:** `PUT`
- **Description:** Update a specific order by its ID.
- **Authorization:** Admin and User (Include JWT token in header)
- **Path Parameters:**
  - `id` (string): ID of the order
- **Body Parameters:**
  - `status` (string): Updated status of the order
- **Success Response:**
  - **Code:** 200 OK
  - **Content:**
    ```json
    {
      "id": "1",
      "product_id": "1",
      "quantity": 1,
      "status": "completed"
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
curl -X PUT http://your-domain/api/orders/1 \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <your-token>" \
-d '{
  "status": "completed"
}'
```

#### Delete an Order by ID
- **URL:** `/orders/:id`
- **Method:** `DELETE`
- **Description:** Delete a specific order by its ID.
- **Authorization:** Admin only (Include JWT token in header)
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
curl -X DELETE http://your-domain/api/orders/1 \
-H "Authorization: Bearer <your-token>"
```

### Authentication

#### User Login
- **URL:** `/auth/login`
- **Method:** `POST`
- **Description:** Authenticate a user and return a JWT token.
- **Body Parameters:**
  - `email` (string): User's email address
  - `password` (string): User's password
- **Success Response:**
  - **Code:** 200 OK
  - **Content:**
    ```json
    {
      "token": "<JWT-TOKEN>"
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
curl -X POST http://your-domain/api/auth/login \
-H "Content-Type: application/json" \
-d '{
  "email": "user@example.com",
  "password": "password"
}'
```

#### User Registration
- **URL:** `/auth/register`
- **Method:** `POST`
- **Description:** Register a new user.
- **Body Parameters:**
  - `name` (string): User's full name
  - `email` (string): User's email address
  - `password` (string): User's password
- **Success Response:**
  - **Code:** 201 Created
  - **Content:**
    ```json
    {
      "id": "1",
      "name": "User Name",
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
curl -X POST http://your-domain/api/auth/register \
-H "Content-Type: application/json" \
-d '{
  "name": "New User",
  "email": "user@example.com",
  "password": "password"
}'
```

#### Get Current User Profile
- **URL:** `/auth/me`
- **Method:** `GET`
- **Description:** Retrieve the profile of the currently authenticated user.
- **Authorization:** Include JWT token in header
- **Success Response:**
  - **Code:** 200 OK
  - **Content:**
    ```json
    {
      "id": "1",
      "name": "User Name",
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
curl -X GET http://your-domain/api/auth/me \
-H "Authorization: Bearer <your-token>"
```

#### Update User Profile
- **URL:** `/auth/profile`
- **Method:** `PUT`
- **Description:** Update the profile of the currently authenticated user.
- **Authorization:** Include JWT token in header
- **Body Parameters:**
  - `name` (string): Updated name of the user
  - `email` (string): Updated email address of the user
- **Success Response:**
  - **Code:** 200 OK
  - **Content:**
    ```json
    {
      "id": "1",
      "name": "Updated User Name",
      "email": "updated@example.com"
    }
    ```
- **Error Response:**
  - **Code:** 400 Bad Request
  - **Content:** 
    ```json
    {
      "error": "Invalid profile data."
    }
    ```

**Example Request:**
```bash
curl -X PUT http://your-domain/api/auth/profile \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <your-token>" \
-d '{
  "name": "Updated User Name",
  "email": "updated@example.com"
}'
```

## Middleware

- **authMiddleware:** Ensures that the request is authenticated with a valid JWT token.
- **aclMiddleware:** Checks if the user has the required role(s) to access the route.
- **checkOrderOwnership:** Ensures that the user owns the order or is an admin.

## Error Codes

- **400 Bad Request:** Invalid data sent in the request body.
- **401 Unauthorized:** Authentication failed or unauthorized access.
- **404 Not Found:** Resource not found.
- **500 Internal Server Error:** Server error.

---

This documentation provides a detailed overview of each endpoint, including request formats, expected responses

, and example requests for your Express API.
