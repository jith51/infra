<template>
    <BaseField :form :label :type #default="{ inputProps }">
        <CommandSelect
            :options
            :withDeleteOption
            v-bind="usePick(inputProps, ['modelValue', 'onUpdate:model-value'])"
            @add-option="addOption"
            @remove-option="removeOption"
            @option-selected="optionSelected"
        />
    </BaseField>
</template>

<script setup lang="ts" generic="T, N">
// On utilise ici le mécanisme de allthrough Attributes --> https://vuejs.org/guide/components/attrs.html
// Tous les props et emits passer lors de l'appel de InputField sont passer à FormField
import type { FormApi } from "@tanstack/vue-form"
import type { FieldType } from "@/types/field"

import { CommandSelect } from '@/components/my-ui'

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
        withDeleteOption?: boolean
        label?: string
        type?: FieldType
}>(), {
    options: () => [],
    type: 'text',
    withDeleteOption: true
})
// Emit : demande d'ajout et de suppression d'une option
const emit = defineEmits<{
	(e: 'addOption', name: string): void
    (e: 'removeOption', name: string): void
    (e: 'optionSelected', id: string | null | undefined): void
}>()
// On proage l'emit
function addOption (value: string) {
    emit('addOption', value)
}
function removeOption (value: string) {
    emit('removeOption', value)
}

function optionSelected(id: string | null | undefined) {
    emit('optionSelected', id)
}

</script>