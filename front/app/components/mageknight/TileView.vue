<template>
  <g>
    <HexagonView
      v-for="hexagon in hexagons"
      :key="hexagon.index"
      :x="hexagon.x"
      :y="hexagon.y"
      :q="hexagon.q"
      :r="hexagon.r"
      :size="hexSize"
      :terrain="hexagon.terrain"
      @click="
        emit(
          'hexagon-click',
          hexagon.index,
        )
      "
    />
  </g>
</template>

<script setup lang="ts">
import { computed } from 'vue'

import HexagonView from './HexagonView.vue'

import {
  getTileHexagonPosition,
  type Tile,
} from './game'

interface Props {
  tile: Tile

  hexSize: number

  originX: number

  originY: number
}

const props =
  defineProps<Props>()

const emit = defineEmits<{
  hexagonClick: [
    hexagonIndex: number,
  ]
}>()

/**
 * ============================================================
 * COORDONNEES HEXAGONALES -> SVG
 * ============================================================
 *
 * Conversion pour des hexagones "pointy top".
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
 * ============================================================
 * HEXAGONES
 * ============================================================
 *
 * On récupère les coordonnées globales de chaque
 * hexagone via getTileHexagonPosition().
 *
 * Cette fonction tient déjà compte de la rotation
 * de la tuile.
 */
const hexagons = computed(
  () =>
    props.tile.hexagons.map(
      (hexagon) => {
        const position =
          getTileHexagonPosition(
            props.tile,
            hexagon,
          )

        const pixel =
          hexToPixel(
            position.q,
            position.r,
          )

        return {
          ...hexagon,

          q:
            position.q,

          r:
            position.r,

          x:
            pixel.x,

          y:
            pixel.y,
        }
      },
    ),
)
</script>