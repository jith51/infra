// src/game/board.ts

import {
  hexagonKey,
  type HexPosition,
} from './hexagon'

import {
  createTile,
  getTileHexagonPosition,
  type Tile,
} from './tile'

import {
  findTilePlacement,
} from './placement'

/**
 * ============================================================
 * TYPES
 * ============================================================
 */

/**
 * Identifiants des trois tuiles utilisées
 * lors de la création initiale du plateau.
 */
export interface StartingTiles {
  tip: string
  left: string
  right: string
}

/**
 * Représentation d'un hexagone lorsqu'il est
 * enregistré sur le plateau global.
 */
export interface BoardHexagon
  extends HexPosition {
  tileId: string
  tileHexagonIndex: number
  terrain: string
  site: string | null
  enemy: string | null
  units: string[]
}

/**
 * Plateau de jeu.
 */
export interface Board {
  /**
   * Tuiles actuellement présentes sur le plateau.
   */
  tiles: Map<string, Tile>

  /**
   * Tous les hexagones occupés par les tuiles.
   *
   * La clé est :
   *
   * q:r
   */
  hexagons: Map<string, BoardHexagon>
  
  /**
   * Les trois tuiles utilisées pour
   * initialiser le plateau.
   */
  startingTiles: StartingTiles
}

/**
 * ============================================================
 * CREATION DU BOARD
 * ============================================================
 */

/**
 * Crée un plateau vide.
 */
export function createBoard(
  startingTiles: StartingTiles,
): Board {
  return {
    tiles: new Map<string, Tile>(),

    hexagons:
      new Map<string, BoardHexagon>(),

    startingTiles,
  }
}

/**
 * ============================================================
 * TILES
 * ============================================================
 */

/**
 * Retourne toutes les tuiles présentes
 * sur le plateau.
 */
export function getTiles(
  board: Board,
): Tile[] {
  return Array.from(
    board.tiles.values(),
  )
}

/**
 * Retourne une tuile à partir de son ID.
 */
export function getTile(
  board: Board,
  tileId: string,
): Tile | null {
  return (
    board.tiles.get(
      tileId,
    ) ?? null
  )
}

/**
 * ============================================================
 * HEXAGONES
 * ============================================================
 */

/**
 * Retourne un hexagone global à partir
 * de ses coordonnées axiales.
 */
export function getHexagon(
  board: Board,
  q: number,
  r: number,
): BoardHexagon | null {
  return (
    board.hexagons.get(
      hexagonKey(q, r),
    ) ?? null
  )
}

/**
 * Vérifie si un hexagone existe déjà
 * à une position donnée.
 */
export function hasHexagon(
  board: Board,
  q: number,
  r: number,
): boolean {
  return board.hexagons.has(
    hexagonKey(q, r),
  )
}

/**
 * ============================================================
 * COLLISIONS
 * ============================================================
 */

/**
 * Vérifie si une tuile entre en collision
 * avec une tuile déjà présente sur le plateau.
 */
export function hasTileCollision(
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
      hasHexagon(
        board,
        position.q,
        position.r,
      )
    ) {
      return true
    }
  }

  return false
}

/**
 * ============================================================
 * AJOUT / SUPPRESSION DE TUILES
 * ============================================================
 */

/**
 * Ajoute une tuile au plateau.
 *
 * La fonction vérifie :
 *
 * - que l'ID n'existe pas déjà
 * - que la tuile ne chevauche pas une tuile existante
 */
export function addTile(
  board: Board,
  tile: Tile,
): void {
  /**
   * Une tuile avec le même ID existe déjà.
   */
  if (
    board.tiles.has(tile.id)
  ) {
    throw new Error(
      `La tuile "${tile.id}" existe déjà.`,
    )
  }

  /**
   * Collision géométrique.
   */
  if (
    hasTileCollision(
      board,
      tile,
    )
  ) {
    throw new Error(
      `La tuile "${tile.id}" chevauche une tuile existante.`,
    )
  }

  /**
   * Enregistre la tuile.
   */
  board.tiles.set(
    tile.id,
    tile,
  )

  /**
   * Enregistre chacun de ses hexagones
   * dans l'index global.
   */
  for (
    const hexagon of tile.hexagons
  ) {
    const position =
      getTileHexagonPosition(
        tile,
        hexagon,
      )

    const key =
      hexagonKey(
        position.q,
        position.r,
      )

    board.hexagons.set(
      key,
      {
        q: position.q,

        r: position.r,

        tileId:
          tile.id,

        tileHexagonIndex:
          hexagon.index,

        terrain:
          hexagon.terrain,

        site:
          hexagon.site,

        enemy:
          hexagon.enemy,

        units: [
          ...hexagon.units,
        ],
      },
    )
  }
}

/**
 * Supprime une tuile du plateau.
 */
export function removeTile(
  board: Board,
  tileId: string,
): boolean {
  const tile =
    board.tiles.get(
      tileId,
    )

  if (!tile) {
    return false
  }

  /**
   * Supprime ses hexagones
   * de l'index global.
   */
  for (
    const hexagon of tile.hexagons
  ) {
    const position =
      getTileHexagonPosition(
        tile,
        hexagon,
      )

    board.hexagons.delete(
      hexagonKey(
        position.q,
        position.r,
      ),
    )
  }

  /**
   * Supprime la tuile.
   */
  board.tiles.delete(
    tileId,
  )

  return true
}

/**
 * ============================================================
 * TUILES DE DEPART
 * ============================================================
 */

