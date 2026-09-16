<script setup lang="ts">
  // Types
  import type { Table } from '@tanstack/vue-table'
  import type { DeviceType, DeviceFilter, BasicDeviceTable } from '@/types/device'

  // GraphQl
  import DEVICE_TABLES_QUERY from '@/graphql/dna/device_tables.query.gql'
  import { useQuery } from '@vue/apollo-composable'

  // Icones
  import { X } from "@lucide/vue"

  // Props & Emits
  defineProps<{
    table: Table<DeviceType>
  }>()

  // Filtre v-model
  const filter = defineModel<DeviceFilter>()

  // Device Tables
  const { deviceTables, formatDeviceTableRow } = useDeviceTables()

  // Gestion du Filtre
  const { isFiltered, resetFilter } = useFilter()  

  // Compositions
  function useFilter() {
    // On enregsitre la valeur initiale
    const initialFilter = useClone(filter.value)

    // Boolean : a-ton filtré
    const isFiltered = computed(() => !isEqual(filter.value, initialFilter))

    // Reset du filtre
    const resetFilter = () => filter.value = useClone(initialFilter)

    return {initialFilter, isFiltered, resetFilter}  
  }

  function useDeviceTables() {
    // Recupération des device tables
    const { result, onError } = useQuery(DEVICE_TABLES_QUERY)

    onError((error) => {
      console.log('errors', error.errors)
    })

    const deviceTables = computed(() => result.value?.deviceTables || [])

    // Utilitaire : Formatage des device tables
    function formatDeviceTableRow(row: BasicDeviceTable) {
      return {
        value: parseInt(row.id),
        label: row.name,
        numberOfThings: row.numberOfDevices
      }
    }

    return { deviceTables, formatDeviceTableRow }
  }

</script>

<template>
  <div class="flex flex-1 items-center space-x-2">
    <Input
      placeholder="Filter hostname..."
      v-model="(filter as DeviceFilter).hostname"
      class="h-8 w-[150px] lg:w-[250px]"
    />
    <DataTableFacetedFilter
      v-model="(filter as DeviceFilter).deviceFamilyIds"
      title="Famille"
      :options="useMap(deviceTables?.deviceFamilies, formatDeviceTableRow)"
    />
    <DataTableFacetedFilter
      v-model="(filter as DeviceFilter).devicePlatformIdIds"
      title="Platform Id"
      :options="useMap(deviceTables?.devicePlatformIds, formatDeviceTableRow)"
    />
    <DataTableFacetedFilter
      v-model="(filter as DeviceFilter).deviceSoftwareTypeIds"
      title="Software Type"
      :options="useMap(deviceTables?.deviceSoftwareTypes, formatDeviceTableRow)"
    />
    <DataTableFacetedFilter
      v-model="(filter as DeviceFilter).deviceSeriesIds"
      title="Serie"
      :options="useMap(deviceTables?.deviceSeries, formatDeviceTableRow)"
    />
    <DataTableFacetedFilter
      v-model="(filter as DeviceFilter).deviceTypeIds"
      title="Device Type"
      :options="useMap(deviceTables?.deviceTypes, formatDeviceTableRow)"
    />
    <DataTableFacetedFilter
      v-model="(filter as DeviceFilter).deviceRoleIds"
      title="Role"
      :options="useMap(deviceTables?.deviceRoles, formatDeviceTableRow)"
    />

    <Button
      v-if="isFiltered"
      variant="ghost"
      class="h-8 px-2 lg:px-3"
      @click="resetFilter()"
    >
      Reset
      <X class="ml-2 h-4 w-4" />
    </Button>
  </div>
  <!-- @vue-generic DeviceType -->
  
</template>