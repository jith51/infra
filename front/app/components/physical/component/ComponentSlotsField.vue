<template>
    <form.Field
        :name
        mode="array"
        #default="{ field }"
    >
        <FieldSet class="gap-2">
            <FieldLegend variant="label" >Composants</FieldLegend>
            <FieldDescription>
                <div class="flex border-b">
                    <div class="w-full grid grid-cols-12 gap-2">
                        <span class="inline-flex items-end col-span-3">Nom</span>
                        <span class="inline-flex items-end col-span-3">Type</span>
                        <span class="inline-flex items-end col-span-6">Description</span>  
                    </div>
                    <Button
                        type="button"
                        variant="ghost"
                        size="icon-sm"
                        class="group pt-3 hover:bg-white"
                        @click="field.pushValue({ name: '', description: '', componentTypeId: ''})"
                    >
                        <Plus class="size-4 group-hover:size-6"/>
                    </Button>
                </div>
            </FieldDescription>
            <FieldGroup class="gap-2">
                <template v-for="(_, index) in field.state.value">
                    <div class="flex">
                        <div class="w-full grid grid-cols-12 gap-2 items-start">
                            <div class="col-span-3">
                                <InputField 
                                    :form
                                    :name="`${name}[${index}].name`"
                                />
                            </div>
                            <div class="col-span-3">
                                <CommandSelectField
                                    :form 
                                    :name="`${name}[${index}].componentTypeId`" 
                                    :options="componentTypes"
                                    @add-option="createNewComponentType"
                                    @remove-option="deleteComponentType"
                                />
                            </div>
                            <div class="col-span-6">
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

// Props
const props = defineProps<{
    form: FormApi<T>
    name: string
}>()

const {
    loadObjects: loadComponentTypes,
    objects: componentTypes,
    onLoadError,

    mutateObject: mutateComponentType,
    onMutationError,

    deleteObject: deleteComponentType,
    onDeleteError,
} = useComponentTypeGraphQl()

// On Recherche les types de component
loadComponentTypes()
onLoadError((error) => {
    let graphQlError
    if (CombinedGraphQLErrors.is(error)) graphQlError = error.errors[0]?.message
    toast.error('Echec de chargement des type de composants : ' + graphQlError)
})

// Creation d'un nouveau ComponentType
function createNewComponentType(value: string) {
    mutateComponentType({name: value})
}
onMutationError((error) => {
    let graphQlError
    if (CombinedGraphQLErrors.is(error)) graphQlError = error.errors[0]?.message
    toast.error('Type de composant non enregistré : ' + graphQlError)
})

// Suppression d'un ComponentType
onDeleteError((error) => {
    let graphQlError
    if (CombinedGraphQLErrors.is(error)) graphQlError = error.errors[0]?.message
    toast.error('Type de composant non supprimé : ' + graphQlError)
})

</script>