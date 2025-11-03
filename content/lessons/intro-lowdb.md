::card
# LowDB
LowDB es una base de datos JSON simple y ligera para Node.js, perfecta para aprender y prototipos.

Podemos visitar la web oficial del paquete de node aquí:  
https://www.npmjs.com/package/lowdb

### ¿Qué es una base de datos?
Una base de datos es un sistema organizado para almacenar, gestionar y recuperar información de manera persistente. A diferencia de las variables en memoria (que se pierden al reiniciar), los datos en una base de datos permanecen guardados.
::

::card
# ¿Por qué usar LowDB?

Hasta ahora hemos trabajado con datos de dos formas:

## Forma 1: Variables en memoria
```js
const projects = [
  { id: 1, title: 'Mi proyecto', status: 'completed' }
];

app.get('/projects', (req, res) => {
  res.render('projects', { projects });
});
```

**Problema:** Si reinicias el servidor y los datos se cambian, los cambios se pierden.

## Forma 2: Archivos JSON estáticos
```js
const projectsData = readFileSync('./projects.json', 'utf-8');
const projects = JSON.parse(projectsData);
```

**Problema:** Solo puedes leer, no modificar fácilmente (necesitas reescribir todo el archivo cada vez).

## La solución: LowDB
LowDB te permite:
- ✅ Leer y escribir datos fácilmente
- ✅ Los datos persisten entre reinicios
- ✅ Sintaxis simple similar a trabajar con objetos JavaScript
- ✅ Perfecto para aprender antes de usar bases de datos complejas (MongoDB, PostgreSQL)

### Comparación

| Característica | Variables | JSON estático | LowDB |
|---------------|-----------|---------------|--------|
| Persistencia | ❌ | ✅ | ✅ |
| Fácil escritura | ✅ | ❌ | ✅ |
| Fácil lectura | ✅ | ⚠️ | ✅ |
| Para producción | ❌ | ❌ | ⚠️ (proyectos pequeños) |
::

::card
# Instalación y configuración

### Paso 1: Instalar LowDB
```bash
npm install lowdb
```

### Paso 2: Crear estructura del proyecto
```bash
mi-proyecto/
├── app.js
├── db.json          # Base de datos (se creará automáticamente)
├── views/
│   ├── layouts/
│   │   └── main.handlebars
│   ├── projects.handlebars
│   └── project-detail.handlebars
└── package.json
```

### Paso 3: Crear archivo de base de datos inicial
```json
// db.json
{
  "projects": []
}
```

**Nota:** Si el archivo no existe, LowDB lo creará automáticamente.
::

::card
# Configurar LowDB en Express

### Estructura básica con LowDB
```js
// app.js
import 'dotenv/config';
import express from 'express';
import { engine } from 'express-handlebars';
import { Low } from 'lowdb';
import { JSONFile } from 'lowdb/node';

const app = express();
const PORT = process.env.PORT || 3000;

// Configurar LowDB
const adapter = new JSONFile('db.json');
const db = new Low(adapter, { projects: [] });

// Leer datos iniciales
await db.read();

// Configurar Handlebars
app.engine('handlebars', engine());
app.set('view engine', 'handlebars');
app.set('views', './views');

app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
```

### ¿Qué hace este código?
1. `new JSONFile('db.json')` - Crea un adaptador para leer/escribir el archivo JSON
2. `new Low(adapter, { projects: [] })` - Inicializa la base de datos con estructura por defecto
3. `await db.read()` - Carga los datos del archivo a memoria
::

::card
# Importante: Top-level await

### Problema con ES Modules
```js
// ❌ Esto dará error
const db = new Low(adapter, { projects: [] });
await db.read(); // Error: await solo funciona en funciones async
```

### Solución 1: Usar función async (recomendado)
```js
// app.js
import express from 'express';
import { Low } from 'lowdb';
import { JSONFile } from 'lowdb/node';

const app = express();
const PORT = 3000;

async function initializeApp() {
  // Configurar base de datos
  const adapter = new JSONFile('db.json');
  const db = new Low(adapter, { projects: [] });
  await db.read();

  // Configurar rutas
  app.get('/projects', async (req, res) => {
    await db.read();
    res.render('projects', { projects: db.data.projects });
  });

  // Iniciar servidor
  app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
  });
}

initializeApp();
```

### Solución 2: Top-level await (Node.js 14.8+)
Asegúrate de tener `"type": "module"` en tu `package.json`:

