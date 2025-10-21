---
title: Lesson - MongoDB & Mongoose
---

::card
# MongoDB & Mongoose
Hasta ahora hemos trabajado con datos en memoria (arrays y objetos en JavaScript). En esta lección aprenderemos a usar una base de datos real: MongoDB.

### ¿Qué aprenderás?
- ¿Qué es MongoDB y por qué usarlo?
- Diferencias entre bases de datos SQL y NoSQL
- Cómo usar MongoDB Atlas (base de datos en la nube)
- Mongoose: ODM para trabajar con MongoDB desde Node.js
- CRUD operations con MongoDB

**Al final de esta lección convertiremos nuestra Countries API de memoria a MongoDB** 🚀
::

::card
# ¿Qué es MongoDB?

MongoDB es una base de datos **NoSQL** orientada a documentos.

### Características principales:

**Documentos JSON:**
Los datos se almacenan como documentos JSON (en realidad BSON - Binary JSON):
```json
{
  "_id": "507f1f77bcf86cd799439011",
  "name": "Alice",
  "email": "alice@example.com",
  "role": "user",
  "createdAt": "2024-01-15T10:30:00Z"
}
```

**Flexible:**
- No necesitas definir un esquema rígido (aunque Mongoose nos ayudará con esto)
- Puedes añadir campos diferentes a cada documento
- Ideal para datos que cambian frecuentemente

**Escalable:**
- Maneja grandes volúmenes de datos
- Rendimiento rápido para lectura y escritura
- Usado por empresas como Facebook, eBay, Adobe

**Popular:**
- Una de las bases de datos NoSQL más usadas
- Gran comunidad y recursos
- Bien integrada con Node.js
::

::card
# SQL vs NoSQL

Entender las diferencias te ayudará a elegir la base de datos correcta para tu proyecto.

## Bases de Datos SQL (Relacionales)

**Ejemplos:** MySQL, PostgreSQL, SQL Server

**Características:**
- Datos organizados en **tablas** con filas y columnas
- Estructura rígida: debes definir el esquema antes
- Relaciones entre tablas (claves foráneas)
- Lenguaje SQL para consultas

**Ejemplo de tabla:**
```
Users Table:
+----+---------+------------------+-------+
| id | name    | email            | role  |
+----+---------+------------------+-------+
| 1  | Alice   | alice@example.com| user  |
| 2  | Bob     | bob@example.com  | admin |
+----+---------+------------------+-------+
```

## Bases de Datos NoSQL (No Relacionales)

**Ejemplos:** MongoDB, CouchDB, Firebase

**Características:**
- Datos organizados como **documentos** (similar a JSON)
- Estructura flexible: puedes añadir campos cuando quieras
- No hay relaciones rígidas (aunque puedes referenciar documentos)
- Consultas con métodos de JavaScript

**Ejemplo de colección:**
```json
// Colección "users"
[
  {
    "_id": "507f1f77bcf86cd799439011",
    "name": "Alice",
    "email": "alice@example.com",
    "role": "user"
  },
  {
    "_id": "507f191e810c19729de860ea",
    "name": "Bob",
    "email": "bob@example.com",
    "role": "admin",
    "department": "IT"  // ← Campo extra, sin problemas
  }
]
```

## Comparación

| Aspecto | SQL | NoSQL (MongoDB) |
|---------|-----|-----------------|
| **Estructura** | Tablas (filas/columnas) | Documentos (JSON) |
| **Esquema** | Rígido, predefinido | Flexible, dinámico |
| **Relaciones** | Joins, claves foráneas | Referencias o documentos embebidos |
| **Escalabilidad** | Vertical (más potencia) | Horizontal (más servidores) |
| **Mejor para** | Datos estructurados, transacciones complejas | Datos flexibles, desarrollo rápido |

## ¿Cuándo usar MongoDB?

✅ **Usa MongoDB cuando:**
- Prototipas rápido y el esquema puede cambiar
- Trabajas con datos JSON/documentos
- Necesitas escalar horizontalmente
- Desarrollas aplicaciones web modernas con Node.js

❌ **Considera SQL cuando:**
- Necesitas transacciones complejas (bancos, finanzas)
- Los datos están muy relacionados
- Requieres integridad referencial estricta
::

