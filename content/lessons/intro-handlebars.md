::card
# Handlebars (HBS)
Handlebars es un motor de plantillas que permite generar HTML dinámico desde el servidor.

Podemos visitar la web oficial del paquete de node aquí:  
https://www.npmjs.com/package/express-handlebars

### ¿Qué es un motor de plantillas?
Un motor de plantillas (template engine) es una herramienta que permite crear HTML dinámico mezclando código HTML con datos del servidor.


### Ejemplo de archivos HTML y Handlebars
|Archivos HTML (.html) |Archivos en Handlebars (.handlebars)|
|-------------|----------------------|
|index.html| index.handlebars|
|about-me.html| about-me.handlebars|
|blog.html|blog.handlebars|

Algunas instalaciones de handlebars utilizan la extensión abreviada `.hbs` en vez de `.handlebars`. 
Nosotros utiliziramoes la versión por defecto.

::

::card
# ¿Por qué usar Handlebars?

Hasta ahora hemos renderizado HTML de dos formas:

**Forma 1: HTML inline**
```js
app.get('/', (req, res) => {
  res.send('<h1>Hello World</h1>');
});
```

**Forma 2: Archivos HTML estáticos**
```js
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'views', 'home.html'));
});
```

### El problema
Ambas formas tienen una limitación: **el contenido es estático**. No podemos insertar datos dinámicos fácilmente.
Esto es especialmente relevante cuando trabajamos con bases de datos.

### La solución: Handlebars
Con Handlebars podemos crear plantillas HTML que se llenan con datos del servidor:

```js
// app.js


app.get('/user', (req, res) => {
  res.render('profile', {  // llamará al archivo profile.handlebars
    name: 'Ana',
    age: 25
  });
});
```

```html
<!-- profile.handlebars -->

<h1>Hola, {{name}}!</h1>
<p>Tienes {{age}} años</p>
```

**Resultado:** `<h1>Hola, Ana!</h1><p>Tienes 25 años</p>`
::

::card
# Instalación y Configuración

### Paso 1: Instalar Handlebars

En una instalación existente de Express debemos añadir el siguiente paquete:

```bash
npm install express-handlebars
```

<details>
<summary>Recordatorio de como instalar Express</summary>

```bash
npm init --yes
npm install express
npm pkg set type=module
npm install dotenv # opcional
```
</details>


### Paso 2: Configurar Express
```js
// app.js
import express from 'express';
import { engine } from 'express-handlebars';

const app = express();

// Configurar Handlebars como motor de plantillas
app.engine('handlebars', engine());
app.set('view engine', 'handlebars');
app.set('views', './views');

app.listen(3000, () => {
  console.log(`Server running at http://localhost:3000/`);
});
```

### Paso 3: Estructura de carpetas

Crearemos la carpeta `views/`. La estructura de nuestro proyecto será la siguiente:

```bash
mi-proyecto/
├── app.js
├── views/
│   ├── home.handlebars
│   ├── about.handlebars
│   └── layouts/
│       └── main.handlebars
└── package.json
```
::

::card
# Nuestra primera plantilla con Handlebars

### Paso 1: Crear el layout principal
El layout es la estructura base que todas las páginas comparten (header, footer, etc.).

```html
<!-- views/layouts/main.handlebars -->
<!DOCTYPE html>
<html>
  <head>
    <title>Mi Aplicación</title>
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
    <header>
      <nav>
        <a href="/">Inicio</a>
        <a href="/about">Sobre Mi</a>
      </nav>
    </header>

    {{{body}}}

    <footer>
      <p>&copy; DevWomen 2025</p>
    </footer>
  </body>
</html>
```

**Nota:** `{{{body}}}` es donde se insertará el contenido de cada página.
::

::card
# Crear una página con Handlebars

### Paso 2: Crear la vista home
```html
<!-- views/home.handlebars -->
<h1>Bienvenida {{name}}!</h1>
<p>Esta es tu página de inicio</p>
```

### Paso 3: Renderizar desde Express
```js
// app.js

// ... Resto del código

app.get('/', (req, res) => {
  res.render('home', {
      name: 'John Doe' // Prueba añadiendo tu nombre
  });
});

// ... Resto del código

```

### ¿Qué sucede aquí?
1. El Usuario visita `/`
2. `res.render` buscará `views/home.handlebars` por el argumento `home`
3. El segundo argumento insertará el objecto que se ha definido
4. El contenido aparecerá dentro `{{{body}}}`
4. Para visitar la web ir al navegador: `http://localhost:3000`

<figure>
  <img src="/images/lessons/handlebars-first-web.webp">
  <figcaption>🎉 Ya tenemos nuestra primera web con NodeJS + Express + Handlebars</figcaption>
</figure>

::

