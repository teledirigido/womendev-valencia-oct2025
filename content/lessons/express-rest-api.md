::card
# REST (REpresentational State Transfer)

REST, acrónimo de **Transferencia de Estado Representacional**. 

Es un estilo de arquitectura web unificado para facilitar la comunicación entre sistemas en la web. 

<figure>
  <img src="/images/lessons/rest-introduction.webp" loading="lazy">
</figure>

### Send HTTP Request

Se envía una solicitud del cliente al servidor a través de una URL web, utilizando uno de los métodos HTTP.

### Receive JSON Response

El servidor responde con el recurso solicitado utilizando el formato JSON para la respuesta

::

::card
# Client-Server (Conceptos claves)

## Cliente-servidor

En la arquitectura REST, las interfaces cliente y servidor están desacopladas. 

Al separar las funciones del cliente (frontend) de las del servidor y el almacenamiento de datos (backend), permitimos que ambos sistemas (frontend y backend) evolucionen de forma independiente.

Es decir, el servidor y el cliente son sistemas independientes. El servidor actúa como almacén de datos, y el cliente los recupera y consume.

## Stateless (Sin estado)

La restricción sin estado implica que el servidor no necesita memorizar el estado del cliente. Las solicitudes del cliente deben contener toda la información necesaria para que el servidor las comprenda.

## Interfaz uniforme

Una API RESTful debe proporcionar una interfaz uniforme para que las aplicaciones de software escritas en diferentes lenguajes de programación o que se ejecutan en diferentes plataformas puedan acceder a los recursos de la misma manera.
::

::card
# Practicas recomendas para crear APIs REST

## 1. Usamos minúsculas al nombrar los endpoints

Dado que las URI en Internet distinguen entre mayúsculas y minúsculas, y por coherencia, se recomienda usar minúsculas al nombrar los endpoints.

## 2. No usamos guiones bajos (_). Si usar guiones (-).

Se recomienda usar guiones `-` en lugar de guiones bajos `_` en sus endpoints. 

También cabe mencionar que los guiones bajos `_` no están permitidos en los nombres de dominio. Por lo tanto, para mantener la coherencia, no use guiones bajos `_` al nombrar sus endpoints. En su lugar, use guiones `-`.

La estructura correcta de una URL es la siguiente:

```bash
<protocol>://<domain>/<resource-collection>/<resource-id>

# Ejemplo 1:
https://domain.com/users/123

# Ejemplo 2:
https://domain.com/projects/my-first-project

```

## 3. Uso correcto de sustantivos

Debemos usar sustantivos para nombrar las rutas de los endpoints que representan los recursos (o colecciones de recursos) que estamos recuperando o manipulando. 

Debemos evitar usar verbos en las rutas de los endpoints. Los tipos de acciones o solicitudes HTTP ya incluyen un (`GET`, `POST`, etc.). 

El uso de verbos en la ruta del punto final haría que la ruta fuera redundantemente larga sin ningún beneficio real.

|🚨 Not OK| ✅ OK| Ejemplo
|-|-|-|
|`/get-users`|`/users`|`GET /users`|
|`/create-user`|`/users`|`POST /users`|
|`/delete-user`|`/user`|`DELETE /users`|
::



::card
# Verbos HTTP y Operaciones CRUD
Los métodos HTTP definen el tipo de operación que quieres realizar sobre un recurso del servidor. Cada método especifica una acción diferente:
|Verbo|Método HTTP|
|----|------|
|Crear|`POST`|
|Leer|`GET`|
|Actualizar|`PUT`|
|Eliminar|`DELETE`|

Por defecto, visitar un sitio web realiza una petición `GET`. Cuando envías un formulario, típicamente usa los métodos `POST`, `PUT` o `DELETE`.

Existen diversos programas para probar diferentes métodos HTTP como [Postman](https://postman.com).

::

::card
## Códigos de Estado HTTP
Los códigos de estado indican el resultado de una petición HTTP. Diferentes métodos típicamente devuelven diferentes códigos:

| Code | Significado | Ejemplo |
|------|-------------|---------|
| 200 | OK | Petición `GET` exitosa |
| 201 | Creado | `POST` creó un nuevo recurso |
| 204 | Sin Contenido | `DELETE` exitoso, sin cuerpo de respuesta |
| 400 | Petición Incorrecta | `POST` con datos inválidos |
| 404 | No Encontrado | `GET` para recurso inexistente |
| 500 | Error del Servidor | Cualquier método - el servidor falló |

### Ejemplos
- `POST /users` → `201` si se creó, `400` si la validación falla, `500` si error de base de datos
- `GET /users/123` → `200` si se encuentra, `404` si no existe
- `DELETE /users/123` → `204` si se eliminó, `404` si no existe


### Probando HTTP con cURL

Prueba estos comandos en tu terminal para ver los códigos de estado HTTP en acción:

```bash
# Seguir redirecciones para ver el estado final (200 OK)
curl -I -L https://nodejs.org
```
::
