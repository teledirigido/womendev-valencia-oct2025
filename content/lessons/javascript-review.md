::card
# Javascript Review

- Variables
- Template Literals
- Funciones
- Arrays
  - Mutación vs Inmutabilidad
  - Shallow copy vs Deep Copy
  - Array vs Array.prototype
  - Encadenando métodos de arrays
- Destructuring
  - Objetos
  - Array

::

::card
# Variables: const vs let

Antes de trabajar con arrays, repasemos cómo declarar variables correctamente.

### `const` - No se puede reasignar
```js
const name = 'Ana'
name = 'Carlos' // ❌ Error! No puedes reasignar
```
Usa `const` por defecto, solo usa `let` cuando necesites reasignar.

### `let` - Se puede reasignar
```js
let counter = 0
counter = counter + 1 // OK
counter = 5 // OK
```



### Importante
Con `const` puedes **modificar el contenido**, solo no puedes **reasignar**:

```js
const posts = []
posts.push({ title: 'Hola' }) // OK! Modificando contenido
posts = [] // ❌ Error! Intentando reasignar
```
::

::card
# Template Literals

Los template literals hacen más fácil trabajar con strings que contienen variables.

### Sintaxis tradicional (concatenación)
```js
const name = 'Ana'
const age = 25
const message = 'Hola, me llamo ' + name + ' y tengo ' + age + ' años'
```

### Con template literals
```js
const name = 'Ana'
const age = 25
const message = `Hola, me llamo ${name} y tengo ${age} años`
```

### Ventajas
- Más fácil de leer
- Puedes usar comillas simples y dobles dentro
- Permite saltos de línea
- Puedes evaluar expresiones: `${5 + 3}` → `8`

### Ejemplos prácticos
```js
const post = { title: 'Mi viaje', author: 'Carlos' }
console.log(`${post.title} por ${post.author}`)
// "Mi viaje por Carlos"

const price = 19.99
console.log(`Total: $${price * 2}`)
// "Total: $39.98"
```

**Nota**: 

- Usa backticks `` ` `` (no comillas simples o dobles)
- Leer más: https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Template_literals
::

::card
# Funciones: Repaso y Evolución

JavaScript tiene varias formas de escribir funciones. Veamos la evolución:

### Declaración tradicional
```js
function greet(name) {
  return 'Hola, ' + name
}
```

### Función expresión (anónima)
```js
const greet = function(name) {
  return 'Hola, ' + name
}
```

### Arrow function
```js
const greet = (name) => {
  return 'Hola, ' + name
}
```

### Arrow function - Forma corta ⭐
```js
// Un parámetro: paréntesis opcionales
const greet = name => {
  return 'Hola, ' + name
}

// Retorno de una expresión: llaves y return opcionales
const greet = name => 'Hola, ' + name

// Múltiples parámetros: paréntesis requeridos
const add = (a, b) => a + b
```

### ¿Cuál usar?

Para este curso, vamos a usar principalmente **arrow functions** porque son más cortas y fáciles de leer.

**Forma corta** - cuando retornas algo directamente:
```js
const greet = name => `Hola ${name}`
const double = n => n * 2
```
::

::card
# Arrays en Javascript
Los arrays son estructuras fundamentales en JavaScript que nos permiten almacenar y manipular colecciones de datos.

### ¿Por qué importa?
- Manipular datos de bases de datos (posts, usuarios, comentarios)
- Transformar y filtrar información
- Construir aplicaciones web dinámicas
::

::card
# Arrays de Objetos

La estructura más común que encontrarás en desarrollo web.

### Ejemplo: Array de posts
```js
const posts = [
  { id: 1, title: 'Mi viaje a París', author: 'Ana', rating: 5 },
  { id: 2, title: 'Londres en invierno', author: 'Carlos', rating: 4 },
  { id: 3, title: 'Roma increíble', author: 'Ana', rating: 5 },
  { id: 4, title: 'Barcelona', author: 'Luis', rating: 3 }
]
```

### Accediendo a los datos
```js
posts[0] // { id: 1, title: 'Mi viaje a París', ... }
posts[0].title // "Mi viaje a París"
posts[0].author // "Ana"
```

### ¿Dónde verás esto?
- Datos de bases de datos (LowDB, MongoDB)
- Respuestas de APIs
- Listas de usuarios, productos, comentarios
- ¡Prácticamente en todas partes!
::

::card
# Spread Operator (...)

El **spread operator** (`...`) es una sintaxis moderna que "expande" un array en sus elementos individuales. Es fundamental para trabajar con arrays de forma inmutable.

## ¿Qué hace?

El spread operator toma todos los elementos de un array y los "expande". 

- `numbers` contiene a todos los elementos: `[1, 2, 3]`
- `...numbers` saca todos los elementos: `1, 2, 3`

Esto es útil cuando quieres crear un nuevo array o combinar arrays.

## Copiar arrays

La forma más común de usarlo:

```js
const original = [1, 2, 3]
const copia = [...original]

