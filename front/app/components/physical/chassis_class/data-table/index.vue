<template>
  <DataTable :table="table" @load-more="loadMore()" :canloadMore="!noMoreData">
    <template #toolbar-filter>
      <Filter/>
    </template>
	<template #toolbar-options>
		<!-- Lien vers creation -->
		<CreateLink/>
		<!-- Upload File -->
		<Upload/>
		<!-- Download File -->
		<Download />
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
  
	// Types
	import type { ChassisClassType } from '@/types/physical/chassis_class'

	// API CALLs
	// On va rechercher les ChassisClasses
	const { useDataTableQuery } = useChassisClassGraphQl()
	const { queryAllResult: chassisClasses, noMoreData, filter, loadMore } = useDataTableQuery()

	// On va rechercher les Powertypes
	const { loadObjectsWithCounter, objectsWithCounter} = useChassisPowertypeGraphQl()
	loadObjectsWithCounter()
	
	// Déclaration de la table
	import { columns } from './columns'	
	const table = useChassisClassTable(chassisClasses, columns)

	// Construction du contex
	import { provideChassisClassesTableContext } from './context'
	provideChassisClassesTableContext({
		table: table,
		filter: filter,
		chassisPowertypes: objectsWithCounter
	})

	// Composition : construction de la table
	import type { VisibilityState, Updater, ColumnDef  } from '@tanstack/vue-table'
	import { getCoreRowModel, useVueTable, FlexRender } from '@tanstack/vue-table'

	function useChassisClassTable(data: Ref<ChassisClassType[]>, columnsDef: ColumnDef<ChassisClassType>[]) {
		const columnVisibility = ref<VisibilityState>({
			name: true,
			fournisseur: true,
			type: true,
			model: true,
			version: false,
			partNumber: false,
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