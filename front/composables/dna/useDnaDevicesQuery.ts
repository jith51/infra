import DNA_DEVICES_QUERY from '~/graphql/dna/devices.query.gql'
import { useQuery } from '@vue/apollo-composable'

import type { DeviceFilter } from '@/types/device'

export const useDnaDevicesQuery = () => {

  const queryVariables = ref<DeviceFilter>({
      _limit: 40,
      _page: 0,
      hostname: "",
      deviceFamilyIds: [],
      devicePlatformIdIds: [],
      deviceSoftwareTypeIds: [],
      deviceSeriesIds: [],
      deviceTypeIds: [],
      deviceRoleIds: [],
  })

  const { result, fetchMore, refetch, loading } = useQuery(DNA_DEVICES_QUERY, queryVariables)

  const loadMore = () => {
      fetchMore({
          variables: {
              _page: (devices.value.length) + 20,
          },
          updateQuery(previousData, { fetchMoreResult}) {
              return {devices: [ ...previousData.devices||[], ...fetchMoreResult.devices ]}
          }
      })
  }

  const devices = computed(() => {
      return result.value?.devices || []
  })

  const noMoreData = computed(() => {
      return !(loading || (result.value?.devices % (queryVariables.value._limit||0) != 0))
  })

  function onFilterChange(filter: DeviceFilter) {
      queryVariables.value._page = 0
      useMerge(queryVariables.value, filter) //lodash
      refetch(queryVariables.value)
  }

 return { queryVariables, devices, noMoreData, onFilterChange, loadMore }

}