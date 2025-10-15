::card
# Node.js/Express
Mastering backend development with Node.js and Express
::

::card
## Topics
- What is Node.js?
- What is Express?
- Basic Routing
::

::card
## What is Node.js?
- Node.js is a JavaScript runtime built on Chrome's V8 JavaScript engine. 
::

::card
## What is Node.js?
- Allows JavaScript to run outside the browser. 
- Built on V8 engine (same as Chrome). 
- Event-driven. 
- Perfect for building scalable network applications. 
- Created by Ryan Dahl in 2009. 
::

::card
## Use cases
- RESTful APIs
- Real-time applications (chat, games)
- Microservices
- Command-line tools
- Server-side rendering
::

::card
## Browser vs Node.js

| Browser Javascript | Node.jS |
|--------------------| ------- |
| Access to DOM (document, window) | No DOM (no window/document) |
| Frontend/UI focused | Full file system access |
| Single environment (browser) | Backend/server focused |
|| Access to operating system APIs |

::

::card
## Installing Node.js
### Steps
- Visit nodejs.org
<figure>
  <img src="/images/lessons/node-js-website.png" alt="Node.js website">
  <figcaption>https://nodejs.org</figcaption>
</figure>

- Download
- Run installer
- Verify installation

```bash
$ node --version
# v20.x.xs

$ npm --version
# 10.x.x
```
::


::card
## Your first Node.js Program
```js
// hello.js
console.log('Hello, Node.js!'); 

// Access Node.js globals
console.log('Current directory:', __dirname);
console.log('Current file:', __filename);
console.log('Platform:', process.platform);
```

On the terminal run it like this:
```bash 
node hello.js
```
::

::card
## Express.js
Express is a fast and minimalist web framework for Node.JS.

<figure>
  <img src="/images/lessons/express-website.png" alt="Node.js website">
  <figcaption>https://expressjs.com/</figcaption>
</figure>

### What is a web framework?
A Web Framework is a software designed to speed up development on web applications.
::

::card
## HTTP Verbs & CRUD Operations
HTTP methods define the type of operation you want to perform on a server resource. Each method specifies a different action:
|Verb|HTTP Method|
|----|------|
|Create|`POST`|
|Read|`GET`|
|Update|`PUT`|
|Delete|`DELETE`|

By default, visiting a website performs a `GET` request. When you submit a form, it typically uses `POST`, `PUT`, or `DELETE` methods.

