<template>
  <polygon
    :points="points"
    @click="$emit('click')"
    :fill="isPlayerHere ? 'blue' : color"
    stroke="black"
    stroke-width="1"
  />
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
  x: { type: Number, required: true }, // Coordonnée X du centre
  y: { type: Number, required: true }, // Coordonnée Y du centre
  size: { type: Number, default: 30 }, // Rayon de l'hexagone (distance centre → sommet)
  color: { type: String, default: '#f0e68c' }, // Couleur de remplissage (ex: "#f0e68c" pour un jaune clair)
  isPlayerHere: { type: Boolean, default: false }, // Si le joueur est ici
});

const emit = defineEmits(['click']);

const points = computed(() => {
  const angle = (2 * Math.PI) / 6; // 60° en radians
  return Array.from({ length: 6 }, (_, i) => {
    const px = props.x + props.size * Math.cos(i * angle);
    const py = props.y + props.size * Math.sin(i * angle);
    return `${px},${py}`;
  }).join(' ');
});
</script>