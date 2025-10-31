---
title: Lesson - Middlewares, URL Parameters & Queries
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
- **Autenticación** - Verificar si el usuario ha iniciado sesión
- **Registro (Logging)** - Rastrear todas las peticiones
- **Validación** - Verificar los datos de la petición
- **Manejo de errores** - Capturar y gestionar errores
- **Parseo** - Convertir datos de la petición (JSON, formularios)

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

1. `request`
- Contiene información sobre la petición entrante
- Acceder datos: `request.body`, `request.params`, `request.query`
- Leer encabezados: `request.headers`
- Obtener el método: `request.method`

2. `response`
- Se usa para enviar la respuesta al cliente
- Enviar datos: `response.send()`, `response.json()`
- Establecer estado: `response.status(404)`
- Redirigir: `response.redirect()`

3. `next`
- Una función que pasa el control al siguiente middleware
- Debes llamar `next()` si quieres continuar la cadena
- No llames `next()` si envías una respuesta

## Ejemplos de Middlewares

### Opción 1: Aplicar a TODAS las rutas
```js
app.use(myMiddleware);
```

### Opción 2: Aplicar a la ruta `/api` especificamente y a todas las sub-rutas
```js
app.use('/api', myMiddleware);
```

### Opción 3: Aplicar a una ruta concreta
```js
app.get('/users', myMiddleware, (req, res) => {
  res.send('Users list');
});
```

### Opción 4: Múltiples middlewares
```js
app.get('/admin', checkAuth, checkRole, (req, res) => {
  res.send('Admin panel');
});
```

**Recuerda:**
- ✅ Llama `next()` para continuar
- ✅ Envía respuesta para detener
- ❌ No llames `next()` Y envíes respuesta (causa errores)
::

::card
## Ejemplo Básico de Middleware
Vamos a crear un middleware simple que verifica un código secreto.

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

Entendiendo `app.use()`:
- `app.use(middleware)` - Se aplica a TODAS las rutas
- `app.use('/api', middleware)` - Se aplica solo a rutas que empiezan con `/api`

### Middlewares integrados comunes:
```js
app.use(express.json());              // Parsear cuerpos JSON
app.use(express.urlencoded());        // Parsear datos de formulario
app.use(express.static('public'));    // Servir archivos estáticos
```
::

::card
## Parámetros de Ruta (Params)
Los parámetros de ruta te permiten capturar valores dinámicos desde la ruta URL.

### Ejemplos de URLs
- `/` - Una ruta sin parámetros
- `/users/123` - Obtener usuario con ID 123
- `/products/laptop` - Obtener producto llamado "laptop"
- `/posts/5/comments/8` - Obtener comentario 8 del post 5
::

::card
## Definiendo parámetros de ruta `GET`
Usa dos puntos `:` antes del nombre del parámetro en tu ruta.

## Parámetro singular

Veamos el siguiente ejemplo donde tenemos la ruta `/users/:id`, la cual en la práctica podríamos utilizar para obtener la información de un usuario específico.

Ejemplo de rutas:
- `/users/1` Usuario con ID 1
- `/users/23` Usuario con ID 23
- `/users/2032` Usuario con ID 2032

La implementación de la ruta es la siguiente:

```js
app.get('/users/:id', (request, response) => {
  const userId = request.params.id;
  response.json({
    message: `Getting user with ID: ${userId}`
  });
});
```

### Resultados:
```bash
# Visita: http://localhost:3000/users/123
# Respuesta: { "message": "Getting user with ID: 123" }

# Visita: http://localhost:3000/users/999
# Respuesta: { "message": "Getting user with ID: 999" }
```

## Múltiples parámetros

Podemos definir múltiples parámetros en una misma ruta. Por ejemplo, `/posts/:postId/comments/:commentId` nos permite capturar tanto el ID del post como el ID del comentario.

Ejemplo de rutas:
- `/posts/5/comments/8` - Obtener comentario 8 del post 5
- `/posts/10/comments/15` - Obtener comentario 15 del post 10

```js
app.get('/posts/:postId/comments/:commentId', (request, response) => {
  const { postId, commentId } = request.params;
  response.json({
    post: postId,
    comment: commentId
  });
});
```

### Resultados:
```bash
# Visita: http://localhost:3000/posts/5/comments/8
# Respuesta: { "post": "5", "comment": "8" }

# Visita: http://localhost:3000/posts/10/comments/15
# Respuesta: { "post": "10", "comment": "15" }
```
::

::card
## Ejemplo Práctico: API de Usuarios
Vamos a construir una API completa con operaciones GET y PUT usando parámetros de ruta.

### Paso 1: Crear la base de datos de usuarios
```js
import express from 'express';
const app = express();

// Habilitar parseo de JSON
app.use(express.json());

// Base de datos estática de usuarios
let users = [
  { id: 1, name: 'Alice', email: 'alice@example.com', role: 'user' },
  { id: 2, name: 'Bob', email: 'bob@example.com', role: 'admin' },
  { id: 3, name: 'Charlie', email: 'charlie@example.com', role: 'user' }
];
```

