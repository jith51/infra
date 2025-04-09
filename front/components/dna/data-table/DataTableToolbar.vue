<script setup lang="ts">
  // IMPORTS
  import DEVICE_TABLES_QUERY from '~/graphql/dna/device_tables.query.gql'

  import type { Table } from '@tanstack/vue-table'
  import type { DeviceType, DeviceFilter, BasicDeviceTable } from '@/types/device'
  
  import DataTableFacetedFilter from './DataTableFacetedFilter.vue'
  import DataTableViewOptions from './DataTableViewOptions.vue'

  import { useQuery } from '@vue/apollo-composable'

  import Cross2Icon from '@radix-icons/vue/Cross2Icon'

  interface DataTableToolbarProps {
    table: Table<DeviceType>
    filter: DeviceFilter
  }

  // PROPS
  const props = defineProps<DataTableToolbarProps>()

  const emit = defineEmits<{
    (e: 'filterChange', filter: DeviceFilter): void
  }>()

  // INITIALISATION DU FILTRE - EMISSION D'UN EVENT LORSQU'IL CHANGE
  const filter = reactive<DeviceFilter>(props.filter)

  watch(filter, (filterNew) => {
    emit('filterChange', filterNew)
  })

  const isFiltered = computed(() => 
    filter.hostname?.length != 0 ||
    useConcat(
      filter.deviceFamilyIds,
      filter.devicePlatformIdIds,
      filter.deviceRoleIds,
      filter.deviceSeriesIds,
      filter.deviceSoftwareTypeIds,
      filter.deviceTypeIds
    ).length != 0
  )

  // RECUPERATION DES TABLES DEVICES
  const { result, onError } = useQuery(DEVICE_TABLES_QUERY)

  const deviceTables = computed(() => {
    return result.value?.deviceTables || []
  })

  onError(({ graphQLErrors, networkError }) => {
    console.log('errors', graphQLErrors)
    console.log('errors', networkError)
  })

  // UTILITAIRES
  function formatDeviceTableRow(row: BasicDeviceTable) {
    return {
      value: parseInt(row.id),
      label: row.name,
      numberOfDevices: row.numberOfDevices
    }
  }

  function resetFilter() {
    Object.assign(filter, {
      _limit: 20,
      _page: 0,
      hostname: "",
      deviceFamilyIds: [],
      devicePlatformIdIds: [],
      deviceSoftwareTypeIds: [],
      deviceSeriesIds: [],
      deviceTypeIds: [],
      deviceRoleIds: [],
    })
  }
</script>

<template>
  <div class="flex items-center justify-between ps-1 pt-2">
    <div class="flex flex-1 items-center space-x-2">
      <Input
        placeholder="Filter hostname..."
        :model-value="props.filter.hostname"
        class="h-8 w-[150px] lg:w-[250px]"
        @input="filter.hostname = $event.target.value"
      />
      <DataTableFacetedFilter
        :filter="props.filter.deviceFamilyIds"
        title="Famille"
        :options="useMap(deviceTables?.deviceFamilies, formatDeviceTableRow)"
        @filter-change="(value) => filter.deviceFamilyIds = value"
      />
      <DataTableFacetedFilter
        :filter="props.filter.devicePlatformIdIds"
        title="Platform Id"
        :options="useMap(deviceTables?.devicePlatformIds, formatDeviceTableRow)"
        @filter-change="(value) => filter.devicePlatformIdIds = value"
      />
      <DataTableFacetedFilter
        :filter="props.filter.deviceSoftwareTypeIds"
        title="Software Type"
        :options="useMap(deviceTables?.deviceSoftwareTypes, formatDeviceTableRow)"
        @filter-change="(value) => filter.deviceSoftwareTypeIds = value"
      />
      <DataTableFacetedFilter
        :filter="props.filter.deviceSeriesIds"
        title="Serie"
        :options="useMap(deviceTables?.deviceSeries, formatDeviceTableRow)"
        @filter-change="(value) => filter.deviceSeriesIds = value"
      />
      <DataTableFacetedFilter
        :filter="props.filter.deviceTypeIds"
        title="Device Type"
        :options="useMap(deviceTables?.deviceTypes, formatDeviceTableRow)"
        @filter-change="(value) => filter.deviceTypeIds = value"
      />
      <DataTableFacetedFilter
        :filter="props.filter.deviceRoleIds"
        title="Role"
        :options="useMap(deviceTables?.deviceRoles, formatDeviceTableRow)"
        @filter-change="(value) => filter.deviceRoleIds = value"
      />

      <Button
        v-if="isFiltered"
        variant="ghost"
        class="h-8 px-2 lg:px-3"
        @click="resetFilter()"
      >
        Reset
        <Cross2Icon class="ml-2 h-4 w-4" />
      </Button>
    </div>
    <DataTableViewOptions :table="table" />
  </div>
</template>