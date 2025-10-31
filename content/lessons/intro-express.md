::card
# Express.js
Express es un framework web rápido y minimalista para Node.js.

<figure>
  <img src="/images/lessons/express-website.png" alt="Node.js website" loading="lazy">
  <figcaption>https://expressjs.com/</figcaption>
</figure>

### ¿Qué es un framework web?
Un Framework Web es un software diseñado para acelerar el desarrollo de aplicaciones web.
::

::card
# Variables de Entorno

Las variables de entorno son valores de configuración que pueden cambiar dependiendo del entorno donde se ejecuta tu aplicación (desarrollo, producción, testing). 
Estos valores se guardan en un archivo llamado `.env`

## ¿Por qué usar .env?

Los arhcivos `.env` son opcionales. 

Si creamos un archivo de configuración externo, entonces las variables de configuración y otras potencialmente sensibles quedarán separadas
de los archivos de trabajo

**Sin .env** (hardcodeado):
```js
// app.js

const PORT = 3000;  // ¿Qué pasa si en producción necesitas puerto 8080?
const API_KEY = "mi-clave-secreta-123";  // ¡PELIGRO! Esto se subirá a GitHub
```

**Con .env** (configuración externa):

```js
// app.js

const PORT = process.env.PORT || 3000;
const API_KEY = process.env.API_KEY;  // Seguro, no se sube a Git
```

## Tipos de archivos .env

Alguno de los archivos de configuración que podriamos encontrar en un proyecto son los siguientes

|Archivo| en `.gitignore`|Uso|
|-------|----------------|---|
|`.env` | Si | Archivo de configuración. |
|`.env.example`| No | Contiene las variables utilzadas con información referencial y no real. |
|`.env.development`| Si | Archivo de configuración para un entorno de desarrollo o development. |
|`.env.production`| Si | Archivo de configuración para un entorno de producción. |

## Creando tu archivo .env

1. Crea el archivo `.env` en la raíz de tu proyecto:
```bash
touch .env
```

2. Añade tus variables (sin espacios):
```bash
# .env

PORT=3000
NODE_ENV=development
API_KEY=mi-clave-super-secreta
DATABASE_URL=mongodb://localhost:27017/miapp
```

3. **IMPORTANTE**: Crea `.gitignore` y añade `.env`:

Es una buena práctica de seguridad añadir el archivo `.env` a `.gitignore` porque puede alamacenar información sensible.

```bash
# .gitignore

node_modules/
.env # .env añadido :)
*.log
```

## Usando variables de entorno

```js
import 'dotenv/config';  // Carga las variables del .env

const PORT = process.env.PORT || 3000;
const apiKey = process.env.API_KEY;

console.log(`Server starting on port ${PORT}`);
```

## Ejemplo práctico: Diferentes entornos

**Desarrollo (.env):**
```bash
PORT=3000
NODE_ENV=development
```

**Producción (.env en el servidor):**
```bash
PORT=8080
NODE_ENV=production
```

El mismo código funciona en ambos entornos porque lee de `process.env` 🎯

## Reglas de oro

✅ **SÍ subir a Git**: `.env.example` (plantilla sin valores reales)
❌ **NO subir a Git**: `.env` (contiene datos sensibles)

**Ejemplo de .env.example:**
```bash
PORT=3000
NODE_ENV=development
API_KEY=tu-clave-aqui
```

::


::card
# Creando nuestra primera aplicación en Express
Veamos como construir una aplicación en Express simple.

<details>
<summary>
Pasos pre-eliminares
</summary>

Antes de proceder, necesitamos revisar que los siguientes conceptos están aprendidos:

1. Crear carpetas y archivos en nuestro editor IDE/Terminal y posicionarnos en la carpeta correcta.
1. Entender como inicializar un proyecto con npm
1. Saber como instalar un paquete de node utilizando algun repositorio (`yarn`, `npm`, `pnpm`, etc).
1. Saber que es un archivo `package.json`
</details>


## Paso 1: Configuración
Crea una carpeta para el proyecto:
```bash
mkdir express-first-app
cd express-first-app
```
Ahora inicialicemos nuestro primer proyecto:
```bash
npm init --yes
npm install express dotenv
npm pkg set type=module
```

## Paso 2: Entendiendo el archivo `package.json`
Después de ejecutar estos comandos, revisa tu `package.json`:

```json
{
  "name": "express-first-app",
  "version": "1.0.0",
  "type": "module",
  "dependencies": {
    "express": "^5.1.0",
    "dotenv": "^16.0.0"
  }
}
```

#### ¿Qué significa esto?
- `type: "module"` - habilita JavaScript moderno (imports ES6)
- `dependencies` - lista los paquetes que tu proyecto necesita
- `express` - framework web para construir APIs
- `dotenv` - carga variables de entorno desde el archivo .env
::

::card
# Paso 3: Crear archivo .env
Crea un archivo llamado `.env` en la raíz de tu proyecto:
```bash
touch .env
```

Añade el siguiente contenido en tu archivo:
```bash
# .env
PORT=3000
```

<details>
<summary>Ventajas de tener un archivo <pre>.env</pre></summary>

- Almacena variables de entorno (configuración)
- No se sube a Git (añádelo a .gitignore)
- Diferentes valores para desarrollo/producción
- Mantiene datos sensibles (API keys, contraseñas) fuera del código
</details>
::

::card
# Paso 4: Crear app.js
Crea un nuevo archivo llamado `app.js`:

```bash
touch app.js
```

Añade el siguiente contenido:

