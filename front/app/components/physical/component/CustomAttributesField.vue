<template>
    <template v-for="customAttributesField in customAttributesDefinition">
        <DynamicField
            :form 
            :type="customAttributesField.type"
            :name="`customAttributes.${customAttributesField!.name}`"
            :label="customAttributesField!.label"
            :validators="{
                onChange: ({ value } : {value: string}) => {
                    const result = validateField(customAttributesField.type, value)
                    if (!result.success) {
                        return result.issues[0].message
                    }
                    return undefined
                }
            }"
        />
    </template>
</template>

<script setup lang="ts" generic="T">
import type { CustomAttributeDefinitionType } from '@/types/physical/custom_attribute_definition'
import { validateField } from '@/types/field'

// Props
const props = defineProps<{
    form: FormApi<T>
    customAttributesDefinition: CustomAttributeDefinitionType[]
}>()

</script>