```json
{
  "type": "module"
}
```

Entonces puedes usar `await` directamente:
```js
const db = new Low(adapter, { projects: [] });
await db.read(); // ✅ Funciona con top-level await
```
::

::card
# Leer todos los registros (READ)

### Obtener lista completa
```js
// app.js

app.get('/projects', async (req, res) => {
  // Leer datos actualizados de la base de datos
  await db.read();

  // Acceder a los proyectos
  const projects = db.data.projects;

  res.render('projects', {
    projects: projects,
    pageTitle: 'Mis Proyectos'
  });
});
```

### Vista Handlebars
```handlebars
<!-- views/projects.handlebars -->
<h1>{{pageTitle}}</h1>

{{#if projects.length}}
  <ul>
    {{#each projects}}
      <li>
        <h3>{{this.title}}</h3>
        <p>{{this.description}}</p>
        <span>Estado: {{this.status}}</span>
        <a href="/projects/{{this.id}}">Ver detalles</a>
      </li>
    {{/each}}
  </ul>
{{else}}
  <p>No hay proyectos todavía.</p>
  <a href="/projects/new">Crear el primero</a>
{{/if}}
```

### ¿Por qué `await db.read()` cada vez?
Asegura que siempre trabajas con los datos más recientes del archivo.
::

::card
# Leer un registro específico (READ by ID)

### Buscar por ID
```js
app.get('/projects/:id', async (req, res) => {
  await db.read();

  const projectId = parseInt(req.params.id);
  const project = db.data.projects.find(p => p.id === projectId);

  if (project) {
    res.render('project-detail', { project });
  } else {
    res.status(404).send('Proyecto no encontrado');
  }
});
```

### Vista de detalle
```handlebars
<!-- views/project-detail.handlebars -->
<article>
  <h1>{{project.title}}</h1>
  <p>{{project.description}}</p>
  <p>Estado: {{project.status}}</p>

  <a href="/projects">← Volver a la lista</a>
  <a href="/projects/{{project.id}}/edit">Editar</a>
</article>
```

### Mejorando el manejo de errores
```js
app.get('/projects/:id', async (req, res) => {
  await db.read();

  const projectId = parseInt(req.params.id);
  const project = db.data.projects.find(p => p.id === projectId);

  if (!project) {
    return res.status(404).render('404', {
      message: 'Proyecto no encontrado'
    });
  }

  res.render('project-detail', { project });
});
```
::

::card
# Ejercicio Práctico: Mostrar lista de proyectos

### Objetivo
Crear una página que muestre todos los proyectos de la base de datos.

### Paso 1: Añade datos de prueba
```json
// db.json
{
  "projects": [
    {
      "id": 1,
      "title": "Portfolio Personal",
      "description": "Mi sitio web profesional",
      "status": "completed"
    },
    {
      "id": 2,
      "title": "App de Tareas",
      "description": "Gestor de tareas pendientes",
      "status": "in-progress"
    },
    {
      "id": 3,
      "title": "Blog Técnico",
      "description": "Blog sobre programación",
      "status": "planning"
    }
  ]
}
```

### Paso 2: Implementa la ruta
```js
app.get('/projects', async (req, res) => {
  await db.read();
  res.render('projects', {
    projects: db.data.projects,
    pageTitle: 'Mis Proyectos'
  });
});
```

### Paso 3: Crea la vista
Usa la plantilla de Handlebars del ejemplo anterior.

### Paso 4: Prueba
Visita http://localhost:3000/projects
::

::card
# Formularios HTML - Repaso

Para crear nuevos registros, necesitamos formularios HTML.

### Estructura básica de un formulario
```html
<form action="/projects" method="POST">
  <label>
    Título:
    <input type="text" name="title" required>
  </label>

  <label>
    Descripción:
    <textarea name="description" required></textarea>
  </label>

  <label>
    Estado:
    <select name="status" required>
      <option value="planning">Planificación</option>
      <option value="in-progress">En progreso</option>
      <option value="completed">Completado</option>
    </select>
  </label>

  <button type="submit">Crear Proyecto</button>
</form>
```

### Atributos importantes
- `action="/projects"` - URL donde se envían los datos
- `method="POST"` - Método HTTP (POST para crear)
- `name="title"` - Nombre del campo (clave en `req.body`)
- `required` - Campo obligatorio
::

::card
# Express Body Parser

