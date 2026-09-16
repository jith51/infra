<template>    
  <div class="max-h-full grid grid-flow-col grid-rows-2 gap-4">
    <div class="row-span-2">
      <div class="overflow-auto max-h-full relative border">
        <div class="sticky top-0 p-3 bg-white border-b inline-grid grid-cols-2 w-full">
          <Input
              placeholder="Filter task..."
              v-model.lazy="taskSelector"
              class="h-8 w-[150px] lg:w-[250px]"
            />
          <span class="pt-1 text-right"> Total :  {{ tasksCount(taskSelector) }} </span>
        </div>
        <div class="p-2">
          <div v-for="task in getTasks(taskSelector)"> {{ task["name"] }} </div>
        </div>
      </div>
    </div>
    <div class="overflow-auto relative flex-none border">
      <div class="sticky top-0 p-3 bg-white border-b">
        <span class="bold">Contrat Sans Provider</span>
      </div>
      <div>
        <div class="p-2">           
          <div v-for="(contrat, c) in getAllContratsWithoutProvider()" :key="c">
            {{ contrat["name"] }}
          </div>
        </div>
      </div>
    </div>
    <div class="overflow-auto relative flex-none border">
      <div class="sticky top-0 p-3 bg-white border-b">
        <span class="bold">Contrat Sans Consumer</span>
      </div>
      <div>
        <div class="p-2">           
          <div v-for="(contrat, c) in getAllContratsWithoutConsumer()" :key="c">
            {{ contrat["name"] }}
          </div>
        </div>
      </div>
    </div>
    <div class="overflow-auto relative flex-none border">
      <div class="sticky top-0 p-3 bg-white border-b">
        <span class="bold">Contrat Sans Filtre</span>
      </div>
      <div>
        <div class="p-2">           
          <div v-for="(contrat, c) in getAllContratsWithoutFilter()" :key="c">
            {{ contrat["name"] }}
          </div>
        </div>
      </div>
    </div>
    <div class="overflow-auto relative flex-none border">
      <div class="sticky top-0 p-3 bg-white border-b">
        <span class="bold">Epg sans serveur</span>
      </div>
      <div>
        <div class="p-2">           
          <div v-for="(contrat, c) in getEpgWithoutServer(props.tenants)" :key="c">
            {{ contrat["name"] }}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
        
<script setup>
  
  const props = defineProps({
    tasks: Array,
    contrats: Array,
    tenants: Array
  });

  const taskSelector = ref('')

  // UTILITY FUNCTIONS
  const getTasks = (taskSelector) => {
    return props.tasks.filter(t => t["name"].match(new RegExp(".*" + taskSelector + ".*")) != null)
  }

  const tasksCount = (taskSelector) => {
    return props.tasks.filter(t => t["name"].match(new RegExp(".*" + taskSelector + ".*")) != null).length
  }

  const getAllContratsWithoutProvider = () => {
    return props.contrats.filter(c => getContractables(c,'Apic::ProvidedContrat').length == 0)
  }

  const getAllContratsWithoutConsumer = () => {
    return props.contrats.filter(c => getContractables(c,'Apic::ConsumedContrat').length == 0)
  }

  const getAllContratsWithoutFilter = () => {
    return props.contrats.filter(c => c['usedFilters'].length == 0)
  }

  const getContractables = (contrat, usedContratType) => {
    return contrat["usedContrats"].filter(c => c['type'] == usedContratType).map(c => c["contractable"])
  }

  const getEpgWithoutServer = (tenants) => {
    return tenants.map((t) => t['applicationProfiles'].map((a) => a['epgs'].filter((e) => e['serveurs'].length == 0).map((e) => t['name'] + " " + e['name'])).flat()).flat()
  }

</script>