console.log(copia) // [1, 2, 3]
console.log(copia === original) // false (son arrays diferentes)
```

## Combinar arrays

Junta varios arrays en uno nuevo:

```js
const frutas = ['manzana', 'pera']
const verduras = ['zanahoria', 'lechuga']

const comida = [...frutas, ...verduras]
console.log(comida)
// ['manzana', 'pera', 'zanahoria', 'lechuga']
```

### Múltiples arrays

```js
const arr1 = [1, 2]
const arr2 = [3, 4]
const arr3 = [5, 6]

const combined = [...arr1, ...arr2, ...arr3]
console.log(combined) // [1, 2, 3, 4, 5, 6]
```

## Añadir elementos

Sin mutar el array original:

```js
const posts = [
  { id: 1, title: 'París' },
  { id: 2, title: 'Roma' }
]

// Añadir al final
const withNew = [...posts, { id: 3, title: 'Londres' }]

// Añadir al inicio
const withNewStart = [{ id: 0, title: 'Madrid' }, ...posts]

// Array original sin cambios
console.log(posts.length) // 2
console.log(withNew.length) // 3
```

## ¿Por qué es importante?

El spread operator es esencial para **programación inmutable**:

- No modifica arrays originales
- Previene bugs difíciles de encontrar
- Es el estándar en frameworks modernos (React, Vue)
- Código más predecible y fácil de debuggear

**Regla general:** Usa spread cuando necesites una nueva copia o combinar arrays sin modificar los originales.
::

::card
# Mutación vs Inmutabilidad

Concepto fundamental para entender cómo funcionan los métodos de arrays.

### ¿Qué significa "mutar"?
**Mutar** = Modificar el array original directamente

### Métodos que MUTAN (modifican el original)
```js
const numbers = [1, 2, 3]

numbers.push(4)        // Añade al final → [1, 2, 3, 4]
numbers.pop()          // Elimina el último → [1, 2, 3]
numbers.shift()        // Elimina el primero → [2, 3]
numbers.unshift(0)     // Añade al inicio → [0, 2, 3]
numbers.splice(1, 1)   // Elimina elementos → [0, 3]

// El array original cambió ⚠️
```

### Métodos que NO mutan (retornan nuevo array)
```js
const numbers = [1, 2, 3]

const doubled = numbers.map(n => n * 2)     // [2, 4, 6]
const evens = numbers.filter(n => n % 2 === 0)  // [2]
const copy = numbers.slice()                 // [1, 2, 3]
const combined = numbers.concat([4, 5])      // [1, 2, 3, 4, 5]

console.log(numbers) // [1, 2, 3] - ¡Original sin cambios! ✔️
```

### ¿Por qué importa?
- **Mutación**: Cambios directos, puede causar bugs difíciles de rastrear
- **Inmutabilidad**: Más seguro, datos originales preservados
- En desarrollo moderno se prefiere **inmutabilidad**
::

::card
# Shallow Copy vs Deep Copy

Entender la diferencia te evitará bugs comunes.

### Shallow Copy (Copia superficial)
Copia el primer nivel, pero objetos internos mantienen la **misma referencia**.

```js
const posts = [
  { id: 1, title: 'París' },
  { id: 2, title: 'Roma' }
]

// Usando spread operator
const copy = [...posts]

// Modificar objeto interno afecta ambos
copy[0].title = 'Londres'
console.log(posts[0].title) // "Londres" ⚠️
```

### ¿Por qué pasa esto?
Los objetos dentro del array **no se copian**, solo sus referencias.

### Deep Copy (Copia profunda)
Copia todo, incluyendo objetos internos.

```js
const posts = [
  { id: 1, title: 'París' },
  { id: 2, title: 'Roma' }
]

// Deep copy con structuredClone (moderno)
const deepCopy = structuredClone(posts)

