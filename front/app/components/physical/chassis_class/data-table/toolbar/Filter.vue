<template>
    <Input
      placeholder="Nom..."
      v-model="filter.name"
      class="h-8 w-37.5 lg:w-62.5"
    />
    <DataTableFacetedFilter
      title="Type"
      :options="chassisPowertypesOptions"
      v-model="filter.chassisPowertypeIds"
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

    // Récupération le context
    import { useChassisClassesTableContext } from '../context'
    const { chassisPowertypes, filter } = useChassisClassesTableContext()

    const chassisPowertypesOptions = computed(() => chassisPowertypes.value.map(({ id, name, chassisClassesNumber }) => ({
        value: id,
        label: name,
        numberOfThings: chassisClassesNumber
    })))

    // On enregsitre la valeur initiale
    const initialFilter = useClone(filter.value)

    // Boolean : a-ton filtré
    const isFiltered = computed(() => !isEqual(filter.value, initialFilter))

    // Reset du filtre
    const resetFilter = () => filter.value = useClone(initialFilter)

</script>