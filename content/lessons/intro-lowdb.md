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

**Problema:** Si reinicias el servidor, los cambios hechos se pierden.

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
# Esquema Cliente - Servidor - BBDD

<figure>
  <img src="/images/lessons/network-diagram-for-client-server.webp">
</figure>
::

::card
# CRUD - Operaciones básicas

CRUD es un acrónimo que representa las cuatro operaciones fundamentales que puedes realizar con datos en una base de datos:

## C - Create (Crear)
Añadir nuevos registros a la base de datos.
- Ejemplo: Crear un nuevo proyecto

## R - Read (Leer)
Obtener y mostrar datos existentes.
- Ejemplo: Ver la lista de proyectos o ver los detalles de un proyecto

## U - Update (Actualizar)
Modificar registros existentes.
- Ejemplo: Editar el título o estado de un proyecto

## D - Delete (Eliminar)
Borrar registros de la base de datos.
- Ejemplo: Eliminar un proyecto que ya no necesitas
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
├── db.json # Base de datos (se creará automáticamente)
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

**Nota:** Si el archivo no existe, LowDB creará un archivo vacío automáticamente.
::

::card

# Handlebars Layout

Vamos a crear ahora el layout principal `/views/main/main.handlebars`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
  <link rel="stylesheet" href="/styles.css">
</head>
<body>
  <h1>Aprendiendo LowDB</h1>
  <a href="/projects/new">
    Crear Proyecto
  </a>
  {{{body}}}
</body>
</html>
```

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

// Configurar carpeta public
app.use(express.static('public'));

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
```html
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
```html
<!-- views/project-detail.handlebars -->
<article>
  <h1>{{project.title}}</h1>
  <p>{{project.description}}</p>
  <p>Estado: {{project.status}}</p>

  <a href="/projects">← Volver a la lista</a>
  <a href="/projects/{{project.id}}/edit">Editar</a>
</article>
```
::

::card
# Crear nuevos registros (CREATE)

Ahora que sabemos leer datos, vamos a aprender a crear nuevos registros.

## ¿Qué necesitamos?

Para crear datos desde una aplicación web necesitamos:

1. **Formulario HTML** - Interfaz para que el usuario ingrese datos
2. **Middleware de Express** - Para procesar datos del formulario
3. **Ruta POST** - Para recibir y guardar los datos

Vamos a ver cada parte paso a paso.
::

::card
# Formularios HTML

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

// resto del codigo y RUTAS ...

```
::

::card
# Mostrar el formulario de creación (CREATE)

### Ruta para el formulario
```js
app.get('/projects/new', (req, res) => {
  res.render('project-form', {
    pageTitle: 'Nuevo Proyecto'
  });
});
```

### Vista del formulario
```html
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
// ORDEN CORRECTO
app.get('/projects/new', (req, res) => { /* ... */ });  // Específica primero
app.get('/projects/:id', (req, res) => { /* ... */ });  // General después

// ORDEN INCORRECTO
app.get('/projects/:id', (req, res) => { /* ... */ });  // Captura "new" como ID
app.get('/projects/new', (req, res) => { /* ... */ });  // Nunca se alcanza
```
::

::card
# Estilos iniciales (CSS)
```css
/* Base */
body {
  font-family: system-ui, sans-serif;
  line-height: 1.6;
  color: #333;
  background-color: #f5f5f5;
  padding: 2rem;
  margin: 0;
}

* {
  box-sizing: border-box;
}

h1 {
  color: #2c3e50;
  margin-bottom: 2rem;
  padding-bottom: 1rem;
  border-bottom: 2px solid #ddd;
}

/* Lista de proyectos */
ul {
  list-style: none;
  padding: 0;
}

ul li {
  background: #fff;
  padding: 1.5rem;
  margin-bottom: 1rem;
  border: 1px solid #ddd;
  border-radius: 4px;
}

ul li h3 {
  margin: 0 0 0.5rem 0;
}

ul li p {
  color: #666;
  margin: 0 0 1rem 0;
}

ul li a,
ul li button {
  display: inline-block;
  padding: 0.5rem 1rem;
  margin-right: 0.5rem;
  border-radius: 4px;
  text-decoration: none;
  font-size: 0.9rem;
  cursor: pointer;
  border: none;
  font-family: inherit;
}

ul li a {
  background-color: #3498db;
  color: #fff;
}

ul li a:hover {
  background-color: #2980b9;
}

ul li button {
  background-color: #e74c3c;
  color: #fff;
}

ul li button:hover {
  background-color: #c0392b;
}

/* Detalle de proyecto */
article {
  background: #fff;
  padding: 2rem;
  border-radius: 4px;
  border: 1px solid #ddd;
}

article h1 {
  border: none;
  padding: 0;
}

article a,
article button {
  display: inline-block;
  padding: 0.75rem 1.5rem;
  margin: 1rem 0.5rem 0 0;
  border-radius: 4px;
  text-decoration: none;
  cursor: pointer;
  border: none;
  font-family: inherit;
}

article a {
  background-color: #3498db;
  color: #fff;
}

