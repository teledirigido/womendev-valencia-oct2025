---
title: Lesson - Middlewares & Error Handling
---

::card
# ¿Qué son los Middlewares?
Los middlewares son funciones que se ejecutan entre recibir una petición y enviar una respuesta.

### Piénsalo como el control de seguridad del aeropuerto:
1. **Llega la petición** (el pasajero entra al aeropuerto)
2. **El middleware verifica** (punto de control de seguridad)
3. **Se envía la respuesta** (el pasajero aborda el avión)
::

::card
## ¿Por qué son importantes?
Los middlewares son fundamentales en Express porque nos permiten organizar y reutilizar código de forma eficiente.

### Casos de uso comunes:
- **Autenticación** - Verificar si el usuario ha iniciado sesión
- **Registro (Logging)** - Rastrear todas las peticiones HTTP
- **Validación** - Verificar los datos de la petición antes de procesarlos
- **Manejo de errores** - Capturar y gestionar errores de forma centralizada
- **Parseo** - Convertir datos de la petición (JSON, formularios)
- **CORS** - Permitir peticiones desde otros dominios
- **Seguridad** - Añadir headers de seguridad, rate limiting

### Flujo de Middleware
```
Request → Middleware 1 → Middleware 2 → Route Handler → Response
```

Cada middleware puede:
- Ejecutar código
- Modificar los objetos request/response
- Finalizar la petición (detener la cadena)
- Llamar al siguiente middleware con `next()`
::

::card
## Sintaxis de Middleware Explicada
Entendiendo los tres parámetros y cómo usar middleware.

### Los Tres Parámetros
```js
const myMiddleware = (request, response, next) => {
  // Tu código aquí
};
```

## 1. `request` (req)
Contiene información sobre la petición entrante:
- **Acceder datos**: `request.body`, `request.params`, `request.query`
- **Leer encabezados**: `request.headers`
- **Obtener el método**: `request.method`
- **URL completa**: `request.url`
- **IP del cliente**: `request.ip`

## 2. `response` (res)
Se usa para enviar la respuesta al cliente:
- **Enviar datos**: `response.send()`, `response.json()`
- **Establecer estado**: `response.status(404)`
- **Redirigir**: `response.redirect()`
- **Establecer headers**: `response.set()`

## 3. `next`
Una función que pasa el control al siguiente middleware:
- **Debes llamar `next()`** si quieres continuar la cadena
- **No llames `next()`** si envías una respuesta
- **Llama `next(error)`** para pasar a un middleware de manejo de errores

**Recuerda:**
- ✅ Llama `next()` para continuar
- ✅ Envía respuesta para detener
- ❌ No llames `next()` Y envíes respuesta (causa errores)
::

::card
## Aplicando Middlewares

Express te permite aplicar middlewares de diferentes formas dependiendo de dónde los necesites.

### Opción 1: Aplicar a TODAS las rutas
```js
app.use(myMiddleware);
```
El middleware se ejecutará para **cada petición**, sin importar la ruta o método HTTP.

### Opción 2: Aplicar a rutas específicas
```js
app.use('/api', myMiddleware);
```
El middleware solo se ejecutará para rutas que empiecen con `/api`.

Ejemplos:
- ✅ `/api/users` - Se ejecuta
- ✅ `/api/products` - Se ejecuta
- ❌ `/home` - NO se ejecuta

### Opción 3: Aplicar a una ruta concreta
```js
app.get('/users', myMiddleware, (request, response) => {
  response.send('Users list');
});
```
El middleware solo se ejecuta para esa ruta específica con ese método HTTP.

### Opción 4: Múltiples middlewares en cadena
```js
app.get('/admin', checkAuth, checkRole, (request, response) => {
  response.send('Admin panel');
});
```
Los middlewares se ejecutan en orden: primero `checkAuth`, luego `checkRole`, y finalmente el handler.
::

::card
## Ejemplo Básico de Middleware
Vamos a crear un middleware simple que verifica un código secreto en los headers.

```js
import express from 'express';
const app = express();

// Función middleware
const checkSecret = (request, response, next) => {
  const secret = request.headers['x-secret'];

  if (secret === 'my-secret-code') {
    console.log('✓ Secret is valid!');
    next(); // Continuar al siguiente middleware o ruta
  } else {
    response.status(403).json({
      error: 'Access denied: Invalid secret'
    });
  }
};

// Aplicar middleware a una ruta específica
app.get('/protected', checkSecret, (request, response) => {
  response.json({ message: 'Welcome! You have access.' });
});

// Ruta pública (sin middleware)
app.get('/public', (request, response) => {
  response.json({ message: 'This is public' });
});

app.listen(3000);
```

