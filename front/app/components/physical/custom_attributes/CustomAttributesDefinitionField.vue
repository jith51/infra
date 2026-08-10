<template>
    <form.Field
        :name
        mode="array"
        #default="{ field }"
    >
        <FieldSet class="gap-2">
            <FieldLegend variant="label" >Custom Attributes</FieldLegend>
            <FieldDescription>
                <div class="flex border-b">
                    <div class="w-full grid grid-cols-12 gap-2">
                        <span class="inline-flex items-end col-span-3">Nom</span>
                        <span class="inline-flex items-end col-span-3">Type</span> 
                        <span class="inline-flex items-end col-span-6">Label</span>
                    </div>
                    <Button
                        type="button"
                        variant="ghost"
                        size="icon-sm"
                        class="group pt-3 hover:bg-white"
                        @click="field.pushValue({ name: '', label: '', type: '' })"
                    >
                        <Plus class="size-4 group-hover:size-6"/>
                    </Button>
                </div>
            </FieldDescription>
            <FieldGroup class="gap-2">
                <template v-for="(_, index) in field.state.value">
                    <div class="flex">
                        <div class="w-full grid grid-cols-12 gap-2 items-start">
                            <div class="col-span-3">
                                <InputField :form :name="`${name}[${index}].name`"/>
                                <!-- <InputField :form :name="`${name}[${index}].name`"
                                    :validators="{
                                        onChange: ({ value }: { value: string }) => {
                                            return validateUniqNameOnCustomAttribute(value)
                                        }
                                    }"
                                /> -->
                            </div>
                            <div class="col-span-3">
                                <SelectField :form :name="`${name}[${index}].type`" :options/>
                            </div>
                            <div class="col-span-6">
                                <InputField :form :name="`${name}[${index}].label`"/>
                            </div>
                        </div>
                        <Button
                            type="button"
                            variant="ghost"
                            size="icon-sm"
                            class="group hover:bg-white"
                            @click="field.removeValue(index)"
                        >
                            <XIcon class="size-4 group-hover:size-6"/>
                        </Button>
                    </div>
                </template>
            </FieldGroup>
        </FieldSet>
        <!-- ff
        {{ field.state.meta.isTouched && !field.state.meta.isValid }}
        {{ field.state.meta.isTouched && !field.state.meta.isValid }} -->
        <FieldError v-if="field.state.meta.isTouched && !field.state.meta.isValid" :errors="field.state.meta.errors" />
        <!-- ff -->
    </form.Field>
</template>

<script setup lang="ts" generic="T">
import type { FormApi } from "@tanstack/vue-form"
import { XIcon, Plus } from "@lucide/vue"
import { FIELD_TYPES } from "@/types/field"

withDefaults(defineProps<{
    form: FormApi<T>
    name: string
    validateUniqNameOnCustomAttribute?: (value: string) => string | undefined
}>(),{
    validateUniqNameOnCustomAttribute: (value: string) => undefined,
})

const options = ref(FIELD_TYPES.map((value) => ({
    label: value.charAt(0).toUpperCase() + value.slice(1),
    value
})))

</script>