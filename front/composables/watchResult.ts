// Watch Result
// Fix for known from a long time issue that causing cached results don't call onResult function.

/** ## Fix for onResult not working with cache enabled
 * ### example:
 * ```js
 * const {result} = useQuery(query)
 *
 * watchResult(result, (result) => {
 *  // Will always be called, even on cached queries
 *  console.log(result)
 * })
 * ```
 */
export const watchResult = <T>(result: Ref<T>, fn: (param: T) => void) => {
  watch(
    result,
    (newResult) => {
      if (newResult) return fn(newResult)
    },
    { immediate: true }
  )
}