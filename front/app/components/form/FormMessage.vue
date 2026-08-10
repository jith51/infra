<template>
    <FieldError v-if="invalid" :errors="field.state.meta.errors" />
</template>
<script setup lang="ts">
    import { injectFormFieldContext } from "./FormFieldContextProvider.vue"

    const { field, invalid } = injectFormFieldContext()
</script>