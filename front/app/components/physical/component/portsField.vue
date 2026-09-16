<template>
    <form.Field
        :name
        mode="array"
        #default="{ field }"
    >
        <FieldSet class="gap-2">
            <FieldLegend variant="label" >Ports</FieldLegend>
            <FieldDescription>
                <div class="flex border-b">
                    <div class="w-full grid grid-cols-8 gap-2">
                        <span class="inline-flex items-end col-span-1">Nom</span>
                        <span class="inline-flex items-end col-span-1">Type</span>
                        <span class="inline-flex items-end col-span-1">Adresse Mac</span>
                        <span class="inline-flex items-end col-span-2">Chassis connecté</span>
                        <span class="inline-flex items-end col-span-1">Link Type</span>
                        <span class="inline-flex items-end col-span-2">Description</span>  
                    </div>
                    <Button
                        type="button"
                        variant="ghost"
                        size="icon-sm"
                        class="group pt-3 hover:bg-white"
                        @click="field.pushValue(newPort)"
                    >
                        <Plus class="size-4 group-hover:size-6"/>
                    </Button>
                </div>
            </FieldDescription>
            <FieldGroup class="gap-2">
                <form.Subscribe
                    :selector="(state: any) => state.values[name]"
                    v-slot="ports"
                >
                    <template v-for="(_, index) in field.state.value">
                        <div class="flex">
                            <div class="w-full grid grid-cols-8 gap-2 items-start">
                                <InputField :form :name="`${name}[${index}].name`" />
                                <CommandSelectField
                                    :form 
                                    :name="`${name}[${index}].portTypeId`" 
                                    :options="portTypes"
                                    @add-option="createNewComponentType"
                                    @remove-option="deletePortType"
                                />
                                <InputField :form :name="`${name}[${index}].macAddress`" />
                                <div class="col-span-2">
                                    <CommandSelectField
                                        :form 
                                        :name="`${name}[${index}].connection.distantPortId`" 
                                        :options="calculatedAvailablePorts(ports, ports[index], availablePorts)"
                                        :with-delete-option="false"
                                    />
                                </div>
                                <CommandSelectField
                                    :form 
                                    :name="`${name}[${index}].connection.linkTypeId`" 
                                    :options="linkTypes"
                                    @add-option="createNewLinkType"
                                    @remove-option="deleteLinkType"
                                />
                                <div class="col-span-2">
                                    <InputField :form :name="`${name}[${index}].description`"/>
                                </div>
                            </div>
                            <Button
                                type="button"
                                variant="ghost"
                                size="icon-sm"
                                class="group hover:bg-white"
                                @click="field.removeValue(index)"
                            >
                                <XIcon class="size-4 group-hover:size-6"/>
                            </Button>
                        </div>
                    </template>
                </form.Subscribe>
            </FieldGroup>
        </FieldSet>
        <FieldError v-if="field.state.meta.isTouched && !field.state.meta.isValid" :errors="field.state.meta.errors" />
    </form.Field>
</template>

<script setup lang="ts" generic="T">
// Import des types
import type { FormApi } from "@tanstack/vue-form"
// Import des icones
import { XIcon, Plus } from "@lucide/vue"
// Import graphql
import { CombinedGraphQLErrors } from "@apollo/client/errors"
// Import du toast
import { toast } from 'vue-sonner'

import type { OptionType } from '@/types/base'
import type { PortType } from '@/types/physical/port'

// Props
const props = defineProps<{
    form: FormApi<T>
    name: string
    availablePorts: OptionType[]
}>()

const newPort = { name: '', description: '', portTypeId: '', macAddress: '', connection: {distantPortId: '', linkTypeId: ''}}

function calculatedAvailablePorts(
  allChassisPorts: PortType[],
  currentChassisPort: PortType,
  availablePorts: OptionType[]
) {
  const currentId = String(currentChassisPort?.connection?.distantPortId ?? '')

  const usedPortIds = new Set(allChassisPorts.map(port => port.connection?.distantPortId).filter(Boolean).map(String))

  return availablePorts.filter(port => {
    const portId = String(port.id)
    
    return portId === currentId || !usedPortIds.has(portId)
  })
}
// QUERIES ET MUTATIONS

const { 
    loadObjects: loadPortTypes,
    objects: portTypes,
    onLoadError,

    mutateObject,
    onMutationError,

    deleteObject: deletePortType,
    onDeleteError,
} = usePortTypeGraphQl()

// On Recherche les types de port
loadPortTypes()

onLoadError((error) => {
    let graphQlError
    if (CombinedGraphQLErrors.is(error)) graphQlError = error.errors[0]?.message
    toast.error('Eches de chargement des types de port : ' + graphQlError)
})

// Creation d'un nouveau PortType
function createNewComponentType(value: string) {
    mutateObject({name: value})
}
onMutationError((error) => {
    let graphQlError
    if (CombinedGraphQLErrors.is(error)) graphQlError = error.errors[0]?.message
    toast.error('Type de port non enregistré : ' + graphQlError)
})

// Suppression d'un PortType
onDeleteError((error) => {
    let graphQlError
    if (CombinedGraphQLErrors.is(error)) graphQlError = error.errors[0]?.message
    toast.error('Type de port non supprimé : ' + graphQlError)
})


const { 
    loadObjects: loadLinkTypes,
    objects: linkTypes,
    onLoadError: onLinkTypeError,

    mutateObject: mutateLinkType,
    onMutationError: onLinkMutationError,

    deleteObject: deleteLinkType,
    onDeleteError: onDeleteLinkError,
} = useLinkTypeGraphQl()

// On Recherche les types de link
loadLinkTypes()

onLinkTypeError((error) => {
    let graphQlError
    if (CombinedGraphQLErrors.is(error)) graphQlError = error.errors[0]?.message
    toast.error('Eches de chargement des types de link : ' + graphQlError)
})

// Creation d'un nouveau PortType
function createNewLinkType(value: string) {
    mutateLinkType({name: value})
}
onLinkMutationError((error) => {
    let graphQlError
    if (CombinedGraphQLErrors.is(error)) graphQlError = error.errors[0]?.message
    toast.error('Type de link non enregistré : ' + graphQlError)
})

// Suppression d'un PortType
onDeleteLinkError((error) => {
    let graphQlError
    if (CombinedGraphQLErrors.is(error)) graphQlError = error.errors[0]?.message
    toast.error('Type de Link non supprimé : ' + graphQlError)
})
</script>