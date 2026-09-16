<template>
    <BaseField :of :path :label #default="{ field }">
        <Input
            id="name"
            v-model="field.input as string | number | undefined"
            v-bind="field.props"
            :aria-invalid="field.errors !== null && field.isTouched"
            autocomplete="off"
        />
    </BaseField>
</template>
<script setup lang="ts">
    import type { FormStore } from '@formisch/vue'
    import BaseField from './BaseField.vue'

    defineProps<{
        of: FormStore
        path: readonly [string] | (string | number)[]
        label?: string
    }>()
</script>