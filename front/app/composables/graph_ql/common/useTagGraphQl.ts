import TAGS from '@/graphql/common/tag/tags.query.gql'
import TAG_MUTATION from '@/graphql/common/tag/tag.mutation.gql'
import TAG_DELETE from '@/graphql/common/tag/deleteTag.mutation.gql'

import { useLazyQuery, useMutation } from '@vue/apollo-composable'

type TagType = {
    id : string
    name: string
    numberOfThings?: number
}

type QueryReturnType = {
    tags: TagType[]
}

type MutationReturnType = {
    tag: TagType
}

type DeleteReturnType = {
    deleteTag: {
        deletedId: string
    }
}

export const useTagGraphQl = () => {
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
        TAGS,
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
    const objects = computed(() =>  result.value?.tags as TagType[] ?? [])

    /*
    |--------------------------------------------------------------------------
    | CREATE / UPDATE
    |--------------------------------------------------------------------------
    */
    const {
        mutate,
        onError: onMutationError,
    } = useMutation<MutationReturnType>(
        TAG_MUTATION,
        {
            update(cache, { data }) {
                const tag =
                    data?.tag

                if (!tag) { 
                    return
                }
                
                ApolloCacheManager.upsertInLists(
                    cache,
                    'tags',
                    {
                        ...tag,
                        __typename: 'Tag',
                    },
                )
            },
        },
    )

    const mutateObject = (
        value: string,
    ) => {

        return mutate({
            variables: {
                input: {
                    name: value,
                }
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
        TAG_DELETE,
        {
            update(cache, { data }) {

                const deletedId =
                    data?.deleteTag.deletedId


                if (!deletedId) {
                    return
                }


                ApolloCacheManager.deleteEntity(
                    cache,
                    {
                        fieldName: 'tags',
                        typename: 'Tag',
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