::card
# MongoDB Atlas: Base de Datos en la Nube

MongoDB Atlas es el servicio cloud de MongoDB. Es **gratuito** para proyectos pequeños y no requiere instalación local.

### ¿Por qué usar Atlas?

- ✅ **Gratis**: Plan gratuito generoso (512 MB)
- ✅ **Sin instalación**: No necesitas instalar MongoDB localmente
- ✅ **Accesible**: Trabaja desde cualquier lugar
- ✅ **Producción-ready**: Usado en aplicaciones reales
- ✅ **Fácil**: Setup en minutos

### Conceptos clave:

**Cluster:**
Un conjunto de servidores que alojan tu base de datos.

**Database:**
Contenedor para colecciones (como una carpeta).

**Collection:**
Grupo de documentos (equivalente a una tabla en SQL).

**Document:**
Un registro individual (equivalente a una fila en SQL).

```
Cluster
  └── Database (ej: "my-app")
       └── Collection (ej: "users")
            ├── Document 1 (Alice)
            ├── Document 2 (Bob)
            └── Document 3 (Charlie)
```
::

::card
# Configurar MongoDB Atlas

Vamos a crear una cuenta y configurar nuestra primera base de datos en la nube.

## Paso 1: Crear cuenta

1. Visita [mongodb.com/cloud/atlas/register](https://www.mongodb.com/cloud/atlas/register)
2. Regístrate con email o Google
3. Completa el formulario inicial

## Paso 2: Crear un Cluster

1. Elige el plan **FREE (M0)**
2. Selecciona un proveedor cloud:
   - AWS, Google Cloud o Azure (cualquiera funciona)
3. Elige la región más cercana (ej: Europe - Ireland)
4. Dale un nombre a tu cluster (ej: `Cluster0`)
5. Haz clic en **Create Cluster**

⏱️ Espera 3-5 minutos mientras se crea el cluster.

## Paso 3: Configurar acceso

### 3.1 Crear usuario de base de datos

1. En el menú lateral, ve a **Database Access**
2. Haz clic en **Add New Database User**
3. Elige **Password** como método de autenticación
4. Usuario: `dbUser` (o el nombre que prefieras)
5. Contraseña: Genera una automática o crea una
   - **Importante:** Guarda esta contraseña, la necesitarás
6. Database User Privileges: **Read and write to any database**
7. Haz clic en **Add User**

### 3.2 Configurar acceso de red

1. En el menú lateral, ve a **Network Access**
2. Haz clic en **Add IP Address**
3. Haz clic en **Allow Access from Anywhere** (para desarrollo)
   - IP: `0.0.0.0/0`
   - **Nota:** En producción deberías usar IPs específicas
4. Haz clic en **Confirm**

## Paso 4: Obtener Connection String

1. Ve a **Database** en el menú lateral
2. Haz clic en **Connect** en tu cluster
3. Selecciona **Drivers**
4. Elige **Node.js** y la versión más reciente
5. Copia el **connection string**:

```bash
mongodb+srv://dbUser:<password>@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority
```

6. **Importante:** Reemplaza `<password>` con la contraseña que creaste

**Guarda este connection string en un lugar seguro** - lo usaremos en nuestra aplicación.
::

::card
# ¿Qué es Mongoose?

Mongoose es un **ODM (Object Data Modeling)** para MongoDB en Node.js.

### ¿Por qué usar Mongoose?

Sin Mongoose, trabajar con MongoDB desde Node.js requiere mucho código manual. Mongoose lo simplifica enormemente.

**Sin Mongoose (driver nativo):**
```js
// Código complejo y verboso
const { MongoClient } = require('mongodb');
const client = new MongoClient(uri);
await client.connect();
const database = client.db('mydb');
const users = database.collection('users');
const user = await users.findOne({ name: 'Alice' });
await client.close();
```

**Con Mongoose:**
```js
// Simple y limpio
const user = await User.findOne({ name: 'Alice' });
```

### Características de Mongoose:

- ✅ **Esquemas (Schemas)**: Define la estructura de tus documentos
- ✅ **Validación**: Valida datos automáticamente
- ✅ **Tipo de datos**: TypeScript-like en JavaScript
- ✅ **Métodos útiles**: find, findById, create, update, delete
- ✅ **Middleware**: Hooks para ejecutar código antes/después de operaciones
- ✅ **Populación**: Relaciones entre documentos fácilmente

## Conceptos clave
|Nombre|Descripcion|Ejemplo|
|------|-----------|-------|
|Schema|Define la estructura y tipos de datos de un documento.|Blueprint (Plano)|
|Model|Representa una colección y proporciona métodos para interactuar con la base de datos.|Constructor (Fábrica)|
|Document|Una instancia de un Model (un registro específico).| Objeto creado (Producto)|
::

::card
# Instalar y Conectar Mongoose

Vamos a integrar MongoDB en nuestra aplicación Express.

## Paso 1: Instalar Mongoose

```bash
npm install mongoose
```

## Paso 2: Configurar variables de entorno

Añade tu connection string al archivo `.env`:

```bash
# .env
PORT=3000
MONGODB_URI=mongodb+srv://dbUser:TU_PASSWORD@cluster0.xxxxx.mongodb.net/myapp?retryWrites=true&w=majority
```

**Importante:**
- Reemplaza `TU_PASSWORD` con tu contraseña real
- Puedes cambiar `myapp` por el nombre de tu base de datos
- Nunca compartas tu `.env` en Git

## Paso 3: Conectar a MongoDB

Crea un archivo `db.js` para manejar la conexión:

```js
// db.js
import mongoose from 'mongoose';
import 'dotenv/config';

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('✅ MongoDB conectado correctamente');
  } catch (error) {
    console.error('❌ Error conectando a MongoDB:', error.message);
    process.exit(1); // Salir si no hay conexión
  }
};

export default connectDB;
```

## Paso 4: Usar la conexión en tu app

```js
// app.js
import express from 'express';
import 'dotenv/config';
import connectDB from './db.js';

const app = express();

// Conectar a la base de datos
connectDB();

// Middlewares
app.use(express.json());

// Rutas
app.get('/', (req, res) => {
  res.send('¡Servidor corriendo con MongoDB!');
});

// Iniciar servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`);
});
```

## Paso 5: Probar la conexión

Ejecuta tu aplicación:

```bash
node app.js
```

Deberías ver:
```bash
✅ MongoDB conectado correctamente
🚀 Servidor corriendo en http://localhost:3000
```
¡Felicidades! Ya estás conectado a MongoDB 🎉
::

::card
# Schemas y Models

Los Schemas definen la estructura de tus documentos. Los Models te permiten interactuar con la base de datos.

## Crear un Schema

Un Schema define:
- Qué campos tendrá cada documento
- Tipo de dato de cada campo
- Validaciones
- Valores por defecto

### Ejemplo: Schema de Usuario

```js
// models/User.js
import mongoose from 'mongoose';

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,  // Campo obligatorio
    trim: true       // Elimina espacios al inicio/final
  },
  email: {
    type: String,
    required: true,
    unique: true,    // No puede haber emails duplicados
    lowercase: true  // Convierte a minúsculas
  },
  role: {
    type: String,
    enum: ['user', 'admin', 'moderator'], // Solo estos valores
    default: 'user'  // Valor por defecto
  },
  age: {
    type: Number,
    min: 18,         // Mínimo 18
    max: 120         // Máximo 120
  },
  isActive: {
    type: Boolean,
    default: true
  }
}, {
  timestamps: true   // Añade createdAt y updatedAt automáticamente
});

