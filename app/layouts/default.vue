<template>
  <main>
    <SiteHeader />
    <SiteNav />
    <slot />
  </main>
</template>

<style>
  main {
    max-width: 950px; 
    margin:0 auto;
  }
</style>