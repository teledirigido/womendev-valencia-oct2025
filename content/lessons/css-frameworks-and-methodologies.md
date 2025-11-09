::card
# CSS Frameworks y Metodologías

Escribir CSS puede parecer simple. Pero a medida que un proyecto crece, el CSS se puede volver difícil de mantener:

- Nombres de clases confusos
- Estilos que se sobrescriben sin querer
- Código duplicado
- Difícil de trabajar en equipo

Usar metodologías y frameworks nos pueden ayudar a organizar mejor nuestro código.

::

::card
# BEM - Block Element Modifier

BEM es una metodología de nomenclatura para CSS que hace tu código más legible y mantenible.

## La estructura BEM

```
.bloque__elemento--modificador
```

- **Block (Bloque):** Componente independiente reutilizable
- **Element (Elemento):** Parte del bloque que no tiene sentido por sí sola
- **Modifier (Modificador):** Variante o estado del bloque o elemento

## Ejemplo práctico

### Antes (sin BEM):
```html
<div class="card">
  <h3 class="title">Mi Proyecto</h3>
  <p class="description">Descripción del proyecto</p>
  <button class="button red">Eliminar</button>
</div>
```

```css
.card { background: #fff; padding: 1rem; }
.title { font-size: 1.5rem; }
.description { color: #666; }
.button { padding: 0.5rem 1rem; }
.red { background: red; color: white; }
```

**Problema:** `.title`, `.description`, `.button` son muy genéricos. Pueden chocar con otros estilos.

### Después (con BEM):
```html
<div class="project-card">
  <h3 class="project-card__title">Mi Proyecto</h3>
  <p class="project-card__description">Descripción del proyecto</p>
  <button class="project-card__button project-card__button--delete">Eliminar</button>
</div>
```

```css
.project-card {
  background: #fff;
  padding: 1rem;
}

.project-card__title {
  font-size: 1.5rem;
}

.project-card__description {
  color: #666;
}

.project-card__button {
  padding: 0.5rem 1rem;
}

.project-card__button--delete {
  background: red;
  color: white;
}
```

**Ventajas:**
- Nombres descriptivos y únicos
- Sabes exactamente dónde pertenece cada clase
- Evitas conflictos de estilos
- Fácil de entender para otros desarrolladores

::

::card
# OOCSS - Object-Oriented CSS

OOCSS es una metodología que trata los elementos de la interfaz como "objetos" reutilizables.

## Principios de OOCSS

### 1. Separar estructura y apariencia

- **Estructura:** Tamaño, posición, márgenes
- **Apariencia:** Colores, bordes, fondos

```css
/* Estructura (reutilizable) */
.button {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

/* Apariencia (variantes) */
.button-primary {
  background-color: #3498db;
  color: #fff;
}

.button-danger {
  background-color: #e74c3c;
  color: #fff;
}

.button-secondary {
  background-color: #95a5a6;
  color: #fff;
}
```

Uso:
```html
<button class="button button-primary">Guardar</button>
<button class="button button-danger">Eliminar</button>
<button class="button button-secondary">Cancelar</button>
```

### 2. Separar contenedor y contenido

Se recomienda no generar dependencia de nuestros elementos, ya sea por ubicación u otra razón.

**❌ No recomendado:**
```css
.sidebar .button {
  width: 100%;
}

.header .button {
  width: auto;
}
```

**✅ Recomendado:**
```css
.button-full {
  width: 100%;
}

.button-auto {
  width: auto;
}
```

```html
<div class="sidebar">
  <button class="button button-primary button-full">Login</button>
</div>

<div class="header">
  <button class="button button-primary button-auto">Login</button>
</div>
```

::

::card
# BEM + OOCSS en práctica

Podemos combinar ambas metodologías para obtener lo mejor de ambas.

## Ejemplo: Sistema de botones

