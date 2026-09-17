<template>
  <div class="board-view">
    <h1>Mage Knight</h1>

    <div class="board-layout">

      <svg
        width="1000"
        height="700"
        viewBox="0 0 1000 700"
        class="board"
      >
        <!-- ================================================= -->
        <!-- TUILES EXISTANTES -->
        <!-- ================================================= -->

        <TileView
          v-for="tile in tiles"
          :key="tile.id"
          :tile="tile"
          :hex-size="30"
          :origin-x="500"
          :origin-y="350"
          @hexagon-click="
            handleHexagonClick(
              tile,
              $event,
            )
          "
        />

        <!-- ================================================= -->
        <!-- TUILES CANDIDATES -->
        <!-- ================================================= -->

        <TileCandidateView
          v-for="candidate in candidates"
          :key="candidate.id"
          :tile="candidate.tile"
          :hex-size="30"
          :origin-x="500"
          :origin-y="350"
          @select="
            selectCandidate(candidate)
          "
        />

        <!-- ================================================= -->
        <!-- JOUEUR -->
        <!-- ================================================= -->

        <circle
          v-if="playerPosition"
          :cx="playerPosition.x"
          :cy="playerPosition.y"
          r="10"
          class="player"
        />

      </svg>

      <!-- =================================================== -->
      <!-- INFORMATIONS -->
      <!-- =================================================== -->

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

        <template
          v-if="candidates.length"
        >
          <hr />

          <h2>
            Nouvelles tuiles
          </h2>

          <p>
            Cliquez sur une tuile
            pour la sélectionner.
          </p>

          <p>
            {{ candidates.length }}
            possibilité(s)
          </p>
        </template>

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
import TileCandidateView from './TileCandidateView.vue'

import {
  createInitialBoard,
  getTiles,
  addTile,
  type Board,
} from './game/board'

import {
  createTile,
  type Tile,
} from './game/tile'

import {
  getTileHexagonPosition,
} from './game/tile'

import {
  getRevealOptions,
  type RevealOption,
} from './game/reveal'

import type {
  TilePlacement,
} from './game/placement'

import type {
  Player,
} from './game/player'


/**
 * ============================================================
 * BOARD
 * ============================================================
 */

const board = ref<Board>(
  createInitialBoard(),
)


/**
 * ============================================================
 * PLAYER
 * ============================================================
 */

const player = ref<Player>({
  tileId:
    board.value.startingTiles.tip,

  hexagonIndex: 0,
})


/**
 * ============================================================
 * TILES
 * ============================================================
 */

const tiles = computed(() =>
  getTiles(
    board.value,
  ),
)


/**
 * ============================================================
 * REVEAL
 * ============================================================
 */

const revealOptions = computed(
  () =>
    getRevealOptions(
      board.value,
      player.value,
    ),
)


/**
 * ============================================================
 * CANDIDATE
 * ============================================================
 */

interface TileCandidate {
  id: string

  tile: Tile

  placement: TilePlacement

  revealOption: RevealOption
}


/**
 * Création des tuiles candidates.
 *
 * Chaque placement retourné par reveal.ts
 * devient une tuile temporaire affichée
 * en fade sur le plateau.
 */
const candidates = computed<
  TileCandidate[]
>(() => {

  return revealOptions.value.flatMap(
    (option) =>
      option.placements.map(
        (placement) => {

          const id =
            `candidate-${option.rule.id}-${placement.position.q}-${placement.position.r}-${placement.rotation}`

          const tile =
            createTile({
              id,

              position: {
                q:
                  placement.position.q,

                r:
                  placement.position.r,
              },

              rotation:
                placement.rotation,
            })

          return {
            id,

            tile,

            placement,

            revealOption:
              option,
          }
        },
      ),
  )
})


/**
 * ============================================================
 * CLIC HEXAGONE
 * ============================================================
 */

function handleHexagonClick(
  tile: Tile,
  hexagonIndex: number,
): void {

  player.value = {
    tileId:
      tile.id,

    hexagonIndex,
  }

  console.log(
    '[PLAYER]',
    tile.id,
    hexagonIndex,
  )
}


/**
 * ============================================================
 * SELECTION D'UNE CANDIDATE
 * ============================================================
 */

function selectCandidate(
  candidate: TileCandidate,
): void {

  console.log(
    '[CANDIDATE SELECTED]',
    candidate,
  )

  /**
   * Pour l'instant :
   *
   * on affiche simplement ce qui
   * a été sélectionné.
   *
   * La prochaine étape sera :
   *
   * addTile(board, candidate.tile)
   */
}


/**
 * ============================================================
 * POSITION SVG DU JOUEUR
 * ============================================================
 */

const playerPosition =
  computed(() => {

    const tile =
      tiles.value.find(
        (tile) =>
          tile.id ===
          player.value.tileId,
      )

    if (!tile) {
      return null
    }

    const hexagon =
      tile.hexagons.find(
        (hexagon) =>
          hexagon.index ===
          player.value.hexagonIndex,
      )

    if (!hexagon) {
      return null
    }

    const position =
      getTileHexagonPosition(
        tile,
        hexagon,
      )

    const hexSize = 30

    return {
      x:
        500 +
        hexSize *
          Math.sqrt(3) *
          (
            position.q +
            position.r / 2
          ),

      y:
        350 +
        hexSize *
          (3 / 2) *
          position.r,
    }
  })
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