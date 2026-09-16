<template>
  <g>
    <Hexagon
      v-for="(hexagon, index) in hexagons"
      :key="index"
      :x="hexagon.x"
      :y="hexagon.y"
      :size="hexagon.size"
      :color="hexagon.color"
      :isPlayerHere="playerHexagon === index"
      @click="$emit('hexagon-click', index)"
    />
  </g>
</template>

<script setup>
import { computed } from 'vue';
import Hexagon from './Hexagon.vue';

const props = defineProps({
  x: { type: Number, default: 300 }, // Coordonnée X du centre de la tuile
  y: { type: Number, default: 250 }, // Coordonnée Y du centre de la tuile
  size: { type: Number, default: 30 }, // Rayon des hexagones
  playerHexagon: { type: Number, default: -1 }, // Index de l'hexagone où se trouve le joueur
});

const emit = defineEmits(['hexagon-click']);

// Taille des hexagones
const hexSize = props.size;

// Distance entre le centre et les hexagones extérieurs (égale à la taille d'un hexagone)
const offset = hexSize * Math.sqrt(3); // Distance entre deux hexagones adjacents

// Couleurs pour les hexagones
const colors = [
  '#f0e68c', // Centre (jaune clair)
  '#90EE90', // Haut
  '#FFD700', // Haut-droit
  '#FF8C00', // Bas-droit
  '#87CEEB', // Bas
  '#DDA0DD', // Bas-gauche
  '#98FB98', // Haut-gauche
];

const hexagons = computed(() => [
  { x: props.x, y: props.y, size: hexSize, color: colors[0] }, // Centre
  { x: props.x, y: props.y - offset, size: hexSize, color: colors[1] }, // Haut
  { x: props.x + offset * Math.cos(Math.PI / 6), y: props.y - offset * Math.sin(Math.PI / 6), size: hexSize, color: colors[2] }, // Haut-droit
  { x: props.x + offset * Math.cos(Math.PI / 6), y: props.y + offset * Math.sin(Math.PI / 6), size: hexSize, color: colors[3] }, // Bas-droit
  { x: props.x, y: props.y + offset, size: hexSize, color: colors[4] }, // Bas
  { x: props.x - offset * Math.cos(Math.PI / 6), y: props.y + offset * Math.sin(Math.PI / 6), size: hexSize, color: colors[5] }, // Bas-gauche
  { x: props.x - offset * Math.cos(Math.PI / 6), y: props.y - offset * Math.sin(Math.PI / 6), size: hexSize, color: colors[6] }, // Haut-gauche
]);
</script>