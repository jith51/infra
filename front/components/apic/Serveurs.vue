<script setup lang="ts">
    type Serveur = {
        name: string
        powerstate: string
    }
  const props = defineProps({
    serveurs: Array<Serveur>
  });
</script>

<template>
    <li class="pl-4" v-for="(serveur, s) in props.serveurs" :key="s" :class="[serveur['powerstate'] == '0' ? 'text-red-300' : '']">
        {{ serveur["name"] }}
    </li>
</template>
