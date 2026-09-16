
<template>
  <div class=" w-full h-full flex flex-col gap-2">
    <div class="py-1 ms-1">
      <Input
          placeholder="Filter filtre..."
          v-model.lazy="filtreSelector"
          class="h-8 w-[150px] lg:w-[250px]"
        />
    </div>
    <div class="border rounded-md max-h-full overflow-auto [&>div]:data-[slot=table-container]:max-h-full [&>div]:data-[slot=table-container]:border [&>div]:data-[slot=table-container]:rounded-md">
      <Table>
        <TableHeader class="sticky top-0 bg-white z-10">
          <TableRow class="[&_th]:after:border-b">
            <TableHead>
              <div>Filtre type</div>
            </TableHead>
            <TableHead>
              <div>Filtre</div>
            </TableHead>
            <TableHead>
              <div>Contrat</div>
            </TableHead> 
            <TableHead>
              <div>Application profile / Epg</div>
            </TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <template v-for="usedContratType in ['Apic::ConsumedContrat', 'Apic::ProvidedContrat']" class="flex-auto">
            <template v-for="contrat in getUsedContrats(usedContratType)">
              <template v-for="(filterType, ft) in ['In', 'Out', 'Sub']" :key="ft">
                <template v-if="hasUsedFilers(contrat, filterType, filtreSelector)">
                  <TableRow class="hover:bg-white">
                    <TableCell class="w-96 align-top" >
                      <ApicDecoredFiltre :filterType="filterType" :usedContratType="usedContratType"/>
                    </TableCell>
                    <TableCell class="align-top" >
                      <div class="sticky top-10 pt-1 bg-white">
                        <div v-for="(filtre, f) in getUsedFilters(contrat, filterType, filtreSelector)" :key="f" >
                          <li v-if="filtre['vzFilter']['name'].match(new RegExp('.*' + filtreSelector + '.*')) != null" :class="filtre['vzFilter']['name']=='any' ? 'text-red-300' : ''">{{ filtre["vzFilter"]["name"] }}</li>
                        </div>
                      </div>
                    </TableCell>
                    <TableCell class="align-top" >
                    <div class="sticky top-10 pt-1 bg-white">
                      {{ contrat['name'] }} 
                      </div>
                    </TableCell>
                    <TableCell>
                      <div v-for="(epg, k) in getEpgs(contrat['id'], oppositeContrat(usedContratType))" :key="k">
                        <div class="sticky top-10 pt-1 bg-white">
                          {{ epg["applicationProfile"]["tenant"]["name"] }} | {{ epg["applicationProfile"]["name"] }} | {{ epg["name"] }} 
                        </div>
                        <div class="pl-4">
                          <ApicServeurs :serveurs="epg['serveurs']"/>
                        </div>
                      </div>
                    </TableCell>
                  </TableRow>
                </template>
              </template>
            </template>
          </template>
        </TableBody>
      </Table>
    </div>
  </div>
</template>

<style scoped>
  th::after {
    content: '';
    position: absolute;
    left: 0;
    width: 100%;
    height: 100%;
    display: block;
    top : 0px;
  }
</style>

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