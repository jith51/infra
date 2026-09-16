<template>
  <g>
    <HexagonView
      v-for="hexagon in hexagons"
      :key="`${hexagon.q}:${hexagon.r}`"
      :x="hexagon.x"
      :y="hexagon.y"
      :q="hexagon.q"
      :r="hexagon.r"
      :size="hexSize"
      :terrain="hexagon.terrain"
      :is-player-here="
        hexagon.q === playerQ &&
        hexagon.r === playerR
      "
      @click="
        emit(
          'hexagon-click',
          hexagon.q,
          hexagon.r,
        )
      "
    />
  </g>
</template>

<script setup lang="ts">
import { computed } from 'vue'

import HexagonView from './HexagonView.vue'

import {
  TILE_SPACING,
  type Tile,
} from './game'

interface Props {
  tile: Tile

  hexSize: number

  originX: number
  originY: number

  playerQ: number
  playerR: number
}

const props =
  defineProps<Props>()

const emit = defineEmits<{
  hexagonClick: [
    q: number,
    r: number,
  ]
}>()

/**
 * Conversion coordonnées hexagonales
 * -> coordonnées SVG.
 */
function hexToPixel(
  q: number,
  r: number,
) {
  return {
    x:
      props.originX +
      props.hexSize *
        Math.sqrt(3) *
        (q + r / 2),

    y:
      props.originY +
      props.hexSize *
        (3 / 2) *
        r,
  }
}

/**
 * Conversion de la position d'une tuile
 * vers la position globale de son centre.
 */
function tileToGlobalPosition(
  q: number,
  r: number,
) {
  return {
    q: q * TILE_SPACING,
    r: r * TILE_SPACING,
  }
}

/**
 * Préparation des 7 hexagones.
 */
const hexagons = computed(
  () => {
    const tilePosition =
      tileToGlobalPosition(
        props.tile.q,
        props.tile.r,
      )

    return props.tile.hexagons.map(
      (hexagon) => {
        /**
         * Position globale.
         */
        const q =
          tilePosition.q +
          hexagon.localQ

        const r =
          tilePosition.r +
          hexagon.localR

        /**
         * Position SVG.
         */
        const position =
          hexToPixel(q, r)

        return {
          ...hexagon,

          q,
          r,

          x: position.x,
          y: position.y,
        }
      },
    )
  },
)
</script>