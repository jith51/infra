<template>
  <g
    class="tile-preview"
    :class="`level-${tile.level}`"
    @click="handleClick"
  >

    <polygon
      v-for="hexagon in hexagons"
      :key="`${hexagon.q}:${hexagon.r}`"
      :points="hexagon.points"
    />

  </g>
</template>

<script setup lang="ts">

import {
  computed,
} from 'vue'

import type {
  HexPosition,
} from './game/hexagon'

import {
  getTileHexagonPosition,
  type TilePlacement,
} from './game/placement'

import type {
  Tile,
} from './game/tile'

/**
 * ============================================================
 * PROPS
 * ============================================================
 */

interface Props {
  /**
   * Définition statique de la tuile.
   */
  tile: Tile

  /**
   * Position + orientation du preview.
   */
  placement: TilePlacement

  hexSize: number

  originX: number

  originY: number
}

const props =
  defineProps<Props>()

/**
 * ============================================================
 * EVENTS
 * ============================================================
 */

const emit =
  defineEmits<{
    select: []
  }>()

function handleClick(): void {
  emit('select')
}

/**
 * ============================================================
 * HEX → SVG
 * ============================================================
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
        (
          q +
          r / 2
        ),

    y:
      props.originY +
      props.hexSize *
        (3 / 2) *
        r,
  }
}

/**
 * ============================================================
 * POLYGONE HEXAGONE
 * ============================================================
 */

function getHexagonPoints(
  x: number,
  y: number,
): string {

  const points: string[] = []

  for (
    let i = 0;
    i < 6;
    i++
  ) {

    const angle =
      (
        Math.PI / 180
      ) *
      (
        60 * i - 30
      )

    points.push(
      `${
        x +
        props.hexSize *
          Math.cos(angle)
      },${
        y +
        props.hexSize *
          Math.sin(angle)
      }`,
    )
  }

  return points.join(' ')
}

/**
 * ============================================================
 * HEXAGONES DU PREVIEW
 * ============================================================
 */

/**
 * Les 7 hexagones de la vraie tuile,
 * positionnés selon le TilePlacement.
 */
const hexagons =
  computed(() => {

    return props.tile.hexagons.map(
      (hexagon) => {

        /**
         * Position globale dans le Board.
         *
         * C'est ici que l'orientation
         * de la tuile est prise en compte.
         */
        const position =
          getTileHexagonPosition(
            props.tile,
            hexagon,
            props.placement,
          )

        const pixel =
          hexToPixel(
            position.q,
            position.r,
          )

        return {
          q:
            position.q,

          r:
            position.r,

          points:
            getHexagonPoints(
              pixel.x,
              pixel.y,
            ),
        }
      },
    )
  })

</script>

<style scoped>

.tile-preview {
  pointer-events: all;
  cursor: pointer;

  opacity: 0.35;
}

.tile-preview polygon {
  fill: white;
  fill-opacity: 0.15;

  stroke: white;
  stroke-width: 2;
  stroke-dasharray: 5 5;

  transition:
    stroke-width 0.15s ease,
    fill-opacity 0.15s ease,
    filter 0.15s ease;
}

/**
 * Lorsque la souris est sur n'importe quel
 * hexagone du preview, toute la tuile
 * est mise en évidence.
 */
.tile-preview:hover {
  opacity: 0.8;
}

.tile-preview:hover polygon {
  fill-opacity: 0.25;

  stroke: white;
  stroke-width: 3;

  filter:
    drop-shadow(0 0 3px white)
    drop-shadow(0 0 6px white);
}

/**
 * Opacité selon le niveau de la tuile.
 */
.level-1 {
  opacity: 0.45;
}

.level-2 {
  opacity: 0.30;
}

.level-3 {
  opacity: 0.20;
}

</style>