/**
 * Retourne les trois tuiles de départ.
 */
export function getStartingTiles(
  board: Board,
): {
  tip: Tile
  left: Tile
  right: Tile
} {
  const tip =
    getTile(
      board,
      board.startingTiles.tip,
    )

  const left =
    getTile(
      board,
      board.startingTiles.left,
    )

  const right =
    getTile(
      board,
      board.startingTiles.right,
    )

  if (!tip) {
    throw new Error(
      `La tuile "${board.startingTiles.tip}" est introuvable.`,
    )
  }

  if (!left) {
    throw new Error(
      `La tuile "${board.startingTiles.left}" est introuvable.`,
    )
  }

  if (!right) {
    throw new Error(
      `La tuile "${board.startingTiles.right}" est introuvable.`,
    )
  }

  return {
    tip,
    left,
    right,
  }
}

/**
 * ============================================================
 * INITIAL BOARD
 * ============================================================
 */

/**
 * Crée le plateau initial de Mage Knight.
 *
 * Configuration :
 *
 *
 *                    TIP
 *
 *
 *                3       4
 *                 \     /
 *                  \   /
 *                LEFT RIGHT
 *                  1     1
 *
 *
 * Contraintes :
 *
 * LEFT[1] touche TIP[3] et TIP[4]
 *
 * RIGHT[1] touche TIP[4] et TIP[5]
 *
 *
 * Le moteur de placement cherche automatiquement :
 *
 * - la position q/r
 * - la rotation
 *
 * et vérifie les collisions.
 */
export function createInitialBoard(): Board {
  /**
   * ==========================================================
   * IDENTIFIANTS
   * ==========================================================
   */

  const startingTiles: StartingTiles = {
    tip: 'starting-tip',

    left: 'starting-left',

    right: 'starting-right',
  }

  /**
   * ==========================================================
   * BOARD VIDE
   * ==========================================================
   */

  const board =
    createBoard(
      startingTiles,
    )

  /**
   * ==========================================================
   * TIP
   * ==========================================================
   *
   * La tuile TIP est toujours au centre.
   */

  const tip =
    createTile({
      id:
        startingTiles.tip,

      position: {
        q: 0,
        r: 0,
      },

      rotation: 0,
    })

  addTile(
    board,
    tip,
  )

  /**
   * ==========================================================
   * LEFT
   * ==========================================================
   *
   * LEFT[1] doit toucher :
   *
   * TIP[3]
   * TIP[4]
   */

  const left =
    createTile({
      id:
        startingTiles.left,

      /**
       * Position temporaire.
       *
       * Le moteur de placement va la remplacer.
       */
      position: {
        q: 0,
        r: 0,
      },

      rotation: 0,
    })

  const leftPlacement =
    findTilePlacement(
      board,
      {
        tile: left,

        contacts: [
          /**
           * LEFT[1] → TIP[3]
           */
          {
            tileId:
              left.id,

            hexagonIndex:
              1,

            otherTileId:
              tip.id,

            otherHexagonIndex:
              3,
          },

          /**
           * LEFT[1] → TIP[4]
           */
          {
            tileId:
              left.id,

            hexagonIndex:
              1,

            otherTileId:
              tip.id,

            otherHexagonIndex:
              4,
          },
        ],
      },
    )

  if (!leftPlacement) {
    throw new Error(
      'Aucun placement valide trouvé pour la tuile LEFT.',
    )
  }

  /**
   * Applique le placement trouvé.
   */
  left.position =
    leftPlacement.position

  left.rotation =
    leftPlacement.rotation

  /**
   * Ajoute LEFT au plateau.
   */
  addTile(
    board,
    left,
  )

  /**
   * ==========================================================
   * RIGHT
   * ==========================================================
   *
   * RIGHT[1] doit toucher :
   *
   * TIP[4]
   * TIP[5]
   *
   * Le moteur tient maintenant compte des tuiles
   * déjà présentes, donc LEFT est pris en compte
   * lors de la recherche.
   */

  const right =
    createTile({
      id:
        startingTiles.right,

      position: {
        q: 0,
        r: 0,
      },

      rotation: 0,
    })

  const rightPlacement =
    findTilePlacement(
      board,
      {
        tile: right,

        contacts: [
          /**
           * RIGHT[1] → TIP[4]
           */
          {
            tileId:
              right.id,

            hexagonIndex:
              1,

            otherTileId:
              tip.id,

            otherHexagonIndex:
              4,
          },

          /**
           * RIGHT[1] → TIP[5]
           */
          {
            tileId:
              right.id,

            hexagonIndex:
              1,

            otherTileId:
              tip.id,

            otherHexagonIndex:
              5,
          },
        ],
      },
    )

  if (!rightPlacement) {
    throw new Error(
      'Aucun placement valide trouvé pour la tuile RIGHT.',
    )
  }

  /**
   * Applique le placement trouvé.
   */
  right.position =
    rightPlacement.position

  right.rotation =
    rightPlacement.rotation

  /**
   * Ajoute RIGHT au plateau.
   */
  addTile(
    board,
    right,
  )

  /**
   * ==========================================================
   * DEBUG
   * ==========================================================
   */

  console.log(
    '[BOARD] Starting tiles:',
    {
      tip: {
        position:
          tip.position,

        rotation:
          tip.rotation,
      },

      left: {
        position:
          left.position,

        rotation:
          left.rotation,
      },

      right: {
        position:
          right.position,

        rotation:
          right.rotation,
      },
    },
  )

  return board
}