::card
# Ejercicio Práctico: Implementar `/about`

1. Implementar la ruta `/about` en `app.js`
2. Anádir un objeto `title`, `coverImage` y `content` Ejemplo:
```js
{
  title: 'Sobre mi',
  coverImage: 'https://placecats.com/millie/500/400',
  content:  'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Laudantium, quam?'
}
```
3. Revisar que el contenido aparece en la web `http://localhost:3000/about`

<details>
<summary>Solución:</summary>

```js
// app.js

app.get('/about', (req, res) => {
  res.render('about', {
    title: 'Sobre mi',
    coverImage: 'https://placecats.com/millie/500/400',
    content:  'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Laudantium, quam?'
  });
});
```

```html
<!-- views/about.handlebars -->

<h1>{{title}}</h1>
<img src="{{coverImage}}" alt="">
<p>{{content}}</p>
```
</details>

::

::card
# Sintaxis de Handlebars

### Variables simples
```html
<h1>{{title}}</h1>
<p>{{description}}</p>
```

```js
res.render('page', {
  title: 'Mi Título',
  description: 'Mi descripción'
});
```

### Objetos
```html
<h2>{{user.name}}</h2>
<p>Email: {{user.email}}</p>
```

```js
res.render('page', {
  user: {
    name: 'Ana',
    email: 'ana@example.com'
  }
});
```

### Diferencia entre 2 llaves `{{}}` y 3 llaves `{{{}}}`
- `{{variable}}` - Escapa HTML (seguro contra XSS)
- `{{{variable}}}` - Renderiza HTML sin escapar (¡cuidado!)

```js
const data = { code: '<strong>Bold</strong>' };
```

```html
{{code}}   → &lt;strong&gt;Bold&lt;/strong&gt;
{{{code}}} → <strong>Bold</strong>
```
::

::card
# Condicionales en Handlebars

### Sintaxis básica con `if`

```html
<!-- page.handlebars -->

{{#if user}}
  <h1>Bienvenida {{user.name}}!</h1>
{{else}}
  <p>Por favor inicia sesión</p>
{{/if}}
```

### Podemos probar estas dos rutas:

Con un usuario definido:
```js
// app.js

// Con usuario
res.render('page', { user: { name: 'Ana' } });
// Resultado: "Bienvenido, Ana!"
```

Sin Usuario definido:
```js
// Sin usuario
res.render('page', { user: null });
// Resultado: "Por favor inicia sesión"
```

### Verificar valores específicos (true/false)
```html
{{#if isPremium}}
  <div class="premium-badge">Usuario Premium ⭐</div>
{{/if}}
```

```js
res.render('profile', { isPremium: true });
```
::

::card
# Iteraciones: Listando datos

### Sintaxis con `each`
```html
<!-- students.handlebars -->

<h2>Lista de Estudiantes</h2>
<ul>
  {{#each students}}
    <li>{{this.name}} - {{this.country}}</li>
  {{/each}}
</ul>
```

```js
// app.js

app.get('/students', (req, res) => {
  res.render('students', {
    students: [
      { name: 'Ana', country: 'Portugal' },
      { name: 'Luis', country: 'Chile' },
      { name: 'María', country: 'España' }
    ]
  });
});
```

**Resultado:**
```html
<h2>Lista de Estudiantes</h2>
<ul>
  <li>Ana - Portugal</li>
  <li>Luis - Chile</li>
  <li>María - España</li>
</ul>
```
::

::card
# `each` con índice

### Usando @index
```html
<table>
  {{#each products}}
    <tr>
      <td>{{@index}}</td>
      <td>{{this.name}}</td>
      <td>{{this.price}}€</td>
    </tr>
  {{/each}}
</table>
```

```js
res.render('products', {
  products: [
    { name: 'Laptop', price: 899 },
    { name: 'Mouse', price: 25 },
    { name: 'Teclado', price: 75 }
  ]
});
```

**Resultado:**
```html
<table>
  <tr><td>0</td><td>Laptop</td><td>899€</td></tr>
  <tr><td>1</td><td>Mouse</td><td>25€</td></tr>
  <tr><td>2</td><td>Teclado</td><td>75€</td></tr>
</table>
```
::

::card
# Manejo de listas vacías

### Usando `else` con `each`
```html
<h2>Mis Tareas</h2>
{{#each tasks}}
  <div class="task">
    <input type="checkbox" {{#if this.done}}checked{{/if}}>
    {{this.title}}
  </div>
{{else}}
  <p>No tienes tareas pendientes 🎉</p>
{{/each}}
```

```js
// Con tareas
res.render('tasks', {
  tasks: [
    { title: 'Estudiar Node.js', done: false },
    { title: 'Practicar Express', done: true }
  ]
});

// Sin tareas
res.render('tasks', { tasks: [] });
// Muestra: "No tienes tareas pendientes 🎉"
```
::

