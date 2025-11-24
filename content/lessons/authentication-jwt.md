---
title: Lesson - Autenticación con JSON Web Tokens (JWT)
---

::card
# ¿Qué es la Autenticación?
## La autenticación es el proceso de verificar que un usuario es quien dice ser.

- Permite a los usuarios **iniciar sesión** en aplicaciones
- Protege rutas y recursos **privados**
- Controla **qué puede hacer** cada usuario
- Es **fundamental** para la seguridad web

### Ejemplos cotidianos
- Iniciar sesión en Instagram
- Acceder a tu cuenta bancaria online
- Entrar a tu email
::

::card
# ¿Por qué JSON Web Tokens (JWT)?

JWT es un **estándar** para transmitir información de forma segura entre sistemas.

## Ventajas de JWT
- **Stateless**: No necesita almacenar sesiones en el servidor
- **Portátil**: Funciona entre diferentes dominios y servicios
- **Seguro**: Firmado digitalmente para evitar modificaciones
- **Estándar**: Ampliamente adoptado en la industria

## ¿Cómo funciona?
1. Usuario envía **credenciales** (email, password)
2. Servidor **verifica** las credenciales
3. Servidor **genera** un token JWT
4. Cliente **almacena** el token
5. Cliente **envía** el token en futuras peticiones
::

::card
# Estructura de un JWT

Un JWT tiene **3 partes** separadas por puntos:

```bash
header.payload.signature
```

## Ejemplo de JWT
```bash
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTIzLCJlbWFpbCI6Im1hcmlhQGVtYWlsLmNvbSJ9.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

## Las 3 partes

### 1. Header (Cabecera)
```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

### 2. Payload (Datos del usuario)
```json
{
  "id": 123,
  "email": "maria@email.com",
  "iat": 1699123456
}
```

### 3. Signature (Firma digital)
Garantiza que el token no ha sido modificado
::

::card
# Flujo de Autenticación JWT

<figure>
  <img src="/images/lessons/jwt-flow.webp" alt="JWT Authentication Flow" loading="lazy">
  <figcaption>Flujo completo de autenticación JWT</figcaption>
</figure>

## Paso a paso

### 1. Login
- Cliente envía username/pass
- Servidor verifica credenciales
- Servidor genera JWT
- Servidor envía JWT al cliente

### 2. Peticiones Autenticadas
- Cliente incluye JWT en header `Authorization`
- Servidor verifica JWT
- Si es válido, procesa la petición
- Si no es válido, devuelve error 401

### 3. Logout
- Cliente elimina el JWT de su almacenamiento
- Sin necesidad de avisar al servidor
::

::card
# Configuración del Proyecto

Vamos a crear una aplicación de autenticación con estructura escalable.

## Paso 1: Crear el proyecto
```bash
# Crear carpeta del proyecto
mkdir auth-jwt-example
cd auth-jwt-example

# Inicializar proyecto Node.js
npm init -y

# Instalar dependencias necesarias
npm install express jsonwebtoken bcryptjs express-handlebars cookie-parser
```

## Paso 2: Actualizar package.json
```json
{
  "type": "module",
  "scripts": {
    "dev": "node --watch .",
    "start": "node app.js"
  }
}
```

## Paso 3: Definiendo la estructura
```bash
auth-jwt-example/
├── app.js                    # Archivo principal del servidor
├── routes/                   # Rutas organizadas
│   ├── auth.js               # Rutas de autenticación (/auth)
│   └── dashboard.js          # Rutas del dashboard (/dashboard)
├── models/                   # Modelos de datos
│   └── user.js               # Modelo de usuario
├── middleware/               # Middleware personalizado
│   └── auth.js               # Middleware de autenticación
├── views/                    # Plantillas Handlebars
│   ├── layouts/
│   │   └── main.handlebars   # Layout principal
│   ├── auth/
│   │   ├── register.handlebars # Formulario de registro
│   │   └── login.handlebars    # Formulario de login
│   ├── dashboard.handlebars   # Página principal del dashboard
│   ├── dashboard/
│   │   ├── index.handlebars   # Home de la Zona privada
│   │   └── profile.handlebars # Perfil del usuario
│   └── home.handlebars        # Home de la web
└── config/                   # Configuración
    └── jwt.js                # Configuración JWT
```

