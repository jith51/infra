<template>
  <div class="h-full mt-4">
    <div class="overflow-auto grow max-h-full">
      <div v-for="tenant in tenants">
        {{ tenant["fvTenant"]["attributes"]["name"] }}
        <div class="pl-4 grid grid-cols-7 gap-7">
          <div>
            <h4 class="bold">Keys :</h4>
            <li v-for="key in getKeys(tenant)" class="pl-4">
              {{ key }} 
            </li>
          </div>
          <div>
            <h4 class="bold">fvBD :</h4>
            <li v-for="fvBD in getfvDB(tenant)" class="pl-4">
              {{ fvBD["fvBD"]["attributes"]["name"] }} {{ fvBD["fvBD"]["attributes"]["descr"] ? " (" + fvBD["fvBD"]["attributes"]["descr"] + ")" :''}}
              <div class="pl-4">
                <h4 class="bold">fvSubnet :</h4>
                <li v-for="fvSubnet in getFvSubnet(fvBD)" class="pl-4">
                  {{ fvSubnet["fvSubnet"]["attributes"]["ip"] }}
                </li>
                <h4 class="bold">fvRsCtx (tnFvCtxName) :</h4>
                <li v-for="fvRsCtx in getFvRsCtx(fvBD)" class="pl-4">
                  {{ fvRsCtx["fvRsCtx"]["attributes"]["tnFvCtxName"] }}
                </li>
                <h4 class="bold">fvRsBDToOut (tnL3extOutName) :</h4>
                <li v-for="fvRsBDToOut in getFvRsBDToOut(fvBD)" class="pl-4">
                  {{ fvRsBDToOut["fvRsBDToOut"]["attributes"]["tnL3extOutName"] }}
                </li>
              </div>
            </li>
          </div>
          <div>
            <h4 class="bold">L3Out :</h4>
            <li v-for="l3extOut in getL3extOut(tenant)" class="pl-4">
              {{ l3extOut["l3extOut"]["attributes"]["name"] }} 
              <div class="pl-4">
                <h4 class="bold">l3extInstP :</h4>
                <li v-for="l3extInstP in getL3extInstPt(l3extOut)" class="pl-4">
                  {{ l3extInstP["l3extInstP"]["attributes"]["name"] }}
                  <div class="pl-4">
                    <h4 class="bold">fvRsProv (tnVzBrCPName) :</h4>
                    <li v-for="fvRsProv in getL3extFvRsProv(l3extInstP)" class="pl-4">
                      {{ fvRsProv["fvRsProv"]["attributes"]["tnVzBrCPName"] }}
                    </li>
                    <h4 class="bold">fvRsCons (tnVzBrCPName) :</h4>
                    <li v-for="fvRsCons in getL3extFvRsCons(l3extInstP)" class="pl-4">
                      {{ fvRsCons["fvRsCons"]["attributes"]["tnVzBrCPName"] }}
                    </li>
                  </div>
                </li>
              </div>
            </li>
          </div>
          <div>
            <h4 class="bold">FvCtx :</h4>
            <li v-for="fvCtx in getFvCtx(tenant)" class="pl-4">
              {{ fvCtx["fvCtx"]["attributes"]["name"] }}
              <div class="pl-4">
                <h4 class="bold">VzRsAnyToProv (tnVzBrCPName): </h4>
                <li v-for="vzRsAnyToProv in getVzRsAnyToProv(fvCtx)" class="pl-4">
                  {{ vzRsAnyToProv["vzRsAnyToProv"]["attributes"]["tnVzBrCPName"] }}
                </li>
                <h4 class="bold">VzRsAnyToProv (tnVzBrCPName): </h4>
                <li v-for="vzRsAnyToCons in getVzRsAnyToCons(fvCtx)" class="pl-4">
                  {{ vzRsAnyToCons["vzRsAnyToCons"]["attributes"]["tnVzBrCPName"] }}
                </li>
              </div>
            </li>
          </div>
          <div>
            <h4 class="bold">vzFilter :</h4>
            <li v-for="vzFilter in getVzFilter(tenant)" class="pl-4">
              {{ vzFilter["vzFilter"]["attributes"]["name"] }}
            </li>
          </div>
          <div>
            <h4 class="bold">fvAp :</h4>
            <li v-for="fvAp in getFvAp(tenant)" class="pl-4">
              {{ fvAp["fvAp"]["attributes"]["name"] }}
              <div class="pl-4">
                <h4 class="bold">fvAEPg :</h4>
                <li v-for="fvAEPg in getFvAEPg(fvAp)" class="pl-4">
                  {{ fvAEPg["fvAEPg"]["attributes"]["name"] }}
                  <div class="pl-4">
                    <h4 class="bold">fvRsProv (vzBrName):</h4>
                    <li v-for="fvRsProv in getFvRsProv(fvAEPg)" class="pl-4">
                      {{ fvRsProv["fvRsProv"]["attributes"]["tnVzBrCPName"] }}
                    </li>
                    
                    <h4 class="bold">fvRsCons (vzBrName):</h4>
                    <li v-for="fvRsCons in getFvRsCons(fvAEPg)" class="pl-4">
                      {{ fvRsCons["fvRsCons"]["attributes"]["tnVzBrCPName"] }}
                    </li>
                    <h4 class="bold">fvRsDomAtt :</h4>
                    <li v-for="fvRsDomAtt in getFvRsDomAtt(fvAEPg)" class="pl-4">
                      {{ fvRsDomAtt["fvRsDomAtt"]["attributes"]["tDn"] }}
                    </li>
                    <h4 class="bold">fvRsPathAtt :</h4>
                    <li v-for="fvRsPathAtt in getFvRsPathAtt(fvAEPg)" class="pl-4">
                      {{ fvRsPathAtt["fvRsPathAtt"]["attributes"]["tDn"] }}
                    </li>
                    <h4 class="bold">fvRsBd (fvBDName):</h4>
                    <li v-for="fvRsBd in getFvRsBd(fvAEPg)" class="pl-4">
                      {{ fvRsBd["fvRsBd"]["attributes"]["tnFvBDName"] }}
                    </li>
                  </div>
                </li>
              </div>
            </li>
          </div>
          <div>
            <h4 class="bold">vzBrCP :</h4>
            <li v-for="vzBrCP in getVzBrCP(tenant)" class="pl-4">
              {{ vzBrCP["vzBrCP"]["attributes"]["name"] }}
              <div class="pl-4">
                <h4 class="bold">vzSubj :</h4>
                <li v-for="vzSubj in getVzSubj(vzBrCP)" class="pl-4">
                  {{ vzSubj["vzSubj"]["attributes"]["name"] }}
                  <div class="pl-4">
                    <h4 class="bold">vzOutTerm/vzRsFiltAtt (vzFilterName) :</h4>
                    <div v-for="vzOutTerm in getVzOutTerm(vzSubj)" class="pl-4">
                      <li v-for="vzRsFiltAtt in getVzRsFiltAttForVzOutTerm(vzOutTerm)" class="pl-4">
                        {{ vzRsFiltAtt["vzRsFiltAtt"]["attributes"]["tnVzFilterName"] }}
                      </li>
                    </div>
                    <h4 class="bold">vzInTerm/vzRsFiltAtt (vzFilterName) :</h4>
                    <div v-for="vzInTerm in getVzInTerm(vzSubj)" class="pl-4">
                      <li v-for="vzRsFiltAtt in getVzRsFiltAttForVzInTerm(vzInTerm)" class="pl-4">
                        {{ vzRsFiltAtt["vzRsFiltAtt"]["attributes"]["tnVzFilterName"] }}
                      </li>
                    </div>
                    <h4 class="bold">vzRsSubjFiltAtt (vzFilterName) :</h4>
                    <li v-for="vzRsSubjFiltAtt in getVzRsSubjFiltAtt(vzSubj)" class="pl-4">
                      {{ vzRsSubjFiltAtt["vzRsSubjFiltAtt"]["attributes"]["tnVzFilterName"] }}
                    </li>
                  </div>
                </li>
              </div>
            </li>
          </div>
        </div>
      </div>
      <div class="min-h-32"/>
    </div>
  </div>