```css
/* Objeto base (OOCSS) */
.btn {
  display: inline-block;
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-family: inherit;
}

/* Modificadores (BEM) */
.btn--primary {
  background-color: #3498db;
  color: #fff;
}

.btn--danger {
  background-color: #e74c3c;
  color: #fff;
}

.btn--small {
  padding: 0.5rem 1rem;
  font-size: 0.875rem;
}

.btn--large {
  padding: 1rem 2rem;
  font-size: 1.125rem;
}
```

Uso:
```html
<button class="btn btn--primary">Guardar</button>
<button class="btn btn--danger btn--small">Eliminar</button>
<button class="btn btn--primary btn--large">Crear Proyecto</button>
```

::

::card
# Aplicando BEM a nuestro proyecto

Vamos a refactorizar el CSS de nuestros proyectos usando BEM.

## Antes (sin metodología):
```html
<ul>
  <li>
    <h3>Mi Proyecto</h3>
    <p>Descripción</p>
    <span>Estado: completado</span>
    <a href="/projects/1">Ver detalles</a>
    <button>Eliminar</button>
  </li>
</ul>
```

```css
ul { list-style: none; }
li { background: #fff; padding: 1.5rem; }
h3 { font-size: 1.25rem; }
p { color: #666; }
a { background-color: #3498db; color: #fff; }
button { background-color: #e74c3c; color: #fff; }
```

## Después (con BEM):
```html
<ul class="project-list">
  <li class="project-list__item">
    <h3 class="project-list__title">Mi Proyecto</h3>
    <p class="project-list__description">Descripción</p>
    <span class="project-list__status project-list__status--completed">
      Estado: completado
    </span>
    <a href="/projects/1" class="project-list__link">Ver detalles</a>
    <button class="project-list__button project-list__button--delete">
      Eliminar
    </button>
  </li>
</ul>
```

```css
.project-list {
  list-style: none;
  padding: 0;
}

.project-list__item {
  background: #fff;
  padding: 1.5rem;
  margin-bottom: 1rem;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.project-list__title {
  font-size: 1.25rem;
  margin: 0 0 0.5rem 0;
}

.project-list__description {
  color: #666;
  margin: 0 0 1rem 0;
}

.project-list__status {
  display: inline-block;
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.875rem;
}

.project-list__status--planning {
  background-color: #fff3cd;
  color: #856404;
}

.project-list__status--in-progress {
  background-color: #d1ecf1;
  color: #0c5460;
}

.project-list__status--completed {
  background-color: #d4edda;
  color: #155724;
}

.project-list__link {
  background-color: #3498db;
  color: #fff;
  padding: 0.5rem 1rem;
  text-decoration: none;
  border-radius: 4px;
}

.project-list__button--delete {
  background-color: #e74c3c;
  color: #fff;
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
```
::

::card
# Utility First CSS

Utility-First es una metodología que propone usar clases pequeñas y específicas, 
cada una con un solo propósito, en lugar de crear clases semánticas con múltiples estilos.

## La filosofía

En lugar de crear clases personalizadas para cada componente, usamos clases de "utilidad" que hacen una sola cosa.

**Enfoque tradicional:**
```css
.card-title {
  font-size: 1.5rem;
  font-weight: bold;
  color: #333;
  margin-bottom: 0.5rem;
}
```

```html
<h3 class="card-title">Título</h3>
```

**Utility-First:**
```css
.text-xl { font-size: 1.5rem; }
.font-bold { font-weight: bold; }
.text-gray-800 { color: #333; }
.mb-2 { margin-bottom: 0.5rem; }
```

```html
<h3 class="text-xl font-bold text-gray-800 mb-2">Título</h3>
```

## Ventajas

1. No más nombres inventados.  
No tienes que pensar: "¿cómo llamo a esta clase?". Simplemente usas las utilidades existentes.
2. Cambios más rápidos.  
Todo está en el HTML. No necesitas ir al archivo CSS para hacer cambios.

3. CSS que no crece
Reutilizas las mismas clases de utilidad. Tu archivo CSS no crece con cada nuevo componente.

4. Consistencia automática.  
Usas valores predefinidos (espaciados, colores, tamaños), lo que mantiene el diseño coherente.