// Crear el Model
const User = mongoose.model('User', userSchema);

export default User;
```

## Tipos de datos comunes

| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| `String` | Texto | `"Alice"` |
| `Number` | Números | `25` |
| `Boolean` | true/false | `true` |
| `Date` | Fechas | `new Date()` |
| `Array` | Arrays | `["tag1", "tag2"]` |
| `ObjectId` | Referencias | `mongoose.Types.ObjectId` |
| `Mixed` | Cualquier tipo | `{ any: "data" }` |

## Validaciones comunes

```js
const schema = new mongoose.Schema({
  username: {
    type: String,
    required: [true, 'Username es obligatorio'],
    minlength: [3, 'Mínimo 3 caracteres'],
    maxlength: [20, 'Máximo 20 caracteres'],
    unique: true
  },
  email: {
    type: String,
    required: true,
    match: [/\S+@\S+\.\S+/, 'Email no válido']  // Regex validation
  },
  password: {
    type: String,
    required: true,
    minlength: 6
  }
});
```

## ¿Qué hace `mongoose.model()`?

```js
const User = mongoose.model('User', userSchema);
```

Esto crea:
1. **Nombre de la colección**: `users` (plural, minúsculas)
2. **Constructor**: Puedes crear documentos con `new User()`
3. **Métodos**: `User.find()`, `User.create()`, etc.

El Model es tu interfaz para interactuar con la base de datos.
::

::card
# CRUD con Mongoose: Create

Vamos a aprender a crear documentos en MongoDB usando Mongoose.

## Método 1: `create()`

La forma más simple:

```js
import User from './models/User.js';