</template>

<script setup>
import apic  from "../../utils/apic.js";

const tenants = computed(() => { 
    return apic["polUni"]["children"].filter(child => child["fvTenant"])
  }
)
const getKeys = (tenant) => {
  return tenant["fvTenant"]["children"].flatMap(el => Object.keys(el)).filter((v, i, a) => a.indexOf(v) === i)
}

const getfvDB = (tenant) => {
  return tenant["fvTenant"]["children"].filter(child => child["fvBD"])
}

const getFvSubnet = (fvBD) => {
  return fvBD["fvBD"]["children"].filter(child => child["fvSubnet"])
}

const getFvRsCtx = (fvBD) => {
  return fvBD["fvBD"]["children"].filter(child => child["fvRsCtx"])
}

const getFvRsBDToOut = (fvBD) => {
  return fvBD["fvBD"]["children"].filter(child => child["fvRsBDToOut"])
}

const getL3extOut = (tenant) => {
  return tenant["fvTenant"]["children"].filter(child => child["l3extOut"])
}

const getL3extInstPt = (l3extOut) => {
  return l3extOut["l3extOut"]["children"].filter(child => child["l3extInstP"])
}

const getL3extFvRsProv = (l3extInstP) => {
  return l3extInstP["l3extInstP"]["children"].filter(child => child["fvRsProv"])
}

