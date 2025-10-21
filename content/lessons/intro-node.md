---
title: Lesson - Introduction to Node.js
---

::card
# ¿Qué es Node.js?
## Node.js es un entorno de ejecución de JavaScript construido sobre el motor V8 de Chrome.
- Permite ejecutar JavaScript fuera del navegador.
- Orientado a eventos.
- Perfecto para construir aplicaciones de red escalables.
- Creado por Ryan Dahl en 2009.
::

::card
# Temas
- Casos de uso
- Instalación de Node.js
- NPM y Gestores de paquetes
- El archivo `package.json`
- Require vs Import
- Flujo de trabajo con Git
- Nodemon
::

::card
# Casos de uso
- APIs RESTful
- Aplicaciones en tiempo real (chat, juegos)
- Microservicios
- Herramientas de línea de comandos
- Renderizado del lado del servidor
::

::card
# Navegador vs Node.js

| JavaScript del Navegador | Node.js |
|--------------------------| ------- |
| Acceso al DOM (document, window) | Sin DOM (no window/document) |
| Enfocado en Frontend/UI | Acceso completo al sistema de archivos |
| Entorno único (navegador) | Enfocado en Backend/servidor |
|| Acceso a APIs del sistema operativo |

::

::card
# Instalando Node.js
### Pasos
- Visita nodejs.org
<figure>
  <img src="/images/lessons/node-js-website.png" alt="Node.js website">
  <figcaption>https://nodejs.org</figcaption>
</figure>

- Descargar la aplicación
- Ejecuta el instalador
- Verifica la instalación

```bash
$ node --version
# v20.x.x

$ npm --version
# 10.x.x
```
::


::card
# Tu primer Programa en Node.js
```js
// hello.js
console.log('Hello, Node.js!');

// Acceder a variables globales de Node.js
console.log('Current directory:', __dirname);
console.log('Current file:', __filename);
console.log('Platform:', process.platform);
```

En la terminal ejecútalo así:
```bash
node hello.js
```
::

::card
# NPM Packages

NPM significa **N**ode **P**ackage **M**anager. 

Entendemos por paquete de Node a código reusable que puede ser descargado desde un repositorio global a tu maquina local. 
Un paquete de Node puede depender de otros paquetes.

Existen diferentes gestores de repositorios


## Gestores de repositorios

| Gestor | Comando de Instalación | Características |
|--------|------------------------|-----------------|
| npm    | `npm install`          | Viene incluido con Node.js |
| yarn   | `yarn add`             | Más rápido, cacheo offline |
| pnpm   | `pnpm add`             | Ahorra espacio en disco |
| bun    | `bun add`              | El más rápido, también es un runtime |

::

::card
# El archivo `package.json`

Es el **manifiesto** de tu proyecto Node.js y contiene información importante sobre tu aplicación.

### ¿Qué incluye?

- **Nombre y versión** del proyecto
- **Dependencias**: Lista de paquetes que necesita tu aplicación
- **Scripts**: Comandos personalizados y ejecutables (ej: `npm start`, `npm test`)
- **Metadata**: Autor, licencia, descripción

### Ejemplo básico

```json
{
  "name": "mi-proyecto",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0"
  },
  "scripts": {
    "start": "node index.js"
  }
}
```

## ¿Cómo se crea?

Ejecuta y responde las preguntas:
```bash 
$ npm init
```
Usa `-y` para valores por defecto:
```bash
$ npm init -y
```
::

::card
# Utilizando un paquete NPM

1. Vamos a crear nuestra primera app con un paquete de NPM.
```bash
# Creamos nuestra carpeta
$ mkdir primer-ejemplo-npm

# Accedemos a la carpeta
$ cd primer-ejemplo-npm

# Inicializamos un proyecto npm
$ npm init --yes

# Importamos nuestro primer paquete npm
$ npm install colors

# Creamos un archivo para nuestra aplicación
$ touch index.js

# Abrimos la carpeta en VS Code.
$ code .
```

2. Vamos a añadir el siguiente código:

```js
// Después de instalar el paquete npm "colors", necesitamos importarlo (require)
// en el archivo donde planeamos usarlo
const myColors = require('colors/safe');

console.log(myColors.yellow('¡Hola WebDev Women Valencia!')); 
console.log(myColors.magenta('Aprendiendo Node.js es divertido')); 
console.log(myColors.cyan.bold('Programar cambia vidas')); 
console.log(myColors.rainbow('WebDev Women Valencia')); 
console.log(myColors.green('¡Sigue aprendiendo!'));
```

3. Ahora revisemos en la terminal el resultado
::

::card
# Require vs Import

Node.js tiene dos formas de importar módulos: **CommonJS** (`require`) y **ES Modules** (`import`).

## Usando `require` (CommonJS)

```js
// Forma tradicional de Node.js
const colors = require('colors/safe');

console.log(colors.yellow('¡Hola WebDev Women Valencia!'));
console.log(colors.magenta('Aprendiendo Node.js'));
```

## Usando `import` (ES Modules)

Para usar `import`, necesitas añadir `"type": "module"` en tu `package.json`:

```json
{
  "name": "mi-proyecto",
  "type": "module"
}
```

Luego puedes usar `import`:

```js
// Sintaxis moderna de JavaScript
import colors from 'colors/safe';

console.log(colors.yellow('¡Hola WebDev Women Valencia!'));
console.log(colors.magenta('Aprendiendo Node.js'));
```

## Comparación

