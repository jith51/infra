export function useClearPhysicalElementClassesCache(cache, powertypeIds) {
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
