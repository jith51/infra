<template>
    <!-- Définition du template pour affichage des attributs du chassis -->
    <DefineChassisAttributes v-slot="{label, value}">
        <div class="flex">
            <span class="flex-1/2">{{label}}</span>
            <span class="flex-1/2">{{ value }}</span>
        </div>
    </DefineChassisAttributes>
    <!-- View / Form -->
    <div class="w-full h-full flex justify-center mx-auto py-5">
        <div class="relative max-h-full w-full max-w-7xl flex flex-col">
            <span class="absolute top-3 text-lg">{{ initialValues?.name }}</span>
            <!-- <div>{{ values }}</div> -->
            <form @submit="onSubmit" class="w-full max-h-full flex flex-col overflow-hidden">
                <Tabs :unmountOnHide="false" class="max-h-full flex flex-col items-end overflow-hidden gap-2" v-model="tabValue">
                    <TabsList class="w-1/2">
                        <TabsTrigger value="view" :disabled="chassis_name == ''">View</TabsTrigger>
                        <TabsTrigger value="properties">Propriétés</TabsTrigger>
                        <TabsTrigger value="components">Composants</TabsTrigger>
                        <TabsTrigger value="interfaces">Interfaces</TabsTrigger>
                    </TabsList>
                    <Separator />
                    <TabsContent value="view" class="w-full max-h-full flex flex-col overflow-hidden pt-5">
                        <div class="w-full max-h-full flex gap-10">
                            <div class="flex flex-col gap-10 flex-1/3  px-2">
                                <!-- Front Image -->
                                <NuxtImg v-if="initialValues?.chassisClass?.frontImage" :src="getImageUrl(<string>initialValues.chassisClass.frontImage)" class="h-9 w-96"/>
                                <!-- Craractéristiques -->
                                <div class="pt-2 flex flex-col gap-2 bg-sidebar rounded-md p-2 ">
                                    <ChassisAttributes label="Model" :value="initialValues?.chassisClass?.model"/>
                                    <ChassisAttributes label="Fournisseur" :value="initialValues?.chassisClass?.fournisseur"/>
                                    <ChassisAttributes label="Serial Number" :value="initialValues?.serialNumber"/>
                                </div>
                                <!-- Tags -->
                                <div v-if="(initialValues?.tagIds ?? []).length != 0" class="w-full flex gap-3">
                                    <Badge v-for="tagId in initialValues?.tagIds" variant="secondary" class="rounded-sm px-1 font-normal">
                                        {{ optionsByKeys.tags[tagId] }}
                                    </Badge>
                                </div>
                                <!-- CPUs / RAM / HDs -->
                                <Collapsible v-if="initialValues?.chassisClass?.type == 'serverClass'" :defaultOpen="true" class="w-full">
                                    <div class="flex items-center justify-between space-x-4 px-4 bg-sidebar">
                                        <span>CPUs / RAM / HDs</span>
                                        <CollapsibleTrigger as-child>
                                            <Button variant="ghost" size="sm" class="w-9 p-0">
                                                <ChevronsUpDown class="h-4 w-4" />
                                                <span class="sr-only">Toggle</span>
                                            </Button>
                                        </CollapsibleTrigger>
                                    </div>
                                    <Separator/>
                                    <CollapsibleContent class="pt-2 flex flex-col gap-2">
                                        <ChassisAttributes label="Nombre de CPU" :value="`${initialValues.chassisClass.cpuNumber}`"/>
                                        <ChassisAttributes label="Type de CPU" :value="initialValues.chassisClass.cpuType"/>
                                        <ChassisAttributes label="Nombre de Core / CPU" :value="`${initialValues.chassisClass.cpuCoreNumber}`"/>
                                        <ChassisAttributes label="Quantité RAM" :value="`${initialValues.chassisClass.ramNumber}`"/>
                                        <ChassisAttributes label="Nombre de HDs" :value="`${initialValues.chassisClass.hdNumber}`"/>
                                        <ChassisAttributes label="Type de HD" :value="initialValues.chassisClass.hdType"/>
                                        <ChassisAttributes label="Capacité des HDs" :value="`${initialValues.chassisClass.hdCapacity}`"/>
                                    </CollapsibleContent>
                                </Collapsible>
                            </div>
                            <!-- <div class="flex flex-col gap-10 flex-2/3"> -->
                            <ScrollArea class="flex-2/3 flex flex-col overflow-hidden [&>div>div]:w-full [&>div>div]:flex [&>div>div]:flex-col [&>div>div]:gap-10">
                                <!-- Composants -->
                                <Collapsible
                                    v-if="(initialValues?.components||[]).length != 0"
                                    :defaultOpen="true"
                                    class="w-full"
                                >
                                    <div class="flex sticky top-0 z-10 items-center justify-between space-x-4 px-4 bg-sidebar">
                                        <span>Composants</span>
                                        <CollapsibleTrigger as-child>
                                            <Button variant="ghost" size="sm" class="w-9 p-0">
                                                <ChevronsUpDown class="h-4 w-4" />
                                                <span class="sr-only">Toggle</span>
                                            </Button>
                                        </CollapsibleTrigger>
                                    </div>
                                    <Separator/>
                                    <CollapsibleContent class="pt-2">
                                        <Table>
                                            <TableHeader>
                                                <TableRow>
                                                    <TableHead class="w-[100px]">Nom</TableHead>
                                                    <TableHead>Type</TableHead>
                                                    <TableHead>Description</TableHead>
                                                    <TableHead >Serial Number</TableHead>
                                                </TableRow>
                                            </TableHeader>
                                            <TableBody>
                                                <TableRow v-for="component in initialValues?.components">
                                                    <TableCell class="font-medium">{{component.name}}</TableCell>
                                                    <TableCell>{{optionsByKeys.componentTypes[component.componentTypeId]}}</TableCell>
                                                    <TableCell>{{component.description}}</TableCell>
                                                    <TableCell >{{component.serialNumber}}</TableCell>
                                                </TableRow>
                                            </TableBody>
                                        </Table>
                                    </CollapsibleContent>
                                </Collapsible>
                                <!-- Interfaces -->
                                <Collapsible
                                    v-if="(initialValues?.ports||[]).length != 0"
                                    :defaultOpen="true"
                                    class="w-full"
                                >
                                    <div class="flex sticky top-0 z-10 bg-sidebar items-center justify-between space-x-4 px-4">
                                        <span>Interfaces</span>
                                        <CollapsibleTrigger as-child>
                                            <Button variant="ghost" size="sm" class="w-9 p-0">
                                                <ChevronsUpDown class="h-4 w-4" />
                                                <span class="sr-only">Toggle</span>
                                            </Button>
                                        </CollapsibleTrigger>
                                    </div>
                                    <Separator/>
                                    <CollapsibleContent class="pt-2">
                                        <Table>
                                            <TableHeader>
                                                <TableRow>
                                                    <TableHead class="w-[100px]">Nom</TableHead>
                                                    <TableHead>Adresse Mac</TableHead>
                                                    <TableHead>Interface type</TableHead>
                                                    <TableHead >Chassis connecté</TableHead>
                                                    <TableHead >Link Type</TableHead>
                                                </TableRow>
                                            </TableHeader>
                                            <TableBody>
                                                <TableRow v-for="port in initialValues?.ports">
                                                    <TableCell class="font-medium">{{port.name}}</TableCell>
                                                    <TableCell>{{port.macAddress}}</TableCell>
                                                    <TableCell>{{port.interfaceTypeId ? optionsByKeys.interfaceTypes[port.interfaceTypeId]:''}}</TableCell>
                                                    <TableCell >{{port.connection?.distantId ? optionsByKeys.chassisPorts[port.connection.distantId]:''}}</TableCell>
                                                    <TableCell >{{port.connection?.linkTypeId ? optionsByKeys.linkTypes[port.connection.linkTypeId]:''}}</TableCell>
                                                </TableRow>
                                            </TableBody>
                                        </Table>
                                    </CollapsibleContent>
                                </Collapsible>
                            </ScrollArea>
                        </div>
                    </TabsContent>
                    <TabsContent value="properties" class="w-full h-full flex flex-col overflow-hidden pt-5">
                        <div class="grid grid-cols-3 flex-col gap-4 pb-2 pl-1">
                            <!-- Affichage des éléments de la form -->
                            <FormInput type="text" name="name" label="Name"/>
                            <FormSelectGroup
                                name="chassisClassId"
                                label="Type"
                                :options="chassisClasses"
                                :disabled="chassis_name != ''"
                            />
                            <FormInput type="text" name="serialNumber" label="Serial Number" />
                        </div>
                    
                        <div class="h-full flex flex-col gap-5 overflow-hidden">
                            <FormComboTag class="max-w-full" name="tagIds" :options="tags" @create-option="addTag"/>
                        </div>
                    </TabsContent>
                    <TabsContent value="components" class="w-full h-full flex flex-col overflow-hidden  pt-5">
                        <FieldArray name="components" v-slot="{ fields, push, remove }" class="pr-1"> 
                            <div class="flex border-b">
                                <div class="w-full grid grid-cols-4 gap-2">
                                    <span>Nom</span>
                                    <span>Type</span>
                                    <span>Description</span>
                                    <span>Serial Number</span>
                                </div>
                                
                                <button type="button" @click="push({})" class="pr-3">
                                    <Plus class="size-5 text-muted-foreground" />
                                </button>
                            </div>
                            <ScrollArea class="flex flex-col overflow-hidden [&>div>div]:w-full [&>div>div]:flex [&>div>div]:flex-col [&>div>div]:gap-2">
                                <div v-for="(field, idx) in fields"  :key="field.key" class="flex gap-2">
                                    <div :class="cn('w-full grid grid-cols-4 gap-2', (idx == 0) && 'pt-2', (idx == (fields?.length ?? 0) -1) && 'pb-2')">
                                        <FormInput type="text" :name="`components[${idx}].name`"/>
                                        <FormComboBox
                                            :name="`components[${idx}].componentTypeId`"
                                            :options="componentTypes"
                                            @create-option="addComponentType"
                                            class="w-full"
                                        />
                                        <FormInput type="text" :name="`components[${idx}].description`"/>
                                        <FormInput type="text" :name="`components[${idx}].serialNumber`"/>
                                    </div>
                                    <button type="button" @click.prevent="remove(idx)" class="pr-3">
                                        <X class="size-5 text-muted-foreground" />
                                    </button>
                                </div>    
                            </ScrollArea>
                        </FieldArray>
                    </TabsContent>
                    <TabsContent value="interfaces" class="w-full h-full flex flex-col overflow-hidden pt-5">
                        <FieldArray name="ports" v-slot="{ fields, push, remove }" class="pr-1"> 
                            <div class="flex border-b">
                                <div class="w-full grid grid-cols-5 gap-2 pl-3">
                                    <span>Nom</span>
                                    <span>Mac Address</span>
                                    <span>Interface Type</span>
                                    <span>Chassis connecté</span>
                                    <span>Link Type</span>
                                    
                                </div>
                                
                                <button type="button" @click="push({})" class="pr-3">
                                    <Plus class="size-5 text-muted-foreground" />
                                </button>
                            </div>
                            <ScrollArea class="flex flex-col overflow-hidden [&>div>div]:w-full [&>div>div]:flex [&>div>div]:flex-col [&>div>div]:gap-2">
                                <div v-for="(field, idx) in fields"  :key="field.key" class="flex gap-2">
                                    <div :class="cn('w-full grid grid-cols-5 gap-2 pl-3', (idx == 0) && 'pt-2', (idx == (fields?.length ?? 0) -1) && 'pb-2')">
                                        <FormInput type="text" :name="`ports[${idx}].name`"/>
                                        <FormInput type="text" :name="`ports[${idx}].macAddress`"/>
                                        <FormComboBox
                                            :name="`ports[${idx}].interfaceTypeId`"
                                            :options="interfaceTypes"
                                            @create-option="addInterfaceType"
                                            class="w-full"
                                        />
                                        <FormSelect 
                                            :name="`ports[${idx}].connection.distantId`"
                                            :options="setChassisPorts((values.ports[idx] as PortType).connection?.distantId)"/>
                                        <FormComboBox
                                            :name="`ports[${idx}].connection.linkTypeId`"
                                            :options="linkTypes"
                                            @create-option="addLinkType"
                                        />
                                    </div>
                                    <button type="button" @click.prevent="remove(idx)" class="pr-3">
                                        <X class="size-5 text-muted-foreground" />
                                    </button>
                                </div>    
                            </ScrollArea>
                        </FieldArray>
                    </TabsContent>
                </Tabs>

                <div v-if="tabValue != 'view'" class="w-full flex flex-col items-end pt-5">
                    <Button type="submit"> Submit </Button>
                </div>
                <Separator class="mt-5"/>
            </form>
        </div>
    </div>
