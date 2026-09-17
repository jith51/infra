<template>
  <div class="board-view">

    <h1>Mage Knight</h1>

    <div class="board-layout">

      <!-- ================================================= -->
      <!-- BOARD -->
      <!-- ================================================= -->

      <svg
        width="1000"
        height="700"
        viewBox="0 0 1000 700"
        class="board"
      >

        <!-- =============================================== -->
        <!-- TUILES DU BOARD -->
        <!-- =============================================== -->

        <TileView
          v-for="placedTile in tiles"
          :key="placedTile.tile.id"
          :tile="placedTile.tile"
          :position="placedTile.position"
          :hex-size="30"
          :origin-x="500"
          :origin-y="350"
          @hexagon-click="
            handleHexagonClick
          "
        />

        <!-- =============================================== -->
        <!-- PREVIEWS -->
        <!-- =============================================== -->

        <TilePreviewView
          v-for="option in revealOptions"
          :key="option.id"
          :position="
            option.placements[0].position
          "
          :hex-size="30"
          :origin-x="500"
          :origin-y="350"
          :level="2"
          @click="
            handlePreviewClick(option)
          "
        />

        <!-- =============================================== -->
        <!-- JOUEUR -->
        <!-- =============================================== -->

        <circle
          v-if="playerPosition"
          :cx="playerPosition.x"
          :cy="playerPosition.y"
          r="10"
          class="player"
        />

      </svg>

      <!-- ================================================= -->
      <!-- PANNEAU -->
      <!-- ================================================= -->

      <aside class="game-panel">

        <h2>Joueur</h2>

        <p>
          Tuile :
          <strong>
            {{ player.tileId }}
          </strong>
        </p>

        <p>
          Hexagone :
          <strong>
            {{ player.hexagonIndex }}
          </strong>
        </p>

        <hr />

        <h2>Révélation</h2>

        <p
          v-if="
            revealOptions.length === 0
          "
        >
          Aucune tuile disponible.
        </p>

        <p
          v-else
        >
          {{ revealOptions.length }}
          preview(s)
        </p>

      </aside>

    </div>

  </div>
</template>

<script setup lang="ts">

import {
  computed,
  ref,
} from 'vue'

import TileView from './TileView.vue'

import TilePreviewView from './TilePreviewView.vue'

import {
  createInitialBoard,
  getTiles,
  type Board,
} from './game/board'

import {
  getTileHexagonPosition,
  type TileHexagonData,
} from './game/placement'

import {
  getRevealOptions,
  type RevealOption,
} from './game/reveal'

import type {
  HexPosition,
} from './game/hexagon'

import type {
  Player,
} from './game/player'

/**
 * ============================================================
 * BOARD
 * ============================================================
 */

const board =
  ref<Board>(
    createInitialBoard(),
  )

/**
 * ============================================================
 * PLAYER
 * ============================================================
 */

const player =
  ref<Player>({
    tileId:
      board.value.startingTileId,

    hexagonIndex: 0,
  })

/**
 * ============================================================
 * TILES
 * ============================================================
 */

const tiles =
  computed(() =>
    getTiles(
      board.value,
    ),
  )

/**
 * ============================================================
 * REVEAL
 * ============================================================
 */

const revealOptions =
  computed(() =>
    getRevealOptions(
      board.value,
      player.value,
    ),
  )

/**
 * ============================================================
 * CLIC SUR UN HEXAGONE
 * ============================================================
 */

function handleHexagonClick(
  tileId: string,
  hexagonIndex: number,
): void {

  player.value = {
    tileId,

    hexagonIndex,
  }

  console.log(
    '[PLAYER]',
    tileId,
    hexagonIndex,
  )
}

/**
 * ============================================================
 * CLIC SUR UNE PREVIEW
 * ============================================================
 */

function handlePreviewClick(
  option: RevealOption,
): void {

  console.log(
    '[PREVIEW]',
    option,
  )

  /**
   * Pour l'instant on ne place rien.
   *
   * La prochaine étape sera :
   *
   * 1. choisir une vraie Tile
   * 2. choisir son orientation
   * 3. la placer dans le Board
   */
}

/**
 * ============================================================
 * POSITION DU JOUEUR
 * ============================================================
 */

const playerPosition =
  computed(() => {

    /**
     * Récupère la tuile du joueur.
     */
    const placedTile =
      board.value.tiles.get(
        player.value.tileId,
      )

    if (!placedTile) {
      return null
    }

    /**
     * Récupère l'hexagone.
     */
    const hexagon =
      placedTile.tile.hexagons.find(
        (hexagon) =>
          hexagon.index ===
          player.value.hexagonIndex,
      )

    if (!hexagon) {
      return null
    }

    /**
     * Position globale.
     *
     * Pour le moment l'orientation
     * du placement est 0.
     */
    const position:
      HexPosition = {
      q:
        placedTile.position.q +
        hexagon.localQ,

      r:
        placedTile.position.r +
        hexagon.localR,
    }

    /**
     * Conversion hexagone → SVG.
     */
    return hexToPixel(
      position.q,
      position.r,
    )
  })

/**
 * ============================================================
 * HEXAGONE → SVG
 * ============================================================
 */

function hexToPixel(
  q: number,
  r: number,
) {

  const hexSize = 30

  return {
    x:
      500 +
      hexSize *
        Math.sqrt(3) *
        (
          q +
          r / 2
        ),

    y:
      350 +
      hexSize *
        (3 / 2) *
        r,
  }
}

</script>

<style scoped>

.board-view {
  padding: 20px;
}

.board-layout {
  display: flex;
  align-items: flex-start;
  gap: 20px;
}

.board {
  background: #333;
  border: 1px solid #000;
}

.game-panel {
  width: 260px;
  padding: 20px;

  border: 1px solid #ccc;
  border-radius: 8px;

  background: #f5f5f5;
}

.game-panel h2 {
  margin-top: 0;
}

.player {
  pointer-events: none;

  fill: blue;

  stroke: white;

  stroke-width: 2;
}

</style>