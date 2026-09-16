<template>
    <PhysicalChassisForm
        v-if="printForm"
        :chassis="(queryResult?.getChassis as ChassisType || undefined)"
        :chassisClasses="(queryResult?.chassisClasses as OptionType[])"
        :tags="(queryResult?.tags as OptionType[])"
        :availablePorts="(queryResult?.availablePorts as OptionType[])"
        @chassisUpdated="async (v) => {
            debugger
            await navigateTo(`/physical/chassis/edit/${v.name}`)
        }"
    />
</template>

<script setup lang="ts">
    // Toast
    // import { toast } from 'vue-sonner'
    import type { ChassisType } from '@/types/physical/chassis'
    import type { OptionType } from '@/types/base'

    // Récupération du param id de la route
    const route = useRoute()
    const chassisNameOrId = route.params.name as string
 
    // Composition : Recupération du ChassisClass en base
    const {  loadQuery, queryResult } = useChassisGraphQl()
    
    const printForm = computed(()=> queryResult?.value?.getChassis || chassisNameOrId == undefined)

    await loadQuery(chassisNameOrId)

</script>