## Paquetes instalados

| Paquete | Propósito |
|---------|-----------|
| `express` | Framework web para Node.js |
| `jsonwebtoken` | Crear y verificar tokens JWT |
| `bcryptjs` | Cifrar passwords de forma segura |
| `express-handlebars` | Motor de plantillas para generar HTML dinámico |
| `cookie-parser` | Middleware para manejar cookies |
| `nodemon` | Reinicio automático en desarrollo |

::

::card
# Estructura Básica del Usuario

Vamos a crear el modelo de usuario siguiendo nuestra estructura organizada.

Si utilizáramos un motor de base de datos como MongoDB + Mongoose, nuestro archivo sería diferente. 

Por motivos de prototipo, vamos a utilizar una estructura simple con funciones básicas.

## Archivo: `models/user.js`
```js
// En una app real, esto sería una base de datos
let users = [
  {
    id: 1,
    email: 'maria@email.com',
    // Password: "123456" cifrado con bcrypt
    password: '$2b$10$Ku3rDOL/A4rhK75WftyH/usmcw276sKtsvdoP9UOFOCEG8vXueNT2'
  }
];

// Buscar usuario por email
export const findUserByEmail = (email) => {
  return users.find(user => user.email === email);
};

// Buscar usuario por ID
export const findUserById = (id) => {
  return users.find(user => user.id === id);
};

// Crear nuevo usuario
export const createUser = (email, hashedPassword) => {
  const newUser = {
    id: users.length + 1,
    email,
    password: hashedPassword
  };
  users.push(newUser);
  return newUser;
};
```

## Notas:
- Si alguien accede a la DB, no puede ver passwords reales
- `bcryptjs` aplica **hashing** + **salt**
::

::card
# Servidor Express Básico

Creamos la base de nuestro servidor con las rutas de autenticación.

## Archivo: `app.js`
```js
import express from 'express';
import { engine } from 'express-handlebars';
import cookieParser from 'cookie-parser';

const app = express();
const PORT = 3000;

// Configurar Handlebars como motor de plantillas
app.engine('handlebars', engine());
app.set('view engine', 'handlebars');
app.set('views', './views');

// Middleware global
app.use(express.urlencoded({ extended: true })); // Para todos los formularios
app.use(cookieParser());                    // Para manejar cookies en toda la app

// Ruta de prueba
app.get('/', (req, res) => {
  res.render('home', { 
    title: 'Autenticación JWT',
    message: 'Bienvenida a nuestra aplicación con JWT' 
  });
});

app.listen(PORT, () => {
  console.log(`Servidor ejecutándose en http://localhost:${PORT}`);
});
```

## Puntos importantes
- **Handlebars**: Motor de plantillas para generar HTML dinámico
- `express.urlencoded()`: Para leer datos de formularios HTML
- `cookieParser()`: Para manejar cookies donde almacenaremos el JWT
- `res.render()`: Renderiza plantillas Handlebars en lugar de enviar JSON
::

::card
# Plantillas Handlebars

Vamos a crear las plantillas HTML que necesitaremos para nuestro sistema de autenticación.

## Layout Principal: `views/layouts/main.handlebars`
```html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{title}} - JWT Auth</title>
    <!-- Simple CSS -->
    <link rel="stylesheet" href="https://cdn.simplecss.org/simple.min.css">
