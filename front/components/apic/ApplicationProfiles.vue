<template>
  <div class=" w-full h-full flex flex-col overflow-auto">
    <div class="py-3 pr-1 ms-1">
      <Input
          placeholder="Filter app..."
          v-model.lazy="applicationProfilesSelector"
          class="h-8 w-[150px] lg:w-[250px]"
        />
    </div>
    <div class="border rounded-md max-h-full overflow-auto">
      <Table>
        <TableHeader class="sticky top-0 bg-white z-10">
          <TableRow class="[&_th]:after:border-b">
            <TableHead>
              <div>Applicaiton profile</div>
            </TableHead>
            <TableHead>
              <div>Epg</div>
            </TableHead>
            <TableHead>
              <div>Provided Contrat</div>
            </TableHead>
            <TableHead>
              <div>Consumed Contrat</div>
            </TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <template v-for="tenant in tenants">
            <template v-for="applicationProfile in getApplicationProfiles(tenant, applicationProfilesSelector)">
              <template v-for="(epg, indexForEpg) in applicationProfile['epgs']">
                <TableRow class="hover:bg-white">
                  <TableCell 
                    v-if="indexForEpg==0"
                    :rowspan="(applicationProfile['epgs']||[]).length"
                    class="w-96 align-top"
                  >
                    <div class="sticky top-10 pt-1 text-orange-300">
                      {{ tenant['name'] }} | {{ applicationProfile["name"] }}
                    </div>
                  </TableCell>              
                  <TableCell class="align-top">
                    <div class="sticky top-10 py-1 text-orange-300 bg-white z-5">
                      {{ epg["name"] }}
                    </div>
                    <div class="pl-4">
                      <div> SERVEURS :</div>
                      <div class="pl-4">
                        <li v-for="(serveur, s) in epg['serveurs']" :key="s" :class="[serveur['powerstate'] == '0' ? 'text-red-300' : '']">
                          {{ serveur["name"] }}
                        </li>
                      </div>
                      <div> DOMAINE :</div>
                      <div class="pl-4 'text-orange-300'">{{ epg["domaine"]["name"] }}</div>
                    </div>
                  </TableCell>
                  <TableCell 
                    v-for="(usedContratType, ct) in ['Apic::ProvidedContrat', 'Apic::ConsumedContrat']" :key="ct"
                    class="align-top"
                  >
                    <template v-for="(contrat, k) in getUsedContrats(epg, usedContratType)" :key="k">
                      <div class="flex flex-col sticky top-10 py-1 bg-white z-5">
                        <div 
                          class="sticky top-10 py-1 bg-white z-5"
                          :class="contrat['name'] != 'LEGACY' ? (contrat['name'] != '_AP:Any' ? 'text-orange-300' : 'text-green-300') : 'text-red-100'"
                        >
                          {{ contrat["name"] }}
                        </div>
                        <div v-if="contrat['name'] != 'LEGACY' && contrat['name'] != '_AP:Any'">
                          <div class="pl-4">
                            <div> FILTRES :</div>
                            <div v-for="(filterType, ft) in ['In', 'Out', 'Sub']" :key="ft" class="pl-4">
                              <div class="pl-4">
                                <div v-for="(filtre, f) in getFilters(contrat, filterType)" :key="f">
                                  <div v-if="f==0">{{ filterType }} :</div>
                                  <li class="pl-4">{{ filtre["vzFilter"]["name"] }}</li>
                                </div>
                              </div>
                            </div>
                          </div>
                          <div v-for="(contractableType, ct) in ['Epg', 'L3Out']" :key="ct" class="pl-4">
                            <div v-if="ct==0">{{ usedContratType == 'Apic::ProvidedContrat' ? "CONSUMERS :" : "PROVIDERS :" }}</div>
                            <div class="pl-4">
                              <div v-for="(contractable, k) in getContractables(contrat['id'], oppositeContrat(usedContratType), contractableType)" :key="k">
                                <div v-if="k==0">{{ contractableType }}:</div>
                                <li v-if="contractableType == 'Epg'" class="pl-4">
                                  {{ contractable["applicationProfile"]["tenant"]["name"] }} | {{ contractable["applicationProfile"]["name"] }} | {{ contractable["name"] }}
                                  <div class="pl-4">
                                    <div v-for="(serveur, s) in contractable['serveurs']" :key="s">
                                      <div v-if="s==0">SERVEURS :</div>
                                      <li class="pl-4" :class="[serveur['powerstate'] == '0' ? 'text-red-300' : '']">
                                        {{ serveur["name"] }}
                                      </li>
                                    </div>
                                  </div>
                                </li>
                                <li v-else class="pl-4">{{ contractable["name"] }}</li>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </template>
                  </TableCell>
                </TableRow>
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

  const applicationProfilesSelector = ref('')

  // UTILITY FUNCTIONS
  const getApplicationProfiles = (tenant, applicationProfilesSelector) => {
    return tenant["applicationProfiles"].filter(ap => ap["name"].match(new RegExp(".*" + applicationProfilesSelector + ".*", "i")) != null).slice(0, 9)
  }

  const getUsedContrats = (epg, usedContratType) => {
    return epg["usedContrats"].filter(uc => uc['type'] == usedContratType).map(uc => uc["contrat"])
  }

  const getFilters = (contrat, filterType) => {
    return contrat["usedFilters"].filter(f => f["type"] == "Apic::Used" + filterType + "Filter")
  }

  const oppositeContrat = (contrat) => {
    return contrat == 'Apic::ProvidedContrat' ? 'Apic::ConsumedContrat' : 'Apic::ProvidedContrat'
  }

  const getContractables = (contratId, usedContratType, contractableType) => {
    return (props.contrats.find(c => c.id == contratId)["usedContrats"] ?? []).filter(c => c["type"] == usedContratType && c["contractable"]["__typename"] == contractableType).map(c => c["contractable"])
  }

</script>