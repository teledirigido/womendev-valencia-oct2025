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

Cloud Name: mi-cuenta
```bash
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

<details>
<summary>Configuración inicial del proyecto</summary>

1. Inicializar proyecto
```bash
npm init -y
```

2. Instalar dependencias
```bash
npm install express cloudinary multer dotenv lowdb express-handlebars
```

3. Asegurate que el valor de `type` es `module` en el archivo `package.json`: 

```js
// package.json
"type": "module"
```


</details>

### Paso 1: Configurar variables de entorno

Crea un archivo `.env` en la raíz del proyecto con tus credenciales:

```bash
# .env
CLOUDINARY_CLOUD_NAME=tu-cloud-name
CLOUDINARY_API_KEY=tu-api-key
CLOUDINARY_API_SECRET=tu-api-secret
```

### Paso 2: Crear un archivo `db.json`

```json
{
  "places": []
}
```

### Paso 3: Crear un archivo `app.js`

```js
// app.js
import 'dotenv/config';
import express from 'express';
import { engine } from 'express-handlebars';
import { v2 as cloudinary } from 'cloudinary';
import { Low } from 'lowdb';
import { JSONFile } from 'lowdb/node';

const app = express();
const PORT = 3000;

// Configurar Cloudinary
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET
});

// Configurar LowDB
const adapter = new JSONFile('db.json');
const db = new Low(adapter, { places: [] });
await db.read();

// Configurar Handlebars
app.engine('handlebars', engine());
app.set('view engine', 'handlebars');
app.set('views', './views');

// Middlewares
app.use(express.static('public'));
app.use(express.urlencoded({ extended: true }));

// Ruta principal - mostrar lista de lugares
app.get('/', async (req, res) => {
  await db.read();
  res.render('home', {
    places: db.data.places
  });
});

app.listen(PORT, () => {
  console.log(`Servidor en http://localhost:${PORT}`);
});
```

Usaremos `places` (lugares) donde cada lugar tendrá:
- `title`: Nombre del lugar
- `imageUrl`: URL de la imagen en Cloudinary

## Generar ID automáticas

Anteriormente hemos generado ID de la siguiente forma:

```js
const newId = db.data.projects.length > 0
    ? Math.max(...db.data.projects.map(p => p.id)) + 1
    : 1;
```

Al momento de crear un nuevo recurso:

```js
const newResource = {
  id: newId,
  title,
  description,
  createdAt: new Date().toISOString()
};
```

Podemos utilizar también la función `crypto.randomUUID()` de Node.JS:

1. Importaremos crypto en `app.js`

```js
import crypto from 'crypto';
```

Al momento de crear un nuevo recurso:
```js
const newResource = {
  id: crypto.randomUUID(),
  title,
  description,
  createdAt: new Date().toISOString()
};
```

Esta es una forma alternativa de generar un identificador único.

::

::card
# Configurar Multer para uploads

Multer nos permite procesar archivos desde formularios.

## Crear archivo de configuración

Creamos un archivo separado en `config/multer.js` para organizar mejor nuestro código:

```js
// config/multer.js
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

export default upload;
```

## Importar en `app.js`

```js
import upload from './config/multer.js';
```

¿Qué hace este código?

- `memoryStorage()`: Guarda el archivo en memoria (RAM) temporalmente
- `limits`: Establece tamaño máximo de 5MB
- `fileFilter`: Solo acepta archivos de tipo imagen

### Ventajas de separar la configuración

- **Organización:** Código más limpio y modular
- **Reutilización:** Puedes importar `upload` en múltiples archivos
- **Mantenimiento:** Más fácil de modificar en un solo lugar

::

::card

# Vistas


<details>
<summary>Crea el archivo <pre>views/layouts/main.handlebars</summary> si no existe.

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdn.simplecss.org/simple.min.css">
  <title>Document</title>
</head>
<body>
  {{{body}}}
</body>
</html>
```

</details>

## Vista 

Vamos a crear la vista del home en `views/home.handlebars`

