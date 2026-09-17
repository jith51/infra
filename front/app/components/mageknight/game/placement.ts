// src/game/placement.ts

import {
  HEX_DIRECTIONS,
  hexagonKey,
  type HexPosition,
} from './hexagon'

import type {
  Tile,
  TileHexagonData,
} from './tile'

import type { Board } from './board'

/**
 * ============================================================
 * ORIENTATION
 * ============================================================
 *
 * Une tuile peut être orientée selon 6 orientations.
 *
 * L'orientation 0 correspond à sa définition originale.
 */
export type TileOrientation =
  0 | 1 | 2 | 3 | 4 | 5

/**
 * ============================================================
 * PLACEMENT
 * ============================================================
 */

export interface TilePlacement {

  /**
   * Position du centre de la tuile
   * dans le Board.
   */
  position: HexPosition

  /**
   * Orientation de la tuile.
   */
  orientation: TileOrientation
}

/**
 * ============================================================
 * CONTACT
 * ============================================================
 */

/**
 * Contact entre un hexagone de la nouvelle tuile
 * et un hexagone déjà présent sur le Board.
 */
export interface TileContact {

  /**
   * Index de l'hexagone de la nouvelle tuile.
   */
  hexagonIndex: number

  /**
   * Position globale de l'hexagone
   * auquel il doit être adjacent.
   */
  otherPosition: HexPosition
}

/**
 * ============================================================
 * CONTRAINTES
 * ============================================================
 */

export interface TilePlacementConstraints {

  /**
   * Tuile que l'on cherche à placer.
   */
  tile: Tile

  /**
   * Contacts que le placement doit respecter.
   */
  contacts?: TileContact[]
}

/**
 * ============================================================
 * POSITIONS ADJACENTES
 * ============================================================
 */

/**
 * Retourne les six positions hexagonales
 * autour d'une position.
 */
export function getAdjacentPositions(
  position: HexPosition,
): HexPosition[] {

  return Object.values(
    HEX_DIRECTIONS,
  ).map(
    (direction) => ({
      q:
        position.q +
        direction.q,

      r:
        position.r +
        direction.r,
    }),
  )
}

/**
 * ============================================================
 * ADJACENCE
 * ============================================================
 */

/**
 * Vérifie si deux hexagones sont voisins.
 */
export function areAdjacent(
  a: HexPosition,
  b: HexPosition,
): boolean {

  return getAdjacentPositions(
    a,
  ).some(
    (position) =>
      position.q === b.q &&
      position.r === b.r,
  )
}

/**
 * ============================================================
 * ROTATION
 * ============================================================
 */

/**
 * Normalise une orientation entre 0 et 5.
 */
export function normalizeOrientation(
  orientation: number,
): TileOrientation {

  const value =
    (
      orientation % 6 +
      6
    ) % 6

  return value as TileOrientation
}

/**
 * Effectue une rotation de 60° sur
 * une coordonnée hexagonale axiale.
 *
 * q = x
 * r = z
 * y = -x-z
 */
export function rotateHex(
  q: number,
  r: number,
  orientation: number,
): HexPosition {

  const normalized =
    normalizeOrientation(
      orientation,
    )

  let x = q
  let z = r
  let y = -x - z

  for (
    let i = 0;
    i < normalized;
    i++
  ) {

    const newX = -z
    const newY = -x
    const newZ = -y

    x = newX
    y = newY
    z = newZ
  }

  return {
    q: x,
    r: z,
  }
}

/**
 * ============================================================
 * POSITION D'UN HEXAGONE
 * ============================================================
 */

/**
 * Retourne la position globale d'un hexagone
 * lorsqu'une tuile est placée.
 *
 * La position de la tuile représente son centre.
 */
export function getTileHexagonPosition(
  tile: Tile,
  hexagon: TileHexagonData,
  placement: TilePlacement,
): HexPosition {

  const rotated =
    rotateHex(
      hexagon.localQ,
      hexagon.localR,
      placement.orientation,
    )

  return {
    q:
      placement.position.q +
      rotated.q,

    r:
      placement.position.r +
      rotated.r,
  }
}

/**
 * ============================================================
 * COLLISION
 * ============================================================
 */

/**
 * Vérifie si la tuile entrerait en collision
 * avec un hexagone déjà présent sur le Board.
 */