deepCopy[0].title = 'Londres'
console.log(posts[0].title) // "París" ✔️ Original sin cambios
```

### Alternativa: JSON (con limitaciones)
```js
const deepCopy = JSON.parse(JSON.stringify(posts))
```
⚠️ No funciona con funciones, Date, undefined

### Cuándo usar cada una
- **Shallow copy**: Arrays simples (números, strings)
- **Deep copy**: Arrays de objetos que vas a modificar
::

::card
# Array vs Array.prototype

Diferencia fundamental entre el constructor y los métodos heredados.

### Array (El constructor)
Es la función constructora que crea arrays.

```js
const arr1 = new Array(1, 2, 3)  // [1, 2, 3]
const arr2 = Array.of(1, 2, 3)   // [1, 2, 3]
const arr3 = Array.from('abc')   // ['a', 'b', 'c']
```

Estos son **métodos estáticos** de Array:
```js
Array.isArray([1, 2])  // true
Array.from('hello')    // ['h', 'e', 'l', 'l', 'o']
```

### Array.prototype (Métodos heredados)
Son métodos que **todas las instancias** de arrays heredan.

```js
const posts = [1, 2, 3]
posts.find(...)    // viene de Array.prototype.find
posts.filter(...)  // viene de Array.prototype.filter
posts.map(...)     // viene de Array.prototype.map
```

### Diferencia clave

| Tipo | Uso | Ejemplo |
|------|-----|---------|
| **Métodos estáticos** | Se llaman en `Array` | `Array.isArray(arr)` |
| **Métodos de instancia** | Se llaman en el array | `arr.map(...)` |

### ¿Por qué importa?
Cuando ves `.map()`, `.filter()`, `.find()` - estás usando métodos de **Array.prototype**.

Todos los arrays heredan estos métodos automáticamente. ¡Por eso funcionan en cualquier array que crees!
::

::card
# Array.prototype.includes()

Verifica si un valor existe en el array. Retorna `true` o `false`.

### Sintaxis básica
```js
const numbers = [1, 2, 3, 4, 5]
numbers.includes(3)  // true
numbers.includes(10) // false
```

### Con arrays de strings
```js
const fruits = ['manzana', 'pera', 'uva']
fruits.includes('pera')     // true
fruits.includes('sandía')   // false
```

### Case sensitive
```js
const names = ['Ana', 'Carlos', 'Luis']
names.includes('ana')  // false (minúscula)
names.includes('Ana')  // true
```

### Uso práctico
```js
const allowedRoles = ['admin', 'editor', 'viewer']
const userRole = 'editor'

if (allowedRoles.includes(userRole)) {
  console.log('Acceso permitido')
} else {
  console.log('Acceso denegado')
}
```

### Características
- No muta el array original ✔️
- Retorna boolean (true/false)
- Más simple que `.find()` cuando solo necesitas verificar existencia
::

::card
# Array.prototype.find()

Encuentra el **PRIMER** elemento que cumple una condición.

### Sintaxis
```js
const result = array.find(elemento => condición)
```

### Ejemplo básico
```js
const posts = [
  { id: 1, title: 'París', author: 'Ana' },
  { id: 2, title: 'Londres', author: 'Carlos' },
  { id: 3, title: 'Roma', author: 'Ana' }
]

// Encontrar post por id
const post = posts.find(p => p.id === 2)
console.log(post)
// { id: 2, title: 'Londres', author: 'Carlos' }
```

### Formas de escribirlo

**Forma larga:**
```js
const post = posts.find(function(post) {
  return post.id === 3
})
```

**Arrow function:**
```js
const post = posts.find((post) => {
  return post.id === 3
})
```

**Forma corta (más común):**
```js
const post = posts.find(p => p.id === 3)
```

### Más ejemplos
```js
// Encontrar por autor
const anaPost = posts.find(p => p.author === 'Ana')
// { id: 1, title: 'París', author: 'Ana' }

// Encontrar por título
const londonPost = posts.find(p => p.title === 'Londres')
```

### ¿Qué pasa si no encuentra nada?
```js
const notFound = posts.find(p => p.id === 999)
console.log(notFound) // undefined
```

### Características importantes
- Retorna el **PRIMER** elemento que cumple
- Retorna `undefined` si no encuentra nada
- No muta el array original ✔️
::

::card
# Array.prototype.filter()

Encuentra **TODOS** los elementos que cumplen una condición. Retorna un nuevo array.

### Diferencia con find()
| Método | Retorna | Cuántos |
|--------|---------|---------|
| `.find()` | Un objeto o `undefined` | Solo el primero |
| `.filter()` | Un array (puede estar vacío) | Todos los que cumplen |

### Sintaxis
```js
const result = array.filter(elemento => condición)
```

### Ejemplos
```js
const posts = [
  { id: 1, title: 'París', author: 'Ana', rating: 5 },
  { id: 2, title: 'Londres', author: 'Carlos', rating: 4 },
  { id: 3, title: 'Roma', author: 'Ana', rating: 5 },
  { id: 4, title: 'Madrid', author: 'Luis', rating: 3 }
]

// Todos los posts de Ana
const anaPosts = posts.filter(p => p.author === 'Ana')
// [{ id: 1, ... }, { id: 3, ... }]

// Posts con rating >= 4
const goodPosts = posts.filter(p => p.rating >= 4)
// [{ id: 1, ... }, { id: 2, ... }, { id: 3, ... }]

