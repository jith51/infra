<template>
    <div class=" w-full h-full flex flex-col overflow-auto">
      <div class="py-3 pr-1 ms-1">
      <Input
          placeholder="Filter contrat..."
          v-model.lazy="contratsSelector"
          class="h-8 w-[150px] lg:w-[250px]"
        />
      </div>
      <div class="border rounded-md max-h-full overflow-auto">
      <Table>
        <TableHeader class="sticky top-0 bg-white z-10">
          <TableRow class="[&_th]:after:border-b">
            <TableHead>
              <div>Contrat</div>
            </TableHead>
            <TableHead>
              <div>Provider</div>
            </TableHead>
            <TableHead>
              <div>Consumer</div>
            </TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow 
            v-for="contrat in getContrats(props.contrats, contratsSelector)"
            class="hover:bg-white"
          >
            <TableCell class="w-96 align-top">
              <div class="sticky top-10 pt-1">
                <div class=" text-orange-300">
                  {{ contrat["name"] }}
                </div>
                <div class="pt-2 pl-2"> Filtres :</div>
                <div v-for="(filterType, ft) in ['In', 'Out', 'Sub']" :key="ft" class="pl-2">
                  <div class="pl-2">
                    <div v-for="(filtre, f) in getFilters(contrat, filterType)" :key="f">
                      <div v-if="f==0">{{ filterType }} :</div>
                      <li class="pl-2">{{ filtre["vzFilter"]["name"] }}</li>
                    </div>
                  </div>
                </div>
              </div>
            </TableCell > 
            <TableCell 
              v-for="usedContratType in ['Apic::ProvidedContrat', 'Apic::ConsumedContrat']"
              class="align-top"
            >
              <div v-for="contractable in getContractables(contrat, usedContratType)" class="pb-2">
                <div v-if="contractable['__typename'] == 'Epg'">
                  <div class="sticky top-10 pt-1 bg-white">
                    {{ contractable["applicationProfile"]["tenant"]["name"] }} |{{ contractable["applicationProfile"]["name"] }} | {{ contractable["name"] }}
                  </div>
                  <li class="pl-4" v-for="(serveur, s) in contractable['serveurs']" :key="s" :class="[serveur['powerstate'] == '0' ? 'text-red-300' : '']">
                    {{ serveur["name"] }}
                  </li>
                </div>
                <div v-else class="text-blue-500 sticky top-10 pt-1 pb-2">
                  {{ contractable["name"] }}
                </div>
              </div>
            </TableCell>
          </TableRow>
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
    contrats: Array
  });

  const contratsSelector = ref('')

  // UTILITY FUNCTIONS
  const getContrats = (contrats, contratsSelector) => {
    return contrats.filter(c => c["name"].match(new RegExp(".*" + contratsSelector + ".*", "i")) != null).slice(0, 9)
  }

  const getContractables = (contrat, usedContratType) => {
    return contrat["usedContrats"].filter(c => c['type'] == usedContratType).map(c => c["contractable"])
  }

  const getFilters = (contrat, filterType) => {
    return contrat["usedFilters"].filter(f => f["type"] == "Apic::Used" + filterType + "Filter")
  }

</script>