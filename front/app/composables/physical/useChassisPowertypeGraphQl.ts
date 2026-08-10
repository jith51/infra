import CHASSIS_POWERTYPES from '@/graphql/physical/chassis_powertype/chassisPowertypes.query.gql'
import CHASSIS_POWERTYPE from '@/graphql/physical/chassis_powertype/chassisPowertype.mutation.gql'
import DELETE_CHASSIS_POWERTYPE from '@/graphql/physical/chassis_powertype/deleteChassisPowertype.mutation.gql'

import { useLazyQuery, useMutation } from '@vue/apollo-composable'

import type { ChassisPowertypeType } from '@/types/physical/chassis_powertype'
import type { ChassisPowertypeFormType } from '@/types/physical/chassis_powertype'

type ChassisPowertypeWithCounter = ChassisPowertypeType & {
    chassisClassesNumber: number
}

type QueryReturnType = {
    chassisPowertypes: ChassisPowertypeType[] | ChassisPowertypeWithCounter[]
}

type MutationReturnType = {
    chassisPowertype: ChassisPowertypeType
}

type DeleteReturnType = {
    deleteChassisPowertype: {
        deletedId: string
    }
}

export const useChassisPowertypeGraphQl = () => {
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
        CHASSIS_POWERTYPES,
        {
            fetchPolicy: 'cache-first',
        },
    )
    
    // Récupération de tous les powertypes
    const loadObjects = async () => {
        try { 
            await load()
        } catch (e) {
            // déjà géré par onQueryError
        }
    }

    const objects = computed(() =>  result.value?.chassisPowertypes as ChassisPowertypeType[] ?? [])
    
    // Récupération de tous les powertypes avec le nombre de chassis class associés
    const loadObjectsWithCounter = async () => {
        try { 
            await load({
                variables: {
                    withCounter: true
                }
            })
        } catch (e) {
            // déjà géré par onQueryError
        }
    }
    const objectsWithCounter = computed(() =>  result.value?.chassisPowertypes as ChassisPowertypeWithCounter[] ?? [])

    /*
    |--------------------------------------------------------------------------
    | CREATE / UPDATE
    |--------------------------------------------------------------------------
    */

    // Mutation
    const {
        mutate,
        onError: onMutationError,
        onDone: onMutationDone,
    } = useMutation<MutationReturnType>(
        CHASSIS_POWERTYPE,
        {
            update(cache, { data }) {
                const chassisPowertype =
                    data?.chassisPowertype

                if (!chassisPowertype) { 
                    return
                }
                
                ApolloCacheManager.upsertInLists(
                    cache,
                    'chassisPowertypes',
                    {
                        ...chassisPowertype,
                        __typename: 'ChassisPowertypeType',
                    },
                )
            },
        },
    )

    const mutateObject = (
        value: ChassisPowertypeFormType,
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
        onDone : onDeleteDone
    } = useMutation<DeleteReturnType>(
        DELETE_CHASSIS_POWERTYPE,
        {
            update(cache, { data }) {

                const deletedId =
                    data?.deleteChassisPowertype.deletedId

                if (!deletedId) {
                    return
                }

                ApolloCacheManager.deleteEntity(
                    cache,
                    {
                        fieldName: 'chassisPowertypes',
                        typename: 'ChassisPowertypeType',
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

        loadObjectsWithCounter,
        objectsWithCounter,

        mutateObject,
        onMutationError,
        onMutationDone,

        deleteObject,
        onDeleteError,
        onDeleteDone
    }
}
