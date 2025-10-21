---
title: Lesson - Route Params, Query Strings & Postman
---

::card
# Parámetros de Ruta (Route Params)
Los parámetros de ruta te permiten capturar valores dinámicos desde la URL.

Son útiles cuando necesitas identificar un recurso específico (como un usuario, producto o post).

### Ejemplos de URLs con parámetros:
- `/users/123` - Obtener usuario con ID 123
- `/products/laptop` - Obtener producto llamado "laptop"
- `/posts/5/comments/8` - Obtener comentario 8 del post 5
- `/api/articles/intro-to-express` - Obtener artículo por slug

### ¿Cuándo usar Route Params?
Usa parámetros de ruta cuando necesites **identificar un recurso específico** de forma obligatoria.

Ejemplos:
- Ver el perfil de un usuario específico
- Obtener los detalles de un producto
- Eliminar un post concreto
- Actualizar información de un pedido
::

::card
# Definiendo Parámetros de Ruta

Usa dos puntos `:` antes del nombre del parámetro en tu ruta.

### Sintaxis básica:
```js
app.get('/ruta/:nombreParametro', (request, response) => {
  const valor = request.params.nombreParametro;
  // Tu lógica aquí
});
```

### Parámetro singular

Veamos el siguiente ejemplo donde tenemos la ruta `/users/:id`, la cual podemos utilizar para obtener la información de un usuario específico.

**Ejemplos de rutas válidas:**
- `/users/1` → Usuario con ID 1
- `/users/23` → Usuario con ID 23
- `/users/2032` → Usuario con ID 2032

**Implementación:**
```js
app.get('/users/:id', (request, response) => {
  const userId = request.params.id;
  response.json({
    message: `Getting user with ID: ${userId}`
  });
});
```
::

::card
# Ejemplo práctico: Nuestra primera ruta

Consideremos la siguiente app en express:
```js
// app.js

import express from 'express';
const app = express();

app.get('/users/:id', (request, response) => {
  const userId = request.params.id;
  response.json({
    message: `Getting user with ID: ${userId}`
  });
});

app.listen(3001, () => {
  console.log(`✅ Servidor corriendo en http://localhost:3001`);
});
```

<details>
  <summary>
    Recordemos aquí los pasos para una app en express.
  </summary>

  ```bash
  # Crear carpeta
  mkdir practice-routes
  cd practice-routes

  # Inicializar proyecto
  npm init -y
  npm pkg set type=module

  # Instalar Express
  npm install express

  # Crear archivo principal
  touch app.js
  ```

</details>

## Pasos a seguir

1. Ejecuta el servidor con `node --watch app.js` o `nodemon app.js`;
2. Visita las siguientes URL en tu navegador


```bash
# Visita: http://localhost:3001/users/123
# Respuesta: { "message": "Getting user with ID: 123" }

# Visita: http://localhost:3001/users/999
# Respuesta: { "message": "Getting user with ID: 999" }
```

3. El resultado debería ser el siguiente:

<figure>
  <img src="/images/lessons/express-primera-ruta.png">
  <figcaption>http://localhost:3001/users/123</figcaption>
</figure>

**Importante:** Los parámetros de ruta siempre son **strings**. Si necesitas un número, debes convertirlo:
```js
const userId = parseInt(request.params.id);
```
::

::card
# Múltiples Parámetros

También podemos definir múltiples parámetros en una misma ruta para capturar diferentes valores de la URL.

Observemos las siguientes rutas:

```js
// Ruta para obtener todos los posts de un usuario
app.get('/users/:userId/posts', (request, response) => {
  const { userId } = request.params;
  response.json({
    message: `Getting all posts from user ${userId}`,
    userId: userId
  });
});

// Ruta para obtener un post específico de un usuario
app.get('/users/:userId/posts/:postId', (request, response) => {
  const { userId, postId } = request.params;
  response.json({
    message: `Getting post ${postId} from user ${userId}`,
    userId: userId,
    postId: postId
  });
});