## Desventajas
1. HTML más largo.  
El HTML se vuelve más verboso con muchas clases.

```html
<!-- Puede verse así -->
<button class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 transition">
  Click
</button>
```
2. Repetición.  
Si un componente se repite mucho, duplicas las mismas clases varias veces.

3. Curva de aprendizaje.  
Necesitas aprender qué hace cada clase de utilidad.

4. Volviendo a crear componentes.  
Los frameworks utility-first terminan ofreciendo formas de agrupar clases (componentes, `@apply`), volviendo al enfoque tradicional para evitar la repetición.

5. Dependencia del framework.  
Aprendes las clases del framework, pero no CSS real, lo cual genera dependencia al framework.

<details>
<summary>BEM vs Utility-First</summary>

### BEM:

Clases con nombres que describen el propósito, no el estilo visual

```html
<button class="btn btn--primary btn--large">Guardar</button>
```


### Utility-First:

Clases funcionales que describen exactamente qué hacen (color, tamaño, espaciado)


```html 
<button class="px-6 py-3 bg-blue-500 text-white text-lg rounded">Guardar</button>
```
</details>

## ¿Cuándo usar Utility-First?


|Ideal para:|No recomendado para:|
|-----------|--------------------|
|Proyectos que cambian frecuentemente|Proyectos muy simples (puede ser excesivo)
|Equipos que quieren desarrollo rápido|Equipos que prefieren separación estricta HTML/CSS
|Aplicaciones con muchas variaciones de diseño|Si necesitas soporte para navegadores muy antiguos
|Cuando quieres un sistema de diseño consistente||

::

::card
# Conclusión sobre las diferentes metodologías

No existe una metodología "perfecta" para todos los proyectos. Cada una tiene su lugar y momento ideal.

### BEM (Block Element Modifier)
- Nombres claros y predecibles
- Evita conflictos de estilos
- Ideal para proyectos donde trabajas directamente con CSS

### OOCSS (Object-Oriented CSS)
- Reutilización de código
- Separación de estructura y apariencia
- Reduce duplicación de estilos

### Utility-First
- Desarrollo rápido sin inventar nombres
- Consistencia automática con valores predefinidos
- Puede alejar del aprendizaje profundo de CSS

## En la práctica

Muchos proyectos modernos **combinan** estas metodologías:

- Usan **BEM** para componentes grandes y únicos
- Aplican **OOCSS** para crear objetos reutilizables
- Adoptan **Utility-First** (como Tailwind) para desarrollo rápido o componentes visuales sin definición semántica

## Tu decisión depende de:

1. **Tamaño del proyecto:** ¿Simple o complejo?
2. **Equipo:** ¿Cuántas personas trabajarán en el CSS?
3. **Tiempo:** ¿Necesitas ir rápido o construir algo muy personalizado?
4. **Experiencia:** ¿El equipo conoce CSS a profundidad?
5. **Mantenimiento:** ¿El proyecto vivirá mucho tiempo?

## Recomendación para empezar

1. **Aprende CSS vanilla primero** - Entiende los fundamentos
2. **Practica con BEM** - Aprende a organizar tu código
3. **Experimenta con Utility-First** - Descubre la velocidad de desarrollo
4. **Decide según el proyecto** - No hay una solución única

Lo importante no es seguir una metodología religiosamente, sino escribir CSS que tú y tu equipo puedan mantener.

::

::card
# CSS Frameworks

Los frameworks CSS son bibliotecas preconstruidas que nos dan componentes y estilos listos para usar.
::

::card
# Bootstrap

Framework popular y muy utilizado.

**Ventajas:**
- Muy completo
- Gran comunidad
- Documentación extensa
- Componentes JavaScript incluidos

**Desventajas:**
- Archivos grandes
- Todos los sitios se ven similares
- Difícil de personalizar

**Cuándo usarlo:** Proyectos rápidos, prototipos, aplicaciones empresariales

```html
<!-- CDN de Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Ejemplo de uso -->
<button class="btn btn-primary">Click me</button>
<div class="card">
  <div class="card-body">
    <h5 class="card-title">Card title</h5>
    <p class="card-text">Some quick example text.</p>
  </div>
</div>
```

