<template>
  <section class="course-container">
    <div class="course-container--item" v-for="item in course">
      <span class="course-container--title">{{ item.title }}</span>
      <ul>
        <li v-for="lesson in item.lessons">
          <NuxtLink :to="lesson.link">
            {{ lesson.title }}
          </NuxtLink>
        </li>
      </ul>
    </div>

  </section>
</template>

<script setup>
const course = [
  {
    title: 'Day 1',
    lessons: [
      {
        link: '/lessons/intro-node',
        title: 'Introducción a Node.js'
      }
    ]
  },
  {
    title: 'Day 2',
    lessons: [
      {
        link: '/lessons/intro-express',
        title: 'Introducción a Express'
      },
      {
        link: '/lessons/practice-express-first-app',
        title: 'Práctica: Nuestra primera app en Express'
      }
    ]
  },
  {
    title: 'Day 3',
    lessons: [
      {
        link: '/lessons/express-rest-api',
        title: 'Express & REST API'
      },
      {
        link: '/lessons/params-query-postman',
        title: 'Route Params, Query & Postman'
      },
    ]
  },
  {
    title: 'Day 4',
    lessons: [
      {
        link: '/lessons/middlewares-error-handling',
        title: 'Middlewares & Error Handling'
      },
      {
        link: '/lessons/practice-basic-routing',
        title: 'Práctica: CRUD API Completa'
      },
    ]
  },
  {
    title: 'Day 5',
    lessons: [
      {
        link: '/lessons/mongodb-mongoose',
        title: 'Express, MongoDB & Mongoose'
      },
      {
        link: '/lessons/practice-mini-project-2',
        title: 'Práctica: Express, MongoDB & Mongoose'
      },
    ]
  },
  {
    title: 'Day 6',
    lessons: [
      {
        link: '/lessons/practice-mini-project',
        title: 'Review & Práctica: Express, MongoDB & Mongoose'
      },
    ]
  }
]
</script>

<style>
.course-container {
  padding: 2rem;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 2rem;
  row-gap: 5rem;

  .course-container--title {
    font-weight: bold;
    text-transform: uppercase;
    color: #666;
  }

  ul {
    list-style: none;
    padding-left: 0;
    display: flex;
    flex-direction: column;
    gap: 1rem;
  }

  li {
    a {
      border: 1px solid #CCC;
      line-height: 145%;
      display: block;
      padding: 1.5rem;
      text-decoration: none;
      color: inherit;
      font-family: 1rem;
      border-radius: 0.5rem;
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
@media all and (max-width: 850px) {
  .course-container {
    grid-template-columns: repeat(2, 1fr);
  }
}
@media all and (max-width: 650px) {
  .course-container {
    grid-template-columns: repeat(1, 1fr);
  }
}
</style>