// Posts que NO son de Ana
const notAna = posts.filter(p => p.author !== 'Ana')
// [{ id: 2, ... }, { id: 4, ... }]
```

### Cuando no encuentra nada
```js
const badPosts = posts.filter(p => p.rating < 2)
console.log(badPosts) // [] (array vacío)
```

### Verificar si está vacío
```js
const results = posts.filter(p => p.rating === 5)

if (results.length === 0) {
  console.log('No se encontraron resultados')
} else {
  console.log(`Se encontraron ${results.length} resultados`)
}
```

### Características
- Retorna un **nuevo array**
- Puede retornar array vacío `[]`
- No muta el array original ✔️
::

::card
# Array.prototype.map()

Transforma cada elemento del array y retorna un **nuevo array** con los resultados.

### Sintaxis
```js
const newArray = array.map(elemento => transformación)
```

### Ejemplo básico
```js
const numbers = [1, 2, 3, 4]
const doubled = numbers.map(n => n * 2)
console.log(doubled) // [2, 4, 6, 8]
console.log(numbers) // [1, 2, 3, 4] - original sin cambios
```

### Extraer propiedades específicas
```js
const posts = [
  { id: 1, title: 'París', author: 'Ana' },
  { id: 2, title: 'Londres', author: 'Carlos' },
  { id: 3, title: 'Roma', author: 'Ana' }
]

// Solo los títulos
const titles = posts.map(p => p.title)
console.log(titles)
// ['París', 'Londres', 'Roma']

// Solo los autores
const authors = posts.map(p => p.author)
// ['Ana', 'Carlos', 'Ana']

// Solo los IDs
const ids = posts.map(p => p.id)
// [1, 2, 3]
```

### Crear nuevos objetos
```js
// Resúmenes con solo algunas propiedades
const summaries = posts.map(p => {
  return {
    title: p.title,
    author: p.author
  }
})

// Forma corta (retorno implícito con paréntesis)
const summaries = posts.map(p => ({
  title: p.title,
  author: p.author
}))
```

### Transformaciones
```js
// Títulos en mayúsculas
const upperTitles = posts.map(p => p.title.toUpperCase())
// ['PARÍS', 'LONDRES', 'ROMA']

// Combinar con template literals
const formatted = posts.map(p => `${p.title} por ${p.author}`)
// ['París por Ana', 'Londres por Carlos', 'Roma por Ana']
```

### Características
- Siempre retorna un **nuevo array** del mismo tamaño
- No muta el array original ✔️
- Perfecto para transformar datos
::

::card
# Array.prototype.some()

Verifica si **AL MENOS UN** elemento cumple la condición. Retorna `true` o `false`.

### Sintaxis
```js
const result = array.some(elemento => condición)
```

### Ejemplos básicos
```js
const numbers = [1, 3, 5, 8, 9]

// ¿Hay algún número par?
const hasEven = numbers.some(n => n % 2 === 0)
console.log(hasEven) // true (el 8 es par)

// ¿Hay algún número mayor a 10?
const hasLarge = numbers.some(n => n > 10)
console.log(hasLarge) // false
```

### Con arrays de objetos
```js
const posts = [
  { id: 1, title: 'París', rating: 4 },
  { id: 2, title: 'Londres', rating: 5 },
  { id: 3, title: 'Roma', rating: 3 }
]

// ¿Hay algún post con rating perfecto?
const hasPerfect = posts.some(p => p.rating === 5)
console.log(hasPerfect) // true

// ¿Hay algún post con rating bajo?
const hasLowRating = posts.some(p => p.rating < 2)
console.log(hasLowRating) // false
```

### Casos de uso prácticos
```js
const users = [
  { name: 'Ana', role: 'user' },
  { name: 'Carlos', role: 'admin' },
  { name: 'Luis', role: 'user' }
]

// ¿Hay algún administrador?
const hasAdmin = users.some(u => u.role === 'admin')
if (hasAdmin) {
  console.log('Hay al menos un admin en el sistema')
}
```

### Características
- Retorna boolean (`true` o `false`)
- Se detiene en el primer elemento que cumple (eficiente)
- No muta el array original ✔️
- Útil para validaciones
::

::card
# Array.prototype.every()

Verifica si **TODOS** los elementos cumplen la condición. Retorna `true` o `false`.

### Sintaxis
```js
const result = array.every(elemento => condición)
```

### Diferencia con some()
| Método | Retorna `true` cuando... |
|--------|--------------------------|
| `.some()` | **AL MENOS UNO** cumple |
| `.every()` | **TODOS** cumplen |

### Ejemplos básicos
```js
const numbers = [2, 4, 6, 8]

// ¿Todos son pares?
const allEven = numbers.every(n => n % 2 === 0)
console.log(allEven) // true

