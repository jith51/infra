<template>
    <FormischField v-slot="field" :of :path>
        <Field :data-invalid="field.errors !== null && field.isTouched" v-bind="$attrs">
            <FieldLabel v-if="label" for="form-formisch-demo-title"> {{ label }} </FieldLabel>
            <slot v-bind="{field}"/>
            <FieldError v-if="field.errors && field.isTouched" :errors="field.errors.map(message => ({ message }))"/>
        </Field>
    </FormischField>
</template>
<script setup lang="ts">
    import {Field as FormischField } from '@formisch/vue'
    import type { FormStore } from '@formisch/vue'

    defineOptions({
        inheritAttrs: false
    })

    defineProps<{
        of: FormStore
        path: readonly [string] | (string | number)[]
        label?: string
    }>()
</script>
