<template>
  <main class="lesson-wrapper">
    <slot />
    <div class="lesson-footer">
      <div class="slides">
        {{ currentIndex + 1 }} / {{ cardCounter }}
      </div>
      <div class="navigation">
        <button class="nav" @click="previous" :disabled="!hasPrevious">⬅️</button>
        <NuxtLink :to="home" >🏠</NuxtLink>
        <button class="nav" @click="next" :disabled="!hasNext">➡️</button>
      </div>
    </div>
  </main>
</template>

<script setup>
const { init, next, previous, home, hasNext, hasPrevious, currentIndex } = useCards()

const cardCounter = ref(0)

const resetCards = () => {
  cardCounter.value = 0
  // Don't reset currentIndex - preserve which card user is viewing
}

provide('currentCardIndex', currentIndex)
provide('resetCards', resetCards)
provide('registerCard', () => {
  const index = cardCounter.value++
  return index
})

const route = useRoute()
watch(() => route.path, () => {
  resetCards()
  nextTick(() => init())
})

onMounted(() => {
  nextTick(() => init())
})
</script>

<style src="~/assets/lesson.css"></style>