https://getbootstrap.com/

::

::card
# Material Design (Materialize, MUI)

Basado en el sistema de diseño de Google.

**Ventajas:**
- Diseño moderno y consistente
- Animaciones suaves
- Iconografía rica

**Desventajas:**
- Aspecto muy "Google"
- Curva de aprendizaje

**Cuándo usarlo:** Apps que quieren el look de Material Design


- https://m3.material.io/
- https://www.interaction-design.org/literature/topics/material-design
- https://material-web.dev/ (En mantenimiento)
::

::card

# Simple.css
Framework minimalista sin clases.

**Ventajas:**
- Extremadamente simple
- No necesitas clases
- Perfecto para páginas de contenido
- Muy ligero (~4KB)

**Desventajas:**
- Limitado en componentes
- No apto para interfaces complejas

```html
<!-- CDN de Simple.css -->
<link rel="stylesheet" href="https://cdn.simplecss.org/simple.min.css">

<!-- No necesitas clases, solo HTML semántico -->
<button>Click me</button>
<article>
  <h1>Title</h1>
  <p>Content here</p>
</article>

- https://simplecss.org/

```

**Cuándo usarlo:** Blogs, documentación, páginas simples

::

::card
# Tailwind

Tailwind es un utility-first framework muy popular.

## Filosofía: Utility-First

Tailwind promueve el uso de clases de utilidad directamente en el HTML, en vez de escribir CSS.

```html
<button class="px-6 py-3 bg-blue-500 text-white rounded">
  Click me
</button>
```

## Ventajas de Tailwind

1. **Rápido de desarrollar:** No cambias entre HTML y CSS
2. **No inventas nombres:** No más "¿cómo llamo a esta clase?"
3. **Consistencia:** Colores, espaciados y tamaños predefinidos
4. **Fácil de mantener:** Todo en un solo lugar
5. **Optimizado:** Solo incluye las clases que usas

## Desventajas de Tailwind

1. **HTML verboso:** Muchas clases en el HTML
2. **Curva de aprendizaje:** Debes aprender las clases
3. **Repetición:** Duplicas clases en componentes similares

::

::card
# Integrar Tailwind con Handlebars

## Paso 1: Actualizar el layout

```html
<!-- views/layouts/main.handlebars -->
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{{pageTitle}}</title>

  <!-- Tailwind CSS CDN -->
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body>
  {{{body}}}
</body>
</html>
```

**Nota:** Para producción es mejor instalar Tailwind con npm, pero para aprender el CDN funciona perfecto.

<details>
<summary>Instalar Tailwind con npm</summary>

1. Instalar Tailwind (v4)
```bash
npm install -D tailwindcss@latest
```

2. Crear archivo CSS de entrada (ej: `public/input.css`)
```css
/* public/input.css */
@import "tailwindcss";
```

Recuerda que en `app.js` necesitas añadir la carpeta `/public`:

```js
// app.js
app.use(express.static('public'));
```

3. Añadir un archivo de configuración de Tailwind

Necesitamos un archivo de configuración llamado `tailwind.config.js` para observar los archivos de handlebars:

```js
// tailwind.config.js
export default {
  content: ['./views/**/*.handlebars'],
}
```


4. Añadir scripts en `package.json`
```json
"scripts": {
  "build:css": "tailwindcss -i ./public/input.css -o ./public/output.css",
  "watch:css": "tailwindcss -i ./public/input.css -o ./public/output.css --watch"
}
```

5. Compilar CSS
```bash
# Para hacer un build
npm run build:css

# O en desarrollo (modo watch):
npm run watch:css
```

6. Enlazar el CSS compilado en tu HTML/Handlebars
```html
<link href="/output.css" rel="stylesheet">
```

7. (Opcional) Puedes añadir configuraciones personalizadas en `tailwind.config.js`
```javascript
export default {
  content: ['./views/**/*.handlebars'],
  theme: {
    extend: {
      colors: {
        primary: '#3498db',
      }
    }
  }
}
```

