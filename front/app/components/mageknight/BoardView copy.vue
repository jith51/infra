<template>
  <div class="board-container">
    <h1>Mage Knight</h1>

    <svg
      :width="width"
      :height="height"
      class="board"
      viewBox="0 0 1000 800"
    >
      <!-- Fond -->
      <rect
        width="1000"
        height="800"
        class="board-background"
      />

      <!-- ================================================= -->
      <!-- TUILES -->
      <!-- ================================================= -->

      <g
        v-for="tile in tiles"
        :key="tile.id"
      >
        <!-- Les 7 hexagones de la tuile -->
        <g
          v-for="hexagon in tile.hexagons"
          :key="`${tile.id}-${hexagon.index}`"
        >
          <!-- Hexagone -->
          <polygon
            :points="
              getHexagonPoints(
                getHexagonScreenPosition(
                  tile,
                  hexagon,
                ),
              )
            "
            :fill="getTerrainColor(hexagon.terrain)"
            class="hexagon"
            @click="handleHexagonClick(tile, hexagon.index)"
          />

          <!-- Numéro de l'hexagone -->
          <text
            :x="
              getHexagonScreenPosition(
                tile,
                hexagon,
              ).x
            "
            :y="
              getHexagonScreenPosition(
                tile,
                hexagon,
              ).y
            "
            class="hexagon-number"
          >
            {{ hexagon.index }}
          </text>
        </g>

        <!-- Nom de la tuile -->
        <text
          :x="getTileCenter(tile).x"
          :y="getTileCenter(tile).y - 75"
          class="tile-name"
        >
          {{ getTileName(tile.id) }}
        </text>

        <!-- Rotation -->
        <text
          :x="getTileCenter(tile).x"
          :y="getTileCenter(tile).y + 75"
          class="tile-info"
        >
          rotation: {{ tile.rotation * 60 }}°
        </text>
      </g>

      <!-- ================================================= -->
      <!-- CENTRE DU REPERE -->
      <!-- ================================================= -->

      <circle
        :cx="centerX"
        :cy="centerY"
        r="4"
        class="origin"
      />
    </svg>

    <!-- =================================================== -->
    <!-- DEBUG -->
    <!-- =================================================== -->

    <div class="debug">
      <h2>Tuiles de départ</h2>

      <div
        v-for="tile in tiles"
        :key="`debug-${tile.id}`"
        class="debug-tile"
      >
        <strong>
          {{ getTileName(tile.id) }}
        </strong>

        <span>
          position :
          q={{ tile.position.q }},
          r={{ tile.position.r }}
        </span>

        <span>
          rotation :
          {{ tile.rotation * 60 }}°
        </span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import {
  computed,
} from 'vue'

import {
  createInitialBoard,
  getTiles,
  type Board,
} from './game/board'

import {
  getTileHexagonPosition,
  type Tile,
} from './game/tile'

/**
 * ========================================================
 * CONFIGURATION VISUELLE
 * ========================================================
 */

const width = 1000
const height = 800

const centerX = width / 2
const centerY = height / 2

/**
 * Taille d'un hexagone.
 *
 * C'est le rayon :
 *
 * centre → sommet
 */
const HEX_SIZE = 32

/**
 * ========================================================
 * BOARD
 * ========================================================
 */

const board: Board =
  createInitialBoard()

const tiles = computed(
  () => getTiles(board),
)

/**
 * ========================================================
 * COORDONNEES AXIALES → SVG
 * ========================================================
 *
 * Nous utilisons ici les mêmes coordonnées
 * axiales que le moteur du jeu.
 *
 * Pour un hexagone "pointy top" :
 *
 * x = sqrt(3) * (q + r / 2)
 * y = 3/2 * r
 */
function hexToScreen(
  q: number,
  r: number,
) {
  return {
    x:
      centerX +
      HEX_SIZE *
        Math.sqrt(3) *
        (q + r / 2),

    y:
      centerY +
      HEX_SIZE *
        1.5 *
        r,
  }
}

/**
 * ========================================================
 * POSITION D'UN HEXAGONE
 * ========================================================
 */

