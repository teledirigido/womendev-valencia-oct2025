<template>
  <ContentRenderer v-if="data" :value="data" :key="contentKey" />
  <div v-else>Lesson not found</div>
</template>

<script setup>
definePageMeta({
  layout: 'lesson'
})

const { data } = await useAsyncData(() =>
  queryCollection('content').path('/lessons/middlewares-params-query').first()
)

const resetCards = inject('resetCards', () => {})
const contentKey = ref(0)

watch(data, () => {
  resetCards()
  contentKey.value++
}, { deep: true })
</script>