// Crear un usuario
const newUser = await User.create({
  name: 'Alice',
  email: 'alice@example.com',
  role: 'user',
  age: 25
});

console.log('Usuario creado:', newUser);
```

**Respuesta:**
```json
{
  "_id": "507f1f77bcf86cd799439011",
  "name": "Alice",
  "email": "alice@example.com",
  "role": "user",
  "age": 25,
  "isActive": true,
  "createdAt": "2024-01-15T10:30:00.000Z",
  "updatedAt": "2024-01-15T10:30:00.000Z",
  "__v": 0
}
```

## Método 2: `new` + `save()`

Más control sobre el proceso:

```js
// Crear instancia
const user = new User({
  name: 'Bob',
  email: 'bob@example.com',
  age: 30
});

// Modificar antes de guardar (opcional)
user.role = 'admin';

// Guardar en la base de datos
await user.save();
```

## Crear múltiples documentos

```js
const users = await User.create([
  { name: 'Alice', email: 'alice@example.com' },
  { name: 'Bob', email: 'bob@example.com' },
  { name: 'Charlie', email: 'charlie@example.com' }
]);

console.log(`${users.length} usuarios creados`);
```

## Manejo de errores

```js
try {
  const user = await User.create({
    name: 'Alice',
    email: 'invalid-email', // ❌ No pasa validación
    age: 15  // ❌ Menor que el mínimo (18)
  });
} catch (error) {
  console.error('Error de validación:', error.message);
  // Error: User validation failed: ...
}
```

## En una ruta de Express

```js
// POST /users - Crear usuario
app.post('/users', async (request, response) => {
  try {
    const newUser = await User.create(request.body);
    response.status(201).json(newUser);
  } catch (error) {
    response.status(400).json({ error: error.message });
  }
});
```

**Probar con Postman:**
```json
POST http://localhost:3000/users
Body (JSON):
{
  "name": "Alice",
  "email": "alice@example.com",
  "age": 25
}
```
::

::card
# CRUD con Mongoose: Read

Existen múltiples métodos para leer datos de MongoDB.

## `find()` - Obtener todos los documentos

```js
// Obtener TODOS los usuarios
const users = await User.find();
console.log(users); // Array de documentos
```

**Resultado:**
```json
[
  { "_id": "...", "name": "Alice", "email": "alice@example.com", ... },
  { "_id": "...", "name": "Bob", "email": "bob@example.com", ... }
]
```

## `find()` con filtros

```js
// Usuarios con rol 'admin'
const admins = await User.find({ role: 'admin' });

// Usuarios mayores de 25 años
const adults = await User.find({ age: { $gte: 25 } });

// Múltiples condiciones
const activeAdmins = await User.find({
  role: 'admin',
  isActive: true
});
```

## `findById()` - Buscar por ID

```js
const userId = '507f1f77bcf86cd799439011';
const user = await User.findById(userId);

if (user) {
  console.log('Usuario encontrado:', user.name);
} else {
  console.log('Usuario no existe');
}
```

## `findOne()` - Obtener un solo documento

```js
// Primer usuario con email específico
const user = await User.findOne({ email: 'alice@example.com' });