### Pruébalo:
```bash
# Sin secret - Acceso denegado
curl http://localhost:3000/protected

# Con secret - Acceso permitido
curl http://localhost:3000/protected -H "x-secret: my-secret-code"

# Ruta pública - Siempre funciona
curl http://localhost:3000/public
```

**Puntos clave:**
- El middleware tiene 3 parámetros: `(request, response, next)`
- Llama `next()` para continuar al siguiente middleware/ruta
- O envía una respuesta para detener la cadena
- Puedes leer datos del `request` (headers, body, params, etc.)
::

::card
## Middlewares Útiles: Logger
Vamos a crear un middleware logger para rastrear todas las peticiones.

```js
import express from 'express';
const app = express();

// Middleware logger
const logger = (request, response, next) => {
  const timestamp = new Date().toISOString();
  const method = request.method;
  const url = request.url;

  console.log(`[${timestamp}] ${method} ${url}`);

  next(); // Continuar al siguiente middleware
};

// Aplicar logger a TODAS las rutas
app.use(logger);

app.get('/', (request, response) => {
  response.send('Home page');
});

app.get('/about', (request, response) => {
  response.send('About page');
});

app.listen(3000);
```

### Salida en consola:
```bash
[2025-10-15T12:30:45.123Z] GET /
[2025-10-15T12:30:47.456Z] GET /about
[2025-10-15T12:30:50.789Z] GET /contact
```

**¿Por qué es útil?**
- Ver todas las peticiones en tiempo real
- Detectar patrones de uso
- Debugging durante desarrollo
- Monitorear el tráfico de tu API
::

::card
## Middlewares Integrados de Express

Express incluye varios middlewares útiles que puedes usar directamente.

### 1. `express.json()`
Parsea el cuerpo de las peticiones cuando el Content-Type es `application/json`.

```js
app.use(express.json());

app.post('/users', (request, response) => {
  console.log(request.body); // { "name": "Alice", "email": "alice@example.com" }
  response.json({ message: 'User created' });
});
```

### 2. `express.urlencoded()`
Parsea datos de formularios HTML (cuando el Content-Type es `application/x-www-form-urlencoded`).

```js
app.use(express.urlencoded({ extended: true }));

app.post('/contact', (request, response) => {
  console.log(request.body); // { name: 'John', message: 'Hello' }
  response.send('Form received');
});
```

### 3. `express.static()`
Sirve archivos estáticos (HTML, CSS, imágenes, JavaScript) desde una carpeta.

```js
app.use(express.static('public'));

// Ahora puedes acceder a:
// http://localhost:3000/styles.css
// http://localhost:3000/images/logo.png
// http://localhost:3000/script.js
```

### Ejemplo completo:
```js
import express from 'express';
const app = express();

// Middlewares integrados
app.use(express.json());              // Parsear JSON
app.use(express.urlencoded({ extended: true })); // Parsear formularios
app.use(express.static('public'));    // Servir archivos estáticos

app.listen(3000);
```
::

::card
## Middleware de Manejo de Errores

Express permite crear middlewares especiales para manejar errores de forma centralizada.

### Características especiales:
- **Tiene 4 parámetros** (en lugar de 3): `(error, request, response, next)`
- **Se define al final** de todas las rutas
- **Se ejecuta automáticamente** cuando ocurre un error

### Ejemplo básico:
```js
import express from 'express';
const app = express();

app.use(express.json());

// Rutas normales
app.get('/users/:id', (request, response) => {
  const { id } = request.params;

  if (id === '999') {
    // Lanzar un error
    throw new Error('User not found');
  }

  response.json({ id, name: 'Alice' });
});

// Middleware de manejo de errores (al final)
app.use((error, request, response, next) => {
  console.error('Error:', error.message);

  response.status(500).json({
    error: 'Something went wrong!',
    message: error.message
  });
});

app.listen(3000);
```

### Pruébalo:
```bash
# Funciona normalmente
curl http://localhost:3000/users/1

# Genera un error
curl http://localhost:3000/users/999
```

