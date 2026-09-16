// src/game/placement.ts
import {
  isInsideWedge,
} from './wedge'

import {
  HEX_DIRECTIONS,
  hexagonKey,
  type HexPosition,
} from './hexagon'

import {
  getTileHexagonPosition,
  type Tile,
} from './tile'

import type { Board } from './board'

/**
 * Un contact entre deux hexagones.
 *
 * Exemple :
 *
 * LEFT[1] touche TIP[3]
 */
export interface TileContact {
  tileId: string
  hexagonIndex: number

  otherTileId: string
  otherHexagonIndex: number
}

/**
 * Contraintes de placement d'une tuile.
 */
export interface TilePlacementConstraints {
  /**
   * Tuile que l'on cherche à placer.
   */
  tile: Tile

  /**
   * Les contacts que cette tuile doit respecter.
   */
  contacts: TileContact[]
}

/**
 * Résultat d'un placement.
 */
export interface TilePlacement {
  position: HexPosition
  rotation: number
}

/**
 * Retourne les six positions adjacentes
 * à une position hexagonale.
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
 * Retourne la position globale d'un hexagone
 * d'une tuile.
 */
function getHexagonPosition(
  tile: Tile,
  hexagonIndex: number,
): HexPosition {
  const hexagon =
    tile.hexagons.find(
      (hexagon) =>
        hexagon.index ===
        hexagonIndex,
    )

  if (!hexagon) {
    throw new Error(
      `Hexagone ${hexagonIndex} introuvable dans la tuile "${tile.id}".`,
    )
  }

  return getTileHexagonPosition(
    tile,
    hexagon,
  )
}

/**
 * Retourne la position locale d'un hexagone
 * dans une tuile centrée en 0,0.
 */
function getLocalHexagonPosition(
  tile: Tile,
  hexagonIndex: number,
): HexPosition {
  const originTile: Tile = {
    ...tile,

    position: {
      q: 0,
      r: 0,
    },
  }

  return getHexagonPosition(
    originTile,
    hexagonIndex,
  )
}

/**
 * Teste si deux positions hexagonales
 * sont adjacentes.
 */
export function areAdjacent(
  a: HexPosition,
  b: HexPosition,
): boolean {
  return getAdjacentPositions(a).some(
    (position) =>
      position.q === b.q &&
      position.r === b.r,
  )
}

/**
 * Retourne toutes les positions possibles
 * pour un hexagone cible lorsqu'il doit toucher
 * un hexagone de référence.
 */
function getCandidatePositions(
  referenceTile: Tile,
  referenceHexagonIndex: number,
): HexPosition[] {
  const referencePosition =
    getHexagonPosition(
      referenceTile,
      referenceHexagonIndex,
    )

  return getAdjacentPositions(
    referencePosition,
  )
}

/**
 * Retourne la position du centre de la tuile
 * à partir de la position globale d'un de ses
 * hexagones.
 */
function getTilePositionFromHexagon(
  tile: Tile,
  hexagonIndex: number,
  globalHexagonPosition: HexPosition,
): HexPosition {
  const localPosition =
    getLocalHexagonPosition(
      tile,
      hexagonIndex,
    )

  return {
    q:
      globalHexagonPosition.q -
      localPosition.q,

    r:
      globalHexagonPosition.r -
      localPosition.r,
  }
}

/**
 * Vérifie si une tuile placée à une position
 * donnée entre en collision avec le plateau.
 */
function hasCollision(
  board: Board,
  tile: Tile,
): boolean {
  for (
    const hexagon of tile.hexagons
  ) {
    const position =
      getTileHexagonPosition(
        tile,
        hexagon,
      )

    if (
      board.hexagons.has(
        hexagonKey(
          position.q,
          position.r,
        ),
      )
    ) {
      return true
    }
  }

  return false
}

/**
 * Vérifie que deux tuiles ne se chevauchent pas.
 */
export function tilesOverlap(
  a: Tile,
  b: Tile,
): boolean {
  const occupied =
    new Set(
      a.hexagons.map(
        (hexagon) => {
          const position =
            getTileHexagonPosition(
              a,
              hexagon,
            )

          return hexagonKey(
            position.q,
            position.r,
          )
        },
      ),
    )

  return b.hexagons.some(
    (hexagon) => {
      const position =
        getTileHexagonPosition(
          b,
          hexagon,
        )

      return occupied.has(
        hexagonKey(
          position.q,
          position.r,
        ),
      )
    },
  )
}

/**
 * Vérifie tous les contacts demandés.
 */
function satisfiesContacts(
  board: Board,
  tile: Tile,
  contacts: TileContact[],
): boolean {
  for (
    const contact of contacts
  ) {
    const referenceTile =
      board.tiles.get(
        contact.otherTileId,
      )

    if (!referenceTile) {
      return false
    }

    const targetPosition =
      getHexagonPosition(
        tile,
        contact.hexagonIndex,
      )

    const referencePosition =
      getHexagonPosition(
        referenceTile,
        contact.otherHexagonIndex,
      )

    if (
      !areAdjacent(
        targetPosition,
        referencePosition,
      )
    ) {
      return false
    }
  }

  return true
}

/**
 * Recherche tous les placements possibles
 * respectant les contraintes.
 *
 * Les 6 rotations sont testées.
 */
export function findTilePlacements(
  board: Board,
  constraints: TilePlacementConstraints,
): TilePlacement[] {
  const {
    tile,
    contacts,
  } = constraints

  if (
    contacts.length === 0
  ) {
    return []
  }

  const placements: TilePlacement[] = []

  for (
    let rotation = 0;
    rotation < 6;
    rotation++
  ) {
    const rotatedTile: Tile = {
      ...tile,

      rotation,

      position: {
        q: 0,
        r: 0,
      },

      hexagons:
        tile.hexagons.map(
          (hexagon) => ({
            ...hexagon,
          }),
        ),
    }

    /**
     * Le premier contact sert à générer
     * les positions candidates.
     */
    const firstContact =
      contacts[0]

    const referenceTile =
      board.tiles.get(
        firstContact.otherTileId,
      )

    if (!referenceTile) {
      continue
    }

    const candidateHexagonPositions =
      getCandidatePositions(
        referenceTile,
        firstContact.otherHexagonIndex,
      )

    for (
      const candidateHexagonPosition
      of candidateHexagonPositions
    ) {
      const position =
        getTilePositionFromHexagon(
          rotatedTile,
          firstContact.hexagonIndex,
          candidateHexagonPosition,
        )

      const candidateTile: Tile = {
        ...rotatedTile,

        position,
      }

      /**
       * Vérification des contacts.
       */
      if (
        !satisfiesContacts(
          board,
          candidateTile,
          contacts,
        )
      ) {
        continue
      }

      /**
       * Vérification des collisions.
       */
      if (
        hasCollision(
          board,
          candidateTile,
        )
      ) {
        continue
      }

      /**
       * Vérification de la frontière
       * du wedge.
       */
      if (
        !isInsideWedge(
          board,
          position,
        )
      ) {
        continue
      }
      
      placements.push({
        position,

        rotation,
      })
    }
  }

  return placements
}

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