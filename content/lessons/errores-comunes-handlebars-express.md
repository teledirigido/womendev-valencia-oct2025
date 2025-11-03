::card
# Errores comunes en Handlebars & Express

### Error 1: Cannot GET /route
**Problema:** La ruta no está definida en tu aplicación.

**Solución:**
- Verifica que hayas definido la ruta en `app.js`
- Comprueba que no haya errores de tipeo en la URL Ej: 
```bash
/projects vs /project
/users vs /user
```
- Asegúrate de que el servidor esté corriendo

```js
// ❌ Mal - ruta no definida
// Usuario visita /projects pero no existe

// ✅ Bien - ruta definida
app.get('/projects', (req, res) => {
  res.render('projects');
});
```

### Error 2: Failed to lookup view "view-name"
**Problema:** Express no puede encontrar el archivo de vista.

**Causas comunes:**
- El archivo no existe en la carpeta `views/`
- Nombre de archivo incorrecto (typo)
- Extensión incorrecta (`.hbs` vs `.handlebars`)

**Solución:**
```js
// ❌ Mal - archivo no existe
app.get('/users', (req, res) => {
  res.render('user-list'); // Busca: views/user-list.handlebars
});

// ✅ Bien - archivo existe
// Crear archivo: views/user-list.handlebars
app.get('/users', (req, res) => {
  res.render('user-list'); // ✅ Encuentra el archivo
});
```

### Error 3: Motor de plantillas no configurado
**Problema:** Las variables aparecen como texto literal `{{name}}` en el navegador.

**Causa:** Handlebars no está configurado correctamente.

**Solución:**
```js
// ❌ Mal - falta configuración
import express from 'express';
const app = express();
app.get('/', (req, res) => {
  res.render('home', { name: 'Ana' }); // ❌ Error
});

// ✅ Bien - Handlebars configurado
import express from 'express';
import { engine } from 'express-handlebars';

const app = express();
app.engine('handlebars', engine());
app.set('view engine', 'handlebars');
app.set('views', './views');

app.get('/', (req, res) => {
  res.render('home', { name: 'Ana' }); // ✅ Funciona
});
```

### Error 4: {{{body}}} aparece como texto
**Problema:** El layout muestra `{{{body}}}` literalmente en la página.

**Causa:** El layout no está siendo utilizado correctamente.

**Solución:**
```js
// Verificar que el archivo esté en: views/layouts/main.handlebars
// Por defecto, Handlebars busca el layout en esa ubicación

// Si tu layout tiene otro nombre:
app.engine('handlebars', engine({
  defaultLayout: 'mi-layout' // busca views/layouts/mi-layout.handlebars
}));
```

### Error 5: ENOENT: no such file or directory './projects.json'
**Problema:** Node.js no encuentra el archivo JSON.

**Causa:** Ruta incorrecta del archivo.

**Solución:**
```js
// ❌ Mal - ruta relativa incorrecta
const data = readFileSync('./data/projects.json', 'utf-8');
// Busca desde donde ejecutas el comando

// ✅ Bien - usar ruta absoluta
import { fileURLToPath } from 'url';
import path from 'path';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const data = readFileSync(path.join(__dirname, 'projects.json'), 'utf-8');
```

### Error 6: Unexpected token in JSON
**Problema:** Error de sintaxis en el archivo JSON.

**Causas comunes:**
- Coma al final del último elemento
- Comillas simples en lugar de dobles
- Comentarios en JSON (no están permitidos)

**Solución:**
```json
// ❌ Mal
[
  {
    "id": 1,
    "name": "Ana",
  }  // ← coma extra
]

// ✅ Bien
[
  {
    "id": 1,
    "name": "Ana"
  }
]
```

### Error 7: Cannot read property 'name' of undefined
**Problema:** Intentas acceder a una propiedad de un objeto que no existe.

**Causa:** No pasaste los datos correctamente a la vista.

**Solución:**
```js
// ❌ Mal - falta pasar el dato 'user'
app.get('/profile', (req, res) => {
  res.render('profile'); // user es undefined en la vista
});

// ✅ Bien - dato pasado correctamente
app.get('/profile', (req, res) => {
  res.render('profile', {
    user: { name: 'Ana', email: 'ana@example.com' }
  });
});
```

```handlebars
<!-- views/profile.handlebars -->

<!-- Usar condicional para evitar errores -->
{{#if user}}
  <h1>{{user.name}}</h1>
  <p>{{user.email}}</p>
{{else}}
  <p>Usuario no encontrado</p>
{{/if}}
```

::