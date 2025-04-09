<script setup lang="ts">
  // IMPORTS
  import type {
    ColumnDef,
    ExpandedState,
    Updater,
  } from '@tanstack/vue-table'

  import type { SwitchType } from '@/types/device'

  import {
    FlexRender,
    getCoreRowModel,
    useVueTable,
  } from '@tanstack/vue-table'

  import TableEquipements from './TableEquipements.vue'
  
  // PROPS
  interface DataTableProps {
    columns: ColumnDef<SwitchType, any>[]
    data: SwitchType[]
  }

  const props = defineProps<DataTableProps>()

  const expanded = ref<ExpandedState>({})

  function valueUpdater<T extends Updater<any>>(updaterOrValue: T, ref: Ref) {
    ref.value
      = typeof updaterOrValue === 'function'
        ? updaterOrValue(ref.value)
        : updaterOrValue
  }

  const table = useVueTable({
    get data() { return props.data },
    get columns() { return props.columns },
    state: {
      get expanded() { return expanded.value; },
    },
    onExpandedChange: updaterOrValue => valueUpdater(updaterOrValue, expanded),
    // Add your logic to determine if a row can be expanded. True means all rows include expanded data
    getRowCanExpand: (row) => (row.original.equipements ||[]).length !=0, 
    getCoreRowModel: getCoreRowModel(),
  })
</script>

<template>
  <table class="w-full caption-bottom border text-sm">
    <TableHeader class="border-b">
      <TableRow v-for="headerGroup in table.getHeaderGroups()" :key="headerGroup.id">
        <TableHead v-for="header in headerGroup.headers" :key="header.id" >
          <FlexRender v-if="!header.isPlaceholder" :render="header.column.columnDef.header" :props="header.getContext()"/>
        </TableHead>
      </TableRow>
    </TableHeader>
    <TableBody>
      <template 
        v-for="row in table.getRowModel().rows"
        :key="row.id"
      >
        <TableRow :data-state="row.getIsSelected() && 'selected'">
          <TableCell v-for="cell in row.getVisibleCells()" :key="cell.id">        
            <FlexRender :render="cell.column.columnDef.cell" :props="cell.getContext()" />
          </TableCell>
        </TableRow>
        <TableRow v-if="row.getIsExpanded()">
          <TableCell 
            :colspan="columns.length"
            class="p-4 pl-20"
          >
            <div class="w-1/2">
              <div class="pb-2">Equipements</div>
              <TableEquipements :equipements="row['original']['equipements']"/>
            </div>
          </TableCell>
        </TableRow>
      </template>
    </TableBody>
  </table>
</template>