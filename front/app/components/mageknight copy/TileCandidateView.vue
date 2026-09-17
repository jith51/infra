<template>
  <g
    class="tile-candidate"
    @click="emit('select')"
  >
    <TileView
      :tile="tile"
      :hex-size="hexSize"
      :origin-x="originX"
      :origin-y="originY"
    />
  </g>
</template>

<script setup lang="ts">
import TileView from './TileView.vue'

import type { Tile } from './game/tile'

interface Props {
  tile: Tile

  hexSize: number

  originX: number

  originY: number
}

defineProps<Props>()

const emit = defineEmits<{
  select: []
}>()
</script>

<style scoped>
.tile-candidate {
  opacity: 0.45;
  cursor: pointer;

  transition:
    opacity 150ms ease,
    filter 150ms ease;
}

.tile-candidate:hover {
  opacity: 0.8;
  filter: brightness(1.15);
}
</style>