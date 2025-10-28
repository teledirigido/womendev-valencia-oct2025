---
title: Lesson - Mini Proyecto Final
---

::card
# Revisión del material del dia anterior

https://github.com/teledirigido/express-mongodb-mongoose

### Este repositorio contiene:

- Conexión a MongoDB Atlas
- Schema y Model de Usuario
- CRUD completo (Create, Read, Update, Delete)
- Rutas en Express
- Manejo de errores
- Variables de entorno (.env)

::

::card
# Relaciones entre Documentos

Hasta ahora hemos trabajado con una sola colección (usuarios). Pero en aplicaciones reales, necesitamos relacionar datos entre diferentes colecciones.

### Ejemplo del mundo real:

Imagina un blog:
- **Users** (Usuarios que escriben posts)
- **Posts** (Artículos del blog)
- **Comments** (Comentarios en los posts)

**Relaciones:**
- Un usuario puede tener **muchos posts**
- Un post pertenece a **un usuario**
- Un post puede tener **muchos comentarios**
- Un comentario pertenece a **un usuario** y a **un post**

## Formas de relacionar documentos en MongoDB

### 1. Documentos Embebidos (Embedded)

Los datos relacionados se guardan **dentro** del documento:

```json
{
  "_id": "507f1f77bcf86cd799439011",
  "title": "Mi primer post",
  "author": {
    "name": "Alice",
    "email": "alice@example.com"
  },
  "comments": [
    { "text": "Gran post!", "user": "Bob" },
    { "text": "Gracias!", "user": "Alice" }
  ]
}
```

Ventajas: 
- Rápido, todo en una consulta

Desventajas: 
- Duplicación de datos, difícil de actualizar

### 2. Referencias (References)

Los documentos se guardan por separado y se **referencian** por ID:

```json
// Post
{
  "_id": "507f1f77bcf86cd799439011",
  "title": "Mi primer post",
  "author": "65a1b2c3d4e5f6g7h8i9j0k1"  // ← ID del usuario
}

// User
{
  "_id": "65a1b2c3d4e5f6g7h8i9j0k1",
  "name": "Alice",
  "email": "alice@example.com"
}
```

Ventajas:
- Sin duplicación, fácil de actualizar

Desventajas:
- Requiere múltiples consultas (o `.populate()`)

## ¿Cuándo usar cada una?

| Situación | Recomendación |
|-----------|---------------|
| Datos que se usan independientemente (usuarios) | Referencias |
| Relaciones muchos-a-muchos | Referencias |
| Datos que no cambian (direcciones, timestamps) | Embebidos |
| Relaciones uno-a-muchos simples | Embebidos |

**El patrón de referencias** es común y flexible.
::

::card
# ObjectId y Referencias

Para relacionar documentos usamos el tipo `ObjectId` de Mongoose.

## ¿Qué es ObjectId?

Es el tipo de dato que MongoDB usa para los `_id` de los documentos.

```js
// Ejemplo de ObjectId
"507f1f77bcf86cd799439011"
```

- 12 bytes (24 caracteres hexadecimales)
- Único globalmente
- Generado automáticamente
- Contiene timestamp de creación

## Definir una referencia en un Schema

Vamos a crear dos modelos relacionados: **User** y **Post**.

### Schema de Post con referencia a User

```js
// models/Post.js
import mongoose from 'mongoose';

const postSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
    trim: true
  },
  content: {
    type: String,
    required: true
  },
  author: {
    type: mongoose.Schema.Types.ObjectId,  // ← Tipo ObjectId
    ref: 'User',                            // ← Referencia al modelo User
    required: true
  },
  tags: [String],
  published: {
    type: Boolean,
    default: false
  }
}, {
  timestamps: true
});

const Post = mongoose.model('Post', postSchema);

export default Post;
```

**Claves importantes:**
- `type: mongoose.Schema.Types.ObjectId` - Define que es una referencia
- `ref: 'User'` - Indica a qué modelo hace referencia
- `required: true` - Todo post debe tener un autor

