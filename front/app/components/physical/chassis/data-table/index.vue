<template>
  <!-- @vue-generic ChassisType -->
  <DataTable :table="table" @load-more="loadMore()" :canloadMore="!noMoreData">
    <template #toolbar-filter>
      <Filter v-model="filter" :filterTables="(filterTablesResult as ChassisFilterTablesType)"/>
    </template>
	<template #toolbar-options>
		<!-- Lien vers creation -->
		<CreateLink/>
		<!-- Upload File -->
		<Upload/>
		<!-- Download File -->
		<Download :chassis-classes="(filterTablesResult?.chassisClasses as OptionType[]) ?? []"/>
		<!-- Selection des colonnes -->
		<DataTableViewOptions :table="table" />
	</template>
    <template #row="{ row }">
      <TableRow>
        <TableCell v-for="cell in row.getVisibleCells()" :key="cell.id">
          <FlexRender :render="cell.column.columnDef.cell" :props="cell.getContext()"/>
        </TableCell>
      </TableRow>
    </template>
  </DataTable>
</template>

<script setup lang="ts">
  	// Composants
	import Download from './toolbar/Download.vue'
	import CreateLink from './toolbar/CreateLink.vue'
	import Filter from './toolbar/Filter.vue'
	import Upload from './toolbar/Upload.vue'

	import type { ChassisType, ChassisFilterTablesType } from '@/types/physical/chassis'
	import type { OptionType } from '@/types/base'

	// API CALLs
	// On va rechercher les Chassis et les tables de filtres
	const { useDataTableQuery, loadFilterTables, filterTablesResult } = useChassisGraphQl()
	const { queryAllResult: chassis, noMoreData, filter, loadMore } = useDataTableQuery()
	
	await loadFilterTables()
    
	// Déclaration de la table
	import { columns } from './columns'	
	const table = useChassisTable(chassis, columns)

	// Composition : construction de la table
	import type { VisibilityState, Updater, ColumnDef  } from '@tanstack/vue-table'
	import { getCoreRowModel, useVueTable, FlexRender } from '@tanstack/vue-table'

	function useChassisTable(data: Ref<ChassisType[]>, columnsDef: ColumnDef<ChassisType>[]) {
		const columnVisibility = ref<VisibilityState>({
			name: true,
      model: true,
      type: true,
      serialNumber: true,
      tags: true
		}) 

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
			get columnVisibility() { return columnVisibility.value },
			},
			onColumnVisibilityChange: updaterOrValue => valueUpdater(updaterOrValue, columnVisibility),
			getCoreRowModel: getCoreRowModel(),
		})
		
		return table
	}

</script>