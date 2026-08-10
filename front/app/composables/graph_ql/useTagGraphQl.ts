import TAQ_MUTATION from '@/graphql/tag.mutation.gql'

import { useMutation } from '@vue/apollo-composable'

export const useTagGraphQl = (className: string) => {

    // Type
    type TagType = {
        value: string,
        label: string
    }

    // Defaults Callback
    const defaultOnSuccess = (value: TagType | number | string ): void => {console.log(value)}
    const defaultOnError = (graphQLErrors: any, networkError: any): void => {
        console.log(graphQLErrors)
        console.log(networkError)
    }

    // Query
    // const useTagQuery = () => {

    //     const data = ref<TagType[]>([])

    //     const { result, onError } = useQuery(TAQ_QUERY, {
    //         className: className
    //     })

    //     onError(({ graphQLErrors, networkError }) => defaultOnError(graphQLErrors, networkError))

    //     watchResult(result, (newResult) => {
    //         data.value = newResult.tagQuery
    //     })

    //     return data

    // }

    // Mutation
    const useCreateOrUpdateTag = (
        onSuccess: (value: TagType) => void = defaultOnSuccess,
        onError: (invalideRecord: any[], networkError: any) => void = defaultOnError
    ) => {

        const mutateTag = (value: TagType | { name: string }) => {
            
            const { mutate, onDone, onError: onMutationError } = useMutation(
                TAQ_MUTATION, { 
                    update: (cache, { data: { tag } }) => {

                        const updateCache = (existingTag: TagType[]): TagType[] => { return [...existingTag, tag]}

                        switch(className) {
                            case 'Tag': 
                                cache.modify({
                                    fields: { tags: (existingTag) => updateCache(existingTag) },
                                    broadcast: false
                                })
                                break
                            case 'Physical::InterfaceType': 
                                cache.modify({
                                    fields: { interfaceTypes: (existingTag) => updateCache(existingTag) },
                                    broadcast: false
                                })
                                break
                            case 'Physical::LinkType': 
                                cache.modify({
                                    fields: { linkTypes: (existingTag) => updateCache(existingTag) },
                                    broadcast: false
                                })
                                break
                            case 'Physical::ComponentType': 
                                cache.modify({
                                    fields: { componentTypes: (existingTag) => updateCache(existingTag) },
                                    broadcast: false
                                })
                                break
                        }
                    }
            })

            onDone(({ data }) => onSuccess(data['tag']))

            onMutationError(({ graphQLErrors, networkError }) => onError(
                useReduce(graphQLErrors, (result, value) => {
                    if (value?.invalid_record) result.push(value.invalid_record)
                    return result
                }, []),
                networkError))

                mutate(useMerge(value, {className: className}))
        }

        return mutateTag
    }

    return { useCreateOrUpdateTag }
    
}