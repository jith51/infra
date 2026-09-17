import type {
  HexPosition,
} from './hexagon'

import type {
  Board,
} from './board'

import type {
  Player,
} from './player'

import type {
  TilePlacement,
} from './placement'

export interface RevealOption {
  id: string

  name: string

  placements: TilePlacement[]
}

/**
 * Positions possibles pour révéler
 * une nouvelle tuile.
 */
const REVEAL_OFFSETS: HexPosition[] = [
  {
    q: 3,
    r: -1,
  },
  {
    q: 1,
    r: 2,
  },
]

export function getRevealOptions(
  board: Board,
  player: Player,
): RevealOption[] {

  const placedTile =
    board.tiles.get(
      player.tileId,
    )

  if (!placedTile) {
    return []
  }

  /**
   * Pour le moment les révélations
   * partent uniquement de la tuile
   * de départ.
   */
  if (
    player.tileId !==
    board.startingTileId
  ) {
    return []
  }

  const center =
    placedTile.position

  return REVEAL_OFFSETS.map(
    (
      offset,
      index,
    ) => {

      const position:
        HexPosition = {
        q:
          center.q +
          offset.q,

        r:
          center.r +
          offset.r,
      }

      return {
        id:
          `reveal-${index}`,

        name:
          `Révélation ${index + 1}`,

        placements: [
          {
            position,

            /**
             * Orientation par défaut.
             *
             * Le joueur pourra la changer
             * lorsque nous implémenterons
             * la rotation.
             */
            orientation: 0,
          },
        ],
      }
    },
  )
}