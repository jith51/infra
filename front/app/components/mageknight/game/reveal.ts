import type { Board } from './board'
import type { Player } from './player'
import {
  findTilePlacements,
  type TileContact,
  type TilePlacement,
} from './placement'
import {
  createTile,
  type Tile,
} from './tile'

/**
 * ============================================================
 * TYPES
 * ============================================================
 */

/**
 * Position d'un joueur sur une tuile.
 */
export interface PlayerPosition {
  tileId: string
  hexagonIndex: number
}

/**
 * Une règle de révélation.
 *
 * Exemple :
 *
 * RIGHT[3] + RIGHT[4]
 *
 * signifie que NEW[1] doit être adjacent
 * aux deux hexagones.
 */
export interface RevealRule {
  id: string
  name: string

  playerPositions: PlayerPosition[]

  contacts: PlayerPosition[]
}

/**
 * Une option réellement disponible pour le joueur.
 */
export interface RevealOption {
  rule: RevealRule

  /**
   * La nouvelle tuile doit respecter ces contacts.
   */
  contacts: TileContact[]

  /**
   * Toutes les positions / rotations possibles
   * pour la nouvelle tuile.
   */
  placements: TilePlacement[]
}

/**
 * ============================================================
 * CONSTANTES
 * ============================================================
 */

const TIP_ID = 'starting-tip'
const LEFT_ID = 'starting-left'
const RIGHT_ID = 'starting-right'

/**
 * ============================================================
 * REGLES DE REVELATION
 * ============================================================
 *
 * Solution 1
 *
 * RIGHT[3] + RIGHT[4]
 *
 * Solution 2
 *
 * RIGHT[2] + RIGHT[3] + LEFT[5]
 *
 * Solution 3
 *
 * LEFT[3] + LEFT[4]
 */
export const REVEAL_RULES: RevealRule[] = [
  {
    id: 'right-outer',

    name: 'RIGHT 3-4',

    playerPositions: [
      {
        tileId: RIGHT_ID,
        hexagonIndex: 3,
      },

      {
        tileId: RIGHT_ID,
        hexagonIndex: 4,
      },
    ],

    contacts: [
      {
        tileId: RIGHT_ID,
        hexagonIndex: 3,
      },

      {
        tileId: RIGHT_ID,
        hexagonIndex: 4,
      },
    ],
  },

  {
    id: 'right-inner',

    name: 'RIGHT 2-3 + LEFT 5',

    playerPositions: [
      {
        tileId: RIGHT_ID,
        hexagonIndex: 2,
      },

      {
        tileId: RIGHT_ID,
        hexagonIndex: 3,
      },

      {
        tileId: LEFT_ID,
        hexagonIndex: 4,
      },

      {
        tileId: LEFT_ID,
        hexagonIndex: 5,
      },
    ],

    contacts: [
      {
        tileId: RIGHT_ID,
        hexagonIndex: 2,
      },

      {
        tileId: RIGHT_ID,
        hexagonIndex: 3,
      },

      {
        tileId: LEFT_ID,
        hexagonIndex: 5,
      },
    ],
  },

  {
    id: 'left-outer',

    name: 'LEFT 3-4',

    playerPositions: [
      {
        tileId: LEFT_ID,
        hexagonIndex: 3,
      },

      {
        tileId: LEFT_ID,
        hexagonIndex: 4,
      },
    ],

    contacts: [
      {
        tileId: LEFT_ID,
        hexagonIndex: 3,
      },

      {
        tileId: LEFT_ID,
        hexagonIndex: 4,
      },
    ],
  },
]

/**
 * ============================================================
 * PLAYER POSITION
 * ============================================================
 */

/**
 * Récupère la position du joueur.
 *
 * On garde cette fonction isolée afin de ne pas dépendre
 * trop fortement de la structure de Player.
 */
function getPlayerPosition(
  player: Player,
): PlayerPosition {
  return {
    tileId:
      player.tileId,

    hexagonIndex:
      player.hexagonIndex,
  }
}

/**
 * ============================================================
 * REGLES APPLICABLES
 * ============================================================
 */

/**
 * Retourne les règles correspondant à la position
 * actuelle du joueur.
 */
export function getApplicableRevealRules(
  player: Player,
): RevealRule[] {
  const position =
    getPlayerPosition(
      player,
    )

  return REVEAL_RULES.filter(
    (rule) =>
      rule.playerPositions.some(
        (playerPosition) =>
          playerPosition.tileId ===
            position.tileId &&
          playerPosition.hexagonIndex ===
            position.hexagonIndex,
      ),
  )
}

/**
 * ============================================================
 * CONTACTS
 * ============================================================
 */

/**
 * Transforme une définition de contact
 * en TileContact utilisable par placement.ts.
 */
function createContacts(
  rule: RevealRule,
  newTileId: string,
): TileContact[] {
  return rule.contacts.map(
    (contact) => ({
      tileId:
        newTileId,

      /**
       * Toujours l'hexagone 1 de la nouvelle tuile.
       */
      hexagonIndex:
        1,

      otherTileId:
        contact.tileId,

      otherHexagonIndex:
        contact.hexagonIndex,
    }),
  )
}

/**
 * ============================================================
 * CREATION D'UNE TUILE
 * ============================================================
 */

/**
 * Crée une nouvelle tuile temporaire.
 *
 * Elle n'est PAS encore ajoutée au board.
 */
function createRevealTile(): Tile {
  return createTile({
    id: 'reveal-candidate',

    position: {
      q: 0,
      r: 0,
    },

    rotation: 0,
  })
}

/**
 * ============================================================
 * OPTIONS DE REVELATION
 * ============================================================
 */

/**
 * Retourne les options de révélation disponibles
 * depuis la position actuelle du joueur.
 *
 * IMPORTANT :
 *
 * Cette fonction ne modifie PAS le board.
 */
export function getRevealOptions(
  board: Board,
  player: Player,
): RevealOption[] {
  const rules =
    getApplicableRevealRules(
      player,
    )

  if (rules.length === 0) {
    return []
  }

  const options: RevealOption[] = []

  for (
    const rule of rules
  ) {
    const tile =
      createRevealTile()

    const contacts =
      createContacts(
        rule,
        tile.id,
      )

    const placements =
      findTilePlacements(
        board,
        {
          tile,

          contacts,
        },
      )

    /**
     * Une règle n'est réellement disponible
     * que si au moins un placement géométrique
     * est possible.
     */
    if (
      placements.length === 0
    ) {
      continue
    }

    options.push({
      rule,

      contacts,

      placements,
    })
  }

  return options
}