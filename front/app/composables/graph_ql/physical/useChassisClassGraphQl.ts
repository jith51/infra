import CHASSIS_CLASS from '@/graphql/physical/chassis_class/chassisClass.query.gql'
import CHASSIS_CLASSES_FILE from '@/graphql/physical/chassis_class/chassisClassesFile.query.gql'
import CHASSIS_CLASS_MUTATION from '@/graphql/physical/chassis_class/chassisClass.mutation.gql'
import DELETE_CHASSIS_CLASS from '@/graphql/physical/chassis_class/deleteChassisClass.mutation.gql'
import CHASSIS_CLASSES from '@/graphql/physical/chassis_class/chassisClasses.query.gql'
import UPLOAD_CHASSIS_CLASSES from '@/graphql/physical/chassis_class/uploadChassisClasses.mutation.gql'

import { useLazyQuery, useMutation } from '@vue/apollo-composable'

import type { ChassisClassType, ChassisClassFormType, ChassisClassFilterType } from '@/types/physical/chassis_class'
import type { ChassisPowertypeType } from '@/types/physical/chassis_powertype'


type QueryReturnType = { 
    chassisClass: ChassisClassType
    chassisPowertypes: ChassisPowertypeType[]
}
type MutationReturnType = { 
    chassisClass: ChassisClassType
}
type DeleteReturnType = { 
    deleteChassisClass: { deletedId: string } 
}

type ChassisClassesFileData = {
  chassisClassesFile: {
    filename: string;
    type: string;
    contentBase64: string;
  };
};

export const useChassisClassGraphQl = () => {
    // QUERYs
    // Récupération des chassis Classes
    const useDataTableQuery = () => {
        const { data: queryAllResult, noMoreData, filter, loadMore } = useFilterQueryWithRefetch<ChassisClassType, ChassisClassFilterType>({
            query: CHASSIS_CLASSES,
            dataName: 'chassisClasses',
            initialFilter: { 
                name: '',
                chassisPowertypeIds: []
            },
            limit: 100
        })
        return { queryAllResult, noMoreData, filter, loadMore,}
    }

    // Récupération d'un chassis class
    const { result: queryResult, load, onError: onQueryError, refetch: refetchChassisClass } = useLazyQuery<QueryReturnType>(CHASSIS_CLASS, {
        fetchPolicy: 'cache-first'
    })
    const loadQuery = async (nameOrId?: string, onlyChassisClass?: boolean) => {
        if (!queryResult.value) {
            try { 
                await load( { nameOrId: nameOrId, onlyChassisClass: onlyChassisClass || false})
            } catch (e) {
                // géré par onQueryError
            }
            return
        }
        try { 
            await refetchQuery(nameOrId, onlyChassisClass)
        } catch (e) {
            // géré par onQueryError
        }
    }

    const refetchQuery = async (nameOrId?: string, onlyChassisClass?: boolean) => {
        try { 
            await refetchChassisClass( { nameOrId: nameOrId, onlyChassisClass: onlyChassisClass || undefined}) 
        } catch (e) {
            // géré par onQueryError
        }
    }

    // Récupération d'un fichier d'import
    const { result: fileResult, load: loadFileQuery, onError: onLoadFileError } = useLazyQuery<ChassisClassesFileData>(CHASSIS_CLASSES_FILE,
        { fetchPolicy: "no-cache" }
    )
    const loadFile= async (variables: {structOnly: boolean, chassisPowertypeId?: string | null}) => {
        try { 
            await loadFileQuery(variables)
        } catch (e) {
            // déjà géré par onQueryError
        }
    }

    // MUTATION
    // Upsert d'un Chassis Class
    const { mutate, onDone: onMutationDone, onError: onMutationError } = useMutation<MutationReturnType>(
        CHASSIS_CLASS_MUTATION, 
        { 
            update(cache, { data }) {
                const chassisClass =
                    data?.chassisClass

                if (!chassisClass) { 
                    return
                }
                
                ApolloCacheManager.invalidateFields(cache,['chassisClasses'])
            },
        }
    )

    const muteChassisClass = (value: ChassisClassFormType) => mutate({
        variables: { input: value }
    })

    // Import de chassis classes 
    const { mutate: upload, onDone: onImportDone, onError: onImportError } = useMutation<{ uploadChassisClasses: { success: boolean } }>(
        UPLOAD_CHASSIS_CLASSES,
        { 
            context: { hasUpload: true },
            update(cache, { data }) {
                const uploadChassisClasses = data?.uploadChassisClasses

                if (!uploadChassisClasses) { 
                    return
                }
                
                ApolloCacheManager.invalidateFields(cache,['chassisClasses'])
            },
        }
    )

    const importChassisClasses = (value: File) => {
        upload({
            variables: {
                input: {
                    file: value
                }
            }
        })
    }

    // SUPPRESSION
    const { mutate: deleteMutation, onError: onDeleteError, onDone: onDeleteDone } = useMutation<DeleteReturnType>(
        DELETE_CHASSIS_CLASS, {
        update(cache, { data }) {
            const deletedId = data?.deleteChassisClass.deletedId

            if (!deletedId) return

            ApolloCacheManager.deleteEntity(
                cache,
                {
                    fieldName: 'chassisClasses',
                    typename: 'ChassisClassType',
                    id: deletedId,
                },
            )
        },
    })

    const deleteChassisClass = (value: string) => deleteMutation({variables: {id: value}})

    return { 
        useDataTableQuery,
        
        loadQuery,
        queryResult,
        onQueryError,

        loadFile,
        fileResult,
        onLoadFileError,

        muteChassisClass,
        onMutationError,
        onMutationDone,

        importChassisClasses,
        onImportDone,
        onImportError,

        deleteChassisClass,
        onDeleteDone,
        onDeleteError
    }
}