**Puntos clave:**
- El middleware de errores **debe tener 4 parámetros**
- Se coloca **después de todas las rutas**
- Captura errores lanzados con `throw new Error()`
- También captura errores pasados con `next(error)`
::

::card
## Manejo de Errores Avanzado

Vamos a crear un sistema de manejo de errores más completo.

```js
import express from 'express';
const app = express();

app.use(express.json());

// Base de datos de usuarios (simulada)
const users = [
  { id: 1, name: 'Alice' },
  { id: 2, name: 'Bob' }
];

// Ruta que puede generar errores
app.get('/users/:id', (request, response, next) => {
  try {
    const { id } = request.params;
    const userId = parseInt(id);

    // Validar que el ID sea un número
    if (isNaN(userId)) {
      const error = new Error('ID must be a number');
      error.status = 400;
      throw error;
    }

    // Buscar el usuario
    const user = users.find(u => u.id === userId);

    if (!user) {
      const error = new Error('User not found');
      error.status = 404;
      throw error;
    }

    response.json(user);
  } catch (error) {
    next(error); // Pasar el error al middleware de manejo de errores
  }
});

// Middleware de manejo de errores
app.use((error, request, response, next) => {
  const status = error.status || 500;
  const message = error.message || 'Internal Server Error';

  console.error(`[ERROR] ${status} - ${message}`);

  response.status(status).json({
    error: message,
    status: status
  });
});

app.listen(3000);
```

### Pruébalo:
```bash
# Usuario válido - 200 OK
curl http://localhost:3000/users/1

# ID no es número - 400 Bad Request
curl http://localhost:3000/users/abc

# Usuario no existe - 404 Not Found
curl http://localhost:3000/users/999
```

**Mejoras implementadas:**
- Validación de datos de entrada
- Diferentes códigos de estado según el error
- Uso de `try/catch` para capturar errores
- Pasar errores con `next(error)`
- Respuestas de error consistentes
::

::card
## Buenas Prácticas con Middlewares

### 1. Orden de los middlewares importa
Los middlewares se ejecutan en el orden que los defines:

```js
// ✅ Correcto
app.use(express.json());      // Primero parsear JSON
app.use(logger);               // Luego logging
app.get('/users', handler);    // Rutas
app.use(errorHandler);         // Manejo de errores al final

// ❌ Incorrecto
app.use(errorHandler);         // Error handler primero (no funcionará)
app.use(express.json());
app.get('/users', handler);
```

### 2. Siempre llama next() o envía respuesta
```js
// ✅ Correcto
app.use((req, res, next) => {
  console.log('Logging...');
  next(); // Continúa al siguiente middleware
});

// ❌ Incorrecto - La petición se queda colgada
app.use((req, res, next) => {
  console.log('Logging...');
  // No llama next() ni envía respuesta
});
```

### 3. Usa try/catch en operaciones asíncronas
```js
app.get('/users/:id', async (req, res, next) => {
  try {
    const user = await database.findUser(req.params.id);
    res.json(user);
  } catch (error) {
    next(error); // Pasa el error al error handler
  }
});
```

### 4. Crea middlewares reutilizables
```js
// Middleware reutilizable en archivo separado
export const requireAuth = (req, res, next) => {
  if (!req.headers.authorization) {
    return res.status(401).json({ error: 'Unauthorized' });
  }
  next();
};

// Úsalo en múltiples rutas
import { requireAuth } from './middlewares/auth.js';

app.get('/profile', requireAuth, getProfile);
app.post('/posts', requireAuth, createPost);
app.delete('/posts/:id', requireAuth, deletePost);
```
::

::card
## Resumen

Los middlewares son el corazón de Express. Te permiten:
- ✅ Organizar tu código de forma modular
- ✅ Reutilizar lógica común
- ✅ Manejar errores de forma centralizada
- ✅ Añadir funcionalidades de forma incremental

### Conceptos clave:
1. **3 parámetros**: `(request, response, next)`
2. **4 parámetros para errores**: `(error, request, response, next)`
3. **Orden importa**: Se ejecutan en el orden que los defines
4. **Llama next()**: O envía respuesta, nunca ambos
5. **Usa try/catch**: Para operaciones asíncronas

En la próxima lección aprenderemos sobre parámetros de ruta y query strings para hacer nuestras APIs más dinámicas.
::
