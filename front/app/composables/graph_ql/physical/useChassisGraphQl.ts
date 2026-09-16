import ALL_CHASSIS from '@/graphql/physical/chassis/chassis.query.gql'
import CHASSIS_FILE from '@/graphql/physical/chassis/chassisFile.query.gql'
import CHASSIS from '@/graphql/physical/chassis/getChassisAndCo.query.gql'
import CHASSIS_MUTATION from '@/graphql/physical/chassis/chassis.mutation.gql'
import DELETE_CHASSIS from '@/graphql/physical/chassis/deleteChassis.mutation.gql'
import CHASSIS_FILTER_TABLES from '@/graphql/physical/chassis/chassisFilterTables.query.gql'
import UPLOAD_CHASSIS from '@/graphql/physical/chassis/uploadChassis.mutation.gql'


import type { ChassisType, ChassisFormType, ChassisFilterType, ChassisFilterTablesType } from '@/types/physical/chassis'
import type { ChassisClassType } from '@/types/physical/chassis_class'
import type { OptionType } from '@/types/base'


import { useLazyQuery, useMutation } from '@vue/apollo-composable'

type QueryReturnType = { 
    getChassis: ChassisType
    chassisClasses: OptionType[]
    tags: OptionType[]
    availablePorts: OptionType[]
}

type MutationReturnType = { 
    chassis: ChassisType
}
type DeleteReturnType = { 
    deleteChassis: { deletedId: string } 
}

// type baseFilterTableType = {
//     id: string,
//     name: string
// }

// type ReturnTagFilterTableType = baseFilterTableType & {
//     numberOfThings: number
// } 
// type ReturnChassisClassFilterTableType = baseFilterTableType & {
//     numberOfChassis: number
// } 

// type ReturnFilterTable = {
//     tags: ReturnTagFilterTableType[],
//     chassisClasses: ReturnChassisClassFilterTableType[]
// }
type ChassisFileData = {
  chassisFile: {
    filename: string;
    type: string;
    contentBase64: string;
  };
};

export const useChassisGraphQl = () => {
    // QUERYs
    // Récupération des chassis Classes
    const useDataTableQuery = () => {
        const { data: queryAllResult, noMoreData, filter, loadMore } = useFilterQueryWithRefetch<ChassisType, ChassisFilterType>({
            query: ALL_CHASSIS,
            dataName: 'chassis',
            initialFilter: { 
                name: '',
                tagIds: [],
                chassisClassIds: []
            },
            limit: 100
        })
        return { queryAllResult, noMoreData, filter, loadMore,}
    }

    // Récupération des classes pour le filtre
    const { result: filterTablesResult, load: loadTables, onError: onQueryFilterTablesError } = useLazyQuery<ChassisFilterTablesType>(CHASSIS_FILTER_TABLES, {
        fetchPolicy: 'cache-first'
    })
    const loadFilterTables = async () => {
        try { 
            await loadTables()
        } catch (e) {
            // déjà géré par onQueryError
        }
    }

    // Récupération d'un chassis
    const { result: queryResult, load: loadChassis, onError: onQueryError } = useLazyQuery<QueryReturnType>(CHASSIS, {
        fetchPolicy: 'cache-first'
    })
    const loadQuery = async (nameOrId?: string) => {
        try { 
            await loadChassis( { nameOrId: nameOrId })
        } catch (e) {
            // déjà géré par onQueryError
        }
    }
    
    // Récupération d'un fichier d'import
    const { result: fileResult, load: loadFileQuery, onError: onLoadFileError } = useLazyQuery<ChassisFileData>(CHASSIS_FILE,
        { fetchPolicy: "no-cache" }
    )
    const loadFile= async (variables: {structOnly: boolean, chassisClassId?: string | null}) => {
        try { 
            await loadFileQuery(variables)
        } catch (e) {
            // déjà géré par onQueryError
        }
    }

    // MUTATION
    // Upsert d'un Chassis
    const { mutate, onDone: onMutationDone, onError: onMutationError } = useMutation<MutationReturnType>(
        CHASSIS_MUTATION, 
        { 
            update(cache, { data }) {
                const chassis =
                    data?.chassis

                if (!chassis) { 
                    return
                }
                ApolloCacheManager.invalidateFields(cache,['chassis'])
                // ON supprime les queries des ports disponibles car plus valide
                ApolloCacheManager.invalidateFields(cache,['availablePorts'])
            },
        }
    )

    const mutateObject = (value: ChassisFormType) => mutate({
        variables: { input: value }
    })

    // Import de chassis 
    const { mutate: upload, onDone: onImportDone, onError: onImportError } = useMutation<{ uploadClasses: { success: boolean } }>(
        UPLOAD_CHASSIS,
        { 
            context: { hasUpload: true },
            update(cache, { data }) {
                const uploadChassis = data?.uploadClasses

                if (!uploadChassis) { 
                    return
                }
                
                ApolloCacheManager.invalidateFields(cache,['chassis'])
            },
        }
    )

    const importChassis = (value: File) => {
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
        DELETE_CHASSIS, {
        update(cache, { data }) {
            const deletedId = data?.deleteChassis.deletedId

            if (!deletedId) return

            ApolloCacheManager.deleteEntity(
                cache,
                {
                    fieldName: 'chassis',
                    typename: 'ChassisType',
                    id: deletedId,
                },
            )
            ApolloCacheManager.invalidateFields(cache,['availablePorts'])
        },
    })

    const deleteObject = (value: string) => deleteMutation({variables: {id: value}})

    return { 
        loadQuery,
        queryResult,
        onQueryError,

        loadFilterTables,
        filterTablesResult,
        onQueryFilterTablesError,
        
        useDataTableQuery,

        loadFile,
        fileResult,
        onLoadFileError,

        mutateObject,
        onMutationError,
        onMutationDone,

        importChassis,
        onImportDone,
        onImportError,

        deleteObject,
        onDeleteDone,
        onDeleteError
    }
}
