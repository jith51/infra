<template>
    <PhysicalChassisClassForm
        v-if="!hasError"
        :chassisClass="chassisClass"
        :chassisPowertypes="queryResult?.chassisPowertypes as ChassisPowertypeType[]||[] "
        @chassisClassUpdated="(v) => {
            navigateTo(`/physical/chassis_classes/edit/${v.name}`)
        }"
    />
</template>

<script setup lang="ts">
    // Toast
    import { toast } from 'vue-sonner'
    import type { ChassisClassType } from '@/types/physical/chassis_class'
    import type { ChassisPowertypeType } from '@/types/physical/chassis_powertype'

    // Récupération du param id de la route
    const route = useRoute()

    const chassisClassNameOrId = route.params.name as string

    const hasError = ref(false)

    // Composition : Recupération du ChassisClass en base
    const {  loadQuery, queryResult, onQueryError } = useChassisClassGraphQl()
    onQueryError(() => {
        // si un nom ou id est passé mais qu'il n'existe pas
        // TODO --> à développer pour etre plus precis
        if (chassisClassNameOrId) {
            hasError.value = true
            toast('Erreur de récupération des données.')
        }
    })

    await loadQuery(chassisClassNameOrId)
    
    if (!queryResult?.value?.chassisClass && chassisClassNameOrId) {
        debugger
        hasError.value = true
        toast('Classe de chassis non existante.')
    }

    const chassisClass = computed(() => {
        if (queryResult.value?.chassisClass == null) return undefined
        const { chassisPowertype, ...result } = queryResult.value.chassisClass
        return result as ChassisClassType
    })

</script>
