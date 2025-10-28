<template>
  <nav class="nav-lessons">
    <div>
      <ul>
        <li v-for="(item, index) in lessons">
          <NuxtLink :to="item.link">
            <span>Day {{index+1}}</span>
            {{item.title}}
          </NuxtLink>
        </li>
      </ul>
    </div>
  </nav>
</template>

<script setup>
const lessons = [
  {
    link: '/lessons/intro-node',
    title: 'Introducción a Node.js'
  },
  {
    link: '/lessons/intro-express',
    title: 'Introducción a Express'
  },
  {
    link: '/lessons/practice-express-first-app',
    title: 'Práctica: Nuestra primera app en Express'
  },
  {
    link: '/lessons/express-rest-api',
    title: 'Express & REST API'
  },
  {
    link: '/lessons/params-query-postman',
    title: 'Route Params, Query & Postman'
  },
  {
    link: '/lessons/middlewares-error-handling',
    title: 'Middlewares & Error Handling'
  },
  {
    link: '/lessons/practice-basic-routing',
    title: 'Práctica: CRUD API Completa'
  },
  {
    link: '/lessons/mongodb-mongoose',
    title: 'Express, MongoDB & Mongoose'
  },
  {
    link: '/lessons/practice-mini-project',
    title: 'Review & Práctica: Express, MongoDB & Mongoose'
  },
  {
    link: '/lessons/practice-mini-project-2',
    title: 'Práctica: Express, MongoDB & Mongoose'
  }
]
</script>

<style>
.nav-lessons {
  ul {
    list-style: none;
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 1rem;
    padding-left: 0;
  }

  li {
    a {
      border: 1px solid #CCC;
      line-height: 145%;
      display: block;
      padding: 2rem;
      text-decoration: none;
      color: inherit;
      font-family: 1rem;
      border-radius: 0.5rem;
      min-height: 100px;
      transition: ease background-color 200ms;

      &:hover {
        background-color: #fff;
      }
    }

    span {
      display: block;
      padding-bottom: 1rem;
      font-size: 1rem;
      opacity: 0.5;
      text-transform: uppercase;
      font-weight: bold;
    }
  }
}
</style>