</template>
  
<script setup lang="ts">
    // Utilitaire tailwind
    import { cn } from '@/lib/utils'

    // Icones
    import { Plus, X, ChevronsUpDown } from '@lucide/vue'

    // GraphQl
    import GET_CHASSIS from '@/graphql/physical/getChassisAndCo.query.gql'
    import { useQuery } from '@vue/apollo-composable'
    
    // Types
    import type { ChassisType, ChassisFormType, PortType } from '@/types/physical/chassis.ts'
    import type { OptionType } from '@/types/base.ts'

    // Alerte
    import { toast } from 'vue-sonner'

    // Template pour affichage du chassis
    const { define: DefineChassisAttributes, reuse: ChassisAttributes } = createReusableTemplate<OptionType>()

    // Pour afficher l'image cu chassis
    const getImageUrl = (path: string) => {
        return new URL(path, import.meta.url).href
    }

    // Schema valibot
    import { chassisFormSchema } from '@/types/physical/chassis'

    // Form
    import { useForm, FieldArray } from 'vee-validate'
    import { toTypedSchema } from '@vee-validate/valibot'

    // Récupération du param id de la route
    const route = useRoute()
    const chassis_name = route.params.name
    
    // On récupére le chassis et les différentes tables
    const { initialValues, interfaceTypes, linkTypes, chassisPorts, chassisClasses, tags, componentTypes } =  useGetChassisAndCo(chassis_name as string)

    // On génére une ref avec les options par Keys (pour faciliter l'affichage de la vue
    const optionsByKeys = computed(() => {
        return {
            tags: useFromPairs(tags.value.map((o) => [o.value, o.label])),
            interfaceTypes: useFromPairs(interfaceTypes.value.map((o) => [o.value, o.label])),
            linkTypes: useFromPairs(linkTypes.value.map((o) => [o.value, o.label])),
            componentTypes: useFromPairs(componentTypes.value.map((o) => [o.value, o.label])),
            chassisPorts: useFromPairs(chassisPorts.value.map((o) => [o.value, o.label])),
        }
    })
    
    // Définition de la form
    const { onSubmit, values } = useChassisForm(initialValues)

    // Mutation des tag tables 
    const { addInterfaceType, addLinkType, addTag, addComponentType } = useMutateTagTables()

    // Variable 
    const currentDistantPorts = computed(() => useCompact((values.ports ||[]).map((p) => p.connection?.distantId)))

    // Utilitaire : filtre les ports distants disponibles
    const setChassisPorts = (fieldDistantPortId: string) => {
        return useConcat(
            { label: "", value: undefined },
            chassisPorts.value.filter((p) => !useIncludes(useWithout(currentDistantPorts.value, fieldDistantPortId), p.value))
        )
    }

    // Suivi de la valeur du Tab : pour affichage ou onndu button validation : on l'initialise à properties en création
    const tabValue = ref(chassis_name ? 'view' : 'properties')

    // Compositions
    function useChassisForm(initialValues: Ref<ChassisType | undefined>) {
        // Définition
        const { resetForm, handleSubmit, setErrors, values  } = useForm({
            validationSchema: toTypedSchema(chassisFormSchema)
        })

        watch(
            () => initialValues.value,
            (newValue) => {
                if (newValue) {
                    newValue.ports = useSortBy(newValue.ports, (p) => p.name)
                    resetForm({ values: JSON.parse(JSON.stringify(useOmit(newValue, 'chassisClass'))) })
                }
            },
            { immediate: true }
        )

        // validation de la form            
        const onValidationSuccess = (values: ChassisFormType) => {
            // Ports intials
            const initialPorts: PortType[] = initialValues?.value?.ports || []

            // Recherche des ports en base supprimés et marquage pour destruction
            const removedPorts = useReduce(initialPorts, (result: PortType[], p: PortType) => {
                if (!(values.ports ?? []).find((r) => r.id == p.id)) result.push({...p, _destroy: true})
                return result
            }, [])
            // Ajout de ces ports avant mutation (values ports peut être undefined en creation)
            values.ports = useConcat(values.ports||[], removedPorts)

            // Recherche des connections non remplies pour supprimer ou les marquer pour destruction
            values.ports = values.ports.map((p) => {
                if (p.connection?.distantId) {
                    // Si connection renseignée
                    return p
                } else {
                    // Sinon on recherche si une connection existait sur ce port
                  const initialPort: PortType | undefined = initialPorts.find((i) => (i.id == p.id && i.connection?.id))
                  // Si c'est le cas on la marque pour destruction sinon on omit la connection
                  return (initialPort == undefined) ? useOmit(p, 'connection') : useMerge(p, {connection: {...initialPort.connection, _destroy: true }})
                } 
            })
            
            mutateChassis(values)
        }

        // Pas besoin de gèrer l'erreur car tout est pris en compte au niveau des FormField par vee-validate (pas d'rerreur globale
        // handleSubmit(onSuccess, onInvalidSubmit)
        const onSubmit = handleSubmit(onValidationSuccess, (errors) => {console.log(errors)})

        // Mutation Gql
        const { useCreateOrUpdateChassis } = useChassisGraphQl()

        const onMutationSuccess = (chassis: ChassisType) => {
            toast(`Chassis enregistré`)
            // Si on était en création
            if (chassis_name == '') navigateTo(`/physical/chassis/edit/${chassis.name}`)
        }

        const onMutationError = (invalideRecord: any, networkError: any) => {
                invalideRecord.forEach((r: any) => setErrors(r))
                if (invalideRecord.length == 0) toast(`Erreur lors de l'enregistrement`)
            }   

        const mutateChassis = useCreateOrUpdateChassis(onMutationSuccess, onMutationError)

        return { onSubmit, values }
    } 
    
    function useGetChassisAndCo(name: string) {
        const initialValues = ref<ChassisType & {chassisClassId: string}>()
        const interfaceTypes = ref<OptionType[]>([])
        const linkTypes = ref<OptionType[]>([])
        const componentTypes = ref<OptionType[]>([])
        const chassisPorts = ref<OptionType[]>([])
        const tags = ref<OptionType[]>([])
        const chassisClasses = ref<Record<string, OptionType[]>>()

        // Recupération du Chassis si id et des tables params
        const { result, onError } = useQuery(GET_CHASSIS, { name: name, justCo: (name === '') })

        // Gestion de l'erreur
        onError(({ graphQLErrors, networkError }) => {
            if (graphQLErrors) console.log('graphQLErrors', graphQLErrors) 
            if (networkError) console.log('networkError', networkError)
            toast('Erreur de récupération des données')
            navigateTo('/physical/chassis')
        })

        // Initialisation ou mise à jour des données
        // On fait plusieurs watcher pour gèrer la mise à jour unitaire des tables param en cas d'update 

        // Valeur initiale du chassis
        watchResult<ChassisType>(
            () => result.value?.getChassis,
            (v) => initialValues.value = { ...v, chassisClassId: <string>v.chassisClass.id }
        )
        // Interface Types
        watchResult<OptionType[]>(() => result.value?.interfaceTypes, (v) => interfaceTypes.value = v)
        // Link Types
        watchResult<OptionType[]>(() => result.value?.linkTypes, (v) => linkTypes.value = v)
        // Ports affectables --> les ports déjà affectés sur le chassis + les ports disponibles
        watchResult<OptionType[]>(() => result.value?.chassisPorts, (v) => chassisPorts.value = v)
        // Component Types
        watchResult<OptionType[]>(() => result.value?.componentTypes, (v) => componentTypes.value = v)
        // Chassis Classes
        watchResult<OptionType[]>(() => result.value?.chassisClasses, (v) => chassisClasses.value = useGroupBy(v, 'type'))
        // Tags
        watchResult<OptionType[]>(() => result.value?.tags, (v) => tags.value = v)
        
        return { initialValues, interfaceTypes, linkTypes, chassisPorts, chassisClasses, tags, componentTypes }
    }

    function useMutateTagTables() {
        // const addOption = (optionType: string, label: string) => {
        //     const { useCreateOrUpdateTag } = useTagGraphQl(optionType)
        //     const addOptionType = (val: string) => {
        //         const mutateOptionType = useCreateOrUpdateTag((value) => {
        //             toast(`${label} Type ${value.label} créé`)
        //         })
        //         mutateOptionType({name: val})
        //     }
        //     return addOptionType
        // }
        // Ajout d'un nouveau type d'interface
        const { useCreateOrUpdateTag: useCreateOrUpdateInterfaceType } = useTagGraphQl('Physical::InterfaceType')
        const addInterfaceType = (val: string) => {
            const mutateInterfaceType = useCreateOrUpdateInterfaceType((value) => {
                toast(`Interface Type ${value.label} créé`)
            })
            mutateInterfaceType({name: val})
        }

        // Ajout d'un nouveau type de Link
        const { useCreateOrUpdateTag: useCreateOrUpdateLinkType } = useTagGraphQl('Physical::LinkType')
        const addLinkType = (val: string) => {
            const mutateLinkType = useCreateOrUpdateLinkType((value) => {
                toast(`Link Type ${value.label} créé`)
            })
            mutateLinkType({name: val})
        }

        // Ajout d'un nouveau tag
        const { useCreateOrUpdateTag } = useTagGraphQl('Tag')
        const addTag = (val: string) => {
            const mutateTag = useCreateOrUpdateTag((value) => {
                toast(`Tag ${value.label} créé`)
            })
            mutateTag({name: val})
        }

        // Ajout d'un component type
        const { useCreateOrUpdateTag: ueCreateOrUpdateComponentType } = useTagGraphQl('Physical::ComponentType')
        const addComponentType = (val: string) => {
            const mutateTag = ueCreateOrUpdateComponentType((value) => {
                toast(`Component Type ${value.label} créé`)
            })
            mutateTag({name: val})
        }

        return { addInterfaceType, addLinkType, addTag, addComponentType }
    }
</script>