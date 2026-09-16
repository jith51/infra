export interface HexPosition {
  q: number
  r: number
}

/**
 * Les 6 directions autour d'un hexagone.
 */
export const HEX_DIRECTION = {
  NORTH: 'north',
  NORTH_EAST: 'north-east',
  NORTH_WEST: 'north-west',
  SOUTH: 'south',
  SOUTH_EAST: 'south-east',
  SOUTH_WEST: 'south-west',
} as const


export type HexDirection =
  typeof HEX_DIRECTION[keyof typeof HEX_DIRECTION]

export const HEX_DIRECTIONS: Record<
  HexDirection,
  HexPosition
> = {
  [HEX_DIRECTION.SOUTH]: { q: -1, r: 0, },
  [HEX_DIRECTION.SOUTH_WEST]: { q: 0, r: -1, },
  [HEX_DIRECTION.NORTH_WEST]: { q: 1, r: -1, },
  [HEX_DIRECTION.NORTH]: { q: 1, r: 0, },
  [HEX_DIRECTION.NORTH_EAST]: { q: 0, r: 1, },
  [HEX_DIRECTION.SOUTH_EAST]: { q: -1, r: 1, },
}

export function getNeighborPosition(
  position: HexPosition,
  direction: HexDirection,
): HexPosition {
  const delta =
    HEX_DIRECTIONS[direction]

  return {
    q: position.q + delta.q,
    r: position.r + delta.r,
  }
}

export function hexagonKey(
  q: number,
  r: number,
): string {
  return `${q}:${r}`
}

/**
 * Types de terrain.
 */
export const TERRAIN = {
  PLAINS: 'plains',
  FOREST: 'forest',
  HILLS: 'hills',
  SWAMP: 'swamp',
  DESERT: 'desert',
  MOUNTAIN: 'mountain',
  WASTELAND: 'wasteland',
  COST: 'cost'
} as const

export type Terrain =
  typeof TERRAIN[keyof typeof TERRAIN]

/**
 * Les 7 hexagones composant une tuile.
 *     2
 *   1   3
 *     0
 *   6   4
 *     5
 *
 * Les coordonnées sont relatives
 * au centre de la tuile.
 */
export interface TileHexagon {
  index: number
  q: number
  r: number
}

export const TILE_HEXES: TileHexagon[] = [
  { index: 0, q: 0, r: 0, },
  { index: 1, q: -1, r: 0, },
  { index: 2, q: 0, r: -1, },
  { index: 3, q: 1, r: -1, },
  { index: 4, q: 1, r: 0, },
  { index: 5, q: 0, r: 1, },
  { index: 6, q: -1, r: 1, },
]