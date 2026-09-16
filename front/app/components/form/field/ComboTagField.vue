<template>
    <BaseField :form :label :type #default="{ inputProps }">
        <ComboTag
            :options
            :label
            v-bind="usePick(inputProps, ['modelValue', 'onUpdate:model-value'])"
            @add="add"
            @remove="remove"
        />            
    </BaseField>
</template>

<script setup lang="ts" generic="T, N">
// On utilise ici le mécanisme de allthrough Attributes --> https://vuejs.org/guide/components/attrs.html
// Tous les props et emits passer lors de l'appel de InputField sont passer à FormField
import type { FormApi } from "@tanstack/vue-form"
import type { FieldType } from "@/types/field"

import { ComboTag } from "@/components/my-ui"

// Types
type Option = {
    id: string
    name: string
}
// Props
withDefaults(
    defineProps<{
        form: FormApi<T>
        options: Option[]
        label?: string
        type?: FieldType
}>(), {
    options: () => [],
    type: 'text',
})

// Emit : demande d'ajout et de suppression d'un Tag
const emit = defineEmits<{
	(e: 'add', name: string): void
    (e: 'remove', name: string): void
}>()

// On proage l'emit
function add (value: string) {
    emit('add', value)
}
function remove (value: string) {
    emit('remove', value)
}

</script>