// ¿Todos son mayores a 5?
const allLarge = numbers.every(n => n > 5)
console.log(allLarge) // false (2 y 4 no lo son)
```

### Con arrays de objetos
```js
const posts = [
  { id: 1, title: 'París', rating: 4 },
  { id: 2, title: 'Londres', rating: 5 },
  { id: 3, title: 'Roma', rating: 3 }
]

// ¿Todos tienen rating >= 3?
const allGood = posts.every(p => p.rating >= 3)
console.log(allGood) // true

// ¿Todos tienen rating perfecto?
const allPerfect = posts.every(p => p.rating === 5)
console.log(allPerfect) // false
```

### Casos de uso prácticos
```js
const formData = [
  { field: 'name', value: 'Ana', valid: true },
  { field: 'email', value: 'ana@example.com', valid: true },
  { field: 'age', value: '', valid: false }
]

// ¿Todos los campos son válidos?
const formIsValid = formData.every(field => field.valid)
if (formIsValid) {
  console.log('Formulario válido, enviar')
} else {
  console.log('Hay campos inválidos')
}
```

### Características
- Retorna boolean (`true` o `false`)
- Se detiene en el primer elemento que NO cumple
- No muta el array original ✔️
- Útil para validaciones completas
::

::card
# Array.prototype.reduce() - Básico

Reduce un array a un **solo valor**. Es el método más poderoso pero también el más complejo.

### Concepto
- Tiene un`acumulador` que guarda el resultado mientras procesa
- En cada iteración, el acumulador se actualiza
- Al final, se retorna el valor acumulado

### Sintaxis
```js
const result = array.reduce((acumulador, elemento) => {
  // retornar nuevo valor del acumulador
}, valorInicial)
```

### Analogía
Es como ir sumando dinero en tu bolsillo:
- Empiezas con 0€ en el bolsillo (valor inicial)
- Cada persona te da dinero (cada elemento del array)
- Vas sumándolo a lo que ya tienes (acumulador)
- Al final cuentas cuánto tienes en total (resultado final)

### Ejemplo 1: Sumar números
```js
const numbers = [1, 2, 3, 4, 5]

const sum = numbers.reduce((total, n) => {
  return total + n
}, 0)

console.log(sum) // 15
```

**¿Cómo funciona?**
```js
// Iteración 1: total = 0, n = 1 → retorna 0 + 1 = 1
// Iteración 2: total = 1, n = 2 → retorna 1 + 2 = 3
// Iteración 3: total = 3, n = 3 → retorna 3 + 3 = 6
// Iteración 4: total = 6, n = 4 → retorna 6 + 4 = 10
// Iteración 5: total = 10, n = 5 → retorna 10 + 5 = 15
```

### Forma corta
```js
const sum = numbers.reduce((total, n) => total + n, 0)
```

### Ejemplo 2: Contar elementos
```js
const posts = [
  { author: 'Ana' },
  { author: 'Carlos' },
  { author: 'Ana' },
  { author: 'Ana' }
]

// Contar posts por autor
const count = posts.reduce((acc, post) => {
  if (post.author === 'Ana') {
    return acc + 1
  }
  return acc
}, 0)

console.log(count) // 3
```

### Ejemplo 3: Sumar ratings
```js
const reviews = [
  { place: 'París', rating: 5 },
  { place: 'Londres', rating: 4 },
  { place: 'Roma', rating: 5 }
]

const totalRating = reviews.reduce((sum, review) => {
  return sum + review.rating
}, 0)

console.log(totalRating) // 14

// Calcular promedio
const average = totalRating / reviews.length
console.log(average) // 4.67
```

### Características
- Retorna un **solo valor** (número, string, objeto, array)
- No muta el array original ✔️
- El acumulador puede ser cualquier tipo
- Requiere valor inicial (segundo parámetro)
::

::card
# Combinando Métodos (Chaining)

Hasta ahora hemos usado cada método por separado. Pero en programación real, es muy común **encadenar** (chain) varios métodos para transformar datos en múltiples pasos.

## ¿Qué es chaining?

**Chaining** significa conectar varios métodos uno después del otro, como una cadena de producción.

```js
array
  .método1()  // paso 1: retorna nuevo array
  .método2()  // paso 2: retorna nuevo array
  .método3()  // paso 3: retorna resultado final
```

## ¿Por qué funciona?

Los métodos como `.filter()`, `.map()`, y otros retornan un **nuevo array**, entonces puedes llamar otro método inmediatamente sobre ese resultado.

## ¿Por qué es útil?

Compara estas dos formas de resolver el mismo problema:

```js
const posts = [
  { id: 1, author: 'Ana', rating: 5 },
  { id: 2, author: 'Carlos', rating: 4 },
  { id: 3, author: 'Ana', rating: 3 }
]

