::card
# Por qué Express

Express.js se convirtió en uno de los frameworks de Node.js más populares gracias a su simplicidad y flexibilidad.

A diferencia de otros frameworks que requieren estructuras de proyecto complejas desde el principio, Express te permite crear un servidor web funcional con tan solo unas pocas líneas de código.

Esto lo hace perfecto para aprender, crear prototipos y proyectos pequeños donde se busca priorizar la funcionalidad sobre la configuración.

## Todo en un solo archivo
Para prototipos rápidos, mantener todo en `app.js` es perfectamente válido:

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
# Escalando Express

Hasta ahora, hemos añadido varias funcionalidades a nuestras aplicaciones Express:
- Handlebars para renderizar plantillas dinámicas
- Archivos `.env` para gestionar la configuración
- Carpeta public para servir archivos estáticos
- Cloudinary para manejar la subida de imágenes
- LowDB para persistir datos

A medida que añadimos más rutas y funcionalidad, nuestro archivo `app.js` se vuelve más difícil de mantener debido a su longitud.

Es momento de organizar nuestro código en una estructura más escalable, separando las rutas en carpetas dedicadas y organizando mejor la configuración de la base de datos.


::

::card

# Escalando Express - Routes

Es momento de organizar nuestro código en una estructura más escalable. Comenzaremos moviendo nuestras rutas a una carpeta dedicada.

```bash
project-root/
├── app.js
├── routes/                   # Carpeta con las rutas
│   └── projects.js           # Las rutas de los proyectos (/projects)
├── db/                       # Carpeta para la DB
│   ├── db.json               # La base de datos
│   └── connection.js         # El archivo de configuración
├── views/
│   ├── layouts/
│   │   └── main.handlebars
│   └── projects/
│       ├── list.handlebars
│       └── detail.handlebars
└── public/
    ├── css/
    └── images/
```

Antes definíamos las rutas directamente en `app.js`:

```javascript
// Resto del codigo...

app.get('/projects', (req, res) => {
  // código de la ruta
});

// Resto del codigo...

```

## Creando un enrutador

Cuando separamos las rutas a un archivo externo, ya no podemos usar `app.get()` directamente porque `app` solo existe en `app.js`. 

Por eso usamos `express.Router()` para crear un mini-enrutador que luego conectamos con `app.use()`.


```js
import express from 'express';
const router = express.Router();
```

Entonces, siguiendo esta estructura en `routes/projects.js`:

```javascript
import express from 'express';
const router = express.Router();

// Listar todos los proyectos
router.get('/', (req, res) => {
  // Cuerpo de la función
});

// Ver detalle de un proyecto
router.get('/:id', (req, res) => {
  // Cuerpo de la función
});

// Crear proyecto (mostrar formulario)
router.get('/new', (req, res) => {
  // Cuerpo de la función
});

// Crear proyecto (procesar formulario)
router.post('/', (req, res) => {
  // Cuerpo de la función
});

export default router;
```

**En `app.js`:**

1. Importamos el archivo con las rutas de los proyectos:

```javascript
import projectsRouter from './routes/projects.js';
```

2. Añadimos el middleware que indica el uso de las rutas

```js
// Resto del código...

app.use('/projects', projectsRouter);

// Resto del código...

```

Ahora todas las rutas definidas en `projects.js` estarán bajo el prefijo `/projects`.

## Nota:

- En este ejemplo, las rutas aún no interactúan con una base de datos. 
- En la siguiente card veremos cómo integrar LowDB para persistir los datos.
- En algunos casos es necesario implementar `async/await` en las rutas, por ejemplo cuando trabajamos con bases de datos.

::

::card

# Escalando Express - LowDB

Ahora veremos como configurar la base de datos LowDB en una carpeta separada. Siguiendo esta estructura:

```bash
project-root/
├── ...
├── db/                       # Carpeta para la DB
│   ├── db.json               # La base de datos
│   └── connection.js         # El archivo de configuración
├── ...
```

## Configurando LowDB en `db/connection.js`

Creamos un archivo de conexión que se encargará de inicializar LowDB:

```javascript
import { Low } from 'lowdb';
import { JSONFile } from 'lowdb/node';

// Configurar el adaptador para leer/escribir en db.json
const adapter = new JSONFile('db/db.json');

// Crear la instancia de la base de datos con estructura inicial
const db = new Low(adapter, { projects: [] });

// Leer los datos del archivo
await db.read();

export default db;
```

## Estructura inicial de `db/db.json`

```json
{
  "projects": []
}
```

## Usando LowDB en `routes/projects.js`

Para consumir la base de datos desde nuestras rutas, importamos la conexión:

```javascript
// routes/projects.js

import express from 'express';
import db from '../db/connection.js';

const router = express.Router();

// Listar todos los proyectos
router.get('/', async (req, res) => {
  await db.read();
  const projects = db.data.projects;
  res.render('projects/list', { projects });
});

// Ver detalle de un proyecto
router.get('/:id', async (req, res) => {
  // Cuerpo de la función
});

export default router;
```

### Nota:

- Las funciones que usan `db.read()` o `db.write()` deben ser `async` y usar `await`.

::