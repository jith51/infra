// src/game/tile.ts

import {
  TILE_HEXES,
  TERRAIN,
  type Terrain,
} from './hexagon'

export interface TilePosition {
  q: number
  r: number
}

enum TileLevel {
  First = 1,
  Second = 2,
  Third = 3
}

export interface TileHexagonData {
  index: number

  localQ: number
  localR: number

  level: TileLevel | null

  terrain: Terrain

  site: string | null

  enemy: string | null

  units: string[]
}

export interface Tile {
  id: string

  /**
   * Position du centre de la tuile.
   */
  position: TilePosition

  /**
   * Rotation de 0 à 5.
   *
   * Chaque unité correspond à 60°.
   */
  rotation: number

  hexagons: TileHexagonData[]
}

export interface CreateTileOptions {
  id: string

  position?: TilePosition

  rotation?: number

  level?: TileLevel

  terrains?: Terrain[]
}

/**
 * Normalise une rotation.
 */
export function normalizeRotation(
  rotation: number,
): number {
  return (
    (
      rotation % 6
    ) +
    6
  ) % 6
}

/**
 * Rotation d'une coordonnée axiale.
 *
 * Une rotation correspond à 60°.
 *
 * Formule cube :
 *
 * x = q
 * z = r
 * y = -x-z
 */
export function rotateHex(
  q: number,
  r: number,
  rotation: number,
): TilePosition {
  const normalized =
    normalizeRotation(rotation)

  let x = q
  let z = r
  let y = -x - z

  for (
    let i = 0;
    i < normalized;
    i++
  ) {
    /**
     * Rotation de 60° :
     *
     * (x, y, z)
     * →
     * (-z, -x, -y)
     */
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
 * Retourne les coordonnées globales
 * d'un hexagone d'une tuile.
 */
export function getTileHexagonPosition(
  tile: Tile,
  hexagon: TileHexagonData,
): TilePosition {
  const rotated =
    rotateHex(
      hexagon.localQ,
      hexagon.localR,
      tile.rotation,
    )

  return {
    q:
      tile.position.q +
      rotated.q,

    r:
      tile.position.r +
      rotated.r,
  }
}

/**
 * Crée un hexagone de tuile.
 */
function createTileHexagon(
  index: number,
  q: number,
  r: number,
  terrain: Terrain,
  level?: TileLevel
): TileHexagonData {
  return {
    index,

    localQ: q,
    localR: r,

    terrain,

    level: level ?? null,

    site: null,

    enemy: null,

    units: [],
  }
}

/**
 * Crée une tuile.
 */
export function createTile({
  id,
  position = {
    q: 0,
    r: 0,
  },
  rotation = 0,
  level = undefined,
  terrains = [],
}: CreateTileOptions): Tile {
  return {
    id,

    position: {
      q: position.q,
      r: position.r,
    },

    rotation:
      normalizeRotation(
        rotation,
      ),

    hexagons:
      TILE_HEXES.map(
        (hexagon) =>
          createTileHexagon(
            hexagon.index,
            hexagon.q,
            hexagon.r,
            terrains[
              hexagon.index
            ] ?? TERRAIN.PLAINS,
          ),
      ),
  }
}

/**
 * Change la rotation d'une tuile.
 */
export function rotateTile(
  tile: Tile,
  rotation: number,
): void {
  tile.rotation =
    normalizeRotation(
      rotation,
    )
}