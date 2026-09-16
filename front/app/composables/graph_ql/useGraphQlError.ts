import type { GraphQLFieldErrors, GraphQLApiError  } from '@/types/graphql'

// composables/useGraphqlError.ts

export const useGraphqlError = () => {
    const fieldErrors = ref<GraphQLFieldErrors>({})
    const code = ref<string>()
    const message = ref<string>()

    function handle(errors: readonly GraphQLApiError[]) {
        clear()

        const firstError = errors.at(0)

        if (!firstError) {
            return
        }

        message.value = firstError.message
        code.value = firstError.extensions?.code

        for (const error of errors) {
            const errorsByField = error.extensions?.field_errors

            if (errorsByField) {
                Object.assign(fieldErrors.value, errorsByField)
            }
        }
    }


    function getFieldError(field: string) {
        return fieldErrors.value[field]?.[0]
    }

    function getFieldErrors(field: string) {
        return fieldErrors.value[field] ?? []
    }

    function hasFieldError(field: string) {
        return !!fieldErrors.value[field]?.length
    }

    function clear() {
        fieldErrors.value = {}
        code.value = undefined
        message.value = undefined
    }

    return {
        fieldErrors,
        code,
        message,
        handle,
        getFieldError,
        getFieldErrors,
        hasFieldError,
        clear,
    }
}

// USAGE 
// const { mutate, onError } = useMutation(CREATE_TAG)

// Tu peux faire :

// const {
//   errors: fieldErrors,
//   handle: handleGraphqlError,
// } = useGraphqlError()

// Puis :

// onError((error) => {
//   if (CombinedGraphQLErrors.is(error)) {
//     const graphqlError = error.errors[0]

//     handleGraphqlError(graphqlError)
//   }
// })

// Tu récupères alors :

// fieldErrors.value

// qui contient :

// {
//   name: ['has already been taken'],
//   description: ['can't be blank']
// }