// Ruta para obtener un comentario específico de un post
app.get('/posts/:postId/comments/:commentId', (request, response) => {
  const { postId, commentId } = request.params;
  response.json({
    message: `Getting comment ${commentId} from post ${postId}`,
    post: postId,
    comment: commentId
  });
});
```

Prueba añadiendo estas rutas ⬆️ al archivo `app.js` del ejemplo anterior.


## Probando las rutas

1. Todos los posts de un usuario:
```bash
# Visita: http://localhost:3001/users/5/posts
# Respuesta: {
#   "message": "Getting all posts from user 5",
#   "userId": "5"
# }
```
2. Post específico de un usuario:
```bash
# Visita: http://localhost:3001/users/5/posts/10
# Respuesta: {
#   "message": "Getting post 10 from user 5",
#   "userId": "5",
#   "postId": "10"
# }
```
3. Comentario de un post:
```bash
# Visita: http://localhost:3001/posts/5/comments/8
# Respuesta: {
#   "message": "Getting comment 8 from post 5",
#   "post": "5",
#   "comment": "8"
# }

# Visita: http://localhost:3001/posts/10/comments/15
# Respuesta: {
#   "message": "Getting comment 15 from post 10",
#   "post": "10",
#   "comment": "15"
# }
```

## Desestructuración
Nota cómo usamos desestructuración para obtener ambos parámetros de forma limpia:
```js
const { postId, commentId } = request.params;
// Es equivalente a:
const postId = request.params.postId;
const commentId = request.params.commentId;
```
::

::card
# Postman - Probando APIs

Antes de construir nuestra API de usuarios, vamos a aprender sobre Postman, la herramienta profesional para probar APIs.

<figure>
  <img src="/images/lessons/postman-logo.png">
</figure>

### ¿Qué es Postman?

Postman es una aplicación que facilita probar APIs sin escribir código ni usar la terminal. Es perfecta para:
- Probar diferentes métodos HTTP (`GET`, `POST`, `PUT`, `DELETE`)
- Enviar datos en el body (JSON, formularios)
- Ver respuestas de forma organizada
- Guardar colecciones de peticiones
- Compartir APIs con tu equipo

### ¿Por qué usar Postman?

**Sin Postman (usando cURL):**
```bash
# Difícil de leer y escribir
curl -X PUT http://localhost:3000/users/2 \
  -H "Content-Type: application/json" \
  -d '{"role":"moderator"}'
```

**Con Postman:**
- ✅ Interfaz visual fácil de usar
- ✅ Guarda tus peticiones para reutilizarlas
- ✅ Muestra respuestas de forma bonita (JSON formateado)
- ✅ Permite probar headers, authentication, etc.
- ✅ No necesitas recordar sintaxis de comandos

### ¿Cuándo usar Postman?

Postman es ideal cuando:
- Desarrollas APIs y necesitas probarlas constantemente
- Quieres documentar tus endpoints
- Trabajas en equipo y necesitan compartir ejemplos de peticiones
- Necesitas probar endpoints con autenticación, headers complejos, etc.
::

::card
# Descargar e Instalar Postman

Vamos a instalar Postman para poder probar la API que construiremos en las siguientes tarjetas.

### Paso 1: Descargar
Visita [postman.com/downloads](https://www.postman.com/downloads/) y descarga la aplicación para tu sistema operativo (Windows, Mac, Linux).

### Paso 2: Instalar
Sigue las instrucciones de instalación según tu sistema operativo.

### Paso 3: Crear cuenta (opcional)
Puedes usar Postman sin cuenta, pero crear una te permite:
- Guardar tus peticiones en la nube
- Sincronizar entre dispositivos
- Compartir colecciones con tu equipo

**Recomendación:** Crea una cuenta gratuita para guardar tu trabajo.

### Paso 4: Familiarízate con la interfaz

Una vez abierto Postman, verás estos elementos principales:

**Elementos de la interfaz:**
- **Request URL**: Donde introduces la URL del endpoint (ej: `http://localhost:3000/users`)
- **Method dropdown**: Selecciona GET, POST, PUT, DELETE, etc.
- **Params tab**: Para añadir query parameters visualmente
- **Headers tab**: Para añadir headers HTTP
- **Body tab**: Para enviar datos (JSON, formularios, etc.)
- **Send button**: Ejecuta la petición
- **Response section**: Muestra el resultado (status code, body, headers)

### Paso 5: Crea tu primera petición de prueba

1. Abre Postman
2. Haz clic en **"+"** para crear una nueva petición
3. Selecciona **GET** en el dropdown
4. Introduce esta URL: `https://jsonplaceholder.typicode.com/users/1`
5. Haz clic en **Send**
6. ¡Verás una respuesta JSON con datos de un usuario!

Esto confirma que Postman está funcionando correctamente.

**Ahora estás listo para probar tu propia API** 🚀
::