## Crear un documento con referencia

```js
import User from './models/User.js';
import Post from './models/Post.js';

// 1. Primero necesitamos un usuario
const user = await User.create({
  name: 'Alice',
  email: 'alice@example.com'
});

// 2. Crear un post asociado a ese usuario
const post = await Post.create({
  title: 'Mi primer post',
  content: 'Este es el contenido de mi post',
  author: user._id,  // ← Asignamos el ID del usuario
  tags: ['node', 'mongodb']
});

console.log(post);
```

**Resultado:**
```json
{
  "_id": "65b1c2d3e4f5g6h7i8j9k0l1",
  "title": "Mi primer post",
  "content": "Este es el contenido de mi post",
  "author": "65a1b2c3d4e5f6g7h8i9j0k1",  // ← Solo el ID
  "tags": ["node", "mongodb"],
  "published": false,
  "createdAt": "2024-01-15T10:30:00.000Z",
  "updatedAt": "2024-01-15T10:30:00.000Z"
}
```

**Nota:** Por defecto, `author` solo contiene el ID, no los datos del usuario.
::

::card
# El método .populate()

`.populate()` es el método que nos permite **traer los datos completos** de las referencias.

## Sin populate

```js
const post = await Post.findById(postId);
console.log(post.author);
// Output: "65a1b2c3d4e5f6g7h8i9j0k1" ← Solo el ID
```

## Con populate

```js
const post = await Post.findById(postId).populate('author');
console.log(post.author);
// Output: { _id: "65a...", name: "Alice", email: "alice@example.com", ... }
```

## Sintaxis básica

```js
// Populate un campo
const posts = await Post.find().populate('author');

// Populate múltiples campos
const post = await Post.findById(id)
  .populate('author')
  .populate('comments');

// Populate con selección de campos
const posts = await Post.find()
  .populate('author', 'name email');  // Solo traer name y email
```

## Ejemplo completo

```js
// GET /posts/:id - Obtener un post con datos del autor
app.get('/posts/:id', async (request, response) => {
  try {
    const post = await Post.findById(request.params.id)
      .populate('author', 'name email');

    if (!post) {
      return response.status(404).json({ error: 'Post not found' });
    }

    response.json(post);
  } catch (error) {
    response.status(500).json({ error: error.message });
  }
});
```

**Respuesta con populate:**
```json
{
  "_id": "65b1c2d3e4f5g6h7i8j9k0l1",
  "title": "Mi primer post",
  "content": "Este es el contenido de mi post",
  "author": {
    "_id": "65a1b2c3d4e5f6g7h8i9j0k1",
    "name": "Alice",
    "email": "alice@example.com"
  },
  "tags": ["node", "mongodb"],
  "published": false,
  "createdAt": "2024-01-15T10:30:00.000Z",
  "updatedAt": "2024-01-15T10:30:00.000Z"
}
```

**¡Ahora tenemos los datos completos del autor!** ✨
::

::card
# Populate Avanzado

Veamos opciones más avanzadas de `.populate()`.

## Seleccionar campos específicos

```js
// Solo traer name y email del autor
const posts = await Post.find()
  .populate('author', 'name email');

// Excluir campos (con -)
const posts = await Post.find()
  .populate('author', '-password -__v');
```

## Populate anidado (nested)

Si un documento referenciado también tiene referencias:

```js
// Comment schema tiene referencia a User
const commentSchema = new mongoose.Schema({
  text: String,
  author: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }
});

// Post schema tiene array de comments
const postSchema = new mongoose.Schema({
  title: String,
  author: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  comments: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Comment' }]
});

// Populate anidado
const post = await Post.findById(id)
  .populate('author', 'name')
  .populate({
    path: 'comments',
    populate: {
      path: 'author',
      select: 'name email'
    }
  });
```

## Filtrar datos populados

