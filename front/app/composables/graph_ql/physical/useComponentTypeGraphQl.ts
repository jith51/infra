import COMPONENT_TYPES from '@/graphql/physical/component_type/componentTypes.query.gql'
import COMPONENT_TYPE_MUTATION from '@/graphql/physical/component_type/componentType.mutation.gql'
import COMPONENT_TYPE_DELETE from '@/graphql/physical/component_type/deleteComponentType.mutation.gql'


import { useLazyQuery, useMutation } from '@vue/apollo-composable'


import type { PartialBy } from '@/types/partial_by'

type ComponentTypeType= {
    id : string
    name: string
}


type QueryReturnType = {
    componentTypes: ComponentTypeType[]
}

type MutationReturnType = {
    componentTypeMutation: ComponentTypeType
}

type DeleteReturnType = {
    deleteComponentType: {
        deletedId: string
    }
}

type ComponentTypeFormType = PartialBy<ComponentTypeType, 'id'>

export const useComponentTypeGraphQl = () => {
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
        COMPONENT_TYPES,
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
    const objects = computed(() =>  result.value?.componentTypes as ComponentTypeType[] ?? [])

    /*
    |--------------------------------------------------------------------------
    | CREATE / UPDATE
    |--------------------------------------------------------------------------
    */
    const {
        mutate,
        onError: onMutationError,
    } = useMutation<MutationReturnType>(
        COMPONENT_TYPE_MUTATION,
        {
            update(cache, { data }) {
                const componentType =
                    data?.componentTypeMutation

                if (!componentType) { 
                    return
                }
                
                ApolloCacheManager.upsertInLists(
                    cache,
                    'componentTypes',
                    {
                        ...componentType,
                        __typename: 'ComponentTypeType',
                    },
                )
            },
        },
    )

    const mutateObject = (
        value: ComponentTypeFormType,
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
        COMPONENT_TYPE_DELETE,
        {
            update(cache, { data }) {

                const deletedId =
                    data?.deleteComponentType.deletedId


                if (!deletedId) {
                    return
                }


                ApolloCacheManager.deleteEntity(
                    cache,
                    {
                        fieldName: 'componentTypes',
                        typename: 'ComponentType',
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
