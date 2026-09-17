// src/game/player.ts

import type {
  Board,
} from './board'

import {
  getHexagon,
} from './board'

import {
  getNeighborPosition,
  type HexDirection,
  type HexPosition,
} from './hexagon'

export interface Player {
  id: string

  name: string

  /**
   * Position globale du joueur.
   */
  position: HexPosition

  /**
   * Tuile sur laquelle se trouve le joueur.
   */
  tileId: string | null

  /**
   * Index de l'hexagone dans la tuile.
   */
  tileHexagonIndex: number | null
}

/**
 * Crée un joueur.
 */
export function createPlayer(
  id: string,
  name: string,
  position: HexPosition = {
    q: 0,
    r: 0,
  },
): Player {
  return {
    id,

    name,

    position: {
      q: position.q,
      r: position.r,
    },

    tileId: null,

    tileHexagonIndex: null,
  }
}

/**
 * Met à jour les informations de tuile
 * du joueur.
 */
function updatePlayerTile(
  board: Board,
  player: Player,
): void {
  const hexagon =
    getHexagon(
      board,
      player.position.q,
      player.position.r,
    )

  if (!hexagon) {
    player.tileId = null

    player.tileHexagonIndex = null

    return
  }

  player.tileId =
    hexagon.tileId

  player.tileHexagonIndex =
    hexagon.tileHexagonIndex
}

/**
 * Déplace le joueur vers un hexagone voisin.
 *
 * Cette fonction vérifie uniquement que
 * l'hexagone de destination existe.
 *
 * Les règles de mouvement Mage Knight
 * seront ajoutées plus tard.
 */
export function movePlayer(
  board: Board,
  player: Player,
  direction: HexDirection,
): boolean {
  const newPosition =
    getNeighborPosition(
      player.position,
      direction,
    )

  const destination =
    getHexagon(
      board,
      newPosition.q,
      newPosition.r,
    )

  if (!destination) {
    return false
  }

  player.position =
    newPosition

  updatePlayerTile(
    board,
    player,
  )

  return true
}

/**
 * Place le joueur sur un hexagone précis.
 */
export function placePlayer(
  board: Board,
  player: Player,
  position: HexPosition,
): boolean {
  const hexagon =
    getHexagon(
      board,
      position.q,
      position.r,
    )

  if (!hexagon) {
    return false
  }

  player.position = {
    q: position.q,
    r: position.r,
  }

  updatePlayerTile(
    board,
    player,
  )

  return true
}

/**
 * Vérifie si le joueur peut atteindre
 * directement un hexagone voisin.
 */
export function canMovePlayer(
  board: Board,
  player: Player,
  direction: HexDirection,
): boolean {
  const position =
    getNeighborPosition(
      player.position,
      direction,
    )

  return (
    getHexagon(
      board,
      position.q,
      position.r,
    ) !== null
  )
}