Para recibir datos de formularios, necesitas configurar Express.

### Middleware necesario
```js
// app.js

// ⚠️ IMPORTANTE: Añadir ANTES de las rutas
app.use(express.urlencoded({ extended: true }));

// Ahora puedes usar req.body en tus rutas
app.post('/projects', async (req, res) => {
  console.log(req.body); // { title: '...', description: '...', status: '...' }
});
```

### ¿Qué hace este middleware?
Convierte los datos del formulario HTML en un objeto JavaScript accesible en `req.body`.

### Ejemplo completo
```js
import express from 'express';

const app = express();

// Configurar body parser
app.use(express.urlencoded({ extended: true }));

// Ruta para mostrar formulario
app.get('/projects/new', (req, res) => {
  res.render('project-form');
});

// Ruta para procesar formulario
app.post('/projects', async (req, res) => {
  const { title, description, status } = req.body;
  console.log('Datos recibidos:', { title, description, status });
  // Aquí crearemos el proyecto en la base de datos
});
```
::

::card
# Crear nuevos registros (CREATE)

### Implementación completa
```js
app.post('/projects', async (req, res) => {
  await db.read();

  // Obtener datos del formulario
  const { title, description, status } = req.body;

  // Generar ID único
  const newId = db.data.projects.length > 0
    ? Math.max(...db.data.projects.map(p => p.id)) + 1
    : 1;

  // Crear nuevo proyecto
  const newProject = {
    id: newId,
    title,
    description,
    status,
    createdAt: new Date().toISOString()
  };

  // Añadir a la base de datos
  db.data.projects.push(newProject);

  // Guardar cambios
  await db.write();

  // Redirigir a la lista
  res.redirect('/projects');
});
```

### Generación de IDs
```js
// Obtener el ID más alto y sumar 1
const newId = db.data.projects.length > 0
  ? Math.max(...db.data.projects.map(p => p.id)) + 1
  : 1;

// Explicación:
// 1. db.data.projects.map(p => p.id) → [1, 2, 3]
// 2. Math.max(...[1, 2, 3]) → 3
// 3. 3 + 1 → 4 (nuevo ID)
```
::

::card
# Pattern: POST/Redirect/GET

### ¿Por qué redirigir después de POST?

**Problema sin redirección:**
```js
app.post('/projects', async (req, res) => {
  // Crear proyecto...
  res.render('projects', { projects: db.data.projects });
});
```

Si el usuario recarga la página (F5), el formulario se enviará de nuevo → **datos duplicados**.

### Solución: POST/Redirect/GET
```js
app.post('/projects', async (req, res) => {
  // Crear proyecto...
  await db.write();

  // Redirigir a la página de lista (GET)
  res.redirect('/projects');
});

app.get('/projects', async (req, res) => {
  await db.read();
  res.render('projects', { projects: db.data.projects });
});
```

### Flujo completo
1. Usuario envía formulario (POST /projects)
2. Servidor crea el proyecto
3. Servidor responde con redirección (302 → GET /projects)
4. Navegador hace GET /projects
5. Se muestra la lista actualizada
6. Si el usuario recarga (F5), solo repite el GET (seguro)
::

::card
# Mostrar formulario de creación

### Ruta para el formulario
```js
app.get('/projects/new', (req, res) => {
  res.render('project-form', {
    pageTitle: 'Nuevo Proyecto'
  });
});
```

### Vista del formulario
```handlebars
<!-- views/project-form.handlebars -->
<h1>{{pageTitle}}</h1>

<form action="/projects" method="POST">
  <div>
    <label for="title">Título:</label>
    <input
      type="text"
      id="title"
      name="title"
      required
      placeholder="Ej: Mi Portfolio"
    >
  </div>

  <div>
    <label for="description">Descripción:</label>
    <textarea
      id="description"
      name="description"
      required
      rows="5"
      placeholder="Describe tu proyecto..."
    ></textarea>
  </div>

  <div>
    <label for="status">Estado:</label>
    <select id="status" name="status" required>
      <option value="">-- Selecciona un estado --</option>
      <option value="planning">Planificación</option>
      <option value="in-progress">En progreso</option>
      <option value="completed">Completado</option>
    </select>
  </div>

  <button type="submit">Crear Proyecto</button>
  <a href="/projects">Cancelar</a>
</form>
```

