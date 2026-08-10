// Watch Result
// Fix for known from a long time issue that causing cached results don't call onResult function.
export const watchResult = <T>(result: Readonly<Ref<T | undefined>>, callback: (param: T) => void) => {
  watch(
    result,
    (newResult) => {
      if (newResult) return callback(newResult)
    },
    { immediate: true }
  )
}