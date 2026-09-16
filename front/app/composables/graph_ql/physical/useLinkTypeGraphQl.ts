import LINK_TYPES from '@/graphql/physical/link_type/linkTypes.query.gql'
import LINk_TYPE_MUTATION from '@/graphql/physical/link_type/linkType.mutation.gql'
import LINK_TYPE_DELETE from '@/graphql/physical/link_type/deleteLinkType.mutation.gql'

import { useLazyQuery, useMutation } from '@vue/apollo-composable'

import type { PartialBy } from '@/types/partial_by'

type LinkTypeType = {
    id : string
    name: string
}

type QueryReturnType = {
    linkTypes: LinkTypeType[]
}

type MutationReturnType = {
    linkTypeMutation: LinkTypeType
}

type DeleteReturnType = {
    deleteLinkType: {
        deletedId: string
    }
}

type LinkTypeFormType = PartialBy<LinkTypeType, 'id'>

export const useLinkTypeGraphQl = () => {
   /*
    |--------------------------------------------------------------------------
    | QUERY
    |--------------------------------------------------------------------------
    */
    const {
        result,
        load,
        onError: onLoadError,
    } = useLazyQuery<QueryReturnType>(
        LINK_TYPES,
        {
            fetchPolicy: 'cache-first',
        },
    )

    const loadObjects = async () => {
        try { 
            await load()
        } catch (e) {
            // déjà géré par onQueryError
        }
    }

    // useLazyQuey retourne un DeepPartial, on indique a TS que l'object est complet
    const objects = computed(() =>  result.value?.linkTypes as LinkTypeType[] ?? [])
    /*
    |--------------------------------------------------------------------------
    | CREATE / UPDATE
    |--------------------------------------------------------------------------
    */
    const {
        mutate,
        onError: onMutationError,
    } = useMutation<MutationReturnType>(
        LINk_TYPE_MUTATION,
        {
            update(cache, { data }) {
                const linkType =
                    data?.linkTypeMutation

                if (!linkType) { 
                    return
                }
                
                ApolloCacheManager.upsertInLists(
                    cache,
                    'linkTypes',
                    {
                        ...linkType,
                        __typename: 'LinkTypeType',
                    },
                )
            },
        },
    )

    const mutateObject = (
        value: LinkTypeFormType,
    ) => {

        return mutate({
            variables: {
                input: value,
            },
        })
    }

    /*
    |--------------------------------------------------------------------------
    | DELETE
    |--------------------------------------------------------------------------
    */
    const {
        mutate: deleteMutation,
        onError: onDeleteError,
    } = useMutation<DeleteReturnType>(
        LINK_TYPE_DELETE,
        {
            update(cache, { data }) {

                const deletedId =
                    data?.deleteLinkType.deletedId


                if (!deletedId) {
                    return
                }


                ApolloCacheManager.deleteEntity(
                    cache,
                    {
                        fieldName: 'linkTypes',
                        typename: 'Linkype',
                        id: deletedId,
                    },
                )
            },
        },
    )


    const deleteObject = (
        id: string,
    ) => {

        return deleteMutation({
            variables: {
                id,
            },
        })
    }

    return {
        loadObjects,
        objects,
        onLoadError,

        mutateObject,
        onMutationError,

        deleteObject,
        onDeleteError,
    }
}
