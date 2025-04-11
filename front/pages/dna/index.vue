<script setup lang="ts">
  // IMPORTS TYPES
  import type {
    ExpandedState,
    VisibilityState,
    Updater
  } from '@tanstack/vue-table'

  // AUTRES IMPORTS
  import { columns } from '@/components/dna/data-table/columns'
  
  import ExpandedCell from '@/components/dna/data-table/ExpandedCell.vue'
  import DataTableToolbar from'@/components/dna/data-table/DataTableToolbar.vue'

  import {
    FlexRender,
    getCoreRowModel,
    useVueTable,
  } from '@tanstack/vue-table'

  // UTILISATION DU COMPOSABLE useDnaDevicesQuery QUI GERE LES ACCES API
  const { queryVariables, devices, noMoreData, onFilterChange, loadMore } = useDnaDevicesQuery()

  // INITIALISATION DE LA TABLE
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
    get data() { return devices.value },
    get columns() { return columns },
    state: {
      get expanded() { return expanded.value; },
      get columnVisibility() { return columnVisibility.value },
    },
    onColumnVisibilityChange: updaterOrValue => valueUpdater(updaterOrValue, columnVisibility),
    onExpandedChange: updaterOrValue => valueUpdater(updaterOrValue, expanded),
    getRowCanExpand: (row) => useConcat(row.original.equipements, row.original.switches, row.original.eolBulletins).length !=0, 
    getCoreRowModel: getCoreRowModel(),
  })

  // INFINITE SCROLL
  const el = useTemplateRef<HTMLElement>('el')
 
  useInfiniteScroll(
    el,
    () => { loadMore() },
    { distance: 10, canLoadMore: () => { return !noMoreData.value } }
  )

</script>

<template>
  <div class=" w-full h-full flex flex-col gap-4">
    <DataTableToolbar
      :table="table"
      :filter="queryVariables"
      @filter-changed="onFilterChange"
    />
    <div ref="el" class=" relative rounded-md max-h-full border w-full overflow-auto">
      <table class="w-full caption-bottom text-sm">
        <TableHeader class="sticky top-0 bg-white z-10 [&_th]:after:border-b">
          <TableRow v-for="headerGroup in table.getHeaderGroups()" :key="headerGroup.id">
            <TableHead v-for="header in headerGroup.headers" :key="header.id" >
              <FlexRender v-if="!header.isPlaceholder" :render="header.column.columnDef.header" :props="header.getContext()"/>
            </TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <template 
            v-if="table.getRowModel().rows?.length"
            v-for="row in table.getRowModel().rows"
            :key="row.id"
          >
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
          <TableRow v-else>
            <TableCell
              :colspan="columns.length"
              class="h-24 text-center"
            >
              No results.
            </TableCell>
          </TableRow>
        </TableBody>
      </table>
    </div>
  </div>
</template>

<style scoped>
  th::after {
    content: '';
    position: absolute;
    left: 0;
    width: 100%;
    height: 100%;
    display: block;
    top : 0px;
  }
</style>
