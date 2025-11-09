<template>
  <section class="course-container">
    <div class="course-container--item" v-for="item in course">
      <span class="course-container--title">{{ item.title }}</span>
      <ul>
        <li v-for="lesson in item.lessons" :class="['item', getLessonClass(lesson.type)]">
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
const getLessonClass = (type) => {
  if (!type) return 'item-lesson';
  
  return 'item-' + type
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '');
};

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
        link: '/lessons/intro-handlebars',
        title: 'Express & Handlebars'
      },
      {
        type: 'Ayuda',
        link: '/lessons/errores-comunes-handlebars-express',
        title: 'Errores comunes on Handlebars & Express'
      }
    ]
  },
  {
    title: 'Día 4',
    lessons: [
      {
        title: 'LowDB - Create & Read',
        link: '/lessons/intro-lowdb'
      },
      {
        title: 'LowDB - Update',
        link: '/lessons/intro-lowdb-update'
      },
      {
        title: 'LowDB - Delete',
        link: '/lessons/intro-lowdb-delete'
      },
      {
        type: 'Ayuda',
        title: 'Errores Comunes on LowDB',
        link: '/lessons/errores-comunes-lowdb'
      }
    ]
  },
  {
    title: 'Dìa 5',
    lessons: [
      {
        title: 'CSS Frameworks and Methodologies',
        link: '/lessons/css-frameworks-and-methodologies'
      },
      {
        title: 'Express & Cloudinary',
        link: '/lessons/express-cloudinary'
      },
      {
        title: 'Estructura de un proyecto en Express',
        link: '/lessons/express-project-structure'
      }
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
  .item-ayuda {
    .type {
      color:#999;
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