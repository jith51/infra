<template>
  <div class=" w-full h-full flex flex-col gap-2">
    <div class="py-1 ms-1">
      <Input
          placeholder="Filter contrat..."
          v-model.lazy="applicationProfilesSelector"
          class="h-8 w-[150px] lg:w-[250px]"
        />
    </div>
    <div class="border rounded-md max-h-full overflow-auto [&>div]:data-[slot=table-container]:max-h-full [&>div]:data-[slot=table-container]:border [&>div]:data-[slot=table-container]:rounded-md">
      <Table>
        <TableHeader class="sticky top-0 bg-white z-10">
          <TableRow class="[&_th]:after:border-b">
            <TableHead>
              <div>Applicaiton profile</div>
            </TableHead>
            <TableHead>
              <div>Serveurs</div>
            </TableHead>
            <TableHead>
              <div>Filtre Type</div>
            </TableHead>
            <TableHead>
              <div>Filtre</div>
            </TableHead>
            <TableHead>
              <div>Serveurs</div>
            </TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <template v-for="tenant in tenants">
            <template v-for="applicationProfile in getApplicationProfiles(tenant, applicationProfilesSelector)">
              <template v-for="(epg, indexForEpg) in applicationProfile['epgs']">
                <template v-for="(usedContratType, indexForUsedContratType) in getUsedContratTypes(epg)">
                  <template v-for="(contrat, indexForContrat) in getUsedContrats(epg, usedContratType)">
                    <template v-for="(filterType, indexForFilterType) in getUsedFilterTypes(contrat)">
                      <template v-if="hasFilters(contrat, filterType)">
                        <TableRow class="hover:bg-white">
                          <TableCell 
                            v-if="indexForEpg + indexForUsedContratType + indexForContrat + indexForFilterType == 0"
                            :rowspan="getAppFilterNumber(applicationProfile)"
                            class="w-96 align-top"
                          >
                            <div class="sticky top-10 pt-1 text-orange-300">
                              {{ tenant['name'] }} | {{ applicationProfile["name"] }}
                            </div>
                          </TableCell>
                          <TableCell
                            v-if="indexForContrat + indexForUsedContratType + indexForFilterType  == 0"
                            :rowspan="getEpgFilterNumber(epg)"
                            class="align-top"
                          >
                            <div class="sticky top-10 pt-1">
                              <li v-for="(serveur, s) in epg['serveurs']" :key="s" :class="[serveur['powerstate'] == '0' ? 'text-red-300' : '']">
                                {{ serveur["name"] }}
                              </li>
                            </div>
                          </TableCell>
                          <TableCell class="align-top">
                            <ApicDecoredFiltre :filterType="filterType" :usedContratType="usedContratType"/>
                          </TableCell>
                          <TableCell class="align-top">
                            <li 
                              v-for="(filtre, f) in getFilters(contrat, filterType)"
                              :key="f" 
                              class="sticky top-10 pt-1"
                              :class="filtre['vzFilter']['name']=='any' ? 'text-red-300' : ''"
                            >
                              {{ filtre["vzFilter"]["name"] }}
                            </li>
                          </TableCell>
                          <TableCell class="align-top">

                            <ApicServeurs :serveurs="getContractableServeurs(contrat['id'], oppositeContrat(usedContratType))"/>
                            
                          </TableCell>
                        </TableRow>
                      </template>
                    </template>
                  </template>
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

  const applicationProfilesSelector = ref('')

  // UTILITY FUNCTIONS
  const getApplicationProfiles = (tenant, applicationProfilesSelector) => {
    return tenant["applicationProfiles"].filter(ap => ap["name"].match(new RegExp(".*" + applicationProfilesSelector + ".*", "i")) != null).slice(0, 9)
  }

  const getUsedContrats = (epg, usedContratType) => {
    return epg["usedContrats"].filter(uc => uc['type'] == usedContratType && uc['name'] != '_AP:Any' && uc['contrat']['usedFilters'].length != 0).map(uc => uc["contrat"])
  }

  const hasFilters = (contrat, filterType) => {
    return contrat['usedFilters'].filter(f => f["type"] == "Apic::Used" + filterType + "Filter").length != 0
  }

  const getFilters = (contrat, filterType) => {
    return contrat["usedFilters"].filter(f => f["type"] == "Apic::Used" + filterType + "Filter")
  }

  const oppositeContrat = (contrat) => {
    return contrat == 'Apic::ProvidedContrat' ? 'Apic::ConsumedContrat' : 'Apic::ProvidedContrat'
  }

  const getContractableServeurs = (contratId, usedContratType) => {
    return (props.contrats.find(c => c.id == contratId)["usedContrats"] ?? []).filter(c => c["type"] == usedContratType && c["contractable"]["__typename"] == 'Epg')
      .map(c => c["contractable"]["serveurs"]).flat()
      .concat((props.contrats.find(c => c.id == contratId)["usedContrats"] ?? []).filter(c => c["type"] == usedContratType && c["contractable"]["__typename"] == 'L3Out')
        .map(uc => { return {'name': uc["contractable"]["name"], 'powerstate': '0'} }))
  }

  const getUsedContratTypes = (epg) => {
    return useUniq(useCompact(epg["usedContrats"].map(uc => uc['name'] != '_AP:Any' ? uc['type'] : '')))
  }

  const getUsedFilterTypes = (contrat) => {
    return useUniq(contrat["usedFilters"].map(uc => uc['type'].slice(10, -6) ))
  }

  // UTILITY FUNCTIONS FOR ROWSPAN
  const getEpgFilterNumber = (epg) => {
    return useReduce(epg["usedContrats"], (sum, uc) => {
      return sum + useUniq((uc["contrat"]["usedFilters"]||[]).map((f) => f['type'])).length
    },0)
  }
  const getAppFilterNumber = (applicationProfile) => {
    return useReduce(applicationProfile['epgs'], (sum, e) => {
      return sum + getEpgFilterNumber(e)
    }, 0)
  }
</script>