```html
<!-- views/home.handlebars -->
<h1>Mis Lugares</h1>

<!-- IMPORTANTE: añadir enctype="multipart/form-data" -->
<form action="/places" method="POST" enctype="multipart/form-data">
  <fieldset>  
    <label for="title">Nombre del lugar:</label>
    <input
      type="text"
      id="title"
      name="title"
      required
      placeholder="Ej: Torre Eiffel"
    >
    <label for="image">Imagen:</label>
    <input
      type="file"
      id="image"
      name="image"
      accept="image/*"
      required
    >
    <small>Máximo 5MB</small>
  </fieldset>
  <button type="submit">Subir Lugar</button>
</form>

<hr>

<h2>Lugares guardados</h2>

{{#if places.length}}
  {{#each places}}
    <div>
      <h3>{{this.title}}</h3>
      <a href="/places/{{this.id}}/edit">Editar</a> <!-- Link para editar -->
      <img src="{{this.imageUrl}}" alt="{{this.title}}" width="300">
      <form action="/places/{{this.id}}/delete" method="POST" style="display: inline;">
        <button type="submit" onclick="return confirm('¿Eliminar este lugar?')">Eliminar</button> <!-- Botón para eliminar -->
      </form>
    </div>
  {{/each}}
{{else}}
  <p>No hay lugares aún.</p>
{{/if}}
```

### Elementos importantes:

1. `enctype="multipart/form-data"` - Necesario para enviar archivos
2. `<input type="file">` - Campo para seleccionar imagen
3. `accept="image/*"` - Solo permite seleccionar imágenes

::

::card
# Subir imagen a Cloudinary

Creamos la ruta POST para procesar y subir la imagen.

```js
// app.js

app.post('/places', upload.single('image'), async (req, res) => {
  try {
    await db.read();

    const { title } = req.body;

    // Convertir el buffer a base64
    const b64 = Buffer.from(req.file.buffer).toString('base64');
    const dataURI = `data:${req.file.mimetype};base64,${b64}`;

    // Subir a Cloudinary
    const result = await cloudinary.uploader.upload(dataURI, {
      folder: 'places',
      resource_type: 'auto'
    });

    // Crear objeto del lugar
    const newPlace = {
      id: crypto.randomUUID(),
      title,
      imageUrl: result.secure_url,
      imagePublicId: result.public_id,
      createdAt: new Date().toISOString()
    };

    // Añadir a la base de datos
    db.data.places.push(newPlace);
    await db.write();

    res.redirect('/');

  } catch (error) {
    console.error('Error al crear lugar:', error);
    res.status(500).send('Error al subir la imagen');
  }
});
```

### ¿Qué hace este código?

1. `upload.single('image')`: Middleware de Multer que procesa el campo 'image'
2. `req.file`: Contiene la información del archivo subido
3. Convertimos el archivo a base64 (formato que acepta Cloudinary)
4. `cloudinary.uploader.upload()`: Sube la imagen a Cloudinary
5. `crypto.randomUUID()`: Genera un ID único para el lugar
6. Guardamos `secure_url` (URL de la imagen) y `public_id` (ID para eliminar)

::

::card
# Editar recursos con imágenes

Cuando actualizamos un recurso que tiene una imagen, tenemos dos escenarios:

1. **El usuario sube una nueva imagen** → Eliminar la antigua de Cloudinary y subir la nueva
2. **El usuario NO sube imagen** → Mantener la imagen existente

## Vista de edición

Primero, creamos un formulario de edición en `views/edit.handlebars`:

```html
<!-- views/edit.handlebars -->
<h1>Editar Lugar</h1>

<form action="/places/{{place.id}}/edit" method="POST" enctype="multipart/form-data">
  <fieldset>
    <label for="title">Nombre del lugar:</label>
    <input
      type="text"
      id="title"
      name="title"
      value="{{place.title}}"
      required
    >

    <label>Imagen actual:</label>
    <img src="{{place.imageUrl}}" alt="{{place.title}}" width="200">

    <label for="image">Cambiar imagen (opcional):</label>
    <input
      type="file"
      id="image"
      name="image"
      accept="image/*"
    >
    <small>Si no seleccionas una imagen, se mantendrá la actual</small>
  </fieldset>

  <button type="submit">Actualizar</button>
  <a href="/">Cancelar</a>
</form>
```