// Sin chaining - múltiples variables temporales
const anaPosts = posts.filter(p => p.author === 'Ana')
const anaRatings = anaPosts.map(p => p.rating)
console.log(anaRatings) // [5, 3]

// Con chaining - más limpio y directo
const anaRatings = posts
  .filter(p => p.author === 'Ana')
  .map(p => p.rating)
console.log(anaRatings) // [5, 3]
```

**Ventajas:**
- Menos variables temporales
- Código más limpio y fácil de leer
- Describe claramente el flujo de transformación

## Cómo leerlo

Lee de **arriba hacia abajo**, como una línea de ensamblaje:

```js
const result = posts
  .filter(p => p.rating >= 4)   // 1 Primero: filtra
  .map(p => p.title)            // 2 Después: transforma
  .map(t => t.toUpperCase())    // 3 Por último: a mayúsculas

// Flujo: posts -> posts filtrados -> títulos -> TÍTULOS
```

Cada método recibe el resultado del anterior.

## Ejemplo 1: Filter + Map

```js
const posts = [
  { id: 1, author: 'Ana', rating: 5 },
  { id: 2, author: 'Carlos', rating: 4 },
  { id: 3, author: 'Ana', rating: 3 },
  { id: 4, author: 'Luis', rating: 5 }
]

// Obtener ratings de posts de Ana
const anaRatings = posts
  .filter(p => p.author === 'Ana')  // [post1, post3]
  .map(p => p.rating)                // [5, 3]

console.log(anaRatings) // [5, 3]
```

## Ejemplo 2: Filter + Map + Reduce

```js
// Suma total de ratings >= 4
const totalGoodRatings = posts
  .filter(p => p.rating >= 4)        // posts con rating alto
  .map(p => p.rating)                // extraer solo los números
  .reduce((sum, r) => sum + r, 0)   // sumarlos

console.log(totalGoodRatings) // 14 (5 + 4 + 5)
```

## Ejemplo 3: Múltiples transformaciones

```js
const reviews = [
  { destination: 'parís', rating: 5, country: 'francia' },
  { destination: 'londres', rating: 3, country: 'uk' },
  { destination: 'roma', rating: 5, country: 'italia' }
]

// Destinos con rating 5, en mayúsculas, con emoji
const topDestinations = reviews
  .filter(r => r.rating === 5)
  .map(r => r.destination.toUpperCase())
  .map(d => `✈️ ${d}`)

console.log(topDestinations)
// ['✈️ PARÍS', '✈️ ROMA']
```

## Ejemplo 4: Some con otras operaciones

```js
// ¿Hay algún post de Ana con rating perfecto?
const anaPerfect = posts
  .filter(p => p.author === 'Ana')
  .some(p => p.rating === 5)

console.log(anaPerfect) // true
```

## Buenas prácticas

```js
// Legible - cada método en su línea
const result = posts
  .filter(p => p.rating >= 4)
  .map(p => p.title)

// Difícil de leer - todo en una línea
const result = posts.filter(p => p.rating >= 4).map(p => p.title)
```

**Consejo:** Si un chain se vuelve muy largo o confuso, está bien separarlo en pasos con variables temporales. La legibilidad es más importante.

## ¿Por qué aprender chaining?

Es un **patrón muy común** en JavaScript moderno. Lo verás en:
- Código profesional
- Frameworks como React, Vue
- Trabajo con APIs y datos

::

::card
# Destructuring de Objetos

Extrae propiedades de objetos de forma más limpia y concisa.

### La forma antigua
```js
const post = { id: 1, title: 'París', author: 'Ana' }

const title = post.title
const author = post.author
```

### Con destructuring
```js
const post = { id: 1, title: 'París', author: 'Ana' }

const { title, author } = post

console.log(title)  // 'París'
console.log(author) // 'Ana'
```

### Extraer múltiples propiedades
```js
const { id, title, author } = post
// Ahora tienes: id, title, author como variables
```

### Destructuring directo
```js
const posts = [
  { id: 1, title: 'París', author: 'Ana' }
]

const { title, author } = posts[0]
console.log(title) // 'París'
```

### Renombrar mientras destructuras
```js
const { title: postTitle, author: postAuthor } = post

console.log(postTitle)  // 'París'
console.log(postAuthor) // 'Ana'
```

### Destructuring en parámetros de función
Muy común en desarrollo moderno:

```js
// Sin destructuring
const printPost = (post) => {
  console.log(post.title + ' por ' + post.author)
}

// Con destructuring
const printPost = ({ title, author }) => {
  console.log(`${title} por ${author}`)
}

