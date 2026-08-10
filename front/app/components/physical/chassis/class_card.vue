<template>
    <Card class="relative w-lg h-[750px] shrink-0" :key="props.chassisClass.id">
        <CardHeader class="h-10">
            <CardTitle> {{ props.chassisClass.name }} </CardTitle>
            <CardDescription> {{ props.chassisClass.fournisseur }} </CardDescription>
        </CardHeader>
        <CardContent class="flex flex-col gap-4 [&>div]:h-[50px] [&>div]:shrink-0 [&_label]:text-muted-foreground [&_label]:pb-1">
            <div>
                <Label>Front Image</Label>
                <NuxtImg v-if="props.chassisClass.frontImage" :src="getImageUrl(<string>props.chassisClass.frontImage)" class="h-9 w-96"/>
            </div>
            <div>
                <Label>Back Image</Label>
                <NuxtImg v-if="props.chassisClass.backImage" :src="getImageUrl(<string>props.chassisClass.backImage)" class="h-9 w-96"/>
            </div>                            
            <div>
                <Tabs 
                    default-value="model"
                    class="
                        w-full pt-2
                        [&>[role=tabpanel]]:pt-2 [&>[role=tabpanel]]:flex [&>[role=tabpanel]]:flex-col [&>[role=tabpanel]]:gap-3
                        [&>[role=tabpanel]>div]:h-full [&>[role=tabpanel]>div]:min-h-[50px] [&>[role=tabpanel]>div:shrink-0
                    "
                >
                    <TabsList :class="cn('w-full grid grid-cols-2', {'grid-cols-3': props.chassisClass.type === 'serverClass'})">
                        <TabsTrigger value="model">
                            Model
                        </TabsTrigger>
                        <TabsTrigger v-if="props.chassisClass.type === 'serverClass'" value="component">
                            Components
                        </TabsTrigger>
                        <TabsTrigger value="divers">
                            Divers
                        </TabsTrigger>
                    </TabsList>
                    <TabsContent value="model">
                        <div>
                            <Label>Type</Label>
                            <span> {{ props.chassisClass.type == "chassisClass" ? "Chassis" : "Serveur" }}</span>
                        </div>
                        <div>
                            <Label>Model</Label>
                            <span> {{ props.chassisClass.model }}</span>
                        </div>
                        <div>
                            <Label>Version</Label>
                            <span> {{ props.chassisClass.version }}</span>
                        </div>
                        <div>
                            <Label>Part Number</Label>
                            <span> {{ props.chassisClass.partNumber }}</span>
                        </div>
                        
                    </TabsContent>
                    <TabsContent  v-if="props.chassisClass.type === 'serverClass'" value="component">
                            <div>
                                <div>
                                    <Label>CPUs</Label>
                                    <Separator orientation="horizontal" class="h-1 mb-3" />
                                </div>
                                <div class="grid grid-cols-3 [&_div]:min-h-[50px]">
                                    <div class="col-span-2">
                                        <Label>Type de CPU</Label>
                                        <span> {{ props.chassisClass.cpuType }}</span>
                                    </div>
                                    <div class="[&_div]:min-h-[50px]">
                                        <div>
                                            <Label>Nombre de CPUs</Label>
                                            <span> {{ props.chassisClass.cpuNumber }}</span>
                                        </div>
                                        <div>
                                            <Label>Cores / CPU</Label>
                                            <span> {{ props.chassisClass.cpuCoreNumber }}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <div>
                                    <Label>RAM</Label>
                                    <Separator orientation="horizontal" class="h-1 mb-3" />
                                </div>
                                <div class="grid grid-cols-3 [&_div]:min-h-[50px]">
                                    <div class="col-span-2">
                                        <Label>Type de RAM</Label>
                                        <span> </span>
                                    </div>
                                    <div>
                                        <Label>Quantité de RAM</Label>
                                        <span> {{ props.chassisClass.ramNumber }}</span>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <div>
                                    <Label>HDs</Label>
                                    <Separator orientation="horizontal" class="h-1 mb-3" />
                                </div>
                                <div class="grid grid-cols-3 [&_div]:min-h-[50px]">
                                    <div class="col-span-2">
                                        <Label>Type de HD</Label>
                                        <span> {{ props.chassisClass.hdType }}</span>
                                    </div>
                                    <div class="[&_div]:min-h-[50px]">
                                        <div>
                                            <Label>Nombre de HDs</Label>
                                            <span> {{ props.chassisClass.hdNumber }}</span>
                                        </div>
                                        <div>
                                            <Label>Capacité des HDs</Label>
                                            <span> {{ props.chassisClass.hdCapacity }}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                    </TabsContent>
                    <TabsContent value="divers">
                        <div>
                            <Label>vendorEquipmentType</Label>
                            <span> {{ props.chassisClass.vendorEquipmentType }}</span>
                        </div>
                        <div>
                            <Label>height (U)</Label>
                            <span> {{ props.chassisClass.height }}</span>
                        </div>
                        <div>
                            <Label>technicalUrl</Label>
                            <span> {{ props.chassisClass.urlLink }}</span>
                        </div>
                    </TabsContent>
                </Tabs>
            </div>
        </CardContent>
        <CardFooter class="w-full absolute bottom-0">
            <div class="w-full flex justify-between  pb-6 ">
                <Button variant="outline" @click="emit('delete', props.chassisClass.id)">Supprimer</Button>
                <Button @click="emit('update', props.chassisClass)">Modifier</Button>
            </div>
        </CardFooter>
    </Card>
</template>
  
<script setup lang="ts">
    // IMPORTs
    import { cn } from '@/lib/utils'
    import type { ChassisClassType } from '@/types/physical/chassis_class.ts'

    const props = defineProps<{
        chassisClass: ChassisClassType
    }>()

    const getImageUrl = (path: string) => {
        return new URL(path, import.meta.url).href
    }
    
    const emit = defineEmits<{
        (e: 'delete', id: number): void
        (e: 'update', chassisClass: ChassisClassType): void
    }>()
    
</script>