::card
# LowDB - Update

Para actualizar un recurso necesitamos hacer lo siguiente:

1. Crear una ruta `GET` para mostrar la página de edición:
```js
app.get('/<recurso>/:id/edit')

// Ejemplo:
// app.get('/projects/:id/edit')
// app.get('/blog/:id/edit')
```

2. Crear una página de HTML Handlebars con un formulario para su edición:

```bash
/views/<recurso>-edit.handlebars

# Ejemplo:
# /views/projects-edit.handlebars
# /views/blog-edit.handlebars

```

3. Crear una ruta `POST` para actualizar el recurso:

```js
app.post('/<recurso>/:id')

// Ejemplo:
// app.post('/projects/:id')
// app.post('/blog/:id')
```

## Diferencias entre **app.get** y **app.post**

- `app.get` - Para **mostrar** páginas. El navegador pide ver contenido (como abrir una URL)
- `app.post` - Para **enviar** información. El navegador envía datos al servidor (como al enviar un formulario)

**Ejemplo:**
- Cuando visitas `/projects/5/edit` usamos `app.get` (solo quieres ver el formulario)
- Cuando envías el formulario para guardar cambios usamos `app.post` (estás enviando los datos editados)

::

::card
# Mostrar el formulario de edición (EDIT)

Aquí vemos como crear la ruta para mostrar la página de edición.

### Ruta para el formulario de edición
```js
app.get('/projects/:id/edit', async (req, res) => {
  await db.read();

  const projectId = parseInt(req.params.id);
  const project = db.data.projects.find(p => p.id === projectId);

  if (project) {
    res.render('project-edit', {
      project,
      pageTitle: 'Editar Proyecto'
    });
  } else {
    res.status(404).send('Proyecto no encontrado');
  }
});
```

Elementos claves a identificar:
1. El método utilizado es `.get`
1. La ruta creada es `/projects/:id/edit`
1. El archivo handlebars utilizado es `project-edit`

<details>
<summary>Qué es <pre>:id</pre>?</summary>

`:id` es un **parámetro dinámico** en la ruta. Actúa como una variable que captura cualquier valor en esa posición de la URL.

### Ejemplos:

Si defines la ruta:
```js
app.get('/projects/:id/edit')
```

Esta ruta coincide con la ruta en la URL del navegador:
- `/projects/1/edit` → `id` = `"1"`
- `/projects/5/edit` → `id` = `"5"`
- `/projects/999/edit` → `id` = `"999"`

### ¿Cómo acceder al valor?

Dentro de la función, usas `req.params.id`:

```js
app.get('/projects/:id/edit', (req, res) => {
  const projectId = req.params.id;  // "1", "5", "999", etc.
  console.log(projectId);
});
```

### Puedes usar cualquier nombre:

```js
app.get('/projects/:projectId/edit')  → req.params.projectId
app.get('/blog/:postId')              → req.params.postId
app.get('/users/:userId/posts/:id')   → req.params.userId y req.params.id
```

**Regla:** Los dos puntos `:` indican que es un parámetro dinámico, no un texto literal.

</details>

::

::card
# Vista del formulario de edición
```handlebars
<!-- views/project-edit.handlebars -->
<h1>{{pageTitle}}</h1>

<form action="/projects/{{project.id}}" method="POST">
  <div>
    <label for="title">Título:</label>
    <input
      type="text"
      id="title"
      name="title"
      value="{{project.title}}"
      required
    >
  </div>

  <div>
    <label for="description">Descripción:</label>
    <textarea
      id="description"
      name="description"
      required
      rows="5"
    >{{project.description}}</textarea>
  </div>

  <div>
    <label for="status">Estado:</label>
    <select id="status" name="status" required>
      <option value="planning">
        Planificación
      </option>
      <option value="in-progress">
        En progreso
      </option>
      <option value="completed">
        Completado
      </option>
    </select>
  </div>

  <button type="submit">Guardar Cambios</button>
  <a href="/projects/{{project.id}}">Cancelar</a>
</form>

<script>
  // Fallback to ensure the value is set
  document.getElementById('status').value = '{{project.status}}';
</script>
```

### Diferencias con el formulario de creación
- `value="{{project.title}}"` - Prellenar campos con datos actuales
- `action="/projects/{{project.id}}"` - URL específica del proyecto
- Usamos JavaScript selecciona la opción actual mediante el valor del proyecto
::

::card
# Actualizar registros (UPDATE)

### Implementación completa
```js
app.post('/projects/:id', async (req, res) => {
  try {
    await db.read();

    const projectId = parseInt(req.params.id);
    const { title, description, status } = req.body;

    // Buscar índice del proyecto
    const projectIndex = db.data.projects.findIndex(p => p.id === projectId);

    if (projectIndex === -1) {
      return res.status(404).send('Proyecto no encontrado');
    }

    // Actualizar proyecto
    db.data.projects[projectIndex] = {
      ...db.data.projects[projectIndex],
      title,
      description,
      status,
      updatedAt: new Date().toISOString()
    };

    // Guardar cambios
    await db.write();

    // Redirigir al detalle del proyecto
    res.redirect(`/projects/${projectId}`);

  } catch (error) {
    console.error('Error al actualizar proyecto:', error);
    res.status(500).render('error', {
      message: 'Error al actualizar el proyecto'
    });
  }
});
```

### Explicación paso a paso
1. `findIndex()` - Encuentra la posición del proyecto en el array
2. Spread operator (`...`) - Mantiene campos existentes (como `id`, `createdAt`)
3. Sobrescribe solo los campos actualizados
4. `await db.write()` - Persiste los cambios
5. Redirección al detalle (no a la lista)
::
