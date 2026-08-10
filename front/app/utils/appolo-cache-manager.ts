import type {
    ApolloCache,
    Reference,
    StoreObject,
} from '@apollo/client'


export class ApolloCacheManager {

	/**
	 * Ajoute ou met à jour une entité dans toutes les listes
	 * correspondant au champ GraphQL.
	 *
	 * Exemple :
	 *
	 * componentTypes
	 * componentTypes(page:1)
	 * componentTypes(filter:{name:"router"})
	 *
	 * seront toutes mises à jour.
	 */
	static upsertInLists<T extends StoreObject>(
		cache: ApolloCache,
		fieldName: string,
		item: T,
	) {

		cache.modify({
			fields: {
				// La clé dynamique permet de cibler le champ
				// quelle que soit sa configuration d'arguments
				[fieldName](
					existing: readonly (Reference | StoreObject)[] = [],
					{ readField, toReference },
				) {
					const id = readField('id', item)

					const exists = existing.some(
						ref => readField('id', ref) === id
					)

					// L'objet existe déjà dans la liste.
					// Apollo a déjà mis à jour l'entité normalisée.
					if (exists) {
						return existing
					}

					const reference = toReference(item, true)

					return reference ? [...existing, reference] : existing
				},
			},
		})
	}

	/**
	 * Supprime une entité dans toutes les listes
	 * ayant ce nom de champ.
	 */
	static removeFromAllLists(
		cache: ApolloCache,
		fieldName: string,
		id: string,
	) {

		cache.modify({
			fields: {

				[fieldName](
					existing: readonly (Reference | StoreObject)[] = [],
					{ readField },
				) {
					return existing.filter( item => readField('id', item) !== id)
				},
			},
		})
	}


	/**
	 * Supprime une entité du cache normalisé Apollo.
	 */
	static evictEntity(
		cache: ApolloCache,
		typename: string,
		id: string,
	) {
		cache.evict({
			id: cache.identify({
				__typename: typename,
				id,
			}),
		})

		cache.gc()
	}

	/**
	 * Suppression complète :
	 *
	 * - retrait des listes
	 * - suppression de l'entité Apollo
	 */
	static deleteEntity(
		cache: ApolloCache,
		options: {
			fieldName: string
			typename: string
			id: string
		},
	) {

		this.removeFromAllLists(
			cache,
			options.fieldName,
			options.id,
		)


		this.evictEntity(
			cache,
			options.typename,
			options.id,
		)
	}
	
    /**
     * Invalide un champ de ROOT_QUERY.
     *
     * Utile quand les listes ont :
     * - des filtres
     * - des tris
     * - des pages
     *
     * Exemple :
     *
     * componentTypes()
     * componentTypes(filter:{})
     * componentTypes(orderBy:name)
     *
     * seront supprimés.
     */
    static invalidateField(
        cache: ApolloCache,
        fieldName: string,
    ) {

        const rootQuery = cache.identify({
            __typename: 'Query',
        })

        cache.evict({
            id: rootQuery,
            fieldName,
        })

        cache.gc()
    }

    /**
     * Invalide plusieurs queries.
     */
    static invalidateFields(
        cache: ApolloCache,
        fields: string[],
    ) {

        const rootQuery = cache.identify({
            __typename: 'Query',
        })


        fields.forEach(fieldName => {

            cache.evict({
                id: rootQuery,
                fieldName,
            })

        })


        cache.gc()
    }
}
