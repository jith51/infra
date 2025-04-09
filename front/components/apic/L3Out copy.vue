<template>
  <div class="h-full">
    <div class="pb-3">
      <Input
        placeholder="Filtre Filter..."
        v-model.lazy="filtreSelector"
        class="h-8 w-[150px] lg:w-[250px]"
      />
    </div>
    <div class="h-full">
      <div class="flex  border-b-4 border-grey-200">
        <div class="flex-none w-64">FILTRE TYPE</div>
        <div class="flex-none w-96">FILTRE</div>
        <div class="flex-auto">APPLICATION PROFILES</div>
      </div>
      <div class="overflow-auto grow max-h-full flex">
        <div class="flex-auto">
          <div v-for="(usedContratType, ct) in ['Apic::ConsumedContrat', 'Apic::ProvidedContrat']" :key="ct" class="flex-auto">
            <div v-for="(contrat, c) in getUsedContrats(usedContratType)" :key="c">
              <div v-for="(filterType, ft) in ['In', 'Out', 'Sub']" :key="ft">
                <div v-if="hasUsedFilers(contrat, filterType, filtreSelector)" class="flex-auto flex">
                  <div v-if="usedContratType=='Apic::ProvidedContrat'">
                    <div v-if="filterType == 'In'" class="flex-none w-64 text-red-600 sticky top-0 bg-gray-100"> {{"<-----------"}} </div>
                    <div v-else-if="filterType == 'Out'" class="flex-none w-64 text-green-600 sticky top-0 bg-gray-100">{{"----------->"}}</div>
                    <div v-else class="flex-none w-64  text-blue-400 sticky top-0 bg-gray-100">{{"<---------->"}}</div>
                  </div>
                  <div v-else>
                    <div v-if="filterType =='Out'" class="flex-none w-64 text-red-600 sticky top-0 bg-gray-100"> {{"<-----------"}} </div>
                    <div v-else-if="filterType == 'In'" class="flex-none w-64 text-green-600 sticky top-0 bg-gray-100">{{"----------->"}}</div>
                    <div v-else class="flex-none w-64  text-blue-400 sticky top-0 bg-gray-100">{{"<---------->"}}</div>
                  </div>
                  <div class="flex-none w-96">
                    <div class="sticky top-0 bg-gray-100">
                      <div v-for="(filtre, f) in getUsedFilters(contrat, filterType, filtreSelector)" :key="f" >
                        <li v-if="filtre['vzFilter']['name'].match(new RegExp('.*' + filtreSelector + '.*')) != null" :class="filtre['vzFilter']['name']=='any' ? 'text-red-600' : ''">{{ filtre["vzFilter"]["name"] }}</li>
                      </div>
                    </div>
                    <br>
                  </div>
                  <div class="flex-auto">
                    <li v-for="(epg, k) in getEpgs(contrat['id'], oppositeContrat(usedContratType))" :key="k">
                      <div class="sticky top-0 bg-gray-100">
                        {{ epg["applicationProfile"]["tenant"]["name"] }} | {{ epg["applicationProfile"]["name"] }} | {{ epg["name"] }} 
                      </div>
                      <div class="pl-4">
                        <li class="pl-4" v-for="(serveur, s) in epg['serveurs']" :key="s" :class="[serveur['powerstate'] == '0' ? 'text-red-500' : '']">
                          {{ serveur["name"] }}
                        </li>
                      </div>
                    </li>
                    <br>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="min-h-32"/>
    </div>
  </div>
</template>
        
<script setup>
  
  const props = defineProps({
    tenants: Array,
    contrats: Array
  });

  const filtreSelector = ref('')

  // UTILITY FUNCTIONS
  const getUsedContrats = (usedContratType) => {
    return props.contrats.filter(c => c["usedContrats"].filter(uc => uc['type'] == usedContratType && uc['contractable']['__typename'] == 'L3Out').length != 0)
  }

  const hasUsedFilers = (contrat, filterType, filtreSelector) => {
    return contrat['usedFilters'].filter(f => f["type"] == "Apic::Used" + filterType + "Filter" && f["vzFilter"]["name"].match(new RegExp(".*" + filtreSelector + ".*", "i")) != null ).length != 0
  }

  const getUsedFilters = (contrat, filterType) => {
    return contrat["usedFilters"].filter(f => f["type"] == "Apic::Used" + filterType + "Filter" && f["vzFilter"]["name"].match(new RegExp(".*" + filtreSelector + ".*", "i")) != null)
  }

  const oppositeContrat = (contrat) => {
    return contrat == 'Apic::ProvidedContrat' ? 'Apic::ConsumedContrat' : 'Apic::ProvidedContrat'
  }

  const getEpgs = (contratId, usedContratType) => {
    return (props.contrats.find(c => c.id == contratId)["usedContrats"] ?? []).filter(c => c["type"] == usedContratType && c["contractable"]["__typename"] == 'Epg')
      .map(c => c["contractable"]).flat()
  }

</script>