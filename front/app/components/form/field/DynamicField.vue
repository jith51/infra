<template>
    <component :is="componentType" :form :label :type />
</template>

<script setup lang="ts" generic="T">
// On utilise ici le mécanisme de allthrough Attributes --> https://vuejs.org/guide/components/attrs.html
// Tous les props et emits passer lors de l'appel de InputField sont passer à FormField
import type { FormApi } from "@tanstack/vue-form"
import type { FieldType } from "@/types/field"

import InputField from './InputField.vue'
import DateField from './InputField.vue'
import SwitchField from './SwitchField.vue'

const { form, label, type = 'text' } = defineProps<{
    form: FormApi<T>
    label?: string
    type?: FieldType
}>()

const componentType = computed(() => {
    switch (type) {
    case "date":
        return DateField
    case "boolean":
        return SwitchField        
    default:
        return InputField
    }
})
</script>