```js
// Solo traer posts publicados del autor
const user = await User.findById(userId).populate({
  path: 'posts',
  match: { published: true },  // ← Filtro
  select: 'title createdAt',
  options: { sort: { createdAt: -1 } }  // ← Ordenar
});
```

## Populate múltiple

```js
const post = await Post.findById(id)
  .populate('author', 'name email')
  .populate('comments')
  .populate('category', 'name');
```

## Populate con límite

```js
// Solo traer los últimos 5 comentarios
const post = await Post.findById(id).populate({
  path: 'comments',
  options: { limit: 5, sort: { createdAt: -1 } }
});
```

## Rendimiento

**Importante:** `.populate()` hace consultas adicionales a la base de datos.

```js
// Esto hace 1 consulta
const posts = await Post.find();

// Esto hace 2 consultas (posts + users)
const posts = await Post.find().populate('author');

// Esto hace 3 consultas (posts + users + comments)
const posts = await Post.find()
  .populate('author')
  .populate('comments');
```

Usa populate solo cuando realmente necesites los datos relacionados.
::

::card
# Ejemplo Práctico: Blog API

Vamos a crear una mini API de blog con usuarios y posts relacionados.

## Setup inicial

### 1. Modelo User (ya lo tenemos)

```js
// models/User.js
import mongoose from 'mongoose';

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true
  },
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true
  },
  bio: String
}, {
  timestamps: true
});

const User = mongoose.model('User', userSchema);
export default User;
```

### 2. Modelo Post

```js
// models/Post.js
import mongoose from 'mongoose';

const postSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, 'Title is required'],
    trim: true,
    minlength: 3,
    maxlength: 100
  },
  content: {
    type: String,
    required: [true, 'Content is required'],
    minlength: 10
  },
  author: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  tags: [String],
  published: {
    type: Boolean,
    default: false
  },
  likes: {
    type: Number,
    default: 0
  }
}, {
  timestamps: true
});

const Post = mongoose.model('Post', postSchema);
export default Post;
```

## Rutas de la API

### POST /posts - Crear un post

```js
app.post('/posts', async (request, response) => {
  try {
    const { title, content, authorId, tags } = request.body;

    // Verificar que el autor existe
    const user = await User.findById(authorId);
    if (!user) {
      return response.status(404).json({ error: 'Author not found' });
    }

    // Crear el post
    const post = await Post.create({
      title,
      content,
      author: authorId,
      tags
    });

    response.status(201).json(post);
  } catch (error) {
    response.status(400).json({ error: error.message });
  }
});
```

### GET /posts - Obtener todos los posts con autores

```js
app.get('/posts', async (request, response) => {
  try {
    const posts = await Post.find()
      .populate('author', 'name email')
      .sort({ createdAt: -1 });

    response.json({
      count: posts.length,
      posts
    });
  } catch (error) {
    response.status(500).json({ error: error.message });
  }
});
```

### GET /posts/:id - Obtener un post específico

```js
app.get('/posts/:id', async (request, response) => {
  try {
    const post = await Post.findById(request.params.id)
      .populate('author', 'name email bio');

    if (!post) {
      return response.status(404).json({ error: 'Post not found' });
    }

    response.json(post);
  } catch (error) {
    response.status(500).json({ error: error.message });
  }
});
```

### GET /users/:id/posts - Obtener todos los posts de un usuario

```js
app.get('/users/:id/posts', async (request, response) => {
  try {
    const posts = await Post.find({ author: request.params.id })
      .populate('author', 'name email')
      .sort({ createdAt: -1 });

    response.json({
      count: posts.length,
      posts
    });
  } catch (error) {
    response.status(500).json({ error: error.message });
  }
});
```

### PUT /posts/:id/publish - Publicar un post

