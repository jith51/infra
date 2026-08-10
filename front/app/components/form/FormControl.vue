<template>
    <Field :data-invalid="invalid">
        <slot v-bind="{ inputProps }"/>
    </Field>
</template>
<script setup lang="ts">
    import type { FieldType } from "@/types/field"

    type ControlMode =
        | 'modelValue'
        | 'checked'

    const props = withDefaults(
        defineProps<{
            type?: FieldType
            mode?: ControlMode
    }>(), {
        type: 'text',
        mode: 'modelValue'
    })

    import { injectFormFieldContext } from "./FormFieldContextProvider.vue"

    const { id, name, field, invalid } = injectFormFieldContext()

    const inputProps = computed(() => {
        const baseProps = {
            id: id,
            type: props.type,
            name: name,
            onBlur: field.handleBlur,
            'aria-invalid': invalid,
            autocomplete: "off"
            // 'aria-describedby': invalid.value ? `${descriptionId} ${messageId}` : descriptionId,
        }

        if (props.mode === 'checked') {
            return {
                ...baseProps,
                checked: field.state.value,
                'onUpdate:checked': (value: boolean) => {field.handleChange(value)}
            }
        }
        return {
            ...baseProps,
            modelValue: field.state.value,
            'onUpdate:model-value':  (value: unknown) => {
                field.handleChange(
                    props.type === 'number' ? Number(value) :  value
                )
            }
        }
    })

</script>