export function hasCollision(
  board: Board,
  tile: Tile,
  placement: TilePlacement,
): boolean {

  for (
    const hexagon of tile.hexagons
  ) {

    const position =
      getTileHexagonPosition(
        tile,
        hexagon,
        placement,
      )

    const key =
      hexagonKey(
        position.q,
        position.r,
      )

    if (
      board.hexagons.has(key)
    ) {
      return true
    }
  }

  return false
}

/**
 * ============================================================
 * CONTACTS
 * ============================================================
 */

/**
 * Vérifie tous les contacts demandés.
 */
export function satisfiesContacts(
  tile: Tile,
  placement: TilePlacement,
  contacts: TileContact[],
): boolean {

  for (
    const contact of contacts
  ) {

    const hexagon =
      tile.hexagons.find(
        (hexagon) =>
          hexagon.index ===
          contact.hexagonIndex,
      )

    if (!hexagon) {
      return false
    }

    const position =
      getTileHexagonPosition(
        tile,
        hexagon,
        placement,
      )

    if (
      !areAdjacent(
        position,
        contact.otherPosition,
      )
    ) {
      return false
    }
  }

  return true
}

/**
 * ============================================================
 * GENERATION DES PLACEMENTS
 * ============================================================
 */

/**
 * Recherche les placements possibles d'une tuile.
 *
 * Si des contacts sont fournis :
 *
 *     - on utilise le premier contact
 *       pour générer les positions candidates ;
 *
 *     - on vérifie ensuite tous les contacts.
 *
 * Si aucun contact n'est fourni :
 *
 *     - aucune position n'est générée.
 *
 * Le Board n'est jamais modifié.
 */
export function findTilePlacements(
  board: Board,
  constraints: TilePlacementConstraints,
): TilePlacement[] {

  const {
    tile,
    contacts = [],
  } = constraints

  /**
   * Sans contrainte, nous ne savons pas encore
   * où proposer la tuile.
   */
  if (
    contacts.length === 0
  ) {
    return []
  }

  const placements:
    TilePlacement[] = []

  /**
   * Premier contact utilisé comme point
   * de génération des candidats.
   */
  const firstContact =
    contacts[0]

  /**
   * Les six orientations sont testées.
   *
   * C'est volontairement conservé ici,
   * même si plus tard l'utilisateur pourra
   * choisir lui-même l'orientation.
   */
  for (
    let orientation = 0;
    orientation < 6;
    orientation++
  ) {

    /**
     * Les hexagones candidats doivent être
     * voisins de l'hexagone de référence.
     */
    const candidatePositions =
      getAdjacentPositions(
        firstContact.otherPosition,
      )

    /**
     * Hexagone de la nouvelle tuile
     * concerné par le premier contact.
     */
    const hexagon =
      tile.hexagons.find(
        (hexagon) =>
          hexagon.index ===
          firstContact.hexagonIndex,
      )

    if (!hexagon) {
      continue
    }

    /**
     * Position locale de cet hexagone
     * après rotation.
     */
    const rotated =
      rotateHex(
        hexagon.localQ,
        hexagon.localR,
        orientation,
      )

    /**
     * Pour chaque position adjacente,
     * on déduit la position du centre
     * de la nouvelle tuile.
     */
    for (
      const hexagonPosition
      of candidatePositions
    ) {

      const position:
        HexPosition = {
        q:
          hexagonPosition.q -
          rotated.q,

        r:
          hexagonPosition.r -
          rotated.r,
      }

      const placement:
        TilePlacement = {
        position,

        orientation:
          orientation as TileOrientation,
      }

      /**
       * Vérifie les contacts.
       */
      if (
        !satisfiesContacts(
          tile,
          placement,
          contacts,
        )
      ) {
        continue
      }

      /**
       * Vérifie les collisions.
       */
      if (
        hasCollision(
          board,
          tile,
          placement,
        )
      ) {
        continue
      }

      /**
       * Evite les doublons.
       */
      const exists =
        placements.some(
          (existing) =>
            existing.position.q ===
              placement.position.q &&
            existing.position.r ===
              placement.position.r &&
            existing.orientation ===
              placement.orientation,
        )

      if (exists) {
        continue
      }

      placements.push(
        placement,
      )
    }
  }

  return placements
}

/**
 * ============================================================
 * PREMIER PLACEMENT
 * ============================================================
 */

/**
 * Retourne le premier placement valide.
 */
export function findTilePlacement(
  board: Board,
  constraints: TilePlacementConstraints,
): TilePlacement | null {

  return (
    findTilePlacements(
      board,
      constraints,
    )[0] ?? null
  )
}