::card
# Ejemplo Práctico: API de Usuarios

Ahora que tienes Postman instalado, vamos a construir una API completa con operaciones CRUD usando parámetros de ruta.

### Paso 1: Crear la base de datos de usuarios

Primero creamos una base de datos simulada en memoria:

```js
import express from 'express';
const app = express();

// Habilitar parseo de JSON
app.use(express.json());

// Base de datos en memoria
let users = [
  { id: 1, name: 'Alice', email: 'alice@example.com', role: 'user' },
  { id: 2, name: 'Bob', email: 'bob@example.com', role: 'admin' },
  { id: 3, name: 'Charlie', email: 'charlie@example.com', role: 'user' }
];
```

### Paso 2: GET todos los usuarios

```js
// GET /users - Obtener todos los usuarios
app.get('/users', (request, response) => {
  response.json(users);
});
```

### Paso 3: GET un usuario específico por ID

```js
// GET /users/:id - Obtener un usuario por ID
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
// PUT /users/:id - Actualizar usuario
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

### Paso 5: Ejecuta tu servidor

Guarda el código en un archivo `app.js` y ejecuta:
```bash
node app.js
```

**Puntos clave:**
- Usamos `request.params.id` para obtener el ID de la URL
- Usamos `request.body.role` para obtener los datos del body
- Convertimos el ID a número con `parseInt()`
- Devolvemos 404 si el usuario no existe

**Ahora vamos a probar cada endpoint con Postman** →
::

::card
# Probando la API de Usuarios con Postman

Con tu servidor corriendo (`node app.js`), vamos a probar cada endpoint usando Postman.

### GET /users (obtener todos los usuarios)

1. Abre Postman
2. Crea una nueva petición (botón "+ New" o "New Request")
3. Establece el método a `GET` (dropdown a la izquierda)
4. Introduce la URL: `http://localhost:3000/users`
5. Haz clic en **Send**
6. ¡Verás la respuesta con todos los usuarios!

<figure>
  <img src="/images/lessons/postman.png" alt="Postman screenshot">
</figure>

**Respuesta esperada:**
```json
[
  { "id": 1, "name": "Alice", "email": "alice@example.com", "role": "user" },
  { "id": 2, "name": "Bob", "email": "bob@example.com", "role": "admin" },
  { "id": 3, "name": "Charlie", "email": "charlie@example.com", "role": "user" }
]
```

### GET /users/:id (obtener un usuario específico)

1. Establece el método a `GET`
2. Introduce la URL: `http://localhost:3000/users/1`
3. Haz clic en **Send**
4. Deberías ver los datos del usuario Alice

**Respuesta esperada:**
```json
{
  "id": 1,
  "name": "Alice",
  "email": "alice@example.com",
  "role": "user"
}
```

### PUT /users/:id (actualizar un usuario)

1. Establece el método a `PUT`
2. Introduce la URL: `http://localhost:3000/users/2`
3. Haz clic en la pestaña **Body**
4. Selecciona **raw**
5. En el dropdown de la derecha, elige **JSON**
6. Introduce este JSON:
```json
{
  "role": "moderator"
}
```
7. Haz clic en **Send**
8. ¡Deberías ver los datos actualizados de Bob con el nuevo rol!

**Respuesta esperada:**
```json
{
  "id": 2,
  "name": "Bob",
  "email": "bob@example.com",
  "role": "moderator"
}
```

### Probar con ID inválido

1. Establece el método a `GET`
2. Introduce la URL: `http://localhost:3000/users/999`
3. Haz clic en **Send**

**Respuesta esperada (404):**
```json
{
  "error": "User not found"
}
```

**Nota:** Observa que el status code es `404 Not Found` en la sección de respuesta de Postman.
::

::card
# Parámetros de Query (Query Strings)

Los parámetros de query te permiten pasar datos **opcionales** en la URL después del símbolo `?`.

### ¿Qué son los Query Params?

Son pares clave-valor que van al final de la URL:
```
/ruta?clave1=valor1&clave2=valor2&clave3=valor3
```

### Características:
- **Opcionales**: La ruta funciona sin ellos
- **Múltiples**: Puedes pasar varios separados por `&`
- **Para filtrar**: Ideales para búsquedas, filtros, paginación

### Ejemplos de URLs con query params:

