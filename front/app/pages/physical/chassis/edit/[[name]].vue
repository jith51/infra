<template>
    <PhysicalChassisForm
        v-if="!hasError"
        :chassis="(queryResult?.getChassis as ChassisType || undefined)"
        :chassisClasses="(queryResult?.chassisClasses as OptionType[])"
        :tags="(queryResult?.tags as OptionType[])"
        :componentTypes="(queryResult?.componentTypes as OptionType[])"
        :portTypes="(queryResult?.portTypes as OptionType[])"
    />
</template>

<script setup lang="ts">
    // Toast
    import { toast } from 'vue-sonner'
    import type { ChassisType } from '@/types/physical/chassis'
    import type { OptionType } from '@/types/base'

    // Récupération du param id de la route
    const route = useRoute()
    const chassisNameOrId = route.params.name as string

    const hasError = ref(false)

    // Composition : Recupération du ChassisClass en base
    const {  loadQuery, queryResult, onQueryError} = useChassisGraphQl()
    onQueryError(() => {
        // si un nom ou id est passé mais qu'il n'existe pas
        // TODO --> à développer pour etre plus precis
        if (chassisNameOrId != '') {
            hasError.value = true
            toast('Chassis non existant.')
        }
    })
    await loadQuery(chassisNameOrId)
    
</script>