<template>
    <div class="w-full grid grid-cols-2 gap-4">
        <div class="space-y-8">
            <CardItem label="Fournisseur" :value="chassisClass.fournisseur"/>
            <CardItem label="Model" :value="chassisClass.model"/>
            <CardItem label="Version" :value="chassisClass.version"/>
            <CardItem label="Part Number" :value="chassisClass.partNumber"/>
            <CardItem label="Vendor Equipment Type" :value="chassisClass.vendorEquipmentType"/>
            <CardItem label="Hauteur (U)" :value="chassisClass.height"/>
            <CardItem label="Lien Constructeur" :value="chassisClass.urlLink" type="url"/>
        </div>
        <div class="space-y-8">
            <CardItem label="Powertype" :value="chassisClass.chassisPowertype?.name"/>
            <CardItem 
                v-for="(v, k) in definitions" 
                :label="v['label']"
                :type="v['type']"
                :value="chassisClass.customAttributes![k] ?? null"/>
        </div>
    </div>
</template>
        
<script setup lang="ts">
// Types
import type { ChassisClassType } from '@/types/physical/chassis_class'

import CardItem from './CardItem.vue'

// // Props : le ChassisClass et tous les powertypes
const props = defineProps<{
    chassisClass: ChassisClassType
}>()

const definitions = computed(() => props.chassisClass.allCustomAttributesDefinition)
</script>