```js
app.put('/posts/:id/publish', async (request, response) => {
  try {
    const post = await Post.findByIdAndUpdate(
      request.params.id,
      { published: true },
      { new: true }
    ).populate('author', 'name email');

    if (!post) {
      return response.status(404).json({ error: 'Post not found' });
    }

    response.json(post);
  } catch (error) {
    response.status(400).json({ error: error.message });
  }
});
```

### DELETE /posts/:id - Eliminar un post

```js
app.delete('/posts/:id', async (request, response) => {
  try {
    const post = await Post.findByIdAndDelete(request.params.id);

    if (!post) {
      return response.status(404).json({ error: 'Post not found' });
    }

    response.json({
      message: 'Post deleted successfully',
      post
    });
  } catch (error) {
    response.status(500).json({ error: error.message });
  }
});
```
::

::card
# Probando la Blog API con Postman

Vamos a probar nuestra API paso a paso.

## 1. Crear un usuario

**POST** `http://localhost:3000/users`

```json
{
  "name": "Alice",
  "email": "alice@devwoman.com",
  "bio": "Full-stack developer"
}
```

**Respuesta:** Guarda el `_id` del usuario (lo necesitarás para crear posts)

## 2. Crear un post

**POST** `http://localhost:3000/posts`

```json
{
  "title": "Introducción a MongoDB",
  "content": "MongoDB es una base de datos NoSQL muy popular. En este post aprenderemos los conceptos básicos...",
  "authorId": "65a1b2c3d4e5f6g7h8i9j0k1",
  "tags": ["mongodb", "database", "nosql"]
}
```

## 3. Obtener todos los posts (con populate)

**GET** `http://localhost:3000/posts`

**Respuesta:**
```json
{
  "count": 1,
  "posts": [
    {
      "_id": "65b1c2d3e4f5g6h7i8j9k0l1",
      "title": "Introducción a MongoDB",
      "content": "MongoDB es una base de datos NoSQL...",
      "author": {
        "_id": "65a1b2c3d4e5f6g7h8i9j0k1",
        "name": "Alice",
        "email": "alice@devwoman.com"
      },
      "tags": ["mongodb", "database", "nosql"],
      "published": false,
      "likes": 0,
      "createdAt": "2024-01-15T10:30:00.000Z",
      "updatedAt": "2024-01-15T10:30:00.000Z"
    }
  ]
}
```

## 4. Obtener un post específico

**GET** `http://localhost:3000/posts/65b1c2d3e4f5g6h7i8j9k0l1`

## 5. Publicar un post

**PUT** `http://localhost:3000/posts/65b1c2d3e4f5g6h7i8j9k0l1/publish`

## 6. Obtener todos los posts de un usuario

**GET** `http://localhost:3000/users/65a1b2c3d4e5f6g7h8i9j0k1/posts`

## 7. Eliminar un post

**DELETE** `http://localhost:3000/posts/65b1c2d3e4f5g6h7i8j9k0l1`

## Ejercicio

Crea al menos:
- ✅ 2 usuarios diferentes
- ✅ 3 posts (de diferentes autores)
- ✅ Prueba todas las rutas
- ✅ Verifica que `.populate()` trae los datos del autor correctamente
::

::card
# Mini Proyecto: Elige tu API

Ahora es tu turno de construir una API completa desde cero. Puedes elegir uno de estos proyectos:

## Opción 1: Blog API (Posts + Comments)

**Modelos:**
- **User**: name, email, bio
- **Post**: title, content, author (ref User), tags
- **Comment**: text, author (ref User), post (ref Post)

**Features:**
- CRUD de usuarios, posts y comentarios
- Relaciones: User → Posts, Post → Comments
- Filtrar posts por autor
- Filtrar comentarios por post
- Buscar posts por tag

## Opción 2: E-commerce Products API (Products + Reviews)

**Modelos:**
- **User**: name, email, role (customer/seller)
- **Product**: name, description, price, seller (ref User), category
- **Review**: rating (1-5), comment, user (ref User), product (ref Product)

