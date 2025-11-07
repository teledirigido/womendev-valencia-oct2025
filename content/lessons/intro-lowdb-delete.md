::card
# LowDB - DELETE

Para eliminar un recurso necesitamos hacer lo siguiente:

1. Añadir un formulario de eliminación en alguna vista. Pueden ser:
    1. Vista de detalle: `views/project-details.handlebars`
    1. Listado: `views/projects.handlebars`
1. Crear una ruta `POST` para eliminar el recurso.
```js
app.post('/<recurso>/:id/delete')
```

### Algunas observaciones

1. HTML solo soporta `GET` y `POST`
1. Los formularios HTML no soportan `method="DELETE"` directamente.
1. El botón para eliminar lo añadimos dentro de un `<form>`
::

::card

# Añadiendo el formulario

## En la vista de detalle:

```html
<!-- views/project-detail.handlebars -->
<article>
  <h1>{{project.title}}</h1>
  <p>{{project.description}}</p>
  <p>Estado: {{project.status}}</p>

  <a href="/projects">← Volver a la lista</a>
  <a href="/projects/{{project.id}}/edit">Editar</a>

  <form action="/projects/{{project.id}}/delete" method="POST" style="display: inline;">
    <button
      type="submit"
      onclick="return confirm('Confirmas eliminar {{project.title}}?')"
    >
      Eliminar
    </button>
  </form>
</article>
```

## En un listado:

Aquí vemos un ejemplo de como añadir el botón de eliminación en `projects.handlebars`. En este ejemplo, no usamos el dialogo de confirmación `confirm()`

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
        <form action="/projects/{{this.id}}/delete" method="POST" style="display: inline;">
          <button type="submit">Eliminar</button>
        </form>
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
# Eliminar registro (DELETE)
```js
app.post('/projects/:id/delete', async (req, res) => {
  try {
    await db.read();

    const projectId = parseInt(req.params.id);

    // Buscar índice del proyecto
    const projectIndex = db.data.projects.findIndex(p => p.id === projectId);

    if (projectIndex === -1) {
      return res.status(404).send('Proyecto no encontrado');
    }

    // Eliminar proyecto del array
    db.data.projects.splice(projectIndex, 1);

    // Guardar cambios
    await db.write();

    // Redirigir a la lista
    res.redirect('/projects');

  } catch (error) {
    console.error('Error al eliminar proyecto:', error);
    res.status(500).render('error', {
      message: 'Error al eliminar el proyecto'
    });
  }
});
```

### Métodos de array para eliminar
```js
// Opción 1: splice (modifica el array original)
db.data.projects.splice(projectIndex, 1);

// Opción 2: filter (crea nuevo array)
db.data.projects = db.data.projects.filter(p => p.id !== projectId);
```

Ambas funcionan, pero `splice` es más directo.
::