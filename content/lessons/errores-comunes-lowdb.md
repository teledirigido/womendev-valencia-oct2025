::card
# Errores comunes con LowDB

### Error 1: await fuera de función async
**Problema:**
```js
const db = new Low(adapter, { projects: [] });
await db.read(); // ❌ SyntaxError
```

**Solución:**
```js
// Opción 1: Función async
async function start() {
  const db = new Low(adapter, { projects: [] });
  await db.read();
}
start();

// Opción 2: Top-level await (asegúrate de tener "type": "module") en package.json
const db = new Low(adapter, { projects: [] });
await db.read(); // ✅
```

### Error 2: No guardar cambios con db.write()
**Problema:**
```js
db.data.projects.push(newProject);
// Falta: await db.write();
```

Los cambios solo están en memoria, no en el archivo.

**Solución:**
```js
db.data.projects.push(newProject);
await db.write(); // ✅ Guardar en archivo
```

### Error 3: No leer antes de modificar
**Problema:**
```js
app.get('/projects', async (req, res) => {
  // Falta: await db.read();
  res.render('projects', { projects: db.data.projects });
});
```

Puedes estar mostrando datos desactualizados.

**Solución:**
```js
app.get('/projects', async (req, res) => {
  await db.read(); // ✅ Leer datos actuales
  res.render('projects', { projects: db.data.projects });
});
```

### Error 4: Ruta del archivo incorrecta
**Problema:**
```js
const adapter = new JSONFile('./data/db.json');
// Pero la carpeta 'data' no existe
```

**Solución:**
```js
// Crear la carpeta primero o usar ruta existente
const adapter = new JSONFile('db.json'); // Raíz del proyecto
```

### Error 5: Estructura de datos undefined
**Problema:**
```js
const db = new Low(adapter); // Sin estructura por defecto
await db.read();
db.data.projects.push(...); // ❌ Cannot read property 'projects' of undefined
```

**Solución:**
```js
const db = new Low(adapter, { projects: [] }); // ✅ Con estructura por defecto
```
::

::card
# Debugging tips

### Verificar el contenido de la base de datos
```js
app.get('/debug/db', async (req, res) => {
  await db.read();
  res.json(db.data);
});
```

Visita http://localhost:3000/debug/db para ver todo el contenido.

### Logs útiles
```js
app.post('/projects', async (req, res) => {
  console.log('📥 Datos recibidos:', req.body);

  await db.read();
  console.log('📊 Proyectos actuales:', db.data.projects.length);

  // ... crear proyecto

  await db.write();
  console.log('✅ Proyecto guardado');
  console.log('📁 Ver archivo: db.json');
});
```

### Verificar el archivo db.json
```bash
# En la terminal
cat db.json

# O formateado
cat db.json | jq .
```

### Reset de la base de datos
```js
app.get('/debug/reset', async (req, res) => {
  db.data = { projects: [] };
  await db.write();
  res.send('Base de datos reseteada');
});
```

**⚠️ Usa estas rutas solo en desarrollo, nunca en producción.**
::