**Features:**
- CRUD de productos y reviews
- Relaciones: Seller → Products, Product → Reviews
- Filtrar productos por categoría
- Filtrar productos por vendedor
- Buscar productos por rango de precio
- Calcular rating promedio de un producto

## Opción 3: Task Manager API (Tasks + Categories)

**Modelos:**
- **User**: name, email, role
- **Category**: name, color, user (ref User)
- **Task**: title, description, completed, dueDate, category (ref Category), assignedTo (ref User)

**Features:**
- CRUD de categorías y tareas
- Relaciones: User → Categories, Category → Tasks
- Filtrar tareas por categoría
- Filtrar tareas completadas/pendientes
- Filtrar tareas por fecha
- Asignar tareas a usuarios

## Requisitos mínimos

Tu API debe incluir:
- ✅ Al menos 3 modelos relacionados
- ✅ CRUD completo para cada modelo
- ✅ Uso de `.populate()` en al menos 3 rutas
- ✅ Validaciones en los schemas
- ✅ Manejo de errores (try/catch)
- ✅ Códigos de estado HTTP correctos
- ✅ Variables de entorno (.env)
- ✅ README.md con instrucciones

## Bonus (opcional)

- ✅ Query strings para filtrado (`?category=tech&published=true`)
- ✅ Paginación (`?page=1&limit=10`)
- ✅ Middleware de autenticación simple
- ✅ Validación de input (campos requeridos, formatos)

**¡Manos a la obra!** 💪
::

::card
# Guía paso a paso: Estructura del proyecto

Si no sabes por dónde empezar, sigue esta guía.

## Paso 1: Setup inicial

```bash
# Crear carpeta del proyecto
mkdir mi-proyecto-api
cd mi-proyecto-api

# Inicializar proyecto
npm init -y

# Instalar dependencias
npm install express mongoose dotenv

# Crear archivos
touch app.js
touch db.js
touch .env
touch .env.example
touch .gitignore
mkdir models
```

## Paso 2: Configurar .env

```bash
# .env
PORT=3000
MONGODB_URI=mongodb+srv://usuario:password@cluster.mongodb.net/mibd?retryWrites=true&w=majority
```

## Paso 3: Configurar .gitignore

```bash
node_modules/
.env
*.log
.DS_Store
```

## Paso 4: Crear conexión a DB

```js
// db.js
import mongoose from 'mongoose';
import 'dotenv/config';

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('✅ MongoDB conectado');
  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
};

export default connectDB;
```

## Paso 5: Crear modelos

```js
// models/User.js
import mongoose from 'mongoose';

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true }
}, { timestamps: true });

export default mongoose.model('User', userSchema);
```

```js
// models/Post.js (o el modelo que elijas)
import mongoose from 'mongoose';

const postSchema = new mongoose.Schema({
  title: { type: String, required: true },
  author: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }
}, { timestamps: true });

export default mongoose.model('Post', postSchema);
```

## Paso 6: Configurar app.js