printPost(post) // 'París por Ana'
```

### Ejemplo práctico con múltiples funciones
```js
const posts = [
  { id: 1, title: 'París', author: 'Ana', rating: 5 },
  { id: 2, title: 'Londres', author: 'Carlos', rating: 4 }
]

// Función que formatea un post
const formatPost = ({ title, author, rating }) => {
  return `${title} por ${author} (${rating}★)`
}

posts.forEach(post => {
  console.log(formatPost(post))
})
// París por Ana (5★)
// Londres por Carlos (4★)
```

### Con template literals
```js
const showPost = ({ title, author }) => {
  return `
    <div>
      <h2>${title}</h2>
      <p>Por: ${author}</p>
    </div>
  `
}
```

### Características
- Código más limpio y legible
- Menos repetición de código
- Muy usado en funciones modernas
::

::card
# Destructuring de Arrays

Menos común que el destructuring de objetos, pero útil en ciertos casos.

### Sintaxis básica
```js
const numbers = [1, 2, 3, 4, 5]

const [first, second] = numbers

console.log(first)  // 1
console.log(second) // 2
```

### Saltar elementos
```js
const numbers = [1, 2, 3, 4, 5]

// Saltar el segundo elemento
const [first, , third] = numbers

console.log(first) // 1
console.log(third) // 3
```

### Rest operator (...)
Captura "el resto" de elementos:

```js
const numbers = [1, 2, 3, 4, 5]

const [first, ...rest] = numbers

console.log(first) // 1
console.log(rest)  // [2, 3, 4, 5]
```

### Otro ejemplo con rest
```js
const [first, second, ...others] = numbers

console.log(first)  // 1
console.log(second) // 2
console.log(others) // [3, 4, 5]
```

### Intercambiar valores
```js
let a = 1
let b = 2

[a, b] = [b, a]

console.log(a) // 2
console.log(b) // 1
```

### Caso de uso práctico
```js
const data = 'Ana,25,España'.split(',')
const [name, age, country] = data

console.log(name)    // 'Ana'
console.log(age)     // '25'
console.log(country) // 'España'
```

### Con funciones que retornan arrays
```js
const getCoordinates = () => [40.4168, -3.7038] // Madrid

const [lat, lng] = getCoordinates()
console.log(lat) // 40.4168
console.log(lng) // -3.7038
```

### Características
- Menos usado que destructuring de objetos
- Útil con `.split()`, coordenadas, tuplas
- El orden importa (no los nombres)
::

::card
# Práctica Guiada - Ejemplo 1

Tenemos un array de reseñas de viajes: 

```js
const reviews = [
  { id: 1, destination: 'Lyon', country: 'Francia', rating: 5 },
  { id: 2, destination: 'Barcelona', country: 'España', rating: 4 },
  { id: 3, destination: 'Napoles', country: 'Italia', rating: 5 },
  { id: 4, destination: 'Malaga', country: 'España', rating: 4 },
  { id: 5, destination: 'Manchester', country: 'UK', rating: 3 }
]
```

### Requerimientos

1. Filtrar solo las de España
```js
// Resultado:
[
  { id: 2, destination: 'Barcelona', country: 'España', rating: 4 },
  { id: 4, destination: 'Malaga', country: 'España', rating: 4 }
]
```

2. Obtener los nombres de los destinos
```js
// Resultado:
[ 'Barcelona', 'Malaga' ]
```
3. Mostrarlos en mayúsculas
```js
// Resultado:
[ 'BARCELONA', 'MALAGA' ]
```

<details>
<summary>Solución</summary>

**Paso 1: Filtrar por España**
```js
const spainReviews = reviews.filter(r => r.country === 'España')
// [{ id: 2, ...Barcelona... }, { id: 4, ...Malaga... }]
```

**Paso 2: Obtener solo los destinos**
```js
const destinations = spainReviews.map(r => r.destination)
// ['Barcelona', 'Malaga']
```

**Paso 3: Convertir a mayúsculas**
```js
const upperDestinations = destinations.map(d => d.toUpperCase())
// ['BARCELONA', 'MALAGA']
```

### Solución combinada (chaining)
```js
const result = reviews
  .filter(r => r.country === 'España')
  .map(r => r.destination)
  .map(d => d.toUpperCase())

console.log(result) // ['BARCELONA', 'MALAGA']
```

### Versión optimizada (un solo map)
```js
const result = reviews
  .filter(r => r.country === 'España')
  .map(r => r.destination.toUpperCase())

