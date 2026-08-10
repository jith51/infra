<script setup lang="ts" generic="T">
  import type { Table } from '@tanstack/vue-table'

  import { Columns3Cog } from "@lucide/vue"
  // import MixerHorizontalIcon from '@radix-icons/vue/MixerHorizontalIcon'

  const props = defineProps<{
    table: Table<T>
  }>()

  const columns = computed(() => props.table.getAllColumns()
    .filter(column => typeof column.accessorFn !== 'undefined' && column.getCanHide()))
</script>

<template>
  	<DropdownMenu>
		<DropdownMenuTrigger as-child>
			<DefaultTooltip text="Toggle des colonnes">
			<Button
					variant="outline"
					size="sm"
					class="ml-auto hidden h-8 lg:flex"
				>
					<Columns3Cog class="h-4 w-4" />
				</Button>
			</DefaultTooltip>
		</DropdownMenuTrigger>
		<DropdownMenuContent align="end" class="w-[250px]">
			<DropdownMenuLabel>Toggle columns</DropdownMenuLabel>
			<DropdownMenuSeparator />
			<DropdownMenuCheckboxItem
				v-for="column in columns"
				:key="column.id"
				class="capitalize"
				:model-value="column.getIsVisible()"
				@update:model-value="(value) => column.toggleVisibility(!!value)"
			>
				{{ column.id }}
			</DropdownMenuCheckboxItem>
		</DropdownMenuContent>
	</DropdownMenu>
</template>