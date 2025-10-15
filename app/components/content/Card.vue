<script setup>
const currentIndex = inject('currentCardIndex', ref(0))
const registerCard = inject('registerCard', () => 0)
const cardIndex = registerCard()

const isVisible = computed(() => currentIndex.value === cardIndex)
</script>

<template>
  <section class="card" v-show="isVisible" :id="`card-${cardIndex + 1}`">
    <slot />
  </section>
</template>