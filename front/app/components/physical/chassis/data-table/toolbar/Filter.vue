<template>
    <Input
      placeholder="Nom..."
      v-model="filter.name"
      class="h-8 w-37.5 lg:w-62.5"
    />
    <DataTableFacetedFilter
      title="Chassis Classes"
      :options="filterTablesOptions.chassisClasses"
      v-model="filter.chassisClassIds"
    />
    <DataTableFacetedFilter
      title="Tags"
      :options="filterTablesOptions.tags"
      v-model="filter.tagIds"
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
</template>

<script setup lang="ts">
    import { X } from "@lucide/vue"
    import type { ChassisFilterTablesType, ChassisFilterType } from "@/types/physical/chassis";

    const props = defineProps<{
      filterTables: ChassisFilterTablesType
    }>()

    const filter = defineModel<ChassisFilterType>({
      default: () =>  ({ name: '', tagIds: [], chassisClassIds: [] })
    })

    const filterTablesOptions = computed(() => {
      return {
        tags: props.filterTables?.tags?.map(({ id, name, numberOfThings }) => ({ value: id, label: name, numberOfThings: numberOfThings})) || [],
        chassisClasses: props.filterTables?.chassisClasses?.map(({ id, name, numberOfChassis }) => ({ value: id, label: name, numberOfThings: numberOfChassis})) || [],
      }
    })

    // On enregsitre la valeur initiale
    const initialFilter = useClone(filter.value)

    // Boolean : a-ton filtré
    const isFiltered = computed(() => !isEqual(filter.value, initialFilter))

    // Reset du filtre
    const resetFilter = () => filter.value = useClone(initialFilter)

</script>