::card
# Route Params con Handlebars

Los **route params** son valores dinámicos en la URL que podemos usar en nuestras plantillas.

### Ejemplo básico
```js
// app.js
app.get('/user/:username', (req, res) => {
  const username = req.params.username;

  res.render('profile', {
    username: username
  });
});
```

```html
<!-- views/profile.handlebars -->
<h1>Perfil de @{{username}}</h1>
<p>Bienvenido a tu página personal</p>
```

**Ejemplos de uso:**
- `/user/ana` → Muestra "Perfil de @ana"
- `/user/luis` → Muestra "Perfil de @luis"
::

::card
# Route Params: Ejemplo con datos

### Simulando una base de datos
```js
const users = [
  { id: 1, name: 'Ana García', role: 'Developer' },
  { id: 2, name: 'Luis Martínez', role: 'Designer' },
  { id: 3, name: 'María López', role: 'Manager' }
];

app.get('/users/:id', (req, res) => {
  const userId = parseInt(req.params.id);
  const user = users.find(u => u.id === userId);

  if (user) {
    res.render('user-details', { user });
  } else {
    res.status(404).send('Usuario no encontrado');
  }
});
```

```html
<!-- views/user-detail.handlebars -->
<div class="user-card">
  <h1>{{user.name}}</h1>
  <p>Rol: {{user.role}}</p>
  <a href="/users">← Volver a la lista</a>
</div>
```
::

::card
# Múltiples Route Params

Puedes tener varios parámetros en una misma ruta:

```js
app.get('/blog/:year/:month/:slug', (req, res) => {
  res.render('post', {
    year: req.params.year,
    month: req.params.month,
    slug: req.params.slug
  });
});
```

```html
<!-- views/post.handlebars -->
<article>
  <small>Publicado: {{month}}/{{year}}</small>
  <h1>{{slug}}</h1>
</article>
```

**Ejemplo:**
- URL: `/blog/2024/11/intro-handlebars`
- Resultado: "Publicado: 11/2024" + "intro-handlebars"
::

::card
# Partials en Handlebars

Los **partials** son fragmentos de código HTML reutilizables.

### ¿Por qué usar partials?
Evitan duplicar código que aparece en varias páginas (navegación, tarjetas, etc.).

### Estructura de carpetas
```bash
views/
├── layouts/
│   └── main.handlebars
├── partials/
│   ├── navbar.handlebars
│   └── user-card.handlebars
└── home.handlebars
```

### Configuración en Express
```js
import { engine } from 'express-handlebars';

app.engine('handlebars', engine({
  partialsDir: './views/partials'
}));
```
::

::card
# Crear y usar Partials

### Crear un partial
```html
<!-- views/partials/navbar.handlebars -->
<nav>
  <a href="/">Inicio</a>
  <a href="/about">Sobre Nosotros</a>
  <a href="/contact">Contacto</a>
</nav>
```

### Usar el partial
```html
<!-- views/home.handlebars -->
{{> navbar}}

<h1>Página Principal</h1>
<p>Contenido de la página...</p>
```

El `{{> navbar}}` se reemplaza por el contenido de `navbar.handlebars`.
::

::card
# Partials con datos

Los partials pueden recibir datos:

```html
<!-- views/partials/user-card.handlebars -->
<div class="card">
  <h3>{{name}}</h3>
  <p>{{email}}</p>
</div>
```

```html
<!-- views/team.handlebars -->
<h1>Nuestro Equipo</h1>

{{#each members}}
  {{> user-card name=this.name email=this.email}}
{{/each}}
```

```js
app.get('/team', (req, res) => {
  res.render('team', {
    members: [
      { name: 'Ana', email: 'ana@example.com' },
      { name: 'Luis', email: 'luis@example.com' }
    ]
  });
});
```
::

::card
# Layouts personalizados

Puedes tener diferentes layouts para diferentes secciones:

```js
// Layout para páginas públicas
app.get('/', (req, res) => {
  res.render('home', { layout: 'main' });
});

// Layout para dashboard (sin layout)
app.get('/dashboard', (req, res) => {
  res.render('dashboard', { layout: false });
});

// Layout para admin
app.get('/admin', (req, res) => {
  res.render('admin-panel', { layout: 'admin' });
});
```

### Estructura:
```bash
views/
├── layouts/
│   ├── main.handlebars      # Layout público
│   └── admin.handlebars     # Layout administrador
├── home.handlebars
├── dashboard.handlebars
└── admin-panel.handlebars
```
::

::card
# Ejemplo completo: Lista de proyectos