### Orden importante de las rutas
```js
// ⚠️ ORDEN CORRECTO
app.get('/projects/new', (req, res) => { /* ... */ });  // Específica primero
app.get('/projects/:id', (req, res) => { /* ... */ });  // General después

// ❌ ORDEN INCORRECTO
app.get('/projects/:id', (req, res) => { /* ... */ });  // Captura "new" como ID
app.get('/projects/new', (req, res) => { /* ... */ });  // Nunca se alcanza
```
::

::card
# Práctica: Formulario de creación

### Objetivo
Crear un formulario funcional para añadir proyectos a la base de datos.

### Paso 1: Añade las rutas
```js
// Mostrar formulario
app.get('/projects/new', (req, res) => {
  res.render('project-form', { pageTitle: 'Nuevo Proyecto' });
});

// Procesar formulario
app.post('/projects', async (req, res) => {
  await db.read();

  const { title, description, status } = req.body;

  const newId = db.data.projects.length > 0
    ? Math.max(...db.data.projects.map(p => p.id)) + 1
    : 1;

  const newProject = {
    id: newId,
    title,
    description,
    status
  };

  db.data.projects.push(newProject);
  await db.write();

  res.redirect('/projects');
});
```

### Paso 2: Crea la vista `project-form.handlebars`

### Paso 3: Añade enlace en la lista
```handlebars
<!-- views/projects.handlebars -->
<h1>Mis Proyectos</h1>
<a href="/projects/new">+ Nuevo Proyecto</a>

<!-- Lista de proyectos... -->
```

### Paso 4: Prueba
1. Visita http://localhost:3000/projects/new
2. Llena el formulario
3. Envía
4. Verifica que aparezca en la lista
5. Revisa el archivo `db.json` - debe tener el nuevo registro
::

::card
# Estructura del proyecto completa

### Organización recomendada
```bash
mi-proyecto/
├── app.js                      # Servidor principal
├── db.json                     # Base de datos
├── .env                        # Variables de entorno
├── .gitignore                  # Archivos a ignorar
├── package.json
├── views/
│   ├── layouts/
│   │   └── main.handlebars     # Layout principal
│   ├── projects.handlebars     # Lista de proyectos
│   ├── project-detail.handlebars  # Detalle
│   ├── project-form.handlebars    # Formulario
│   └── 404.handlebars          # Página de error
└── public/                     # Archivos estáticos (opcional)
    └── styles.css
```

### Archivo .gitignore
```bash
# .gitignore
node_modules/
.env
db.json          # Opcional: no subir datos de desarrollo
*.log
```

### ¿Por qué no subir db.json?
En desarrollo, cada desarrollador puede tener datos de prueba diferentes. En producción, la base de datos no debe estar en el repositorio.
::

::card
# Inicializar datos por defecto

### Problema
Si `db.json` no existe o está vacío, la app puede fallar.

### Solución: Datos por defecto
```js
// app.js
import { Low } from 'lowdb';
import { JSONFile } from 'lowdb/node';

// Datos por defecto
const defaultData = {
  projects: [
    {
      id: 1,
      title: 'Proyecto de ejemplo',
      description: 'Este es un proyecto de prueba',
      status: 'completed'
    }
  ]
};

// Inicializar base de datos
const adapter = new JSONFile('db.json');
const db = new Low(adapter, defaultData);

// Leer datos (si el archivo no existe, usa defaultData)
await db.read();

// Si está vacío, inicializar con datos por defecto
if (!db.data || !db.data.projects) {
  db.data = defaultData;
  await db.write();
  console.log('Base de datos inicializada con datos por defecto');
}
```

### Mejor práctica: Función helper
```js
async function initializeDatabase() {
  const adapter = new JSONFile('db.json');
  const db = new Low(adapter, { projects: [] });

  await db.read();

  // Si no hay proyectos, añadir ejemplos
  if (db.data.projects.length === 0) {
    db.data.projects = [
      { id: 1, title: 'Ejemplo 1', description: 'Descripción', status: 'completed' },
      { id: 2, title: 'Ejemplo 2', description: 'Descripción', status: 'in-progress' }
    ];
    await db.write();
  }

  return db;
}

// Usar en la app
const db = await initializeDatabase();
```
::

::card
# Manejo de errores

