export const useCards = () => {
  const route = useRoute()
  const router = useRouter()
  const currentIndex = ref(0)
  const totalCards = ref(0)
  let keydownHandler: ((e: KeyboardEvent) => void) | null = null

  const init = () => {
    const cards = document.querySelectorAll('.card')
    totalCards.value = cards.length

    // Check if there's a hash in the URL
    if (route.hash) {
      const match = route.hash.match(/card-(\d+)/)
      if (match && match[1]) {
        const index = parseInt(match[1]) - 1
        if (index >= 0 && index < totalCards.value) {
          currentIndex.value = index
        }
      }
    }
  }

  const updateHash = (index: number) => {
    router.replace({ hash: `#card-${index + 1}` })
  }

  // Watch currentIndex and update hash
  watch(currentIndex, (newIndex) => {
    updateHash(newIndex)
  })

  const setupKeyboardNavigation = () => {
    // Remove existing listener if any
    if (keydownHandler) {
      window.removeEventListener('keydown', keydownHandler)
    }

    keydownHandler = (e: KeyboardEvent) => {
      if (e.key === 'ArrowRight') {
        next()
      } else if (e.key === 'ArrowLeft') {
        previous()
      }
    }

    window.addEventListener('keydown', keydownHandler)

    // Cleanup function
    onUnmounted(() => {
      if (keydownHandler) {
        window.removeEventListener('keydown', keydownHandler)
      }
    })
  }

  // Call this once
  setupKeyboardNavigation()

  const next = () => {
    if (currentIndex.value < totalCards.value - 1) {
      currentIndex.value++
    }
  }

  const previous = () => {
    if (currentIndex.value > 0) {
      currentIndex.value--
    }
  }

  const hasNext = computed(() => currentIndex.value < totalCards.value - 1)
  const hasPrevious = computed(() => currentIndex.value > 0)

  return {
    init,
    next,
    previous,
    hasNext,
    hasPrevious,
    currentIndex
  }
}
