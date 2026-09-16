<template>
  <!-- @vue-generic ChassisType -->
  <DataTable :table="table" @load-more="loadMore()" :canloadMore="!noMoreData">
    <template #toolbar-filter>
      <Filter :table="table" v-model="filter"/>
    </template>
    <template #toolbar-options>
      <DataTableViewOptions :table="table" />
    </template>
    <template #row="{ row }">
      <TableRow>
        <TableCell v-for="cell in row.getVisibleCells()" :key="cell.id">
              <FlexRender :render="cell.column.columnDef.cell" :props="cell.getContext()" />
        </TableCell>
      </TableRow>
      <TableRow v-if="row.getIsExpanded()">
          <TableCell :colspan="columns.length" class="pl-20">
          <ExpandedCell 
              :switches="row['original']['switches']"
              :equipements="row['original']['equipements']"
              :eolBulletins="row['original']['eolBulletins']"
          />
          </TableCell>
      </TableRow>
    </template>
  </DataTable>
</template>

<script setup lang="ts">
  // Types
  import type { ExpandedState, VisibilityState, Updater, ColumnDef } from '@tanstack/vue-table'
  import type { DeviceType, DeviceFilter } from '@/types/device'

  import Filter from "./Filter.vue"

  // Device Filter default value
  import { defaultDeviceFilter } from '@/types/device'

  // GraphQl
  import DNA_DEVICES_QUERY from '@/graphql/dna/devices.query.gql'

  // Composants
  import ExpandedCell from './ExpandedCell.vue'
  import { columns } from './columns'

  // tansatck
  import { getCoreRowModel, useVueTable, FlexRender } from '@tanstack/vue-table'

  // Api calls
  const { data: devices, noMoreData, filter, loadMore } = useFilterQueryWithRefetch<DeviceType, DeviceFilter>({
    query: DNA_DEVICES_QUERY,
    dataName: 'devices',
    initialFilter: defaultDeviceFilter,
    limit: 100
  })

  // Tables
  const table = useTable(devices, columns)

  function useTable(data: Ref<DeviceType[]>, columnsDef: ColumnDef<DeviceType>[]) {

      const columnVisibility = ref<VisibilityState>({
        description: false,
        hostname: true,
        softwareVersion: true,
        macAddress: false,
        serialNumber: true,
        managementIp: true,
        location: false,
        uuid: false,
        deviceFamily: false,
        devicePlatformId: false,
        deviceSoftwareType: false,
        deviceSeries: false,
        deviceType: false,
        deviceRole: false,
      })

      const expanded = ref<ExpandedState>({})

      function valueUpdater<T extends Updater<any>>(updaterOrValue: T, ref: Ref) {
        ref.value
          = typeof updaterOrValue === 'function'
            ? updaterOrValue(ref.value)
            : updaterOrValue
      }

      const table = useVueTable({
        get data() { return data.value },
        get columns() { return columnsDef },
        state: {
          get expanded() { return expanded.value; },
          get columnVisibility() { return columnVisibility.value },
        },
        onColumnVisibilityChange: updaterOrValue => valueUpdater(updaterOrValue, columnVisibility),
        onExpandedChange: updaterOrValue => valueUpdater(updaterOrValue, expanded),
        getRowCanExpand: (row) => useConcat(row.original.equipements, row.original.switches, row.original.eolBulletins).length !=0,
        getCoreRowModel: getCoreRowModel(),
      })
      
      return table
  }

</script>