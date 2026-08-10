<template>
    <BaseField :form :label :type #default="{ inputProps }">
        <Select v-bind="inputProps">
            <SelectTrigger
                :aria-invalid="inputProps['aria-invalid']"
                class="min-w-full"
            >
                <SelectValue :placeholder/>
            </SelectTrigger>
            <SelectContent position="item-aligned">
                <SelectLabel>{{ label }}</SelectLabel>
                <SelectItem v-for="option in options" :value="option.value">{{ option.label }}</SelectItem>
            </SelectContent>
        </Select>
    </BaseField>
</template>

<script setup lang="ts" generic="T">
// On utilise ici le mécanisme de allthrough Attributes --> https://vuejs.org/guide/components/attrs.html
// Tous les props et emits passer lors de l'appel de InputField sont passer à FormField
import type { FormApi } from "@tanstack/vue-form"
import type { FieldType } from "@/types/field"

defineProps<{
    form: FormApi<T>
    placeholder?: string
    options: { label: string, value: string }[]
    label?: string
    type?: FieldType
}>()
</script>