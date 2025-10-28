<template>
  <NuxtLink
    :href="href"
    :target="computedTarget"
  >
    <slot />
  </NuxtLink>
</template>

<script setup lang="ts">

const props = defineProps({
  href: {
    type: String,
    default: ''
  },
  target: {
    type: String as PropType<'_blank' | '_parent' | '_self' | '_top' | (string & object) | undefined>,
    default: '_blank',
    required: false
  }
})

const computedTarget = computed(() => {
  if (props.href?.startsWith('http://') || props.href?.startsWith('https://')) {
    return '_blank'
  }
  return undefined
})

</script>