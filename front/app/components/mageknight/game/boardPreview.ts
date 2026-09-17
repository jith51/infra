import type {
  HexPosition,
} from './hexagon'

/**
 * Un emplacement théorique de tuile.
 */
export interface TilePreview {
  position: HexPosition

  /**
   * Niveau de profondeur
   *
   * 1 = directement autour des tuiles de départ
   * 2 = deuxième génération
   * 3 = troisième génération
   * 4 = quatrième génération
   */
  level: number
}

/**
 * Déplacements possibles du centre
 * d'une tuile vers une nouvelle tuile.
 *
 * Pour l'instant nous avons identifié
 * ces deux relations :
 *
 *       + (3,-1)
 *       + (1, 2)
 */
const TILE_OFFSETS: HexPosition[] = [
  {
    q: 3,
    r: -1,
  },

  {
    q: 1,
    r: 2,
  },
]

/**
 * Retourne une clé unique pour une position.
 */
function positionKey(
  position: HexPosition,
): string {
  return `${position.q}:${position.r}`
}

/**
 * Ajoute les deux destinations possibles
 * depuis une position.
 */
function getNextPositions(
  position: HexPosition,
): HexPosition[] {
  return TILE_OFFSETS.map(
    (offset) => ({
      q:
        position.q +
        offset.q,

      r:
        position.r +
        offset.r,
    }),
  )
}

/**
 * Génère les emplacements futurs
 * pendant plusieurs niveaux.
 *
 * Les positions déjà rencontrées sont
 * supprimées.
 */
export function generateTilePreviews(
  startingPositions: HexPosition[],
  levels: number,
): TilePreview[] {

  const previews: TilePreview[] = []

  /**
   * Positions déjà connues.
   *
   * On y place également les tuiles
   * de départ afin qu'elles ne soient
   * jamais proposées comme preview.
   */
  const known =
    new Set<string>()

  for (
    const position of startingPositions
  ) {
    known.add(
      positionKey(position),
    )
  }

  let currentPositions =
    startingPositions

  for (
    let level = 1;
    level <= levels;
    level++
  ) {

    const nextPositions: HexPosition[] = []

    for (
      const position of currentPositions
    ) {

      const candidates =
        getNextPositions(
          position,
        )

      for (
        const candidate of candidates
      ) {

        const key =
          positionKey(
            candidate,
          )

        /**
         * Une position déjà rencontrée
         * ne doit pas être ajoutée une
         * deuxième fois.
         */
        if (
          known.has(key)
        ) {
          continue
        }

        known.add(key)

        previews.push({
          position: candidate,
          level,
        })

        nextPositions.push(
          candidate,
        )
      }
    }

    currentPositions =
      nextPositions
  }

  return previews
}