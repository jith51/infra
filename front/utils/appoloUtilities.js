export function handleApolloErrors(graphQLErrors, networkError, operation, forward) {
  if (graphQLErrors != undefined) {
    graphQLErrors.forEach((err) => {
      setErrors('PhysicalElementClassForm', err?.invalid_record ?? err.message)
    })
  }
  console.log('errors', graphQLErrors)
  console.log('errors', networkError)
  console.log('errors', operation)
  console.log('errors', forward)
}



export function clearPhysicalElementClassesCache(cache, powertypeIds) {
  const rootQuery = cache.data.data.ROOT_QUERY;

  powertypeIds.forEach((element) => {
    const filter = new RegExp('physicalElementClasses.*"powertypeId":"' + element + '".*')
    Object.keys(rootQuery).forEach((key) => {
      if (key.match(filter)) {
        cache.evict({ id: "ROOT_QUERY", fieldName: key })
      }
    })

    cache.gc()
  })
}

// export { handleApolloErrors, clearPhysicalElementClassesCache }