const getL3extFvRsCons = (l3extInstP) => {
  return l3extInstP["l3extInstP"]["children"].filter(child => child["fvRsCons"])
}

const getSpanDestGrp = (tenant) => {
  return tenant["fvTenant"]["children"].filter(child => child["spanDestGrp"])
}

const getVzTaboo = (tenant) => {
  return tenant["fvTenant"]["children"].filter(child => child["vzTaboo"])
}

const getFvCtx = (tenant) => {
  return tenant["fvTenant"]["children"].filter(child => child["fvCtx"])
}

const getVzRsAnyToProv = (fvCtx) => {
  let t = fvCtx["fvCtx"]["children"].filter(child => child["vzAny"])
  return (t[0]["vzAny"]["children"] ?? []).filter(child => child["vzRsAnyToProv"])
}

const getVzRsAnyToCons = (fvCtx) => {
  let t = fvCtx["fvCtx"]["children"].filter(child => child["vzAny"])
  return (t[0]["vzAny"]["children"] ?? []).filter(child => child["vzRsAnyToCons"])
}

const getVzFilter = (tenant) => {
  return tenant["fvTenant"]["children"].filter(child => child["vzFilter"]).sort((a, b) => {
    return a["vzFilter"]["attributes"]["name"] > b["vzFilter"]["attributes"]["name"]
   }
  )
}
const getFvAp = (tenant) => {
  return tenant["fvTenant"]["children"].filter(child => child["fvAp"])
}

const getFvAEPg = (fvAp) => {
  return (fvAp["fvAp"]["children"] ?? []).filter(child => child["fvAEPg"])
}

const getFvRsProv = (fvAEPg) => {
  return (fvAEPg["fvAEPg"]["children"] ?? []).filter(child => child["fvRsProv"])
}

const getFvRsDomAtt = (fvAEPg) => {
  return (fvAEPg["fvAEPg"]["children"] ?? []).filter(child => child["fvRsDomAtt"])
}

const getFvRsPathAtt = (fvAEPg) => {
  return (fvAEPg["fvAEPg"]["children"] ?? []).filter(child => child["fvRsPathAtt"])
}


const getFvRsCons = (fvAEPg) => {
  return (fvAEPg["fvAEPg"]["children"] ?? []).filter(child => child["fvRsCons"])
}

const getFvRsBd = (fvAEPg) => {
  return (fvAEPg["fvAEPg"]["children"] ?? []).filter(child => child["fvRsBd"])
}


const getVzBrCP = (tenant) => {
  return (tenant["fvTenant"]["children"] ?? []).filter(child => child["vzBrCP"])
}

const getVzSubj = (vzBrCP) => {
  return (vzBrCP["vzBrCP"]["children"] ?? []).filter(child => child["vzSubj"])
}

const getVzInTerm = (vzSubj) => {
  return (vzSubj["vzSubj"]["children"] ?? []).filter(child => child["vzInTerm"])
}

const getVzOutTerm = (vzSubj) => {
  return (vzSubj["vzSubj"]["children"] ?? []).filter(child => child["vzOutTerm"])
}

const getVzRsFiltAttForVzInTerm = (vzInTerm) => {
  return (vzInTerm["vzInTerm"]["children"] ?? []).filter(child => child["vzRsFiltAtt"])
}

const getVzRsFiltAttForVzOutTerm = (vzOutTerm) => {
  return (vzOutTerm["vzOutTerm"]["children"] ?? []).filter(child => child["vzRsFiltAtt"])
}

const getVzRsSubjFiltAtt = (vzSubj) => {
  return (vzSubj["vzSubj"]["children"] ?? []).filter(child => child["vzRsSubjFiltAtt"])
}
</script>