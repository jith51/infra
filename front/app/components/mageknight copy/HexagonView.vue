<template>
  <polygon
    :points="points"
    :fill="isPlayerHere ? '#4169e1' : terrainColor"
    stroke="black"
    stroke-width="1"
    class="hexagon"
    @click="emit('click')"
  />

  <!-- Coordonnées temporaires pour debug -->
  <text
    :x="x"
    :y="y + 4"
    text-anchor="middle"
    fill="black"
    font-size="10"
    pointer-events="none"
  >
    {{ q }},{{ r }}
  </text>
</template>

<script setup lang="ts">
import { computed } from 'vue'

import type { Terrain } from './game'

interface Props {
  x: number
  y: number
  size: number

  terrain: Terrain

  q: number
  r: number

  isPlayerHere?: boolean
}

const props = withDefaults(
  defineProps<Props>(),
  {
    isPlayerHere: false,
  },
)

const emit = defineEmits<{
  click: []
}>()

/**
 * Couleur d'affichage du terrain.
 *
 * Ces couleurs sont uniquement provisoires.
 * Plus tard on pourra utiliser des images
 * ou des textures pour les terrains.
 */
const terrainColor =
  computed(() => {
    switch (props.terrain) {
      case 'plains':
        return '#f0e68c'

      case 'forest':
        return '#228b22'

      case 'hills':
        return '#d2b48c'

      case 'mountain':
        return '#808080'

      case 'desert':
        return '#edc967'

      case 'swamp':
        return '#556b2f'

      case 'wasteland':
        return '#696969'

      case 'water':
        return '#4682b4'

      default:
        return '#f0e68c'
    }
  })

/**
 * Sommets du polygone SVG.
 *
 * On utilise des hexagones à pointe vers le haut.
 */
const points = computed(() => {
  const angle =
    Math.PI / 3

  return Array.from(
    { length: 6 },
    (_, index) => {
      const currentAngle =
        index * angle -
        Math.PI / 2

      const px =
        props.x +
        props.size *
          Math.cos(currentAngle)

      const py =
        props.y +
        props.size *
          Math.sin(currentAngle)

      return `${px},${py}`
    },
  ).join(' ')
})
</script>

<style scoped>
.hexagon {
  cursor: pointer;
}

.hexagon:hover {
  opacity: 0.8;
}
</style>