```js
// app.js
import express from 'express';
import 'dotenv/config';
import connectDB from './db.js';
import User from './models/User.js';
import Post from './models/Post.js';

const app = express();

// Conectar DB
connectDB();

// Middleware
app.use(express.json());

// Rutas
app.get('/', (req, res) => {
  res.json({ message: 'API funcionando' });
});

// ... tus rutas aquí ...

// Servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Servidor en http://localhost:${PORT}`);
});
```

## Paso 7: Añadir rutas

Empieza por las rutas básicas de cada modelo:
1. POST /users (crear)
2. GET /users (listar todos)
3. GET /users/:id (obtener uno)
4. Repite para tus otros modelos

## Paso 8: Añadir populate

Una vez que funcionen las rutas básicas, añade `.populate()`:

```js
app.get('/posts', async (req, res) => {
  try {
    const posts = await Post.find().populate('author', 'name email');
    res.json(posts);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
```

## Paso 9: Probar con Postman

Crea una colección en Postman y prueba todos los endpoints.

## Paso 10: Crear README.md

Documenta:
- Qué hace tu API
- Cómo instalar
- Endpoints disponibles
- Ejemplos de uso
::

::card
# Tips y Buenas Prácticas

Antes de empezar a programar, ten en cuenta estos consejos.

## Validaciones

Usa validaciones en tus schemas:

```js
const productSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Product name is required'],
    trim: true,
    minlength: [3, 'Name must be at least 3 characters'],
    maxlength: [50, 'Name cannot exceed 50 characters']
  },
  price: {
    type: Number,
    required: true,
    min: [0, 'Price cannot be negative']
  },
  category: {
    type: String,
    enum: {
      values: ['electronics', 'clothing', 'books'],
      message: '{VALUE} is not a valid category'
    }
  }
});
```

## Manejo de errores consistente

```js
app.get('/posts/:id', async (req, res) => {
  try {
    const post = await Post.findById(req.params.id);

    if (!post) {
      return res.status(404).json({ error: 'Post not found' });
    }

    res.json(post);
  } catch (error) {
    // Error de validación o casting
    if (error.name === 'CastError') {
      return res.status(400).json({ error: 'Invalid ID format' });
    }
    res.status(500).json({ error: error.message });
  }
});
```

## Estructura de respuestas

Sé consistente en tus respuestas:

```js
// Éxito
res.json({
  success: true,
  data: posts
});

// Error
res.status(404).json({
  success: false,
  error: 'Not found'
});
```

## Códigos de estado HTTP

Usa los códigos correctos:

| Código | Cuándo usar |
|--------|-------------|
| 200 | GET, PUT exitoso |
| 201 | POST exitoso (creado) |
| 204 | DELETE exitoso (sin contenido) |
| 400 | Datos inválidos |
| 404 | Recurso no encontrado |
| 500 | Error del servidor |

## Nombres de rutas

Sigue las convenciones REST:

```js
// ✅ Bueno
GET    /posts
GET    /posts/:id
POST   /posts
PUT    /posts/:id
DELETE /posts/:id
GET    /posts/:id/comments
GET    /users/:id/posts

// ❌ Evitar
GET /getAllPosts
GET /getPostById/:id
POST /createPost
```

## Organización del código

Para proyectos grandes, considera separar:
- `routes/` - Rutas
- `controllers/` - Lógica de negocio
- `models/` - Schemas
- `middleware/` - Middlewares personalizados

Pero para este ejercicio, todo en `app.js` está bien.
::

::card
# Resumen

¡Has aprendido conceptos muy importantes hoy!

### Repaso Día 8:
- ✅ Revisamos el código del repositorio `express-mongodb-mongoose`
- ✅ Repasamos CRUD operations con Mongoose
- ✅ Q&A sobre MongoDB y Mongoose

### Relaciones entre documentos:
- ✅ Documentos embebidos vs Referencias
- ✅ Cuándo usar cada estrategia
- ✅ Tipo de dato `ObjectId`
- ✅ Definir referencias en schemas con `ref`

### Populate:
- ✅ Qué es `.populate()` y por qué usarlo
- ✅ Sintaxis básica: `.populate('campo')`
- ✅ Seleccionar campos: `.populate('campo', 'name email')`
- ✅ Populate múltiple y anidado
- ✅ Consideraciones de rendimiento

### Blog API práctica:
- ✅ Modelos User y Post relacionados
- ✅ Rutas con populate
- ✅ Crear posts con autor
- ✅ Obtener posts con datos del autor
- ✅ Filtrar posts por usuario

### Mini Proyecto:
- ✅ Tres opciones de proyecto
- ✅ Requisitos mínimos
- ✅ Guía paso a paso
- ✅ Buenas prácticas

## Próximos pasos

En el **Día 10** aprenderemos sobre:
- Preparar la aplicación para producción
- CORS y seguridad
- Desplegar a plataformas cloud
- Documentación de APIs

::
