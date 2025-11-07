::card
# Cloudinary - Gestión de imágenes en la nube

En esta lección aprenderemos a integrar Cloudinary para subir, almacenar y mostrar imágenes en nuestros proyectos.

## ¿Qué es Cloudinary?

Cloudinary es un servicio en la nube que nos permite:

- **Almacenar imágenes:** No ocupan espacio en tu servidor
- **Subir imágenes:** Desde formularios o código
- **Transformar imágenes:** Redimensionar, recortar, optimizar automáticamente
- **Entregar rápido:** CDN global para cargas rápidas
- **Optimización automática:** Convierte a formatos modernos (WebP, AVIF)

### ¿Por qué usar Cloudinary?

**Sin Cloudinary:**
- Guardas imágenes en tu servidor → ocupa espacio
- Debes crear diferentes tamaños manualmente
- Cargas lentas desde tu servidor
- Difícil de escalar

**Con Cloudinary:**
- Imágenes en la nube → espacio ilimitado
- Transformaciones automáticas on-the-fly
- CDN global → cargas rápidas en todo el mundo
- Escalable sin esfuerzo

::

::card
# Crear cuenta en Cloudinary

## Paso 1: Registro

1. Ve a https://cloudinary.com
2. Click en "Sign Up Free"
3. Completa el formulario o regístrate con Google/GitHub
4. Verifica tu email

## Paso 2: Obtener credenciales

Una vez dentro del dashboard:

1. Ve a "Dashboard" en el menú
2. Encontrarás tus credenciales:
   - **Cloud Name:** Tu identificador único
   - **API Key:** Clave pública
   - **API Secret:** Clave privada (¡no la compartas!)

```
Cloud Name: mi-cuenta
API Key: 123456789012345
API Secret: abcdefghijklmnopqrstuvwxyz123
```

**Importante:** Guarda estas credenciales, las necesitaremos.

::

::card
# Instalar el SDK de Cloudinary

Instala el paquete de Node.js para Cloudinary:

```bash
npm install cloudinary
```

También necesitaremos `multer` para manejar uploads de archivos:

```bash
npm install multer
```

::

::card
# Configurar Cloudinary en Express

## Paso 1: Configurar variables de entorno

Añade tus credenciales al archivo `.env`:

```bash
# .env
CLOUDINARY_CLOUD_NAME=tu-cloud-name
CLOUDINARY_API_KEY=tu-api-key
CLOUDINARY_API_SECRET=tu-api-secret
```

## Paso 2: Configurar en app.js

```js
// app.js
import 'dotenv/config';
import express from 'express';
import { engine } from 'express-handlebars';
import { v2 as cloudinary } from 'cloudinary';
import { Low } from 'lowdb';
import { JSONFile } from 'lowdb/node';

const app = express();
const PORT = process.env.PORT || 3000;

// Configurar Cloudinary
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET
});

// Configurar LowDB
const adapter = new JSONFile('db.json');
const db = new Low(adapter, { projects: [] });
await db.read();

// Middlewares
app.use(express.static('public'));
app.use(express.urlencoded({ extended: true }));

// Configurar Handlebars
app.engine('handlebars', engine());
app.set('view engine', 'handlebars');
app.set('views', './views');

app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
```

::

::card
# Configurar Multer para uploads

Multer nos permite procesar archivos desde formularios.

## Crear configuración de Multer

```js
// app.js (añadir después de los imports)
import multer from 'multer';

// Configurar Multer para guardar en memoria temporalmente
const storage = multer.memoryStorage();
const upload = multer({
  storage: storage,
  limits: {
    fileSize: 5 * 1024 * 1024 // Límite de 5MB
  },
  fileFilter: (req, file, cb) => {
    // Aceptar solo imágenes
    if (file.mimetype.startsWith('image/')) {
      cb(null, true);
    } else {
      cb(new Error('Solo se permiten imágenes'), false);
    }
  }
});
```

### ¿Qué hace este código?

