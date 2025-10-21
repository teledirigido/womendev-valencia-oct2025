<template>
  <ContentRenderer v-if="data" :value="data" :key="contentKey" />
  <div v-else>Lesson not found</div>
</template>

<script setup>

const route = useRoute();
const { slug } = route.params;

definePageMeta({
  layout: 'lesson'
})

const { data } = await useAsyncData(() =>
  queryCollection('content').path(`/lessons/${slug}`).first()
)

const resetCards = inject('resetCards', () => {})
const contentKey = ref(0)

watch(data, () => {
  resetCards()
  contentKey.value++
}, { deep: true })
</script>