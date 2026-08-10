import PORT_TYPES from '@/graphql/physical/port_type/portTypes.query.gql'
import PORT_TYPE_MUTATION from '@/graphql/physical/port_type/portType.mutation.gql'
import PORT_TYPE_DELETE from '@/graphql/physical/port_type/deletePortType.mutation.gql'

import { useLazyQuery, useMutation } from '@vue/apollo-composable'

import type { PartialBy } from '@/types/partial_by'

type PortTypeType= {
    id : string
    name: string
}

type QueryReturnType = {
    portTypes: PortTypeType[]
}

type MutationReturnType = {
    portTypeMutation: PortTypeType
}

type DeleteReturnType = {
    deletePortType: {
        deletedId: string
    }
}

type PortTypeFormType = PartialBy<PortTypeType, 'id'>

export const usePortTypeGraphQl = () => {
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
        PORT_TYPES,
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
    const objects = computed(() =>  result.value?.portTypes as PortTypeType[] ?? [])

    /*
    |--------------------------------------------------------------------------
    | CREATE / UPDATE
    |--------------------------------------------------------------------------
    */
    const {
        mutate,
        onError: onMutationError,
    } = useMutation<MutationReturnType>(
        PORT_TYPE_MUTATION,
        {
            update(cache, { data }) {
                const portType =
                    data?.portTypeMutation

                if (!portType) { 
                    return
                }
                
                ApolloCacheManager.upsertInLists(
                    cache,
                    'portTypes',
                    {
                        ...portType,
                        __typename: 'PortTypeType',
                    },
                )
            },
        },
    )

    const mutateObject = (
        value: PortTypeFormType,
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
        PORT_TYPE_DELETE,
        {
            update(cache, { data }) {

                const deletedId =
                    data?.deletePortType.deletedId


                if (!deletedId) {
                    return
                }


                ApolloCacheManager.deleteEntity(
                    cache,
                    {
                        fieldName: 'portTypes',
                        typename: 'PortType',
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
