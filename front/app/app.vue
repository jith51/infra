<template>
  <div class="bg-slate-100 h-screen overflow-hidden flex flex-col ">
    <NuxtLayout>
      <NuxtPage />
      <Toaster />
    </NuxtLayout>
  </div>
</template>

<script setup lang="ts">
  import { Toaster } from '@/components/ui/sonner'
</script>