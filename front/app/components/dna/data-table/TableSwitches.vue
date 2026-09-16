<script setup lang="ts">
  // Types
  import type { ColumnDef, ExpandedState, Updater } from '@tanstack/vue-table'
  import type { SwitchType } from '@/types/device'

  // Tanstack table
  import { FlexRender, getCoreRowModel, useVueTable } from '@tanstack/vue-table'

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
  <!-- @vue-generic SwitchType -->
  <DataTable :table="table">
    <template #row="{ row }">
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
  </DataTable>
</template>