### Try/Catch en operaciones de base de datos
```js
app.post('/projects', async (req, res) => {
  try {
    await db.read();

    const { title, description, status } = req.body;

    // Validación
    if (!title || !description || !status) {
      return res.status(400).render('project-form', {
        error: 'Todos los campos son obligatorios',
        data: req.body
      });
    }

    const newId = db.data.projects.length > 0
      ? Math.max(...db.data.projects.map(p => p.id)) + 1
      : 1;

    const newProject = {
      id: newId,
      title,
      description,
      status,
      createdAt: new Date().toISOString()
    };

    db.data.projects.push(newProject);
    await db.write();

    res.redirect('/projects');

  } catch (error) {
    console.error('Error al crear proyecto:', error);
    res.status(500).render('error', {
      message: 'Error al crear el proyecto'
    });
  }
});
```

### Validación de datos
```js
function validateProject(data) {
  const errors = [];

  if (!data.title || data.title.trim() === '') {
    errors.push('El título es obligatorio');
  }

  if (!data.description || data.description.trim() === '') {
    errors.push('La descripción es obligatoria');
  }

  if (!['planning', 'in-progress', 'completed'].includes(data.status)) {
    errors.push('Estado inválido');
  }

  return errors;
}

// Usar en la ruta
app.post('/projects', async (req, res) => {
  const errors = validateProject(req.body);

  if (errors.length > 0) {
    return res.status(400).render('project-form', {
      errors,
      data: req.body
    });
  }

  // Continuar con la creación...
});
```
::

::card
# Ejemplo completo: app.js

```js
// app.js
import 'dotenv/config';
import express from 'express';
import { engine } from 'express-handlebars';
import { Low } from 'lowdb';
import { JSONFile } from 'lowdb/node';

const app = express();
const PORT = process.env.PORT || 3000;

// Configurar LowDB
const adapter = new JSONFile('db.json');
const db = new Low(adapter, { projects: [] });
await db.read();

// Configurar Handlebars
app.engine('handlebars', engine());
app.set('view engine', 'handlebars');
app.set('views', './views');

// Middleware
app.use(express.urlencoded({ extended: true }));

// RUTAS

// Lista de proyectos
app.get('/projects', async (req, res) => {
  await db.read();
  res.render('projects', {
    projects: db.data.projects,
    pageTitle: 'Mis Proyectos'
  });
});

// Formulario nuevo proyecto
app.get('/projects/new', (req, res) => {
  res.render('project-form', {
    pageTitle: 'Nuevo Proyecto'
  });
});

// Detalle de proyecto
app.get('/projects/:id', async (req, res) => {
  await db.read();

  const projectId = parseInt(req.params.id);
  const project = db.data.projects.find(p => p.id === projectId);

  if (!project) {
    return res.status(404).render('404', {
      message: 'Proyecto no encontrado'
    });
  }

  res.render('project-detail', { project });
});

// Crear proyecto
app.post('/projects', async (req, res) => {
  try {
    await db.read();

    const { title, description, status } = req.body;

    const newId = db.data.projects.length > 0
      ? Math.max(...db.data.projects.map(p => p.id)) + 1
      : 1;

    const newProject = {
      id: newId,
      title,
      description,
      status,
      createdAt: new Date().toISOString()
    };

    db.data.projects.push(newProject);
    await db.write();

    res.redirect('/projects');
  } catch (error) {
    console.error('Error:', error);
    res.status(500).send('Error al crear proyecto');
  }
});

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
```
::

::card
# Resumen

### Conceptos clave aprendidos:

**LowDB:**
- Base de datos JSON simple para Node.js
- Perfecta para aprender y prototipar
- Los datos persisten entre reinicios del servidor

**Operaciones básicas:**
```js
// Leer
await db.read();
const projects = db.data.projects;

// Crear
db.data.projects.push(newProject);
await db.write();

// Buscar
const project = db.data.projects.find(p => p.id === id);
```

**Express + LowDB:**
- Middleware `express.urlencoded()` para formularios
- Pattern POST/Redirect/GET para evitar duplicados
- Try/catch para manejo de errores

**Estructura típica:**
```js
app.get('/resource', async (req, res) => {
  await db.read();
  res.render('view', { data: db.data.resource });
});

app.post('/resource', async (req, res) => {
  await db.read();
  // Crear recurso
  await db.write();
  res.redirect('/resource');
});
```

### Próximos pasos:
En la siguiente lección (Día 5) aprenderemos a:
- Actualizar registros (UPDATE)
- Eliminar registros (DELETE)
- Completar el CRUD completo
::
