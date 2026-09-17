// src/game/board.ts

import {
  hexagonKey,
  type HexPosition,
} from './hexagon'

import  {
    createTile,
  type Tile,
  type TileHexagonData,
} from './tile'

/**
 * ============================================================
 * HEXAGONE DU BOARD
 * ============================================================
 */

export interface BoardHexagon
  extends TileHexagonData {

  /**
   * Position globale de l'hexagone
   * dans le Board.
   */
  position: HexPosition

  /**
   * Tuile d'origine.
   */
  tileId: string
}

/**
 * ============================================================
 * TUILE PLACEE
 * ============================================================
 *
 * Le Board conserve également la définition de la tuile
 * ainsi que l'endroit où son centre a été placé.
 */
export interface PlacedTile {
  tile: Tile

  /**
   * Position du centre de la tuile.
   */
  position: HexPosition
}

/**
 * ============================================================
 * BOARD
 * ============================================================
 */

export interface Board {

  /**
   * Tuiles effectivement placées.
   */
  tiles: Map<string, PlacedTile>

  /**
   * Tous les hexagones du plateau.
   *
   * La clé est :
   *
   * q:r
   */
  hexagons: Map<string, BoardHexagon>

  /**
   * Identifiant de la tuile de départ.
   */
  startingTileId: string
}

/**
 * ============================================================
 * POSITION D'UN HEXAGONE
 * ============================================================
 */

/**
 * Calcule la position globale d'un hexagone
 * à partir du centre de sa tuile.
 */
export function getBoardHexagonPosition(
  tile: Tile,
  position: HexPosition,
  hexagon: TileHexagonData,
): HexPosition {
  return {
    q:
      position.q +
      hexagon.localQ,

    r:
      position.r +
      hexagon.localR,
  }
}

/**
 * ============================================================
 * AJOUT D'UNE TUILE
 * ============================================================
 */

/**
 * Ajoute une tuile au Board.
 *
 * La tuile reste une définition statique.
 *
 * Le Board recopie ses 7 hexagones avec
 * leurs coordonnées globales.
 */
export function addTile(
  board: Board,
  tile: Tile,
  position: HexPosition,
): void {

  /**
   * Une même définition de tuile ne peut
   * pas être ajoutée deux fois avec le même id.
   */
  if (
    board.tiles.has(
      tile.id,
    )
  ) {
    throw new Error(
      `La tuile "${tile.id}" existe déjà sur le plateau.`,
    )
  }

  /**
   * Vérification des collisions.
   */
  for (
    const hexagon of tile.hexagons
  ) {

    const globalPosition =
      getBoardHexagonPosition(
        tile,
        position,
        hexagon,
      )

    const key =
      hexagonKey(
        globalPosition.q,
        globalPosition.r,
      )

    if (
      board.hexagons.has(key)
    ) {
      throw new Error(
        `L'hexagone ${key} est déjà occupé.`,
      )
    }
  }

  /**
   * Enregistre la tuile.
   */
  board.tiles.set(
    tile.id,
    {
      tile,

      position: {
        q: position.q,
        r: position.r,
      },
    },
  )

  /**
   * Recopie les 7 hexagones
   * dans le Board.
   */
  for (
    const hexagon of tile.hexagons
  ) {

    const globalPosition =
      getBoardHexagonPosition(
        tile,
        position,
        hexagon,
      )

    const boardHexagon:
      BoardHexagon = {
      ...hexagon,

      position:
        globalPosition,

      tileId:
        tile.id,
    }

    board.hexagons.set(
      hexagonKey(
        globalPosition.q,
        globalPosition.r,
      ),
      boardHexagon,
    )
  }
}

/**
 * ============================================================
 * BOARD INITIAL
 * ============================================================
 */

export function createInitialBoard(): Board {

  const board: Board = {

    tiles:
      new Map(),

    hexagons:
      new Map(),

    startingTileId:
      'starting',
  }

  /**
   * ==========================================================
   * TUILE DE DEPART
   * ==========================================================
   */
    const startingTile = createTile({
    id: 'starting',

    level: 1,
    })
//   const startingTile: Tile = {
//     id: 'starting',

//     level: 1,

//     hexagons: [
//       {
//         index: 0,
//         localQ: 0,
//         localR: 0,
//         terrain: 'plains',
//         site: null,
//         enemy: null,
//         units: [],
//       },

//       {
//         index: 1,
//         localQ: -1,
//         localR: 0,
//         terrain: 'plains',
//         site: null,
//         enemy: null,
//         units: [],
//       },

//       {
//         index: 2,
//         localQ: 0,
//         localR: -1,
//         terrain: 'plains',
//         site: null,
//         enemy: null,
//         units: [],
//       },

//       {
//         index: 3,
//         localQ: 1,
//         localR: -1,
//         terrain: 'plains',
//         site: null,
//         enemy: null,
//         units: [],
//       },

//       {
//         index: 4,
//         localQ: 1,
//         localR: 0,
//         terrain: 'plains',
//         site: null,
//         enemy: null,
//         units: [],
//       },

//       {
//         index: 5,
//         localQ: 0,
//         localR: 1,
//         terrain: 'plains',
//         site: null,
//         enemy: null,
//         units: [],
//       },

//       {
//         index: 6,
//         localQ: -1,
//         localR: 1,
//         terrain: 'plains',
//         site: null,
//         enemy: null,
//         units: [],
//       },
//     ],
//   }

  /**
   * Centre de la tuile de départ.
   */
  addTile(
    board,
    startingTile,
    {
      q: 0,
      r: 0,
    },
  )

  return board
}

/**
 * ============================================================
 * HELPERS
 * ============================================================
 */

export function getTiles(
  board: Board,
): PlacedTile[] {
  return Array.from(
    board.tiles.values(),
  )
}

export function getBoardHexagon(
  board: Board,
  position: HexPosition,
): BoardHexagon | undefined {
  return board.hexagons.get(
    hexagonKey(
      position.q,
      position.r,
    ),
  )
}