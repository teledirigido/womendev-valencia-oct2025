<template>
  <section class="course-container">
    <div class="course-container--item" v-for="item in course">
      <span class="course-container--title">{{ item.title }}</span>
      <ul>
        <li v-for="lesson in item.lessons" :class="`item ${lesson.type ? `item-practica` : 'item-lesson'}`">
          <NuxtLink :to="lesson.link">
            <span class="type">{{lesson.type ?? 'Lección'}}</span>
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
    title: 'Día 1',
    lessons: [
      {
        link: '/lessons/intro-node',
        title: 'Introducción a Node.js'
      }
    ]
  },
  {
    title: 'Día 2',
    lessons: [
      {
        link: '/lessons/intro-express',
        title: 'Introducción a Express'
      },
      {
        type: 'Práctica',
        link: '/lessons/practice-express-first-app',
        title: 'Práctica: Nuestra primera app en Express'
      }
    ]
  },
  {
    title: 'Día 3',
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
    title: 'Día 4',
    lessons: [
      {
        link: '/lessons/middlewares-error-handling',
        title: 'Middlewares & Error Handling'
      },
      {
        type: 'Práctica',
        link: '/lessons/practice-basic-routing',
        title: 'Práctica: CRUD API Completa'
      },
    ]
  },
  {
    title: 'Día 5',
    lessons: [
      {
        link: '/lessons/mongodb-mongoose',
        title: 'Express, MongoDB & Mongoose'
      },
      {
        type: 'Práctica',
        link: '/lessons/practice-mini-project-2',
        title: 'Práctica: Express, MongoDB & Mongoose'
      },
    ]
  },
  {
    title: 'Día 6',
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
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 2rem;
  row-gap: 5rem;

  .course-container--title {
    font-size:1.2rem;
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
      border: 1px solid #273E4750;
      background-color:#FFF;
      line-height: 145%;
      display: block;
      padding: 1.5rem;
      text-decoration: none;
      color: inherit;
      font-family: 1rem;
      border-radius: 0.5rem;
      transition: ease all 200ms;
      top:0;
      position: relative;
      &:hover {
        box-shadow: 0 10px 20px #DDD;
        top: -2px;
      }
    }

    .type {
      display: block;
      font-size: 0.8rem;
      text-transform: uppercase;
      font-weight: bold;
    }
  }
  .item-practica {
    .type {
      color: #BD632F;
    }
  }
  .item-lesson {
    .type {
      color: #4459a3;
    }
  }
}
@media all and (max-width: 960px) {
  .course-container {
    padding:1.5rem;
    grid-template-columns: repeat(2, 1fr);
  }
}
@media all and (max-width: 650px) {
  .course-container {
    grid-template-columns: repeat(1, 1fr);
  }
}
</style>