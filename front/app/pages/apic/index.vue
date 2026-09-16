<script setup>
  const { tenants, contrats, tasks } = useLoadApicData()
</script>

<template>
  <Tabs 
    default-value="application_profiles" 
    class="
      w-full flex flex-1 flex-col gap-2 items-center
      [&>[data-state=active]]:w-full
      [&>[data-state=active]]:flex [&>[data-state=active]]:flex-1 [&>[data-state=active]]:flex-col [&>[data-state=active]]:gap-2 
      [&>[data-state=active]]:overflow-hidden
    "
  >
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
    <TabsContent value="application_profiles">
      <ApicApplicationProfiles :tenants='tenants' :contrats='contrats'/>
    </TabsContent>
    <TabsContent value="filtres">
      <ApicFiltres :tenants='tenants' :contrats='contrats'/>
    </TabsContent>
    <TabsContent value="contrats">
      <ApicContrats :contrats='contrats'/> 
    </TabsContent>
    <TabsContent value="l3Out">
      <ApicL3Out :tenants='tenants' :contrats='contrats'/>
    </TabsContent>
    <TabsContent value="brut">
      <ApicBrut/>
    </TabsContent>
    <TabsContent value="taches">
      <ApicTasks :tasks='tasks' :contrats='contrats' :tenants='tenants'/>
    </TabsContent>
  </Tabs>
</template>