You can test different HTTP methods with tools like [Postman](https://postman.com).

::

::card
## HTTP Status Codes
Status codes indicate the result of an HTTP request. Different methods typically return different codes:

| Code | Meaning | Example |
|------|---------|---------|
| 200 | OK | `GET` request successful |
| 201 | Created | `POST` created a new resource |
| 204 | No Content | `DELETE` successful, no response body |
| 400 | Bad Request | `POST` with invalid data |
| 404 | Not Found | `GET` for non-existent resource |
| 500 | Server Error | Any method - server crashed |

### Examples
- `POST /users` → `201` if created, `400` if validation fails, `500` if database error
- `GET /users/123` → `200` if found, `404` if doesn't exist
- `DELETE /users/123` → `204` if deleted, `404` if doesn't exist


### Testing HTTP with cURL

Try these commands in your terminal to see HTTP status codes in action:

```bash
# Follow redirects to see final status (200 OK)
curl -I -L https://nodejs.org
```
::

::card
## Your First Express App
Let's build a simple Express application step by step.

### Step 1: Setup
Create a project folder:
```bash
mkdir first-express-app
cd first-express-app
```
Now let's initialize our first project:
```bash
npm init --yes
npm install express
npm pkg set type=module
```

### Step 2: Understanding package.json
After running these commands, check your `package.json`:

```json
{
  "name": "first-express-app",
  "version": "1.0.0",
  "type": "module",
  "dependencies": {
    "express": "^5.1.0"
  }
}
```

### What does this mean?
- `type: "module"` - enables modern JavaScript (ES6 imports)
- `dependencies` - lists packages your project needs
- Express is now installed and ready to use!

### Step 3: Create app.js
Create a new file called `app.js`:

```js
// app.js
import express from 'express';
const app = express();

// Define a route
app.get('/home', (request, response) => {
  response.send('<h1>Hello DevWoman Valencia!</h1>');
});

// Start the server
app.listen(3000, () => {
  console.log('Server running at http://localhost:3000/home');
});
```

### Step 4: Run your app
```bash
node app.js
```

Visit http://localhost:3000/home in your browser!

**Learn more:** [Express Basic Routing](https://expressjs.com/en/starter/basic-routing.html)
::

::card
## Rendering HTML
Instead of sending plain text, let's create a proper HTML page.

### Basic HTML Response
```js
app.get('/', (request, response) => {
  const html = `
    <!DOCTYPE html>
    <html>
      <head>
        <title>My First Express App</title>
      </head>
      <body>
        <h1>Welcome to Express!</h1>
        <p>This is a complete HTML page.</p>
      </body>
    </html>
  `;
  response.send(html);
});
```

### Serving an HTML File
For larger HTML content this will become hard to maintain. Let's create a separate HTML file.

### Step 1 
Create a `views` folder and add `home.html`:
```bash
mkdir views
```

```html
<!-- views/home.html -->
<!DOCTYPE html>
<html>
  <head>
    <title>My Express App</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        max-width: 800px;
        margin: 50px auto;
        padding: 20px;
      }
    </style>
  </head>
  <body>
    <h1>Welcome to My Express App!</h1>
    <p>This HTML is loaded from a file.</p>
    <nav>
      <a href="/home">Home</a>
      <a href="/about">About</a>
    </nav>
  </body>
</html>
```

### Step 2 
Update `app.js` to serve the file:
```js
import express from 'express';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const app = express();

app.get('/', (request, response) => {
  response.sendFile(__dirname + '/views/home.html');
});

app.listen(3001, () => {
  console.log('Server running at http://localhost:3001');
});
```

### Step 3
Run the app and visit http://localhost:3000
::

::card
## Creating Our Own Routes
Routes define how your application responds to client requests at specific endpoints.

### Basic Route Structure
```js
app.get('/path', (request, response) => {
  // Handle the request
});
```

### Breaking It Down

1. The HTTP Method: `app.get()`
- `get` - Handles GET requests (viewing pages, fetching data)
- `post` - Handles POST requests (submitting forms, creating data)
- Other methods: `put`, `delete`, `patch`

2. The Path: `'/path'`
This is the URL endpoint. Examples:
- `'/'` - Home page (http://localhost:3000/)
- `'/about'` - About page (http://localhost:3000/about)
- `'/api/users'` - API endpoint (http://localhost:3000/api/users)

3. The Callback Function: `(request, response) => { }`  
This function runs when someone visits the route.

The `request` object contains:
- `request.body` - Data sent in POST requests
- `request.headers` - Request headers (cookies, content-type, etc.)
- Information about the incoming request

The `response` object lets you send back:
- `response.send('text')` - Send plain text or HTML
- `response.json({ data })` - Send JSON data
- `response.sendFile(path)` - Send an HTML file
- `response.status(404)` - Set HTTP status code

### Example: Multiple Routes
```js
// Home route
app.get('/', (request, response) => {
  response.send('<h1>Welcome to my site!</h1>');
});
```

```js
// About route
app.get('/about', (request, response) => {
  response.send('<h1>About Us</h1><p>We are awesome!</p>');
});
```

```js
// API route - returns JSON
app.get('/api/status', (request, response) => {
  response.json({
    status: 'running',
    timestamp: new Date()
  });
});
```
::

::card
## Working with JSON APIs
Express makes it easy to build REST APIs that send and receive JSON data.

### Example: Simple Products API
```js
import express from 'express';
const app = express();

// Enable JSON parsing
app.use(express.json());

// In-memory database
let products = [
  { id: 1, name: 'Laptop', price: 999 },
  { id: 2, name: 'Phone', price: 599 }
];

// GET - Retrieve all products
app.get('/api/products', (request, response) => {
  response.json(products);
});

// POST - Create a new product
app.post('/api/products', (request, response) => {
  const newProduct = {
    id: products.length + 1,
    name: request.body.name,
    price: request.body.price
  };
  products.push(newProduct);
  response.status(201).json(newProduct);
});

app.listen(3000, () => {
  console.log('API running at http://localhost:3000');
});
```

### Key points:
- `app.use(express.json())` - Parses JSON from request body
- `response.json()` - Sends JSON response
- `request.body` - Contains data sent in POST request

### Testing the API
`GET` request (in browser or terminal):
```bash
curl http://localhost:3000/api/products
```

`POST` request (use terminal, Postman, or Insomnia):
```bash
curl -X POST http://localhost:3000/api/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Tablet","price":399}'
```

### More Resources
- **[Postman](https://www.postman.com/)** - Popular API testing tool
- **[Insomnia](https://insomnia.rest/)** - Lightweight alternative
::