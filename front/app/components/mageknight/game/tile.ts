// src/game/tile.ts

import {
  TILE_HEXES,
  TERRAIN,
  type Terrain,
} from './hexagon'

/**
 * ============================================================
 * POSITION D'UNE TUILE
 * ============================================================
 *
 * La position n'appartient pas à la définition
 * statique d'une tuile.
 *
 * Elle sera définie par le Board lorsqu'on
 * place la tuile.
 */
export interface TilePosition {
  q: number
  r: number
}

/**
 * ============================================================
 * NIVEAU D'UNE TUILE
 * ============================================================
 */

export type TileLevel = 1 | 2 | 3

/**
 * ============================================================
 * HEXAGONE D'UNE TUILE
 * ============================================================
 */

export interface TileHexagonData {
  /**
   * Index de l'hexagone dans la tuile.
   *
   * 0 = centre
   */
  index: number

  /**
   * Coordonnées locales par rapport
   * au centre de la tuile.
   */
  localQ: number
  localR: number

  /**
   * Terrain de l'hexagone.
   */
  terrain: Terrain

  /**
   * Site éventuellement présent.
   */
  site: string | null

  /**
   * Ennemi éventuellement présent.
   */
  enemy: string | null

  /**
   * Unités éventuellement présentes.
   */
  units: string[]
}

/**
 * ============================================================
 * TUILE
 * ============================================================
 *
 * Une Tile est une définition statique d'une
 * tuile du jeu.
 *
 * Elle ne connaît pas sa position sur le Board.
 */
export interface Tile {
  id: string

  /**
   * Niveau de la tuile.
   */
  level: TileLevel

  /**
   * Les 7 hexagones composant la tuile.
   */
  hexagons: TileHexagonData[]
}

/**
 * ============================================================
 * CREATION
 * ============================================================
 */

export interface CreateTileOptions {
  id: string

  level: TileLevel

  terrains?: Terrain[]

  sites?: (string | null)[]

  enemies?: (string | null)[]

  units?: string[][]
}

/**
 * Crée un hexagone appartenant à une tuile.
 */
function createTileHexagon(
  index: number,
  q: number,
  r: number,
  terrain: Terrain,
  site: string | null,
  enemy: string | null,
  units: string[],
): TileHexagonData {
  return {
    index,

    localQ: q,
    localR: r,

    terrain,

    site,

    enemy,

    units,
  }
}

/**
 * Crée une tuile statique.
 */
export function createTile({
  id,
  level,
  terrains = [],
  sites = [],
  enemies = [],
  units = [],
}: CreateTileOptions): Tile {
  return {
    id,

    level,

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

            sites[
              hexagon.index
            ] ?? null,

            enemies[
              hexagon.index
            ] ?? null,

            units[
              hexagon.index
            ] ?? [],
          ),
      ),
  }
}