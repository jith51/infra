<template>
    <BaseField :of :path :label #default="{ field }">
        <Select v-bind="field.props" v-model="field.input">
            <SelectTrigger
                class="min-w-full"
            >
            <!-- :aria-invalid="inputProps['aria-invalid']" -->
                <SelectValue :placeholder/>
            </SelectTrigger>
            <SelectContent position="item-aligned">
                <SelectLabel>{{ placeholder }}</SelectLabel>
                <SelectItem v-for="option in options" :value="option.value">{{ option.label }}</SelectItem>
            </SelectContent>
        </Select>
    </BaseField>
</template>

<script setup lang="ts">
    import type { FormStore } from '@formisch/vue'
    import BaseField from './BaseField.vue'

    defineProps<{
        of: FormStore
        path: readonly [string] | (string | number)[]
        options: { label: string, value: string }[]
        label?: string
        placeholder?: string
    }>()
</script>