article a:hover {
  background-color: #2980b9;
}

article button {
  background-color: #e74c3c;
  color: #fff;
}

article button:hover {
  background-color: #c0392b;
}

/* Formularios */
form {
  background: #fff;
  padding: 2rem;
  border-radius: 4px;
  border: 1px solid #ddd;
  max-width: 600px;
}

form div {
  margin-bottom: 1rem;
}

form label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 600;
}

form input,
form textarea,
form select {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 1rem;
  font-family: inherit;
}

form input:focus,
form textarea:focus,
form select:focus {
  outline: none;
  border-color: #3498db;
}

form button {
  padding: 0.75rem 1.5rem;
  background-color: #27ae60;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  margin-right: 0.5rem;
  font-family: inherit;
}

form button:hover {
  background-color: #229954;
}

form a {
  display: inline-block;
  padding: 0.75rem 1.5rem;
  background-color: #95a5a6;
  color: #fff;
  text-decoration: none;
  border-radius: 4px;
}

form a:hover {
  background-color: #7f8c8d;
}
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
# Siguientes pasos: UPDATE y DELETE

Ahora que dominas las operaciones de **lectura (READ)** y **creación (CREATE)**, es momento de completar el CRUD con las operaciones restantes:

## UPDATE (Actualizar)
Aprende a editar proyectos existentes:
- Crear formularios de edición prellenados
- Actualizar registros en la base de datos
- Usar el spread operator para mantener datos existentes

Continúa en la siguiente lección: **LowDB - Update**


## DELETE (Eliminar)
Aprende a eliminar proyectos:
- Añadir botones de eliminación
- Confirmar antes de eliminar
- Usar `splice()` o `filter()` para eliminar registros

Continúa en la siguiente lección: **LowDB - Delete**

::

::card
# CRUD completo - Resumen de rutas

### Todas las rutas necesarias
```js
// CREATE - Mostrar formulario
app.get('/projects/new', (req, res) => {
  res.render('project-form', { pageTitle: 'Nuevo Proyecto' });
});

// CREATE - Procesar formulario
app.post('/projects', async (req, res) => {
  await db.read();
  // Crear proyecto...
  await db.write();
  res.redirect('/projects');
});

// READ - Lista completa
app.get('/projects', async (req, res) => {
  await db.read();
  res.render('projects', { projects: db.data.projects });
});

// READ - Un proyecto específico
app.get('/projects/:id', async (req, res) => {
  await db.read();
  const project = db.data.projects.find(p => p.id === parseInt(req.params.id));
  res.render('project-detail', { project });
});

// UPDATE - Mostrar formulario de edición
app.get('/projects/:id/edit', async (req, res) => {
  await db.read();
  const project = db.data.projects.find(p => p.id === parseInt(req.params.id));
  res.render('project-edit', { project });
});

// UPDATE - Procesar actualización
app.post('/projects/:id', async (req, res) => {
  await db.read();
  // Actualizar proyecto...
  await db.write();
  res.redirect(`/projects/${req.params.id}`);
});

// DELETE - Eliminar proyecto
app.post('/projects/:id/delete', async (req, res) => {
  await db.read();
  // Eliminar proyecto...
  await db.write();
  res.redirect('/projects');
});
```

### Orden correcto de las rutas
```js
// ✅ Específicas primero
app.get('/projects/new', ...)      // Literal "new"
app.get('/projects/:id/edit', ...) // Literal "edit"
app.get('/projects/:id', ...)      // Parámetro dinámico

// ❌ Incorrecto (/:id captura todo)
app.get('/projects/:id', ...)
app.get('/projects/new', ...)      // Nunca se alcanza
```
::

::card
# Resumen

### Conceptos clave aprendidos:

**LowDB:**
- Base de datos JSON simple para Node.js
- Perfecta para aprender y prototipar
- Los datos persisten entre reinicios del servidor

**Operaciones CRUD completas:**
```js
// CREATE - Crear
db.data.projects.push(newProject);
await db.write();
```

```js
// READ - Leer todos
await db.read();
const projects = db.data.projects;
```

```js
// READ - Buscar uno
const project = db.data.projects.find(p => p.id === id);
```

```js
// UPDATE - Actualizar
const index = db.data.projects.findIndex(p => p.id === id);
db.data.projects[index] = { ...db.data.projects[index], ...updates };
await db.write();
```

```js
// DELETE - Eliminar
const index = db.data.projects.findIndex(p => p.id === id);
db.data.projects.splice(index, 1);
await db.write();
```

**Express + LowDB:**
- Middleware `express.urlencoded()` para formularios
- Pattern POST/Redirect/GET para evitar duplicados
- Try/catch para manejo de errores

**Estructura típica:**
```js

// Muestra la página para crear un recurso
app.get('/resource', async (req, res) => {
  await db.read();
  res.render('view', { data: db.data.resource });
});

// Crear un recurso en la base de datos
app.post('/resource', async (req, res) => {
  await db.read();
  // Crear recurso
  await db.write();
  res.redirect('/resource');
});
```

::