### Paso 2: GET todos los usuarios
```js
app.get('/users', (request, response) => {
  response.json(users);
});
```

### Paso 3: GET un usuario específico por ID
```js
app.get('/users/:id', (request, response) => {
  const { id } = request.params;
  const userId = parseInt(id);
  const user = users.find(u => u.id === userId);

  if (user) {
    response.json(user);
  } else {
    response.status(404).json({ error: 'User not found' });
  }
});
```

### Paso 4: PUT - Actualizar rol de usuario
```js
app.put('/users/:id', (request, response) => {
  const { id } = request.params;
  const { role } = request.body;
  const userId = parseInt(id);

  const user = users.find(u => u.id === userId);

  if (!user) {
    return response.status(404).json({ error: 'User not found' });
  }

  // Actualizar el rol
  user.role = role;
  response.json(user);
});

app.listen(3000, () => {
  console.log('Server running at http://localhost:3000');
});
```
::

::card
## Postman
Postman es una herramienta popular para probar APIs con una interfaz amigable.

Es una aplicación que facilita probar APIs sin escribir código ni usar la terminal. Es perfecta para probar acciones (methods) como `GET`, `POST`, `PUT` y `DELETE`.

Basándonos en el ejercicio anterior vamos a probar las rutas que hemos implementado con Postman.
::

::card
## Descargar Postman
Visita [postman.com](https://www.postman.com/downloads/) y descarga la aplicación para tu sistema operativo.

### GET /users

1. Abre Postman
2. Crea una nueva petición
3. Establece el método a `GET`
4. Introduce la URL: `http://localhost:3000/users`
5. Haz clic en **Send**
6. ¡Verás la respuesta con todos los usuarios!

<figure>
  <img src="/images/lessons/postman.webp" alt="Node.js website" loading="lazy">
</figure>

### GET /users/:id

1. Establece el método a `GET`
2. Introduce la URL: `http://localhost:3000/users/1`
3. Haz clic en **Send**
4. Deberías ver los datos del usuario Alice

### PUT /users/:id

1. Establece el método a `PUT`
2. Introduce la URL: `http://localhost:3000/users/2`
3. Haz clic en la pestaña **Body**
4. Selecciona **raw** y elige **JSON** del desplegable
5. Introduce este JSON:
```json
{
  "role": "moderator"
}
```
6. Haz clic en **Send**
7. ¡Deberías ver los datos actualizados de Bob con el nuevo rol!

### Probar con ID inválido
Prueba: `http://localhost:3000/users/999`

Deberías obtener: `{ "error": "User not found" }`
::


::card
## Parámetros de Query (Query Args)
Los parámetros de query te permiten pasar datos opcionales en la URL después del símbolo `?`.

### Ejemplos de URLs con parámetros de query
- `/products?category=laptops` - Filtrar por categoría
- `/users?age=25&city=Valencia` - Filtrar por edad Y ciudad
- `/search?q=express&limit=10` - Búsqueda con límite

### Formato
```js
/path?key1=value1&key2=value2&key3=value3
```

- Comienza con `?`
- Separa con `&`
- Formato: `key=value`

### Cómo acceder a los parámetros de query
Vamos a extender nuestra API de usuarios para filtrar por rol usando parámetros de query.

```js
import express from 'express';
const app = express();

app.use(express.json());

// Misma base de datos de usuarios de antes
let users = [
  { id: 1, name: 'Alice', email: 'alice@example.com', role: 'user' },
  { id: 2, name: 'Bob', email: 'bob@example.com', role: 'admin' },
  { id: 3, name: 'Charlie', email: 'charlie@example.com', role: 'user' },
  { id: 4, name: 'Diana', email: 'diana@example.com', role: 'admin' },
  { id: 5, name: 'Eve', email: 'eve@example.com', role: 'moderator' }
];

// GET /users con filtro opcional de rol
app.get('/users', (request, response) => {
  const { role } = request.query;

  // Si no hay parámetro de query, devolver todos los usuarios
  if (!role) {
    return response.json(users);
  }

  // Filtrar usuarios por rol
  const filtered = users.filter(u => u.role === role);
  response.json(filtered);
});

app.listen(3000);
```

### Pruébalo:
```bash
# Obtener todos los usuarios
http://localhost:3000/users

# Filtrar por rol: admin
http://localhost:3000/users?role=admin

# Filtrar por rol: user
http://localhost:3000/users?role=user

# Filtrar por rol: moderator
http://localhost:3000/users?role=moderator
```

### Diferencias clave: Params vs Query

| Route Params | Query Params |
|-------------|--------------|
| `/users/:id` | `/users?role=admin` |
| Parte requerida de la URL | Filtros opcionales |
| Para identificar recursos | Para buscar/filtrar |
| `request.params` | `request.query` |

### Cuándo usar cada uno
- **Params**: Obtener un elemento específico (`/users/123`, `/posts/5`)
- **Query**: Filtrar, buscar, paginar (`/products?search=laptop&page=2`)
::

::card
## Ejemplo Páctico: API de Usuarios
Puedes encontrar el código completo de esta lección en el siguiente repositorio: https://github.com/teledirigido/express-users-api
::