### Estructura del proyecto
```bash
mi-app/
├── app.js
├── projects.json
├── views/
│   ├── layouts/
│   │   └── main.handlebars
│   ├── partials/
│   │   └── project-card.handlebars
│   ├── projects.handlebars
│   └── project-detail.handlebars
└── package.json
```

### Paso 1: Crear archivo de datos
```json
// projects.json
[
  {
    "id": 1,
    "title": "Portfolio Personal",
    "description": "Mi sitio web",
    "status": "completed"
  },
  {
    "id": 2,
    "title": "App de Tareas",
    "description": "Gestor de tareas",
    "status": "in-progress"
  },
  {
    "id": 3,
    "title": "Blog Técnico",
    "description": "Blog sobre programación",
    "status": "planning"
  }
]
```

### Paso 2: Configurar Express con Handlebars
```js
// app.js

import 'dotenv/config';
import express from 'express';
import { engine } from 'express-handlebars';
import { readFileSync } from 'fs';

const app = express();
const PORT = process.env.PORT || 3000;

// Leer datos del archivo JSON
const projectsData = readFileSync('./projects.json', 'utf-8');
const projects = JSON.parse(projectsData);

// Configurar Handlebars
app.engine('handlebars', engine());
app.set('view engine', 'handlebars');
app.set('views', './views');

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}/`);
});


```
::

::card
# Ejemplo completo: Rutas

### Paso 3: Definir rutas
```js
// app.js

// ... Resto del código

// Lista de proyectos
app.get('/projects', (req, res) => {
  res.render('projects', {
    projects: projects,
    pageTitle: 'Mis Proyectos'
  });
});

// Detalle de un proyecto
app.get('/projects/:id', (req, res) => {
  const projectId = parseInt(req.params.id);
  const project = projects.find(p => p.id === projectId);

  if (project) {
    res.render('project-detail', { project });
  } else {
    res.status(404).send('Proyecto no encontrado');
  }
});

// ... Resto del código
```
::

::card
# Ejemplo completo: Vistas

```html
<!-- views/partials/project-card.handlebars -->
<div class="project-card">
  <h3>{{title}}</h3>
  <p>{{description}}</p>
  <span class="status-{{status}}">{{status}}</span>
  <a href="/projects/{{id}}">Ver detalles →</a>
</div>
```

```html
<!-- views/projects.handlebars -->
<h1>{{pageTitle}}</h1>

<div class="projects-grid">
  {{#each projects}}
    {{> project-card}}
  {{else}}
    <p>No hay proyectos todavía</p>
  {{/each}}
</div>

<a href="/projects/new">+ Nuevo Proyecto</a>
```
::

::card
# Ejemplo completo: Vista de detalle

```html
<!-- views/project-detail.handlebars -->
<article class="project-detail">
  <header>
    <h1>{{project.title}}</h1>
    <span class="badge">{{project.status}}</span>
  </header>

  <section>
    <h2>Descripción</h2>
    <p>{{project.description}}</p>
  </section>

  <footer>
    <a href="/projects">← Volver a proyectos</a>
    <a href="/projects/{{project.id}}/edit">Editar</a>
  </footer>
</article>
```
::

::card
# Buenas prácticas con Handlebars

### Organización de archivos
✅ **Hacer:**
- Usar layouts para estructura común
- Crear partials para componentes reutilizables
- Mantener lógica en el servidor, no en las vistas
- Usar nombres descriptivos para variables

❌ **Evitar:**
- Lógica compleja en las plantillas
- Duplicar código HTML
- Mezclar estilos inline (usa archivos CSS)

### Seguridad
✅ Usar `{{variable}}` para escapar HTML automáticamente
❌ Evitar `{{{variable}}}` con contenido de usuarios (riesgo XSS)

### Performance
✅ Reutilizar partials  
✅ Pasar solo los datos necesarios a las vistas  
❌ No pasar objetos enormes sin filtrar  
::

::card
# Resumen

### Conceptos clave aprendidos:

**Handlebars (HBS):**
- Motor de plantillas para generar HTML dinámico
- Separa la estructura (HTML) de los datos (JavaScript)
- Permite crear páginas web con contenido dinámico

**Sintaxis básica:**
- `{{variable}}` - Insertar variables (escapado)
- `{{{variable}}}` - Insertar HTML sin escapar
- `{{#if}}` - Condicionales
- `{{#each}}` - Iteraciones
- `{{> partial}}` - Incluir partials

**Route params:**
```js
app.get('/user/:id', (req, res) => {
  res.render('profile', { userId: req.params.id });
});
```

**Estructura recomendada:**
```bash
views/
├── layouts/     # Estructura base
├── partials/    # Componentes reutilizables
└── *.handlebars # Páginas individuales
```

### Próximos pasos:
En las siguientes lecciones aprenderemos a conectar Handlebars con bases de datos para crear aplicaciones web completas con datos persistentes.
::