## Ruta GET para mostrar el formulario

```js
// app.js

app.get('/places/:id/edit', async (req, res) => {
  try {
    await db.read();

    const place = db.data.places.find(p => p.id === req.params.id);

    if (!place) {
      return res.status(404).send('Lugar no encontrado');
    }

    res.render('edit', { place });

  } catch (error) {
    console.error('Error al cargar formulario:', error);
    res.status(500).send('Error al cargar el lugar');
  }
});
```

## Ruta POST para procesar la actualización

```js
// app.js

app.post('/places/:id/edit', upload.single('image'), async (req, res) => {
  try {
    await db.read();

    const { title } = req.body;
    const placeIndex = db.data.places.findIndex(p => p.id === req.params.id);

    if (placeIndex === -1) {
      return res.status(404).send('Lugar no encontrado');
    }

    const place = db.data.places[placeIndex];

    // Si hay una nueva imagen
    if (req.file) {
      // 1. Eliminar la imagen anterior de Cloudinary
      if (place.imagePublicId) {
        await cloudinary.uploader.destroy(place.imagePublicId);
      }

      // 2. Subir la nueva imagen
      const b64 = Buffer.from(req.file.buffer).toString('base64');
      const dataURI = `data:${req.file.mimetype};base64,${b64}`;

      const result = await cloudinary.uploader.upload(dataURI, {
        folder: 'places',
        resource_type: 'auto'
      });

      // 3. Actualizar los datos de la imagen
      place.imageUrl = result.secure_url;
      place.imagePublicId = result.public_id;
    }

    // Actualizar el título
    place.title = title;
    place.updatedAt = new Date().toISOString();

    // Guardar cambios
    db.data.places[placeIndex] = place;
    await db.write();

    res.redirect('/');

  } catch (error) {
    console.error('Error al actualizar lugar:', error);
    res.status(500).send('Error al actualizar el lugar');
  }
});
```

### ¿Qué hace este código?

1. **Busca el lugar** por ID en la base de datos
2. **Verifica si hay nueva imagen** con `if (req.file)`
3. **Si hay nueva imagen:**
   - Elimina la imagen anterior con `cloudinary.uploader.destroy()`
   - Sube la nueva imagen a Cloudinary
   - Actualiza `imageUrl` y `imagePublicId`
4. **Si NO hay nueva imagen:** Mantiene la URL existente
5. **Actualiza** el título y guarda los cambios
::

::card
# Eliminar imágenes de Cloudinary

Cuando eliminamos un lugar, también debemos eliminar su imagen de Cloudinary.

```js
// app.js

app.post('/places/:id/delete', async (req, res) => {
  try {
    await db.read();

    const placeId = req.params.id;
    const placeIndex = db.data.places.findIndex(p => p.id === placeId);

    if (placeIndex === -1) {
      return res.status(404).send('Lugar no encontrado');
    }

    const place = db.data.places[placeIndex];

    // Si el lugar tiene una imagen, vamos a eliminarla de Cloudinary
    if (place.imagePublicId) {
      await cloudinary.uploader.destroy(place.imagePublicId);
    }

    // Eliminar el lugar de la base de datos
    db.data.places.splice(placeIndex, 1);
    await db.write();

    res.redirect('/');

  } catch (error) {
    console.error('Error al eliminar lugar:', error);
    res.status(500).send('Error al eliminar el lugar')
  }
});
```

### ¿Por qué usar `imagePublicId`?

Cloudinary necesita el `public_id` (no la URL) para eliminar imágenes. Por eso lo guardamos cuando subimos la imagen.

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