```js
// app.js

import 'dotenv/config';
import express from 'express';

const app = express();
const PORT = process.env.PORT || 3000;

// Definir una ruta
app.get('/home', (request, response) => {
  response.send('<h1>Hello DevWoman Valencia!</h1>');
});

// Iniciar el servidor
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}/`);
});
```
::

::card
# Paso 5: Ejecuta tu aplicación

Tienes dos opciones para ejecutar tu servidor:

**Opción 1: Node.js con --watch (Node.js 18+)**
```bash
node --watch app.js
```

**Opción 2: Usando Nodemon (recomendado)**
```bash
nodemon app.js
```

Ambas opciones reinician automáticamente el servidor cuando guardas cambios en tus archivos.

¡Visita http://localhost:3000/home en tu navegador!

<figure>
  <img src="/images/lessons/express-first-app.png" alt="Tu primera app en express" loading="lazy">
  <figcaption>Tu primera app en express: <a target="_blank" href="http://localhost:8080/home">http://localhost:3000/home</a></figcaption>
</figure>

### Lee más:
- [Dotenv](https://www.npmjs.com/package/dotenv)
- [Express Basic Routing](https://expressjs.com/en/starter/basic-routing.html)
::


::card
# Renderizando HTML directo
En lugar de enviar texto plano, vamos a crear una página HTML apropiada.

## Respuesta HTML Básica
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
::

::card
# Renderizando HTML con archivos
Para contenido HTML más grande esto se volverá difícil de mantener. Vamos a crear un archivo HTML separado.

### Paso 1
Crea una carpeta `views` y añade `home.html`:
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

### Paso 2
Vamos a actualizar `app.js` para servir el archivo:

1. Vamos a importar fileURLToPath:

```js
import { fileURLToPath } from 'url';
```

<details>
<summary>Qué es <pre>fileURLToPath</pre>?</summary>

`fileURLToPath` es una función que convierte URLs de archivos tipo `file://ruta/archivo.js` a rutas normales del sistema (`/ruta/archivo.js`). 

La necesitamos porque en módulos ES6, Node.js maneja las rutas como URLs.
</details>

2. Añade la siguiente variable:

```js
const __dirname = path.dirname(fileURLToPath(import.meta.url));
```

<details>
<summary>Qué es <pre>__dirname</pre>?</summary>

`__dirname` es una variable que guarda la ruta completa de la carpeta donde está nuestro archivo actual. Usamos `import.meta.url` (que es la URL del archivo actual) y la convertimos a ruta del sistema para luego extraer solo la carpeta con `path.dirname()`. Esto nos permite acceder a archivos relativos a nuestro proyecto de forma confiable.

</details>

3. Vamos añadir la siguiente ruta:
```js
app.get('/', (request, response) => {
  response.sendFile(path.join(__dirname, 'views', 'home.html'));
});
```

### `app.js` actualizada:

```js
// app.js

import express from 'express';
import path from 'path';
import { fileURLToPath } from 'url';

const app = express();
const PORT = process.env.PORT || 3000;
const __dirname = path.dirname(fileURLToPath(import.meta.url));

app.get('/', (request, response) => {
  response.sendFile(path.join(__dirname, 'views', 'home.html'));
});

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}/`);
});
```

### Paso 3
Ejecuta la aplicación y visita http://localhost:3000
::

::card
# Rutas en Express
Las rutas definen cómo tu aplicación responde a las peticiones del cliente en endpoints específicos.

## Estructura Básica de una Ruta
```js
app.get('/path', (request, response) => {
  // Maneja la petición
});
```

- `get` - Maneja peticiones GET (ver páginas, obtener datos)
- `'/path'` es el endpoint de la ruta.
- La función callback se ejecuta cuando alguien visita la ruta.
```js
(request, response) => { 
  // Maneja la peticion
}
```

### El objeto `request` contiene:
- `request.body` - Datos enviados en peticiones POST
- `request.headers` - Encabezados de la petición (cookies, content-type, etc.)
- Información sobre la petición entrante

### El objeto `response` te permite enviar:
- `response.send('text')` - Enviar texto plano o HTML
- `response.json({ data })` - Enviar datos JSON
- `response.sendFile(path)` - Enviar un archivo HTML
- `response.status(404)` - Establecer código de estado HTTP

### Ejemplo: Múltiples Rutas `GET`
```js
// Ruta principal
app.get('/', (request, response) => {
  response.send('<h1>Welcome to my site!</h1>');
});
```

```js
// Ruta sobre nosotros
app.get('/about', (request, response) => {
  response.send('<h1>About Us</h1><p>We are awesome!</p>');
});
```

```js
// Ruta API - devuelve JSON
app.get('/api/status', (request, response) => {
  response.json({
    status: 'running',
    timestamp: new Date()
  });
});
```
::

::card
# Resumen

En esta lección hemos aprendido los fundamentos de Express, el framework web más popular para Node.js.

### Conceptos clave:

**Express.js:**
- Framework minimalista para construir aplicaciones web y APIs
- Facilita la creación de servidores HTTP
- Simplifica el manejo de rutas y peticiones

**Comandos a recordar:**
- `npm init` - Inicializar proyecto Node.js
- `npm install <package>` - Instalar dependencias
- `npm pkg set type=module` - Habilitar ES Modules

**Variables de entorno (.env):**
- Almacenan configuración sensible (PORT, API keys, etc.)
- No se suben a Git (añadir a `.gitignore`)
- Se acceden con `process.env.VARIABLE_NAME`
- Usar `.env.example` como plantilla

**Estructura básica de una ruta:**
```js
app.get('/path', (request, response) => {
  // Maneja la petición
});
```

**Buenas prácticas:**

- ✅ Usa variables de entorno en el archivo `.env` para manejar variables de tu aplicación  
- ✅ Si tu aplicación utiliza archivos HTML, utiliza carpetas separadas
- ✅ Usa `nodemon` o `--watch` para observar los cambios que hagas en desarrollo
::