// Devuelve null si no encuentra nada
if (!user) {
  console.log('Usuario no encontrado');
}
```

## Operadores de consulta

| Operador | Significado | Ejemplo |
|----------|-------------|---------|
| `$eq` | Igual | `{ age: { $eq: 25 } }` |
| `$gt` | Mayor que | `{ age: { $gt: 18 } }` |
| `$gte` | Mayor o igual | `{ age: { $gte: 18 } }` |
| `$lt` | Menor que | `{ age: { $lt: 30 } }` |
| `$lte` | Menor o igual | `{ age: { $lte: 30 } }` |
| `$in` | En array | `{ role: { $in: ['admin', 'moderator'] } }` |
| `$ne` | No igual | `{ role: { $ne: 'user' } }` |

## Limitar y ordenar resultados

```js
// Primeros 10 usuarios
const users = await User.find().limit(10);

// Ordenar por edad (ascendente)
const sorted = await User.find().sort({ age: 1 });

// Ordenar descendente
const sortedDesc = await User.find().sort({ age: -1 });

// Combinar
const result = await User.find({ role: 'user' })
  .sort({ createdAt: -1 })  // Más recientes primero
  .limit(5);                 // Solo 5
```

## En rutas de Express

```js
// GET /users - Obtener todos los usuarios
app.get('/users', async (request, response) => {
  try {
    const users = await User.find();
    response.json(users);
  } catch (error) {
    response.status(500).json({ error: error.message });
  }
});

// GET /users/:id - Obtener un usuario por ID
app.get('/users/:id', async (request, response) => {
  try {
    const user = await User.findById(request.params.id);

    if (!user) {
      return response.status(404).json({ error: 'User not found' });
    }

    response.json(user);
  } catch (error) {
    response.status(500).json({ error: error.message });
  }
});
```
::

::card
# CRUD con Mongoose: Update

Existen varios métodos para actualizar documentos.

## `findByIdAndUpdate()` - Actualizar por ID

```js
const userId = '507f1f77bcf86cd799439011';

const updatedUser = await User.findByIdAndUpdate(
  userId,
  { role: 'admin', age: 30 },
  { new: true }  // Devuelve el documento actualizado
);

console.log(updatedUser);
```

**Opciones importantes:**
- `{ new: true }` - Devuelve el documento DESPUÉS de actualizar
- `{ runValidators: true }` - Ejecuta validaciones del schema

## `findOneAndUpdate()` - Actualizar con filtro

```js
const user = await User.findOneAndUpdate(
  { email: 'alice@example.com' },  // Filtro
  { role: 'moderator' },            // Actualización
  { new: true, runValidators: true }
);
```

## `updateOne()` - Actualizar uno (sin devolver)

```js
const result = await User.updateOne(
  { email: 'bob@example.com' },
  { $set: { role: 'admin' } }
);

console.log(result);
// { acknowledged: true, matchedCount: 1, modifiedCount: 1 }
```

## `updateMany()` - Actualizar múltiples

```js
// Activar todos los usuarios
const result = await User.updateMany(
  {},  // Filtro vacío = todos
  { $set: { isActive: true } }
);

console.log(`${result.modifiedCount} usuarios actualizados`);
```

## Operadores de actualización

| Operador | Descripción | Ejemplo |
|----------|-------------|---------|
| `$set` | Establece un valor | `{ $set: { role: 'admin' } }` |
| `$inc` | Incrementa un número | `{ $inc: { age: 1 } }` |
| `$push` | Añade a un array | `{ $push: { tags: 'new' } }` |
| `$pull` | Elimina de un array | `{ $pull: { tags: 'old' } }` |

## En una ruta de Express

```js
// PUT /users/:id - Actualizar usuario
app.put('/users/:id', async (request, response) => {
  try {
    const updatedUser = await User.findByIdAndUpdate(
      request.params.id,
      request.body,
      { new: true, runValidators: true }
    );

    if (!updatedUser) {
      return response.status(404).json({ error: 'User not found' });
    }

    response.json(updatedUser);
  } catch (error) {
    response.status(400).json({ error: error.message });
  }
});
```

**Probar con Postman:**
```json
PUT http://localhost:3000/users/507f1f77bcf86cd799439011
Body (JSON):
{
  "role": "admin",
  "age": 30
}
```
::

::card
# CRUD con Mongoose: Delete

Métodos para eliminar documentos de la base de datos.

## `findByIdAndDelete()` - Eliminar por ID

```js
const userId = '507f1f77bcf86cd799439011';
const deletedUser = await User.findByIdAndDelete(userId);