```bash
# Filtrar productos por categoría
/products?category=laptops

# Filtrar usuarios por edad Y ciudad
/users?age=25&city=Valencia

# Búsqueda con límite de resultados
/search?q=express&limit=10

# Paginación
/posts?page=2&perPage=20

# Ordenar resultados
/users?sortBy=name&order=desc
```

### Diferencia visual:

```bash
# Route Param (obligatorio)
/users/123
       ^^^
       ID del usuario

# Query Param (opcional)
/users?role=admin
       ^^^^^^^^^^
       Filtro opcional
```
::

::card
# Accediendo a Query Params

Express hace muy fácil acceder a los query params a través de `request.query`.

### Ejemplo básico:

```js
app.get('/search', (request, response) => {
  const searchTerm = request.query.q;
  const limit = request.query.limit;

  response.json({
    searching: searchTerm,
    limit: limit
  });
});
```

**Probando:**
```bash
# URL: http://localhost:3000/search?q=express&limit=10
# Respuesta:
{
  "searching": "express",
  "limit": "10"
}
```

**Desestructuración:**
```js
app.get('/search', (request, response) => {
  const { q, limit } = request.query;

  response.json({
    searching: q,
    limit: limit || 10  // Default a 10 si no se proporciona
  });
});
```
::

::card
# Ejemplo Práctico: Filtrar Usuarios por Rol

Vamos a extender nuestra API de usuarios para filtrar por rol usando query params.

```js
import express from 'express';
const app = express();

app.use(express.json());

// Base de datos de usuarios
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
# Obtener TODOS los usuarios
http://localhost:3000/users

# Filtrar solo admins
http://localhost:3000/users?role=admin

# Filtrar solo users
http://localhost:3000/users?role=user

# Filtrar solo moderators
http://localhost:3000/users?role=moderator
```

**¿Cómo funciona?**
1. Si no hay query param `role`, devuelve todos los usuarios
2. Si hay query param `role`, filtra por ese rol
3. La misma ruta `/users` sirve para ambos casos
::

::card
# Múltiples Query Params

Puedes combinar múltiples query params para filtros más complejos.

### Ejemplo: Filtrar por rol Y buscar por nombre

```js
app.get('/users', (request, response) => {
  const { role, search } = request.query;
  let result = users;

  // Filtrar por rol si se proporciona
  if (role) {
    result = result.filter(u => u.role === role);
  }

  // Buscar por nombre si se proporciona
  if (search) {
    result = result.filter(u =>
      u.name.toLowerCase().includes(search.toLowerCase())
    );
  }

  response.json(result);
});
```

### Pruébalo:

```bash
# Solo filtrar por rol
http://localhost:3000/users?role=admin

# Solo buscar por nombre
http://localhost:3000/users?search=alice

# Combinar ambos filtros
http://localhost:3000/users?role=admin&search=bob

# Sin filtros (todos los usuarios)
http://localhost:3000/users
```

**Ventajas:**
- ✅ Flexible: Cada filtro es opcional
- ✅ Combinable: Puedes usar uno, varios o ninguno
- ✅ Una sola ruta: No necesitas rutas separadas para cada filtro
::

::card
# Probando Query Params en Postman

Postman facilita mucho trabajar con query params.

### Método 1: Escribir directamente en la URL

```
http://localhost:3000/users?role=admin&search=bob
```

### Método 2: Usar la pestaña "Params" (Recomendado)

1. Introduce la URL base: `http://localhost:3000/users`
2. Haz clic en la pestaña **Params** (debajo del método)
3. En la tabla que aparece, añade:
   - **Key:** `role` | **Value:** `admin`
   - **Key:** `search` | **Value:** `bob`
4. Postman construye automáticamente la URL completa
5. Haz clic en **Send**

**Ventajas del método 2:**
- ✅ Más visual y organizado
- ✅ Puedes activar/desactivar params con checkboxes
- ✅ Fácil añadir, quitar o modificar params
- ✅ No tienes que preocuparte por la sintaxis (`?`, `&`, encoding)
::

::card
# Params vs Query: ¿Cuándo usar cada uno?

Entender la diferencia entre Route Params y Query Params es fundamental para diseñar buenas APIs.

### Comparación

| Aspecto | Route Params | Query Params |
|---------|--------------|--------------|
| **Sintaxis** | `/users/:id` | `/users?role=admin` |
| **Obligatorio** | Sí | No (opcional) |
| **Propósito** | Identificar recurso específico | Filtrar, buscar, opciones |
| **Acceso** | `request.params` | `request.query` |
| **Ejemplo** | `/users/123` | `/users?role=admin&page=2` |

