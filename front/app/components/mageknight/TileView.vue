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
      @click="
        handleHexagonClick(
          hexagon.index,
        )
      "
    />

  </g>
</template>

<script setup lang="ts">

import {
  computed,
} from 'vue'

import HexagonView from './HexagonView.vue'

import type {
  Tile,
} from './game/tile'

import type {
  HexPosition,
} from './game/hexagon'

/**
 * ============================================================
 * PROPS
 * ============================================================
 */

interface Props {

  /**
   * Définition de la tuile.
   */
  tile: Tile

  /**
   * Position du centre de la tuile
   * sur le Board.
   */
  position: HexPosition

  /**
   * Taille d'un hexagone.
   */
  hexSize: number

  /**
   * Origine SVG.
   */
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
    (
      event: 'hexagon-click',
      tileId: string,
      hexagonIndex: number,
    ): void
  }>()

/**
 * ============================================================
 * HEXAGONALE → SVG
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
 * HEXAGONES
 * ============================================================
 */

const hexagons =
  computed(() => {

    return props.tile.hexagons.map(
      (hexagon) => {

        /**
         * Position globale de l'hexagone.
         *
         * La tuile est simplement translatée
         * par rapport à son centre.
         */
        const position:
          HexPosition = {

          q:
            props.position.q +
            hexagon.localQ,

          r:
            props.position.r +
            hexagon.localR,
        }

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
    )
  })

/**
 * ============================================================
 * CLIC HEXAGONE
 * ============================================================
 */

function handleHexagonClick(
  hexagonIndex: number,
): void {

  emit(
    'hexagon-click',

    props.tile.id,

    hexagonIndex,
  )
}

</script>