if (deletedUser) {
  console.log('Usuario eliminado:', deletedUser.name);
} else {
  console.log('Usuario no encontrado');
}
```

## `findOneAndDelete()` - Eliminar con filtro

```js
const deleted = await User.findOneAndDelete({
  email: 'alice@example.com'
});
```

## `deleteOne()` - Eliminar uno (sin devolver)

```js
const result = await User.deleteOne({ email: 'bob@example.com' });

console.log(result);
// { acknowledged: true, deletedCount: 1 }
```

## `deleteMany()` - Eliminar múltiples

```js
// Eliminar todos los usuarios inactivos
const result = await User.deleteMany({ isActive: false });

console.log(`${result.deletedCount} usuarios eliminados`);
```

**⚠️ Cuidado:** `deleteMany({})` sin filtro elimina TODOS los documentos.

## En una ruta de Express

```js
// DELETE /users/:id - Eliminar usuario
app.delete('/users/:id', async (request, response) => {
  try {
    const deletedUser = await User.findByIdAndDelete(request.params.id);

    if (!deletedUser) {
      return response.status(404).json({ error: 'User not found' });
    }

    response.json({
      message: 'User deleted successfully',
      user: deletedUser
    });
  } catch (error) {
    response.status(500).json({ error: error.message });
  }
});
```

**Probar con Postman:**
```
DELETE http://localhost:3000/users/507f1f77bcf86cd799439011
```

## Comparación de métodos

| Método | Devuelve documento | Puede filtrar | Múltiples |
|--------|-------------------|---------------|-----------|
| `findByIdAndDelete()` | ✅ Sí | Solo por _id | No |
| `findOneAndDelete()` | ✅ Sí | ✅ Sí | No |
| `deleteOne()` | ❌ Solo info | ✅ Sí | No |
| `deleteMany()` | ❌ Solo info | ✅ Sí | ✅ Sí |

**Recomendación:** Usa `findByIdAndDelete()` para rutas REST con ID en la URL.
::

::card
# Proyecto Práctico: Convertir Countries API a MongoDB

Vamos a convertir nuestra Countries API (Día 7) de datos en memoria a MongoDB.

## Paso 1: Crear el Schema

Crea `models/Country.js`:

```js
// models/Country.js
import mongoose from 'mongoose';

const countrySchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Country name is required'],
    unique: true,
    trim: true
  },
  capital: {
    type: String,
    required: [true, 'Capital is required'],
    trim: true
  },
  code: {
    type: String,
    required: [true, 'Country code is required'],
    uppercase: true,
    minlength: 2,
    maxlength: 2
  },
  flag: {
    type: String,
    required: true
  }
}, {
  timestamps: true
});

const Country = mongoose.model('Country', countrySchema);