console.log(result) // ['BARCELONA', 'MALAGA']
```

</details>

::

::card
# Práctica Guiada - Ejemplo 2

Vamos a crear una función que busque y formatee información sobre las siguientes Reviews:

```js
const reviews = [
  { id: 1, destination: 'París', country: 'Francia', rating: 5, author: 'Ana' },
  { id: 2, destination: 'Barcelona', country: 'España', rating: 4, author: 'Carlos' },
  { id: 3, destination: 'Roma', country: 'Italia', rating: 5, author: 'Luis' }
]
```

### Requerimientos

1. Reciba un id de reseña
2. Busque la reseña
3. Retorne un mensaje formateado con destructuring y template literals

```js
// Ejemplo    -> getReviewMessage(1)
// Resultado  -> París (Francia) - 5★ por Ana
```


<details>
<summary>Solución</summary>

**Paso 1: Función básica**
```js
const getReviewMessage = (id) => {
  const review = reviews.find(r => r.id === id)

  if (!review) {
    return 'Reseña no encontrada'
  }

  return `${review.destination} (${review.country}) - ${review.rating}★ por ${review.author}`
}
```

**Paso 2: Con destructuring**
```js
const getReviewMessage = (id) => {
  const review = reviews.find(r => r.id === id)

  if (!review) {
    return 'Reseña no encontrada'
  }

  const { destination, country, rating, author } = review
  return `${destination} (${country}) - ${rating}★ por ${author}`
}
```

**Paso 3: Destructuring directo (versión final)**
```js
const getReviewMessage = (id) => {
  const review = reviews.find(r => r.id === id)

  if (!review) return 'Reseña no encontrada'

  const { destination, country, rating, author } = review
  return `${destination} (${country}) - ${rating}★ por ${author}`
}

// Probar
console.log(getReviewMessage(1))
// "París (Francia) - 5★ por Ana"

console.log(getReviewMessage(999))
// "Reseña no encontrada"


```
</details>

::

::card
# Cheat Sheet - Referencia Rápida

### Variables
```js
const name = 'Ana'      // No se puede reasignar (usa por defecto)
let counter = 0         // Se puede reasignar
```

### Funciones
```js
// Arrow function forma corta (más común)
const greet = name => `Hola ${name}`
const add = (a, b) => a + b
```

### Template Literals
```js
`${variable} texto ${expresión}`
```

### Destructuring
```js
// Objetos
const { title, author } = post

// Arrays
const [first, second] = array
const [first, ...rest] = array
```

### Métodos de Arrays

| Método | Retorna | Muta | Descripción |
|--------|---------|------|-------------|
| `.includes(valor)` | boolean | ❌ | Verifica si existe |
| `.find(fn)` | objeto o undefined | ❌ | Primer elemento que cumple |
| `.filter(fn)` | array | ❌ | Todos los que cumplen |
| `.map(fn)` | array | ❌ | Transforma cada elemento |
| `.some(fn)` | boolean | ❌ | ¿Alguno cumple? |
| `.every(fn)` | boolean | ❌ | ¿Todos cumplen? |
| `.reduce(fn, init)` | cualquier tipo | ❌ | Reduce a un valor |
| `.push(item)` | número | ✅ | Añade al final |
| `.pop()` | elemento | ✅ | Quita el último |

### Ejemplos Rápidos
```js
// Encontrar por ID
posts.find(p => p.id === 3)

// Filtrar por condición
posts.filter(p => p.rating >= 4)

// Extraer propiedades
posts.map(p => p.title)

// Verificar existencia
posts.some(p => p.rating === 5)

// Verificar todos
posts.every(p => p.rating >= 3)

// Sumar
numbers.reduce((sum, n) => sum + n, 0)
```

### Copias
```js
// Shallow copy
const copy = [...array]

// Deep copy
const deepCopy = structuredClone(array)
```

### Chaining
```js
array
  .filter(condición)
  .map(transformación)
  .reduce(acumulador, inicial)
```
::

::card
# Resumen

### Conceptos Clave

**Variables:**
- Usa `const` por defecto
- Solo usa `let` cuando necesites reasignar

**Funciones:**
- Arrow functions son el estándar moderno
- Forma corta: `param => expresión`

**Template Literals:**
- `` `${variable} texto` `` más fácil que concatenación

**Mutación:**
- Métodos que mutan: `.push()`, `.pop()`, `.splice()`
- Métodos inmutables: `.map()`, `.filter()`, `.find()`
- Prefiere inmutabilidad

**Array.prototype vs Array:**
- `.find()`, `.map()`, `.filter()` son métodos de instancia
- Se heredan automáticamente en todos los arrays

**Métodos Esenciales:**
- `.find()` → UN elemento
- `.filter()` → MÚLTIPLES elementos
- `.map()` → TRANSFORMAR datos
- `.some()` → ¿AL MENOS UNO?
- `.every()` → ¿TODOS?
- `.reduce()` → REDUCIR a un valor

**Destructuring:**
- Extrae propiedades de forma limpia
- Muy usado en parámetros de función

::
