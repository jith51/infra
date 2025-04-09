
import { Ref, watch } from "vue"

// Async Result
// Function that returns result from query as Promise , helpful with actually in experimental state Suspense feature and removing overhead from simple async functions.

/**
 * ## Function that returns result from query as `Promise`
 * ### example:
 * ```js
 * const {result} = useQuery(query)
 *
 * const result = await asyncResult(result)
 * ```
 */
export const asyncResult = async <T>(result: Ref<T>): Promise<T> => {
  return await new Promise((resolve) => {
    watch(
      result,
      (newResult) => {
        if (newResult) resolve(newResult)
      },
      { immediate: true }
    )
  })
}