| Característica | `require` | `import` |
|----------------|-----------|----------|
| **Sistema** | CommonJS | ES Modules |
|| Tradicional en Node.js | Estándar moderno de JavaScript |
| **Sintaxis** | `const x = require('x')` | `import x from 'x'` |
| **Configuración** | Por defecto en Node.js | Requiere `"type": "module"` en package.json |
| **Carga** | Síncrona | Asíncrona |
| **Compatibilidad** | Funciona en todas las versiones | Node.js 12+ |

### ¿Cuál usar?

- **`require`**: Si trabajas con proyectos antiguos o necesitas máxima compatibilidad
- **`import`**: Para proyectos nuevos (es el futuro de JavaScript)

::

::card
# Flujo de Trabajo

## Cuando creas un proyecto

1. Ejecutas `npm init` y se crea `package.json`
2. Instalas paquetes con `npm install <nombre-del-paquete>`
3. Se crean automáticamente:
   - `node_modules/`: Carpeta con todos los paquetes (muy pesada)
   - `package-lock.json`: Archivo con las versiones exactas instaladas
4. Creas `.gitignore` para excluir `node_modules/`
5. Haces commit → Solo subes `package.json` y `package-lock.json`

## Cuando otro desarrollador clona tu proyecto

1. Clona el repositorio con `git clone`
2. Ejecuta `npm install`
3. NPM lee `package.json` y descarga todo en `node_modules/`
4. ¡Todo listo para trabajar!

## ¿Qué subir a Git?

| Archivo/Carpeta | ¿Subir? | ¿Por qué? |
|-----------------|---------|-----------|
| `package.json` | ✅ Sí | Define las dependencias del proyecto |
| `package-lock.json` | ✅ Sí | Versiones exactas de paquetes |
| `node_modules/` | ❌ No | Muy pesada, se regenera con `npm install` |

Sube la receta `package.json`, no los ingredientes `/node_modules`

::

::card
# Nodemon
Nodemon es una herramienta que facilita el desarrollo con Node.js.

La gran ventaja de Nodemon es que **reinicia automáticamente** la aplicación Node.js cuando detecta cambios en los archivos.

### ¿Por qué es útil?
Sin Nodemon:
1. Editas tu código
2. Detienes el servidor (Ctrl+C)
3. Vuelves a ejecutar `node app.js`
4. Repites estos pasos cada vez que haces un cambio

Con Nodemon:
1. Editas tu código
2. ¡Nodemon reinicia automáticamente el servidor!
3. Solo guarda y actualiza el navegador

### Instalación Global
Instala Nodemon globalmente para usarlo en todos tus proyectos:

```bash
npm install -g nodemon
```

### Uso
```bash
# Sin nodemon
node hello.js

# Con nodemon
nodemon hello.js
```

### Ejemplo
```bash
# Iniciar tu aplicación con nodemon
nodemon hello.js

# Verás algo como:
# [nodemon] 3.0.1
# [nodemon] watching: *.*
# [nodemon] starting `node hello.js`
# Server running at http://localhost:3000

# Ahora edita hello.js y guarda...
# [nodemon] restarting due to changes...
# [nodemon] starting `node hello.js`
# Server running at http://localhost:3000
```
::

::card
# Ejercicio Práctico: Mi Tarjeta Personal

Crea una aplicación Node.js que muestre tu información personal con colores.

## Instrucciones

1. Crea una carpeta llamada `mi-tarjeta-personal`
2. Inicializa un proyecto npm con `npm init -y`
3. Añade `"type": "module"` en tu `package.json` para usar ES Modules
4. Instala el paquete `colors` con `npm install colors`
5. Crea un archivo `tarjeta.js`
6. Usa `import` para importar colors: `import colors from 'colors/safe';`
7. Escribe código que muestre:
   - Tu nombre (en color amarillo)
   - Tu ciudad (en color cyan)
   - Por qué quieres aprender programación (en color verde)
   - Un mensaje motivacional (en arcoíris)
8. Ejecuta tu aplicación con `nodemon tarjeta.js`
9. Modifica los colores y mensajes para ver cómo Nodemon reinicia automáticamente

## Ejemplo de salida esperada

```js
María García
Valencia, España
Quiero aprender programación para crear aplicaciones que ayuden a las personas
¡Sigue adelante, tú puedes!
```

## Bonus (Opcional)
- Crea un `.gitignore` y sube tu proyecto a GitHub
::

<!-- ::card
## Trabajando con APIs JSON
Express facilita la construcción de APIs REST que envían y reciben datos JSON.

### Ejemplo: API Simple de Productos
```js
import express from 'express';
const app = express();

// Habilitar parseo de JSON
app.use(express.json());

// Base de datos en memoria
let products = [
  { id: 1, name: 'Laptop', price: 999 },
  { id: 2, name: 'Phone', price: 599 }
];

// GET - Obtener todos los productos
app.get('/api/products', (request, response) => {
  response.json(products);
});

// POST - Crear un nuevo producto
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

### Puntos clave:
- `app.use(express.json())` - Parsea JSON del cuerpo de la petición
- `response.json()` - Envía respuesta JSON
- `request.body` - Contiene datos enviados en petición POST

### Probando la API
Petición `GET` (en navegador o terminal):
```bash
curl http://localhost:3000/api/products
```

Petición `POST` (usa terminal, Postman o Insomnia):
```bash
curl -X POST http://localhost:3000/api/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Tablet","price":399}'
```

### Lee más:
- **[Postman](https://www.postman.com/)** - Herramienta popular para probar APIs
- **[Insomnia](https://insomnia.rest/)** - Alternativa ligera
:: -->