export default Country;
```

## Paso 2: Actualizar las rutas

### GET /countries - Obtener todos

**Antes (memoria):**
```js
app.get('/countries', (request, response) => {
  response.json(countries);
});
```

**Después (MongoDB):**
```js
app.get('/countries', async (request, response) => {
  try {
    const countries = await Country.find();
    response.json(countries);
  } catch (error) {
    response.status(500).json({ error: error.message });
  }
});
```

### GET /countries/:id - Obtener uno

**Antes (memoria):**
```js
app.get('/countries/:id', (request, response) => {
  const country = countries.find(c => c.id === parseInt(request.params.id));
  if (!country) {
    return response.status(404).json({ error: 'Country not found' });
  }
  response.json(country);
});
```

**Después (MongoDB):**
```js
app.get('/countries/:id', async (request, response) => {
  try {
    const country = await Country.findById(request.params.id);

    if (!country) {
      return response.status(404).json({ error: 'Country not found' });
    }

    response.json(country);
  } catch (error) {
    response.status(500).json({ error: error.message });
  }
});
```

### POST /countries - Crear

**Antes (memoria):**
```js
app.post('/countries', (request, response) => {
  const newCountry = {
    id: countries.length + 1,
    ...request.body
  };
  countries.push(newCountry);
  response.status(201).json(newCountry);
});
```

**Después (MongoDB):**
```js
app.post('/countries', async (request, response) => {
  try {
    const newCountry = await Country.create(request.body);
    response.status(201).json(newCountry);
  } catch (error) {
    response.status(400).json({ error: error.message });
  }
});
```

### PUT /countries/:id - Actualizar

**Antes (memoria):**
```js
app.put('/countries/:id', (request, response) => {
  const country = countries.find(c => c.id === parseInt(request.params.id));
  if (!country) {
    return response.status(404).json({ error: 'Country not found' });
  }
  Object.assign(country, request.body);
  response.json(country);
});
```

**Después (MongoDB):**
```js
app.put('/countries/:id', async (request, response) => {
  try {
    const updatedCountry = await Country.findByIdAndUpdate(
      request.params.id,
      request.body,
      { new: true, runValidators: true }
    );

    if (!updatedCountry) {
      return response.status(404).json({ error: 'Country not found' });
    }

    response.json(updatedCountry);
  } catch (error) {
    response.status(400).json({ error: error.message });
  }
});
```

### DELETE /countries/:id - Eliminar

**Antes (memoria):**
```js
app.delete('/countries/:id', (request, response) => {
  const index = countries.findIndex(c => c.id === parseInt(request.params.id));
  if (index === -1) {
    return response.status(404).json({ error: 'Country not found' });
  }
  countries.splice(index, 1);
  response.json({ message: 'Country deleted' });
});
```

**Después (MongoDB):**
```js
app.delete('/countries/:id', async (request, response) => {
  try {
    const deletedCountry = await Country.findByIdAndDelete(request.params.id);

    if (!deletedCountry) {
      return response.status(404).json({ error: 'Country not found' });
    }

    response.json({
      message: 'Country deleted successfully',
      country: deletedCountry
    });
  } catch (error) {
    response.status(500).json({ error: error.message });
  }
});
```

## Diferencias clave

| Aspecto | Memoria | MongoDB |
|---------|---------|---------|
| **Almacenamiento** | Array en RAM | Base de datos persistente |
| **IDs** | Números manuales | ObjectId automático |
| **Búsqueda** | `find()`, `findIndex()` | `findById()`, `find()` |
| **Async** | Síncrono | Asíncrono (async/await) |
| **Validación** | Manual | Automática (Schema) |
| **Persistencia** | Se pierde al reiniciar | Permanente |

¡Ahora tus datos persisten incluso después de reiniciar el servidor! 🎉
::

::card
# Resumen

Has aprendido los fundamentos de MongoDB y Mongoose para crear aplicaciones con persistencia de datos.

### MongoDB:
- ✅ Base de datos NoSQL orientada a documentos
- ✅ Almacena datos en formato JSON (BSON)
- ✅ Flexible y escalable
- ✅ MongoDB Atlas para hosting en la nube (gratis)

### SQL vs NoSQL:
- ✅ SQL: Tablas, esquema rígido, relaciones
- ✅ NoSQL: Documentos, esquema flexible, escalabilidad horizontal
- ✅ Usa MongoDB para desarrollo rápido y datos flexibles

### Mongoose:
- ✅ ODM (Object Data Modeling) para MongoDB
- ✅ Simplifica las operaciones con la base de datos
- ✅ Schemas para definir estructura
- ✅ Validaciones automáticas
- ✅ Models para interactuar con colecciones

### CRUD Operations:
- ✅ **Create**: `create()`, `new Model().save()`
- ✅ **Read**: `find()`, `findById()`, `findOne()`
- ✅ **Update**: `findByIdAndUpdate()`, `updateOne()`
- ✅ **Delete**: `findByIdAndDelete()`, `deleteOne()`

### Buenas prácticas:
1. Usa variables de entorno para connection strings
2. Valida datos con Schemas
3. Maneja errores con try/catch
4. Usa `async/await` para operaciones de base de datos
5. Cierra conexiones apropiadamente (Mongoose lo hace automáticamente)

### Patrón común de ruta:
```js
app.METHOD('/path', async (req, res) => {
  try {
    const result = await Model.operation();
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
```
::

::card
# Ejemplo Completo: Usuarios Mongoose 

Puedes encontrar el código completo de esta lección en el siguiente repositorio:

https://github.com/teledirigido/express-mongodb-mongoose

¡Clona el repositorio y experimenta con el código!
::
