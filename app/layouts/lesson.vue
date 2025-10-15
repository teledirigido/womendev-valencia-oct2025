<template>
  <main class="lesson-wrapper">
    <slot />
    <div class="lesson-footer">
      <div class="slides">
        {{ currentIndex + 1 }} / {{ cardCounter }}
      </div>
      <div class="navigation">
        <button @click="previous" :disabled="!hasPrevious">Previous</button>
        <button @click="next" :disabled="!hasNext">Next</button>
      </div>
    </div>
  </main>
</template>

<script setup>
const { init, next, previous, hasNext, hasPrevious, currentIndex } = useCards()

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