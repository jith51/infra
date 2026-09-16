// src/game/wedge.ts

import type { Board } from './board'
import type { HexPosition } from './hexagon'

/**
 * Produit vectoriel 2D.
 */
function cross(
  a: HexPosition,
  b: HexPosition,
): number {
  return (
    a.q * b.r -
    a.r * b.q
  )
}

/**
 * Produit scalaire.
 */
function dot(
  a: HexPosition,
  b: HexPosition,
): number {
  return (
    a.q * b.q +
    a.r * b.r
  )
}

/**
 * Vecteur allant de a vers b.
 */
function vector(
  a: HexPosition,
  b: HexPosition,
): HexPosition {
  return {
    q: b.q - a.q,
    r: b.r - a.r,
  }
}

/**
 * Vérifie si une position de tuile
 * se trouve dans le wedge du scénario.
 *
 * Le wedge est défini par :
 *
 *             LEFT
 *               \
 *                \
 *                 TIP
 *                /
 *               /
 *            RIGHT
 *
 * Les positions sur la frontière sont autorisées.
 *
 * Les positions au-delà de la frontière
 * sont interdites.
 */
export function isInsideWedge(
  board: Board,
  position: HexPosition,
): boolean {
  const tip =
    board.tiles.get(
      board.startingTiles.tip,
    )

  const left =
    board.tiles.get(
      board.startingTiles.left,
    )

  const right =
    board.tiles.get(
      board.startingTiles.right,
    )

  if (
    !tip ||
    !left ||
    !right
  ) {
    return false
  }

  const tipPosition =
    tip.position

  const leftVector =
    vector(
      tipPosition,
      left.position,
    )

  const rightVector =
    vector(
      tipPosition,
      right.position,
    )

  /**
   * Position de la candidate
   * par rapport au TIP.
   */
  const candidateVector =
    vector(
      tipPosition,
      position,
    )

  /**
   * Vérification de la direction
   * du wedge.
   */
  const orientation =
    cross(
      leftVector,
      rightVector,
    )

  if (orientation === 0) {
    return false
  }

  /**
   * Les deux côtés du wedge.
   */
  const leftSide =
    cross(
      leftVector,
      candidateVector,
    )

  const rightSide =
    cross(
      candidateVector,
      rightVector,
    )

  const inside =
    orientation > 0
      ? leftSide >= 0 &&
        rightSide >= 0
      : leftSide <= 0 &&
        rightSide <= 0

  if (!inside) {
    return false
  }

  /**
   * Évite d'accepter une position
   * située derrière le TIP sur une
   * des deux lignes frontières.
   *
   * On utilise l'axe moyen du wedge.
   */
  const axis: HexPosition = {
    q:
      leftVector.q +
      rightVector.q,

    r:
      leftVector.r +
      rightVector.r,
  }

  return (
    dot(
      candidateVector,
      axis,
    ) >= 0
  )
}