### Cuándo usar Route Params:

Usa **Route Params** cuando necesites identificar **un recurso específico**:
- ✅ `GET /users/123` - Ver perfil del usuario 123
- ✅ `PUT /posts/5` - Actualizar el post 5
- ✅ `DELETE /products/laptop-x` - Eliminar producto específico
- ✅ `GET /articles/intro-to-express` - Ver artículo concreto

### Cuándo usar Query Params:

Usa **Query Params** cuando necesites **filtrar, buscar o configurar opciones**:
- ✅ `GET /users?role=admin` - Filtrar usuarios administradores
- ✅ `GET /products?category=laptops&price=max-1000` - Buscar con filtros
- ✅ `GET /posts?page=2&limit=10` - Paginación
- ✅ `GET /search?q=express&sortBy=date` - Búsqueda con ordenamiento

### Combinando ambos:

Puedes combinar Route Params y Query Params en la misma ruta:

```js
// GET /users/123/posts?status=published&limit=5
app.get('/users/:userId/posts', (request, response) => {
  const { userId } = request.params;        // Route param
  const { status, limit } = request.query;  // Query params

  response.json({
    userId,
    status,
    limit
  });
});
```

**Ejemplo de uso:**
```bash
GET /users/5/posts?status=published&limit=10
```
Obtiene los posts del usuario 5, solo los publicados, limitado a 10 resultados.
::

::card
# Valores por Defecto y Validación

Es buena práctica proporcionar valores por defecto y validar query params.

### Ejemplo con valores por defecto:

```js
app.get('/products', (request, response) => {
  // Valores por defecto
  const page = parseInt(request.query.page) || 1;
  const limit = parseInt(request.query.limit) || 10;
  const sortBy = request.query.sortBy || 'name';

  response.json({
    page,
    limit,
    sortBy,
    message: `Page ${page}, showing ${limit} items, sorted by ${sortBy}`
  });
});
```

**Pruébalo:**
```bash
# Sin query params - usa valores por defecto
http://localhost:3000/products
# { "page": 1, "limit": 10, "sortBy": "name" }

# Con algunos params
http://localhost:3000/products?page=3&limit=20
# { "page": 3, "limit": 20, "sortBy": "name" }

# Con todos los params
http://localhost:3000/products?page=2&limit=5&sortBy=price
# { "page": 2, "limit": 5, "sortBy": "price" }
```

**Puntos clave:**
- Usa `||` para proporcionar valores por defecto
- Convierte a número con `parseInt()` cuando sea necesario
- Los query params siempre llegan como strings
::

::card
# Resumen

Has aprendido sobre Route Params, Query Params y Postman:

### Route Params:
- ✅ Las usamos para identificar recursos específicos
- ✅ Son obligatorios en la URL
- ✅ Se definen con `:` en la ruta. Ejemplo `/users/:id`
- ✅ Se acceden con `request.params` en el callback.

<details>
<summary>Ejemplo</summary>

```js
app.get('/users/:id', (request, response) => {
  const { id } = request.params;
  // ... Resto de la función ...
});
```

</details>

### Query Params:
- ✅ Para filtrar, buscar y opciones
- ✅ Son opcionales
- ✅ Van después de `?` en la URL
- ✅ Se acceden con `request.query`
- ✅ Ejemplo: `/users?role=admin&page=2`

<details>
<summary>Ejemplo</summary>

```js
app.get('/users', (request, response) => {
  const { role } = request.query;
  // ... Resto de la función ...
});
```
</details>

### Postman:
- ✅ Herramienta profesional para probar APIs
- ✅ Interfaz gráfica amigable
- ✅ Permite probar GET, POST, PUT, DELETE
- ✅ Facilita enviar datos en el body
- ✅ Gestiona query params visualmente

### Buenas prácticas:
1. Usa route params para identificar recursos
2. Usa query params para filtros y opciones
3. Proporciona valores por defecto
4. Valida los datos de entrada
5. Convierte tipos cuando sea necesario (parseInt, parseFloat)

::

::card
# Ejemplo Completo: API de Usuarios

Puedes encontrar el código completo de esta lección en el siguiente repositorio:

https://github.com/teledirigido/express-users-api

El repositorio incluye:
- API completa con route params
- Filtros con query params
- Ejemplos de uso con Postman
- Manejo de errores
- Validación de datos

¡Clona el repositorio y experimenta con el código!
::
