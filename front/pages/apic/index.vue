<script setup>
  const { tenants, contrats, tasks } = useLoadApicData()
</script>

<template>
  <Tabs default-value="application_profiles" class="w-full h-full flex flex-col items-center overflow-hidden">
    <TabsList class="grid grid-cols-6 w-3/5">
      <TabsTrigger value="application_profiles">
         <span> Application Profiles </span>
      </TabsTrigger>
      <TabsTrigger value="filtres">
        <span> Filtres </span>
      </TabsTrigger>
      <TabsTrigger value="contrats">
        <span> Contrats </span>
      </TabsTrigger>
      <TabsTrigger value="l3Out">
        <span> L3Out </span>
      </TabsTrigger>
      <TabsTrigger value="brut">
        <span> Brut </span>
      </TabsTrigger>
      <TabsTrigger value="taches">
        <span> Taches </span>
      </TabsTrigger>
    </TabsList>
    <TabsContent value="application_profiles" class="w-full overflow-auto">
      <ApicApplicationProfiles :tenants='tenants' :contrats='contrats'/>
    </TabsContent>
    <TabsContent value="filtres" class="w-full overflow-auto">
      <ApicFiltres :tenants='tenants' :contrats='contrats'/>
    </TabsContent>
    <TabsContent value="contrats" class="w-full overflow-auto">
      <ApicContrats :contrats='contrats'/> 
    </TabsContent>
    <TabsContent value="l3Out" class="w-full overflow-auto">
      <ApicL3Out :tenants='tenants' :contrats='contrats'/>
    </TabsContent>
    <TabsContent value="brut" class="w-full overflow-auto">
      <ApicBrut/>
    </TabsContent>
    <TabsContent value="taches" class="w-full mt-4 overflow-auto">
      <ApicTasks :tasks='tasks' :contrats='contrats' :tenants='tenants'/>
    </TabsContent>
  </Tabs>
</template>