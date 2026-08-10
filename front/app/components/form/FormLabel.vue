<template>
    <FieldLabel :for="field.name">
        <slot/>
    </FieldLabel>
</template>
<script setup lang="ts">
    import { injectFormFieldContext } from "./FormFieldContextProvider.vue"

    const { field } = injectFormFieldContext()
</script>