</details>


## Paso 2: Usar clases de Tailwind

### Clases básicas de Tailwind

```html
<!-- Colores -->
<div class="bg-blue-500">Fondo azul</div>
<div class="text-red-500">Texto rojo</div>

<!-- Espaciado -->
<div class="p-4">Padding 1rem (16px)</div>
<div class="m-2">Margin 0.5rem (8px)</div>
<div class="px-6 py-3">Padding horizontal 1.5rem, vertical 0.75rem</div>

<!-- Tamaños -->
<div class="w-full">Ancho 100%</div>
<div class="h-64">Altura 16rem</div>

<!-- Bordes -->
<div class="border border-gray-300">Borde gris</div>
<div class="rounded">Bordes redondeados</div>
<div class="rounded-lg">Bordes más redondeados</div>

<!-- Flexbox -->
<div class="flex items-center justify-between">
  <span>Izquierda</span>
  <span>Derecha</span>
</div>

<!-- Texto -->
<h1 class="text-2xl font-bold">Título grande y negrita</h1>
<p class="text-gray-600">Texto gris</p>
```

::

::card
# Refactorizar lista de proyectos con Tailwind

Vamos a convertir nuestra lista de proyectos para usar Tailwind.

## Antes (CSS personalizado):
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
{{/if}}
```

## Después (con Tailwind):
```html
<!-- views/projects.handlebars -->
<div class="max-w-4xl mx-auto p-6">
  <h1 class="text-3xl font-bold text-gray-800 mb-6 pb-4 border-b-2 border-gray-200">
    {{pageTitle}}
  </h1>

  {{#if projects.length}}
    <div class="space-y-4">
      {{#each projects}}
        <div class="bg-white p-6 rounded-lg border border-gray-200 hover:shadow-lg transition">
          <h3 class="text-xl font-semibold text-gray-800 mb-2">
            {{this.title}}
          </h3>

          <p class="text-gray-600 mb-4">
            {{this.description}}
          </p>

          <span class="inline-block px-3 py-1 bg-gray-100 text-gray-700 rounded-full text-sm mb-4">
            Estado: {{this.status}}
          </span>

          <div class="flex gap-2">
            <a
              href="/projects/{{this.id}}"
              class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 transition"
            >
              Ver detalles
            </a>

            <form action="/projects/{{this.id}}/delete" method="POST" class="inline">
              <button
                type="submit"
                class="px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600 transition"
                onclick="return confirm('¿Estás seguro?')"
              >
                Eliminar
              </button>
            </form>
          </div>
        </div>
      {{/each}}
    </div>
  {{else}}
    <div class="text-center py-12">
      <p class="text-gray-500 text-lg mb-4">No hay proyectos todavía.</p>
      <a
        href="/projects/new"
        class="inline-block px-6 py-3 bg-green-500 text-white rounded-lg hover:bg-green-600 transition"
      >
        Crear el primero
      </a>
    </div>
  {{/if}}
</div>
```

### Explicación de las clases:

- `max-w-4xl mx-auto`: Contenedor centrado con ancho máximo
- `space-y-4`: Espacio vertical entre elementos hijos
- `hover:shadow-lg`: Sombra al pasar el mouse
- `transition`: Transiciones suaves
- `rounded-lg`: Bordes redondeados grandes
- `bg-blue-500`: Fondo azul (500 es la intensidad)
- `hover:bg-blue-600`: Fondo más oscuro al hacer hover

::

::card
# Formulario con Tailwind

```html
<!-- views/project-form.handlebars -->
<div class="max-w-2xl mx-auto p-6">
  <h1 class="text-3xl font-bold text-gray-800 mb-6">{{pageTitle}}</h1>

  <form action="/projects" method="POST" class="bg-white p-8 rounded-lg border border-gray-200">
    <div class="mb-6">
      <label for="title" class="block text-gray-700 font-semibold mb-2">
        Título:
      </label>
      <input
        type="text"
        id="title"
        name="title"
        required
        placeholder="Ej: Mi Portfolio"
        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
      >
    </div>

    <div class="mb-6">
      <label for="description" class="block text-gray-700 font-semibold mb-2">
        Descripción:
      </label>
      <textarea
        id="description"
        name="description"
        required
        rows="5"
        placeholder="Describe tu proyecto..."
        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
      ></textarea>
    </div>

    <div class="mb-6">
      <label for="status" class="block text-gray-700 font-semibold mb-2">
        Estado:
      </label>
      <select
        id="status"
        name="status"
        required
        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
      >
        <option value="">-- Selecciona un estado --</option>
        <option value="planning">Planificación</option>
        <option value="in-progress">En progreso</option>
        <option value="completed">Completado</option>
      </select>
    </div>

    <div class="flex gap-3">
      <button
        type="submit"
        class="px-6 py-3 bg-green-500 text-white font-semibold rounded-lg hover:bg-green-600 transition"
      >
        Crear Proyecto
      </button>

      <a
        href="/projects"
        class="px-6 py-3 bg-gray-500 text-white font-semibold rounded-lg hover:bg-gray-600 transition"
      >
        Cancelar
      </a>
    </div>
  </form>
</div>
```

### Clases de formulario importantes:

- `focus:outline-none`: Quita el outline por defecto
- `focus:ring-2 focus:ring-blue-500`: Añade un anillo azul al hacer foco
- `focus:border-transparent`: Quita el borde al hacer foco
- `resize-none`: Evita que el textarea sea redimensionable

::

::card
# Personalizar Tailwind (Opcional)

Puedes personalizar los colores y valores de Tailwind.

```html
<script src="https://cdn.tailwindcss.com"></script>
<script>
  tailwind.config = {
    theme: {
      extend: {
        colors: {
          'primary': '#3498db',
          'danger': '#e74c3c',
          'success': '#27ae60',
        }
      }
    }
  }
</script>
```

Ahora puedes usar:
```html
<button class="bg-primary text-white px-4 py-2 rounded">
  Mi botón
</button>
```

Al personalizar colores con nombres como `primary` o `danger`, estamos volviendo a usar nombres semánticos (como en BEM) en lugar de nombres puramente descriptivos del estilo.

```html
<button class="bg-primary">  <!-- Semántico: "es primario" -->
<button class="bg-blue-500"> <!-- Descriptivo: "es azul 500" -->
```

::

::card
# ¿Cuándo usar cada enfoque?

## CSS Vanilla + BEM
**Usar cuando:**
- Proyecto pequeño y simple
- Diseño muy personalizado
- Equipo pequeño
- Quieres control total

**Ejemplo:** Blog personal, landing page simple

## Framework tradicional (Bootstrap, Bulma)
**Usar cuando:**
- Necesitas prototipar rápido
- Diseño estándar es aceptable
- Equipo sin experiencia en diseño
- Proyecto empresarial

**Ejemplo:** Panel de administración, intranet empresarial

## Tailwind CSS
**Usar cuando:**
- Diseño personalizado pero rápido
- Proyecto mediano a grande
- Equipo familiarizado con Tailwind
- Necesitas consistencia

**Ejemplo:** Aplicaciones web modernas, SaaS, dashboards


::

::card
# Recursos adicionales

## Documentación oficial

- **Tailwind CSS:** https://tailwindcss.com/docs
- **Bootstrap:** https://getbootstrap.com
- **Bulma:** https://bulma.io
- **BEM:** https://getbem.com

## Herramientas útiles

- **Tailwind Play:** https://play.tailwindcss.com (Probar Tailwind online)
- **Tailwind Cheat Sheet:** https://nerdcave.com/tailwind-cheat-sheet
- **Can I Use:** https://caniuse.com (Compatibilidad de navegadores)

## Componentes preconstruidos

- **Tailwind UI:** https://tailwindui.com (De pago)
- **Flowbite:** https://flowbite.com (Gratis)
- **DaisyUI:** https://daisyui.com (OOCSS approach for Tailwind)

::
