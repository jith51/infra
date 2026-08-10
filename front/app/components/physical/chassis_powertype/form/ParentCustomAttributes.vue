<script setup lang="ts">
    import { Plus } from "@lucide/vue"
    import type { CustomAttributeDefinitionType  } from '@/types/physical/custom_attribute_definition'

    const props = defineProps<{
        parentName: string
        customAttributes: CustomAttributeDefinitionType []
    }>()

    // Utilitaire 
    const capitalize = (str: string) =>
        str ? str[0]!.toLocaleUpperCase() + str.slice(1) : ""

</script>

<template>
    <FieldSet>
        <FieldLegend variant="label" >Custom Attributes hérités de {{ parentName }}</FieldLegend>
        <FieldDescription>
            <div class="flex border-b">
                <div class="w-full grid grid-cols-12 gap-2">
                    <span class="inline-flex items-end col-span-3">Nom</span>
                    <span class="inline-flex items-end col-span-6">Label</span>
                    <span class="inline-flex items-end col-span-3">Type</span>  
                </div>
                <Button type="button" size="icon-sm" class="hidden">
                    <Plus class="size-4 text-muted-foreground" />
                </Button>
            </div>
        </FieldDescription>
        <FieldGroup class="gap-2">
            <div 
                v-for="customAttribute in customAttributes"
                class="w-full grid grid-cols-12 gap-2"
            >
                <span class="inline-flex items-end col-span-3">{{customAttribute.name}}</span>
                <span class="inline-flex items-end col-span-6">{{customAttribute.label}}</span>
                <span class="inline-flex items-end col-span-3">{{capitalize(customAttribute.type)}}</span>  
            </div>
            <Button type="button" size="icon-sm" class="hidden">
                <Plus class="size-4 text-muted-foreground" />
            </Button>                    
        </FieldGroup>
    </FieldSet>
</template>