function getHexagonScreenPosition(
  tile: Tile,
  hexagon: Tile['hexagons'][number],
) {
  const position =
    getTileHexagonPosition(
      tile,
      hexagon,
    )

  return hexToScreen(
    position.q,
    position.r,
  )
}

/**
 * ========================================================
 * CENTRE D'UNE TUILE
 * ========================================================
 */

function getTileCenter(
  tile: Tile,
) {
  return hexToScreen(
    tile.position.q,
    tile.position.r,
  )
}

/**
 * ========================================================
 * POLYGONE HEXAGONE
 * ========================================================
 */

function getHexagonPoints(
  center: {
    x: number
    y: number
  },
): string {
  return Array
    .from(
      { length: 6 },
      (_, index) => {
        /**
         * Hexagone pointy-top.
         *
         * Le premier sommet est à -30°.
         */
        const angle =
          (
            Math.PI / 180
          ) *
          (
            60 * index -
            30
          )

        const x =
          center.x +
          HEX_SIZE *
          Math.cos(angle)

        const y =
          center.y +
          HEX_SIZE *
          Math.sin(angle)

        return `${x},${y}`
      },
    )
    .join(' ')
}

/**
 * ========================================================
 * TERRAIN
 * ========================================================
 */

function getTerrainColor(
  terrain: string,
): string {
  switch (terrain) {
    case 'plains':
      return '#d8c27c'

    case 'forest':
      return '#4f7942'

    case 'hills':
      return '#a67c52'

    case 'swamp':
      return '#65744a'

    case 'desert':
      return '#d9b44a'

    case 'mountain':
      return '#777777'

    case 'wasteland':
      return '#665c54'

    default:
      return '#cccccc'
  }
}

/**
 * ========================================================
 * NOM DES TUILES
 * ========================================================
 */

function getTileName(
  id: string,
): string {
  switch (id) {
    case 'starting-tip':
      return 'TIP'

    case 'starting-left':
      return 'LEFT'

    case 'starting-right':
      return 'RIGHT'

    default:
      return id
  }
}

/**
 * ========================================================
 * CLICK
 * ========================================================
 */

function handleHexagonClick(
  tile: Tile,
  hexagonIndex: number,
) {
  const hexagon =
    tile.hexagons.find(
      (hex) =>
        hex.index ===
        hexagonIndex,
    )

  if (!hexagon) {
    return
  }

  const position =
    getTileHexagonPosition(
      tile,
      hexagon,
    )

  console.log(
    'Hexagone sélectionné',
    {
      tile: tile.id,

      hexagon:
        hexagonIndex,

      local: {
        q: hexagon.localQ,
        r: hexagon.localR,
      },

      global: position,
    },
  )
}
</script>

<style scoped>
.board-container {
  width: 100%;
  min-height: 100vh;
  padding: 20px;
  box-sizing: border-box;
}

h1 {
  margin-bottom: 20px;
}

.board {
  display: block;
  margin: 0 auto;

  border: 1px solid #111;

  overflow: hidden;
}

.board-background {
  fill: #333;
}

.hexagon {
  stroke: #111;
  stroke-width: 1.5;

  cursor: pointer;

  transition:
    filter 0.15s,
    stroke-width 0.15s;
}

.hexagon:hover {
  filter: brightness(1.2);
  stroke-width: 3;
}

.hexagon-number {
  pointer-events: none;

  text-anchor: middle;
  dominant-baseline: central;

  font-size: 13px;
  font-weight: bold;

  fill: #111;
}

.tile-name {
  pointer-events: none;

  text-anchor: middle;

  font-size: 18px;
  font-weight: bold;

  fill: white;
}

.tile-info {
  pointer-events: none;

  text-anchor: middle;

  font-size: 11px;

  fill: #aaa;
}

.origin {
  fill: red;
}

.debug {
  max-width: 1000px;

  margin: 20px auto 0;

  padding: 15px;

  background: #f5f5f5;

  border-radius: 6px;

  color: #222;
}

.debug h2 {
  margin-top: 0;
}

.debug-tile {
  display: flex;
  gap: 20px;

  padding: 6px 0;

  border-bottom: 1px solid #ddd;
}
</style>