- `memoryStorage()`: Guarda el archivo en memoria (RAM) temporalmente
- `limits`: Establece tamaño máximo de 5MB
- `fileFilter`: Solo acepta archivos de tipo imagen

::

::card
# Actualizar el formulario para subir imágenes

Modificamos el formulario de creación para incluir un campo de imagen.

```handlebars
<!-- views/project-form.handlebars -->
<div class="max-w-2xl mx-auto p-6">
  <h1 class="text-3xl font-bold text-gray-800 mb-6">{{pageTitle}}</h1>

  <!-- IMPORTANTE: añadir enctype -->
  <form
    action="/projects"
    method="POST"
    enctype="multipart/form-data"
    class="bg-white p-8 rounded-lg border border-gray-200"
  >
    <div class="mb-6">
      <label for="title" class="block text-gray-700 font-semibold mb-2">
        Título:
      </label>
      <input
        type="text"
        id="title"
        name="title"
        required
        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
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
        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none"
      ></textarea>
    </div>

    <!-- NUEVO: Campo de imagen -->
    <div class="mb-6">
      <label for="image" class="block text-gray-700 font-semibold mb-2">
        Imagen del proyecto:
      </label>
      <input
        type="file"
        id="image"
        name="image"
        accept="image/*"
        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
      >
      <p class="text-gray-500 text-sm mt-1">Opcional - Máximo 5MB</p>
    </div>

    <div class="mb-6">
      <label for="status" class="block text-gray-700 font-semibold mb-2">
        Estado:
      </label>
      <select
        id="status"
        name="status"
        required
        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
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

### Cambios importantes:

1. `enctype="multipart/form-data"` - Necesario para enviar archivos
2. `<input type="file">` - Campo para seleccionar imagen
3. `accept="image/*"` - Solo permite seleccionar imágenes

::

::card
# Subir imagen a Cloudinary

Actualizamos la ruta POST para procesar y subir la imagen.

```js
// app.js

