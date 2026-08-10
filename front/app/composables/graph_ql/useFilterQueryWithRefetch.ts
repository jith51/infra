import { useLazyQuery } from '@vue/apollo-composable'
import { watchResult } from '../watchResult'

export const useFilterQueryWithRefetch = <T extends Record<string, any>, N extends Record<string, any>>(options: {
    // T : Type des datas - N : Type du filtre
    query: any,
    dataName: string,
    initialFilter: N,
    limit: number | undefined
}) => {
    // Type du résultat de la query
    type R = {
        [K in typeof options.dataName]: T[]
    }
    // Filtre
    const filter = ref<N>(options.initialFilter)

    // Data
    const data = shallowRef<T[]>([])

    // Variable de Base
    const baseQueryVariables = { limit: options.limit ?? 50, page: 0 }

    // Query GraphQl
    const { result, fetchMore, load, loading } = useLazyQuery<R>(options.query, {
        variables: baseQueryVariables, 
        fetchPolicy:'cache-first'
    })

    // Fetch de data supplémentaire
    const loadMore = () => {
        fetchMore({
            variables: {
                page: (data.value.length),
            },
            updateQuery(previousQueryResult, { fetchMoreResult }) { 
                fetchMoreResult[options.dataName] = [ ...previousQueryResult[options.dataName]||[], ...(fetchMoreResult[options.dataName] ?? []) ]
                return fetchMoreResult
            }
        })
    }

    // Mise à jour des datas en retour de query
    watchResult(result, (newResult) => { data.value = <T[]>newResult[options.dataName] || [] })

    // Load de la query dès que le filtre change (execute une première fois la queru également)
    watch(filter, (newFilter) => { if (newFilter) load({...baseQueryVariables, ...newFilter}) }, { deep: true, immediate: true })

    // Boolean indiquant qu'il n'y a plus de data à aller rechercher
    const noMoreData = computed(() => {
        return loading.value || data.value.length == 0 || data.value.length % baseQueryVariables.limit != 0
    })

    return { data, noMoreData, filter, loadMore }

}