</head>
<body>
    <header>
        <nav>
            <a href="/"><strong>JWT Auth</strong></a>
            <ul>
                <li><a href="/auth/register">Registro</a></li>
                <li><a href="/auth/login">Login</a></li>
            </ul>
        </nav>
    </header>

    <main>
        {{#if message}}
            <p><mark>{{message}}</mark></p>
        {{/if}}
        {{#if error}}
            <p><mark style="background-color: #ff6b6b;">{{error}}</mark></p>
        {{/if}}
        
        {{{body}}}
    </main>
</body>
</html>
```

## Página de Inicio: `views/home.handlebars`
```html
<h1>{{title}}</h1>
<p>{{message}}</p>

<div>
    <a href="/auth/register" role="button">Crear Cuenta</a>
    <a href="/auth/login" role="button">Iniciar Sesión</a>
</div>
```

## Formulario de Registro: `views/auth/register.handlebars`
```html
<h1>Crear Cuenta</h1>

<form action="/auth/register" method="POST">
    <label for="email">Email:</label>
    <input type="email" id="email" name="email" required>
    
    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required>
    
    <button type="submit">Registrarse</button>
</form>

<p><a href="/auth/login">¿Ya tienes cuenta? Inicia sesión</a></p>
```

## Formulario de Login: `views/auth/login.handlebars`
```html
<h1>Iniciar Sesión</h1>

<form action="/auth/login" method="POST">
    <label for="email">Email:</label>
    <input type="email" id="email" name="email" required>
    
    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required>
    
    <button type="submit">Entrar</button>
</form>

<p><a href="/auth/register">¿No tienes cuenta? Regístrate</a></p>
```

## Puntos importantes
- **Formularios HTML**: Envían datos via POST
- `{{title}}`: Variable que viene desde el servidor
- `{{{body}}}`: Donde se inserta el contenido de cada página
- **Navegación**: Links a registro y login siempre visibles
::

::card
# Ruta de Registro

Creamos las rutas de autenticación en un archivo separado.

## Archivo: `routes/auth.js`
```js
import express from 'express';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import { findUserByEmail, findUserById, createUser } from '../models/user.js';

const router = express.Router();
const JWT_SECRET = 'mi-secreto-super-seguro-123'; // En producción, usar variable de entorno


// 1. Aquí irá la "Ruta GET de registro" /register
// 2. Aquí irá la "Ruta POST de registro" /register
// 3. Aquí irá la "Ruta GET de login" /login
// 4. Aquí irá la "Ruta POST de login" /login

export default router;
```
::

::card
# Ruta GET /register

Primero añadimos la ruta que muestra el formulario de registro.

## Continuar en: `routes/auth.js`
```js
// 1. Ruta GET registro (mostrar formulario)
router.get('/register', (req, res) => {
  res.render('auth/register', { 
    title: 'Crear Cuenta' 
  });
});
```

## Explicación
- GET `/auth/register`: Muestra el formulario de registro
- `res.render()`: Renderiza la plantilla `auth/register.handlebars`
- `title`: Variable que se pasa a la plantilla

## Probar en el navegador
Ahora puedes visitar: `http://localhost:3000/auth/register`
::

::card
# Ruta POST de registro

Ahora procesamos el formulario de registro y usamos cookies para almacenar el JWT.

```js
// 2. Ruta POST registro (procesar formulario)
router.post('/register', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Validar que se envíen email y password
    if (!email || !password) {
      return res.render('auth/register', { 
        title: 'Crear Cuenta',
        error: 'Email y password son obligatorios' 
      });
    }

    // Verificar si el usuario ya existe
    const existingUser = findUserByEmail(email);
    if (existingUser) {
      return res.render('auth/register', { 
        title: 'Crear Cuenta',
        error: 'Usuario ya existe con este email' 
      });
    }

    // Cifrar el password
    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash(password, saltRounds);

    // Crear el usuario
    const newUser = createUser(email, hashedPassword);

    // Crear token JWT
    const token = jwt.sign(
      { id: newUser.id, email: newUser.email }, 
      JWT_SECRET, 
      { expiresIn: '24h' }
    );

    // Guardar token en cookie httpOnly
    res.cookie('authToken', token, {
      httpOnly: true,
      secure: false, // true en producción con HTTPS
      maxAge: 24 * 60 * 60 * 1000 // 24 horas
    });

    // Redirigir al home con mensaje de éxito
    res.redirect('/?message=Usuario registrado exitosamente');

  } catch (error) {
    res.render('auth/register', { 
      title: 'Crear Cuenta',
      error: 'Error interno del servidor' 
    });
  }
});
```

## Puntos clave
- **Cookie httpOnly**: El token JWT se guarda en una cookie segura que no puede ser accedida por JavaScript
- **Redirect**: En lugar de responder JSON, redirigimos a otra página
- **Error handling**: Los errores se muestran renderizando la misma página con el mensaje
- **res.cookie()**: Establece cookies con opciones de seguridad
::

::card
# Ruta GET de login

Añadimos la ruta que muestra el formulario de inicio de sesión.

## Continuar en: `routes/auth.js`
```js
// 3. Ruta GET login (mostrar formulario)
router.get('/login', (req, res) => {
  res.render('auth/login', { 
    title: 'Iniciar Sesión' 
  });
});
```

## Explicación
- **GET /auth/login**: Muestra el formulario de login
- `res.render()`: Renderiza la plantilla `auth/login.handlebars`
- **title**: Variable que se pasa a la plantilla

## Probar en el navegador
Ahora puedes visitar: `http://localhost:3000/auth/login`
::

::card
# Ruta POST de login

Ahora procesamos el formulario de login y usamos cookies para almacenar el JWT.

## Continuar en: `routes/auth.js`
```js
// 4. Ruta POST login (procesar formulario)
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Validar que se envíen email y password
    if (!email || !password) {
      return res.render('auth/login', { 
        title: 'Iniciar Sesión',
        error: 'Email y password son obligatorios' 
      });
    }

    // Buscar el usuario por email
    const user = findUserByEmail(email);
    if (!user) {
      return res.render('auth/login', { 
        title: 'Iniciar Sesión',
        error: 'Credenciales inválidas' 
      });
    }

    // Verificar el password
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.render('auth/login', { 
        title: 'Iniciar Sesión',
        error: 'Credenciales inválidas' 
      });
    }

    // Crear token JWT
    const token = jwt.sign(
      { id: user.id, email: user.email }, 
      JWT_SECRET, 
      { expiresIn: '24h' }
    );

    // Guardar token en cookie httpOnly
    res.cookie('authToken', token, {
      httpOnly: true,
      secure: false, // true en producción con HTTPS
      maxAge: 24 * 60 * 60 * 1000 // 24 horas
    });

    // Redirigir al home con mensaje de éxito
    res.redirect('/?message=Login exitoso');

  } catch (error) {
    res.render('auth/login', { 
      title: 'Iniciar Sesión',
      error: 'Error interno del servidor' 
    });
  }
});
```

## Seguridad en Login
- **Cookie httpOnly**: El token se almacena de forma segura y no puede ser accedido por JavaScript
- **Mensaje genérico**: "Credenciales inválidas" (sin especificar si es email o password)
- **bcrypt.compare**: Compara de forma segura el password ingresado con el hash
- **Redirect**: Redirige en lugar de enviar respuestas JSON

## Probando el usuario por defecto
Usuario de prueba incluido en `models/user.js`:
- **Email**: `maria@email.com`
- **Password**: `123456`

Ahora puedes probar el login completo en el navegador visitando `/auth/login`.
::

::card
# Recordatorio sobre las rutas

Las siguientes instrucciones son necesarias para importar las rutas.

Es necesario asegurarnos que estan correctamente importadas.

```js
// app.js

// Importamos routes/auth.js
import authRouter from './routes/auth.js';

// app.use() registra las rutas
// las rutas estarán disponibles bajo el prefijo /auth
// Ejemplo: router.post('/login') se convierte en POST /auth/login
app.use('/auth', authRouter);
```
::

::card
# Middlewares, breve introducción

Un **middleware** es una función que se ejecuta entre la petición (request) y la respuesta (response).

## ¿Qué hace un middleware?
```
Request → Middleware → Ruta → Response
```

### Ejemplos que ya hemos usado:

#### 1. Middleware global
```js
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());

/* 
Se ejecutan en todas las rutas:
- express.urlencoded({ extended: true })
- cookieParser() 
*/
```

#### 2. Middleware específico
```js
// Solo se ejecuta en rutas protegidas
app.get('/dashboard', authenticateToken, (req, res) => {
  // Lógica de la ruta GET /dashboard
});

/*
Se ejecuta solo en /dashboard:
- authenticateToken
*/


```

## ¿Cómo funciona?
```js
const miMiddleware = (req, res, next) => {
  // 1. Hacer algo antes de la ruta
  console.log('Antes de la ruta');
  
  // 2. Decidir si continuar o no
  if (todoEstaOk) {
    next(); // Continúa a la siguiente función/ruta
  } else {
    res.redirect('/error'); // Para aquí, no continúa
  }
};
```

## Puntos importantes:
- **`next()`**: Método necesario para continuar con el flujo y pasar a la lógica de la ruta
- **Sin `next()`**: Si no llamamos `next()`, la petición se queda "colgada"
- **Orden importa**: Los middlewares se ejecutan en el orden que se definen

## Casos de uso comunes:
- **Autenticación**: Verificar si el usuario está logueado
- **Parsing**: Convertir datos de formularios (`express.urlencoded`)
- **Cookies**: Leer cookies (`cookieParser`)
- **Logging**: Registrar todas las peticiones
- **CORS**: Permitir peticiones desde otros dominios

En el siguiente card veremos nuestro middleware de autenticación específico.
::

::card
# Middleware de Autenticación

Actualizamos el middleware para leer el JWT desde las cookies en lugar de los headers.

## Archivo: `middleware/auth.js`
```js
import jwt from 'jsonwebtoken';

const JWT_SECRET = 'mi-secreto-super-seguro-123';

// Middleware para verificar JWT desde cookies
const authenticateToken = (req, res, next) => {
  // Obtener el token de las cookies
  const token = req.cookies.authToken;

  if (!token) {
    return res.redirect('/auth/login?error=Sesión expirada. Inicia sesión nuevamente');
  }

  // Verificar y decodificar el token
  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      // Token inválido, limpiar cookie y redirigir
      res.clearCookie('authToken');
      return res.redirect('/auth/login?error=Sesión inválida. Inicia sesión nuevamente');
    }
    
    // Añadir información del usuario al request
    req.user = user;
    next(); // Continuar al siguiente middleware/ruta
  });
};

export default authenticateToken;
```

## ¿Cómo funciona?

### 1. Extraer el token de cookies
```js
const token = req.cookies.authToken;
```
Lee el token directamente de la cookie que establecimos al hacer login

### 2. Verificar el token
```js
jwt.verify(token, JWT_SECRET, callback)
```
Verifica que el token sea válido y no haya expirado

### 3. Manejar errores con redirects
```js
res.redirect('/auth/login?error=mensaje')
```
En lugar de devolver JSON, redirige al login con mensaje de error

### 4. Limpiar cookies inválidas
```js
res.clearCookie('authToken');
```
Elimina cookies con tokens inválidos o expirados
::

::card
# Rutas Protegidas

Ahora podemos crear rutas que solo usuarios autenticados pueden acceder. Necesitamos crear las plantillas para estas páginas también.

## Plantilla de Dashboard: `views/dashboard/index.handlebars`
```html
<h1>Dashboard</h1>
<p>¡Bienvenida <strong>{{user.email}}</strong>!</p>
<p>Estos son datos que solo usuarios autenticados pueden ver.</p>

<div>
    <a href="/auth/profile" role="button">Ver Perfil</a>
    <a href="/auth/logout" role="button">Cerrar Sesión</a>
</div>
```

## Plantilla de Perfil: `views/dashboard/profile.handlebars`
```html
<h1>Mi Perfil</h1>
<p><strong>ID:</strong> {{user.id}}</p>
<p><strong>Email:</strong> {{user.email}}</p>

<div>
    <a href="/dashboard" role="button">Volver al Dashboard</a>
    <a href="/auth/logout" role="button">Cerrar Sesión</a>
</div>
```

## Archivo: `routes/dashboard.js`
```js
import express from 'express';
import { findUserById } from '../models/user.js';
import authenticateToken from '../middleware/auth.js';

const router = express.Router();

// Dashboard principal
router.get('/', authenticateToken, (req, res) => {
  res.render('dashboard', {
    title: 'Dashboard',
    user: req.user
  });
});

// Perfil de usuario  
router.get('/profile', authenticateToken, (req, res) => {
  // Buscar el usuario en la "base de datos"
  const user = findUserById(req.user.id);
  
  if (!user) {
    return res.redirect('/auth/login?error=Usuario no encontrado');
  }
  
  res.render('dashboard/profile', {
    title: 'Mi Perfil',
    user: {
      id: user.id,
      email: user.email
      // NO enviamos el password
    }
  });
});

export default router;
```

## Añadir logout a: `routes/auth.js`
```js
// Ruta de logout (añadir al final del archivo auth.js)
router.get('/logout', (req, res) => {
  res.clearCookie('authToken');
  res.redirect('/?message=Sesión cerrada exitosamente');
});
```

## Conectar en: `app.js`
```js
import dashboardRouter from './routes/dashboard.js';

// Usar rutas del dashboard
app.use('/dashboard', dashboardRouter);
```

## Uso del middleware
```js
app.get('/ruta-publica', (req, res) => { /* Sin middleware */ });
app.get('/ruta-privada', authenticateToken, (req, res) => { /* Con middleware */ });
```

## ¿Qué información está disponible?
El objeto `req.user` contiene los datos que pusimos en el JWT:
```js
{
  id: 123,
  email: 'maria@email.com',
  iat: 1699123456, // Cuándo se creó
  exp: 1699209856  // Cuándo expira
}
```

## Flujo completo
1. Usuario hace login → JWT se guarda en cookie
2. Usuario visita `/dashboard` → Middleware verifica cookie
3. Si cookie es válida → Muestra dashboard
4. Si cookie es inválida → Redirige a login
5. Usuario hace logout → Cookie se elimina
::

::card
# Probando la Aplicación Completa

Ahora vamos a probar toda la aplicación web en el navegador.

## 1. Iniciar el servidor
```bash
cd auth-jwt-example
npm run dev
```

## 2. Probar la navegación completa

### Paso 1: Visita la página de inicio
- Ve a: `http://localhost:3000/`
- Deberías ver links a "Crear Cuenta" y "Iniciar Sesión"

### Paso 2: Crear una cuenta nueva
- Haz clic en "Crear Cuenta" o ve a: `http://localhost:3000/auth/register`
- Llena el formulario con email y password
- Al enviar, deberías ser redirigido al home con mensaje de éxito

### Paso 3: Probar login
- Ve a: `http://localhost:3000/auth/login`
- Usa el usuario de prueba:
  - **Email**: `maria@email.com`
  - **Password**: `123456`
- Al hacer login exitoso, serás redirigido al home

### Paso 4: Acceder a páginas protegidas
- Ve a: `http://localhost:3000/dashboard`
- Deberías ver el dashboard con tu información
- Prueba ir a "Ver Perfil"

### Paso 5: Probar protección de rutas
- Haz clic en "Cerrar Sesión"
- Intenta visitar: `http://localhost:3000/dashboard`
- Deberías ser redirigido al login automáticamente

## 3. Verificar cookies en el navegador
- Abre las **Herramientas de Desarrollador** (F12)
- Ve a la pestaña **Application** > **Cookies**
- Deberías ver la cookie `authToken` cuando estés logueado
::

::card
# Desarrollo y Debug

Para desarrollo y debug de APIs, sigue siendo útil probar las rutas individualmente.

## Usando cURL (opcional para desarrollo)

### 1. Registro via formulario
```bash
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "email=test@email.com&password=test123" \
  -c cookies.txt
```

### 2. Login via formulario
```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "email=maria@email.com&password=123456" \
  -c cookies.txt
```

### 3. Acceder a ruta protegida con cookies
```bash
curl -X GET http://localhost:3000/dashboard \
  -b cookies.txt \
  -L
```

## Nota importante sobre cookies
- **`-c cookies.txt`**: Guarda las cookies en un archivo
- **`-b cookies.txt`**: Envía las cookies guardadas
- **`-L`**: Sigue redirects automáticamente

## Para desarrollo web
La mejor forma de probar es usando el navegador directamente, ya que maneja las cookies automáticamente y te permite ver la experiencia real del usuario.
::

::card
# Mejores Prácticas de Seguridad

## 1. Gestión de secretos
```js
// ❌ MAL - Secreto hardcodeado
const JWT_SECRET = 'mi-secreto-123';

// ✅ BIEN - Variable de entorno
const JWT_SECRET = process.env.JWT_SECRET || 'secreto-para-desarrollo';
```

Crear archivo `.env`:
```
JWT_SECRET=un-secreto-muy-largo-y-aleatorio-para-produccion-123456789
```

## 2. Tiempo de expiración del token
```js
// Token de corta duración para mayor seguridad
const token = jwt.sign(payload, JWT_SECRET, { 
  expiresIn: '15m' // 15 minutos
});

// Para desarrollo puedes usar tiempos más largos
const token = jwt.sign(payload, JWT_SECRET, { 
  expiresIn: '24h' // 24 horas
});
```

## 3. Validación robusta de passwords
```js
// Verificar longitud mínima
if (password.length < 6) {
  return res.status(400).json({ 
    error: 'Password debe tener al menos 6 caracteres' 
  });
}

// Verificar complejidad (opcional)
const hasUpperCase = /[A-Z]/.test(password);
const hasLowerCase = /[a-z]/.test(password);
const hasNumbers = /\d/.test(password);

if (!hasUpperCase || !hasLowerCase || !hasNumbers) {
  return res.status(400).json({ 
    error: 'Password debe incluir mayúsculas, minúsculas y números' 
  });
}
```

## 4. Rate Limiting
Limitar intentos de login para prevenir ataques:
```bash
npm install express-rate-limit
```

```js
import rateLimit from 'express-rate-limit';

const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 5, // máximo 5 intentos por IP
  message: { error: 'Demasiados intentos de login. Intenta en 15 minutos.' }
});

app.post('/auth/login', loginLimiter, async (req, res) => {
  // Tu código de login aquí
});
```
::

::card
# Próximos Pasos y Conceptos Avanzados

## Lo que has aprendido
- ✅ Qué es JWT y por qué usarlo
- ✅ Implementar registro y login
- ✅ Crear middleware de autenticación  
- ✅ Proteger rutas con tokens
- ✅ Probar API con herramientas
- ✅ Aplicar mejores prácticas de seguridad

## Conceptos para explorar después

### 1. Refresh Tokens
- Tokens de larga duración para renovar access tokens
- Mayor seguridad en aplicaciones de producción

### 2. Roles y Permisos
```js
const token = jwt.sign({
  id: user.id,
  email: user.email,
  role: 'admin' // Añadir roles
}, JWT_SECRET);
```

### 3. Base de Datos Real
- Reemplazar array en memoria por MongoDB/PostgreSQL
- Usar ORMs como Mongoose o Prisma

### 4. Logout con Blacklist
- Mantener lista de tokens invalidados
- Verificar tokens en blacklist antes de autorizar

### 5. OAuth con Google/Facebook
- Permitir login con redes sociales
- Integrar con servicios externos

### 6. Password Reset
- Envío de emails para recuperar contraseña
- Tokens temporales para reset

## Recursos adicionales
- [jwt.io](https://jwt.io/) - Decodificar y analizar tokens JWT
- [OWASP](https://owasp.org/) - Mejores prácticas de seguridad web
- [Node.js Security Checklist](https://blog.risingstack.com/node-js-security-checklist/)

¡Has construido un sistema de autenticación funcional desde cero! 🎉
::

::card
# Ejercicio Práctico Final

## Tu misión: Crear un sistema completo de tareas con autenticación

Usando todo lo que has aprendido, crea una API de tareas personales que requiera autenticación.

### Funcionalidades requeridas

#### 1. Autenticación (ya tienes esto!)
- ✅ Registro de usuarios
- ✅ Login con JWT  
- ✅ Middleware de protección

#### 2. CRUD de Tareas (nuevo)
Añade estas rutas protegidas:

```js
// Obtener todas las tareas del usuario
GET /tasks -> Requiere auth

// Crear nueva tarea
POST /tasks -> Requiere auth
{
  "title": "Estudiar Node.js",
  "description": "Completar la lección de JWT",
  "completed": false
}

// Actualizar tarea
PUT /tasks/:id -> Requiere auth

// Eliminar tarea  
DELETE /tasks/:id -> Requiere auth
```

### Estructura sugerida de Task:
```js
{
  id: 1,
  title: "Estudiar Node.js",
  description: "Completar la lección de JWT", 
  completed: false,
  userId: 123, // ID del usuario que creó la tarea
  createdAt: "2023-10-25T10:30:00Z"
}
```

### Reglas de negocio:
- Un usuario **solo puede ver sus propias tareas**
- Un usuario **solo puede modificar sus propias tareas**
- Al crear una tarea, se asigna automáticamente al usuario autenticado

### Entregable:
1. Código completo funcionando
2. Prueba todas las rutas con Postman o cURL
3. Sube tu proyecto a GitHub (recuerda el `.gitignore`)

### Bonus (opcional):
- Filtrar tareas por estado: `GET /tasks?completed=true`
- Buscar tareas: `GET /tasks?search=node`
- Paginación: `GET /tasks?page=1&limit=5`

¡Demuestra todo lo que has aprendido! 💪
::