app.post('/projects', upload.single('image'), async (req, res) => {
  try {
    await db.read();

    const { title, description, status } = req.body;

    // Generar ID único
    const newId = db.data.projects.length > 0
      ? Math.max(...db.data.projects.map(p => p.id)) + 1
      : 1;

    // Crear objeto del proyecto
    const newProject = {
      id: newId,
      title,
      description,
      status,
      createdAt: new Date().toISOString()
    };

    // Si hay imagen, subirla a Cloudinary
    if (req.file) {
      // Convertir el buffer a base64
      const b64 = Buffer.from(req.file.buffer).toString('base64');
      const dataURI = `data:${req.file.mimetype};base64,${b64}`;

      // Subir a Cloudinary
      const result = await cloudinary.uploader.upload(dataURI, {
        folder: 'projects', // Carpeta en Cloudinary
        resource_type: 'auto'
      });

      // Guardar la URL de la imagen
      newProject.imageUrl = result.secure_url;
      newProject.imagePublicId = result.public_id; // Para poder eliminarla después
    }

    // Añadir a la base de datos
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

### ¿Qué hace este código?

1. `upload.single('image')`: Middleware de Multer que procesa el campo 'image'
2. `req.file`: Contiene la información del archivo subido
3. Convertimos el archivo a base64 (formato que acepta Cloudinary)
4. `cloudinary.uploader.upload()`: Sube la imagen a Cloudinary
5. Guardamos `secure_url` (URL de la imagen) y `public_id` (ID para eliminar)

::

::card
# Mostrar imágenes en las vistas

## En la lista de proyectos

```handlebars
<!-- views/projects.handlebars -->
<div class="max-w-4xl mx-auto p-6">
  <h1 class="text-3xl font-bold text-gray-800 mb-6">{{pageTitle}}</h1>

  {{#if projects.length}}
    <div class="space-y-4">
      {{#each projects}}
        <div class="bg-white p-6 rounded-lg border border-gray-200 hover:shadow-lg transition">

          <!-- Mostrar imagen si existe -->
          {{#if this.imageUrl}}
            <img
              src="{{this.imageUrl}}"
              alt="{{this.title}}"
              class="w-full h-48 object-cover rounded-lg mb-4"
            >
          {{/if}}

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
          </div>
        </div>
      {{/each}}
    </div>
  {{/if}}
</div>
```

## En el detalle del proyecto

```handlebars
<!-- views/project-detail.handlebars -->
<div class="max-w-4xl mx-auto p-6">
  <article class="bg-white p-8 rounded-lg border border-gray-200">

    <!-- Imagen destacada -->
    {{#if project.imageUrl}}
      <img
        src="{{project.imageUrl}}"
        alt="{{project.title}}"
        class="w-full h-96 object-cover rounded-lg mb-6"
      >
    {{/if}}

    <h1 class="text-3xl font-bold text-gray-800 mb-4">
      {{project.title}}
    </h1>

    <p class="text-gray-600 text-lg mb-4">
      {{project.description}}
    </p>

    <p class="text-gray-500 mb-6">
      Estado: {{project.status}}
    </p>

    <div class="flex gap-3">
      <a
        href="/projects"
        class="px-6 py-3 bg-gray-500 text-white rounded-lg hover:bg-gray-600 transition"
      >
        ← Volver a la lista
      </a>

      <a
        href="/projects/{{project.id}}/edit"
        class="px-6 py-3 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition"
      >
        Editar
      </a>

      <form action="/projects/{{project.id}}/delete" method="POST" class="inline">
        <button
          type="submit"
          class="px-6 py-3 bg-red-500 text-white rounded-lg hover:bg-red-600 transition"
          onclick="return confirm('¿Estás seguro de eliminar este proyecto?')"
        >
          Eliminar
        </button>
      </form>
    </div>
  </article>
</div>
```

### Clases de Tailwind para imágenes:

- `w-full`: Ancho 100%
- `h-48`: Altura fija de 12rem (en lista)
- `h-96`: Altura fija de 24rem (en detalle)
- `object-cover`: Recorta la imagen para llenar el espacio
- `rounded-lg`: Bordes redondeados

::

::card
# Transformaciones de Cloudinary

Cloudinary permite transformar imágenes on-the-fly modificando la URL.

## URL original de Cloudinary

```
https://res.cloudinary.com/mi-cuenta/image/upload/v1234567890/projects/abc123.jpg
```

## Transformaciones en la URL

Añadimos parámetros entre `/upload/` y el path de la imagen:

```
https://res.cloudinary.com/mi-cuenta/image/upload/w_500,h_300,c_fill/v1234567890/projects/abc123.jpg
                                                    ^^^^^^^^^^^^^ transformaciones
```

### Ejemplos de transformaciones:

```handlebars
<!-- Redimensionar a 500x300 (recortar si es necesario) -->
<img src="{{this.imageUrl}}"
     alt="{{this.title}}"
     class="...">

<!-- Para aplicar transformaciones, modifica la URL: -->

<!-- Ancho de 500px, altura automática -->
{{!-- Insertar w_500 después de /upload/ --}}

<!-- Thumbnail cuadrado de 200x200 -->
{{!-- Insertar w_200,h_200,c_fill después de /upload/ --}}

<!-- Aplicar filtro de escala de grises -->
{{!-- Insertar e_grayscale después de /upload/ --}}
```

## Helper de Handlebars para transformaciones

Podemos crear un helper para facilitar las transformaciones:

```js
// app.js (añadir después de configurar Handlebars)

import Handlebars from 'handlebars';

// Helper para transformar URLs de Cloudinary
Handlebars.registerHelper('cloudinaryTransform', function(url, transformations) {
  if (!url) return '';

  // Insertar transformaciones después de '/upload/'
  return url.replace('/upload/', `/upload/${transformations}/`);
});
```

Uso en Handlebars:

```handlebars
<!-- Thumbnail de 200x200 -->
<img
  src="{{cloudinaryTransform this.imageUrl 'w_200,h_200,c_fill'}}"
  alt="{{this.title}}"
>

<!-- Imagen optimizada para web -->
<img
  src="{{cloudinaryTransform this.imageUrl 'w_800,q_auto,f_auto'}}"
  alt="{{this.title}}"
>
```

### Parámetros comunes:

| Parámetro | Descripción | Ejemplo |
|-----------|-------------|---------|
| `w_500` | Ancho de 500px | `w_500` |
| `h_300` | Altura de 300px | `h_300` |
| `c_fill` | Modo de recorte (llenar) | `c_fill` |
| `c_fit` | Ajustar sin recortar | `c_fit` |
| `q_auto` | Calidad automática | `q_auto` |
| `f_auto` | Formato automático (WebP si soporta) | `f_auto` |
| `e_grayscale` | Escala de grises | `e_grayscale` |
| `e_blur:300` | Desenfoque | `e_blur:300` |

::

::card
# Eliminar imágenes de Cloudinary

Cuando eliminamos un proyecto, también debemos eliminar su imagen de Cloudinary.

```js
// app.js

app.post('/projects/:id/delete', async (req, res) => {
  try {
    await db.read();

    const projectId = parseInt(req.params.id);
    const projectIndex = db.data.projects.findIndex(p => p.id === projectId);

    if (projectIndex === -1) {
      return res.status(404).send('Proyecto no encontrado');
    }

    const project = db.data.projects[projectIndex];

    // Si el proyecto tiene imagen, eliminarla de Cloudinary
    if (project.imagePublicId) {
      await cloudinary.uploader.destroy(project.imagePublicId);
    }

    // Eliminar proyecto de la base de datos
    db.data.projects.splice(projectIndex, 1);
    await db.write();

    res.redirect('/projects');

  } catch (error) {
    console.error('Error al eliminar proyecto:', error);
    res.status(500).render('error', {
      message: 'Error al eliminar el proyecto'
    });
  }
});
```

### ¿Por qué usar `imagePublicId`?

Cloudinary necesita el `public_id` (no la URL) para eliminar imágenes. Por eso lo guardamos cuando subimos la imagen.

::

::card
# Actualizar proyecto con nueva imagen

Para el formulario de edición, permitimos cambiar la imagen.

```handlebars
<!-- views/project-edit.handlebars -->
<div class="max-w-2xl mx-auto p-6">
  <h1 class="text-3xl font-bold text-gray-800 mb-6">{{pageTitle}}</h1>

  <form
    action="/projects/{{project.id}}"
    method="POST"
    enctype="multipart/form-data"
    class="bg-white p-8 rounded-lg border border-gray-200"
  >
    <!-- Mostrar imagen actual si existe -->
    {{#if project.imageUrl}}
      <div class="mb-6">
        <label class="block text-gray-700 font-semibold mb-2">
          Imagen actual:
        </label>
        <img
          src="{{project.imageUrl}}"
          alt="{{project.title}}"
          class="w-full h-48 object-cover rounded-lg"
        >
      </div>
    {{/if}}

    <!-- Campo para nueva imagen -->
    <div class="mb-6">
      <label for="image" class="block text-gray-700 font-semibold mb-2">
        {{#if project.imageUrl}}
          Cambiar imagen:
        {{else}}
          Añadir imagen:
        {{/if}}
      </label>
      <input
        type="file"
        id="image"
        name="image"
        accept="image/*"
        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
      >
      <p class="text-gray-500 text-sm mt-1">
        Opcional - Máximo 5MB
        {{#if project.imageUrl}}
          - Dejar vacío para mantener la imagen actual
        {{/if}}
      </p>
    </div>

    <!-- Resto de campos... -->
    <div class="mb-6">
      <label for="title" class="block text-gray-700 font-semibold mb-2">
        Título:
      </label>
      <input
        type="text"
        id="title"
        name="title"
        value="{{project.title}}"
        required
        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
      >
    </div>

    <!-- ... más campos ... -->

    <div class="flex gap-3">
      <button
        type="submit"
        class="px-6 py-3 bg-green-500 text-white font-semibold rounded-lg hover:bg-green-600 transition"
      >
        Guardar Cambios
      </button>
      <a
        href="/projects/{{project.id}}"
        class="px-6 py-3 bg-gray-500 text-white font-semibold rounded-lg hover:bg-gray-600 transition"
      >
        Cancelar
      </a>
    </div>
  </form>
</div>
```

## Ruta de actualización con imagen

```js
// app.js

app.post('/projects/:id', upload.single('image'), async (req, res) => {
  try {
    await db.read();

    const projectId = parseInt(req.params.id);
    const { title, description, status } = req.body;

    const projectIndex = db.data.projects.findIndex(p => p.id === projectId);

    if (projectIndex === -1) {
      return res.status(404).send('Proyecto no encontrado');
    }

    const existingProject = db.data.projects[projectIndex];

    // Si hay nueva imagen
    if (req.file) {
      // Eliminar imagen anterior si existe
      if (existingProject.imagePublicId) {
        await cloudinary.uploader.destroy(existingProject.imagePublicId);
      }

      // Subir nueva imagen
      const b64 = Buffer.from(req.file.buffer).toString('base64');
      const dataURI = `data:${req.file.mimetype};base64,${b64}`;

      const result = await cloudinary.uploader.upload(dataURI, {
        folder: 'projects',
        resource_type: 'auto'
      });

      // Actualizar proyecto con nueva imagen
      db.data.projects[projectIndex] = {
        ...existingProject,
        title,
        description,
        status,
        imageUrl: result.secure_url,
        imagePublicId: result.public_id,
        updatedAt: new Date().toISOString()
      };
    } else {
      // Sin nueva imagen, mantener la existente
      db.data.projects[projectIndex] = {
        ...existingProject,
        title,
        description,
        status,
        updatedAt: new Date().toISOString()
      };
    }

    await db.write();
    res.redirect(`/projects/${projectId}`);

  } catch (error) {
    console.error('Error al actualizar proyecto:', error);
    res.status(500).render('error', {
      message: 'Error al actualizar el proyecto'
    });
  }
});
```

::

::card
# Validación y manejo de errores

## Validar tipo y tamaño de archivo

Ya configuramos límites en Multer, pero podemos mejorar el manejo de errores:

```js
// app.js

// Middleware de manejo de errores de Multer
app.use((error, req, res, next) => {
  if (error instanceof multer.MulterError) {
    if (error.code === 'LIMIT_FILE_SIZE') {
      return res.status(400).render('error', {
        message: 'El archivo es demasiado grande. Máximo 5MB.'
      });
    }
  }

  if (error.message === 'Solo se permiten imágenes') {
    return res.status(400).render('error', {
      message: 'Solo se permiten archivos de imagen.'
    });
  }

  next(error);
});
```

## Validar imagen en el cliente (opcional)

```html
<script>
  const imageInput = document.getElementById('image');

  imageInput.addEventListener('change', function(e) {
    const file = e.target.files[0];

    if (!file) return;

    // Validar tipo
    if (!file.type.startsWith('image/')) {
      alert('Solo se permiten imágenes');
      this.value = '';
      return;
    }

    // Validar tamaño (5MB)
    const maxSize = 5 * 1024 * 1024;
    if (file.size > maxSize) {
      alert('La imagen es demasiado grande. Máximo 5MB.');
      this.value = '';
      return;
    }

    // Preview de la imagen (opcional)
    const reader = new FileReader();
    reader.onload = function(e) {
      const preview = document.getElementById('preview');
      if (preview) {
        preview.src = e.target.result;
        preview.classList.remove('hidden');
      }
    };
    reader.readAsDataURL(file);
  });
</script>
```

::

::card
# Optimización de imágenes

## Buenas prácticas con Cloudinary

### 1. Usar formato automático
```handlebars
{{cloudinaryTransform this.imageUrl 'f_auto,q_auto'}}
```

Cloudinary entregará:
- WebP a navegadores modernos
- JPEG a navegadores antiguos
- Calidad optimizada automáticamente

### 2. Responsive images

```handlebars
<img
  srcset="
    {{cloudinaryTransform this.imageUrl 'w_400,f_auto,q_auto'}} 400w,
    {{cloudinaryTransform this.imageUrl 'w_800,f_auto,q_auto'}} 800w,
    {{cloudinaryTransform this.imageUrl 'w_1200,f_auto,q_auto'}} 1200w
  "
  sizes="(max-width: 600px) 400px, (max-width: 1000px) 800px, 1200px"
  src="{{cloudinaryTransform this.imageUrl 'w_800,f_auto,q_auto'}}"
  alt="{{this.title}}"
  class="w-full h-48 object-cover rounded-lg"
>
```

### 3. Lazy loading

```handlebars
<img
  src="{{cloudinaryTransform this.imageUrl 'w_800,f_auto,q_auto'}}"
  alt="{{this.title}}"
  loading="lazy"
  class="w-full h-48 object-cover rounded-lg"
>
```

### 4. Placeholder mientras carga

```handlebars
<img
  src="{{cloudinaryTransform this.imageUrl 'w_50,e_blur:1000,f_auto,q_auto'}}"
  data-src="{{cloudinaryTransform this.imageUrl 'w_800,f_auto,q_auto'}}"
  alt="{{this.title}}"
  class="w-full h-48 object-cover rounded-lg blur-sm"
  onload="this.classList.remove('blur-sm'); this.src = this.dataset.src;"
>
```

::

::card
# Ejercicio práctico

Implementa las siguientes mejoras en tu proyecto:

## Nivel básico
1. ✅ Añadir campo de imagen al formulario de creación
2. ✅ Subir imagen a Cloudinary
3. ✅ Mostrar imagen en lista y detalle
4. ✅ Eliminar imagen al borrar proyecto

## Nivel intermedio
5. Añadir preview de imagen antes de subir
6. Crear helper de Handlebars para transformaciones
7. Implementar cambio de imagen en edición
8. Validación de tipo y tamaño de archivo

## Nivel avanzado
9. Implementar lazy loading de imágenes
10. Usar transformaciones responsive (srcset)
11. Añadir galería de imágenes (múltiples imágenes por proyecto)
12. Implementar recorte de imagen antes de subir

::

::card
# Recursos adicionales

## Documentación

- **Cloudinary Node.js:** https://cloudinary.com/documentation/node_integration
- **Multer:** https://github.com/expressjs/multer
- **Transformaciones de Cloudinary:** https://cloudinary.com/documentation/image_transformations

## Herramientas útiles

- **Cloudinary Dashboard:** https://cloudinary.com/console
- **Image Transformation Builder:** https://cloudinary.com/documentation/transformation_reference
- **TinyPNG:** https://tinypng.com (comprimir antes de subir)

## Alternativas a Cloudinary

- **Uploadcare:** Similar a Cloudinary
- **Imgix:** Optimización y CDN de imágenes
- **ImageKit:** CDN de imágenes con transformaciones
- **AWS S3 + CloudFront:** Más control, más configuración

::

::card
# Resumen

### Conceptos aprendidos:

**Cloudinary:**
- Servicio de gestión de imágenes en la nube
- Upload, storage, transformaciones y CDN
- Optimización automática de imágenes

**Integración:**
```js
// Configurar
cloudinary.config({ ... });

// Subir
const result = await cloudinary.uploader.upload(dataURI);

// Eliminar
await cloudinary.uploader.destroy(publicId);
```

**Transformaciones:**
```
/upload/w_500,h_300,c_fill,f_auto,q_auto/image.jpg
```

**Multer:**
- Middleware para procesar archivos
- Validación de tipo y tamaño
- Almacenamiento temporal en memoria

**Buenas prácticas:**
- Usar `f_auto,q_auto` siempre
- Implementar lazy loading
- Eliminar imágenes al borrar recursos
- Validar en cliente y servidor

::
