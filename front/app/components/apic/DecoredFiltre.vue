<script setup lang="ts">
  const props = defineProps({
    filterType: String,
    usedContratType: String
  });
</script>

<template>
    <div 
        v-if="(props.filterType == 'In' && props.usedContratType=='Apic::ProvidedContrat') || (props.filterType == 'Out' &&  props.usedContratType=='Apic::ConsumedContrat')"
        class="sticky top-10 pt-1"
    >
        {{"<-----------"}}
    </div>
    <div 
        v-else-if="(props.filterType == 'Out' && props.usedContratType=='Apic::ProvidedContrat') || (props.filterType == 'In' &&  props.usedContratType=='Apic::ConsumedContrat')"
        class="sticky top-10 pt-1"
    >
        {{"----------->"}}
    </div>
    <div v-else class="sticky top-10 pt-1">
        {{"<---------->"}}
    </div>
</template>
