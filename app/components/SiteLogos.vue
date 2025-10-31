<template>
  <hr>
  <div class="course-logos">
    <img src="/images/course/Cofinanciado_por_la_UE_1.webp" loading="lazy">
    <img src="/images/course/EOI_Ministerio_de_Industria_y_Turismo_1.webp" loading="lazy">
    <img src="/images/course/Logotipo_Fondos_Europeos_1.webp" loading="lazy">
    <img src="/images/course/Logotipo_Fondos_Europeos_2.webp" loading="lazy">
  </div>
</template>

<style scoped>
hr {
  margin-top: 2rem;
  border:0 none;
  height:1px;
  background-color: #CCC;
}
.course-logos {
  max-width: 70%;
  margin:2rem auto 0;
  display: flex;
  width: 100%;
  gap:3rem;
  padding:1rem;
  border-radius: 1rem;
  align-items: center;
  background-color: #FFF;
  opacity: 0.5;
  transition: ease opacity 300ms;
  &:hover {
    opacity: 1;
  }
  img {
    display: block;
    height:auto;
    object-fit:fill;
    width:100%;
  }
} 
</style>