<template>
    <FormField :form>
        <FormControl :type #default="{inputProps}">
            <FormLabel v-if="label !== undefined">{{label}}</FormLabel>
            <slot v-bind="{inputProps}"/>
            <FormMessage />
        </FormControl>
    </FormField>
</template>

<script setup lang="ts" generic="T">
// On utilise ici le mécanisme de allthrough Attributes --> https://vuejs.org/guide/components/attrs.html
// Tous les props et emits passer lors de l'appel de InputField sont passer à FormField
import type { FormApi } from "@tanstack/vue-form"
import type { FieldType } from "@/types/field"

withDefaults(
    defineProps<{
        form: FormApi<T>
        label?: string
        type?: FieldType
}>(), {
    type: 'text'
})
</script>