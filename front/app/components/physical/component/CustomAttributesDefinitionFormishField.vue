<template>
    <FieldArray :of :path v-slot="fieldArray">
        <FieldSet class="gap-2">
            <FieldLegend variant="label" >Définition des Custom Attributes</FieldLegend>
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
                        @click="
                            insert(of, {
                                path: path, 
                                initialInput: { name: '', label: '', type: '' }
                            })
                        "
                    >
                        <Plus class="size-4 group-hover:size-6"/>
                    </Button>
                </div>
            </FieldDescription>
            <FieldGroup class="gap-2">
                <template v-for="(item, index) in fieldArray.items" :key="item">
                <!-- <template v-for="(_, index) in field.state.value"> -->
                    <div class="flex">
                        <div class="w-full grid grid-cols-12 gap-2 items-start">
                            <div class="col-span-3">
                                <InputField :of :path="[...path, index, 'name']"/>
                                <!-- <InputField :form :name="`${name}[${index}].name`"
                                    :validators="{
                                        onChange: ({ value }: { value: string }) => {
                                            return validateUniqNameOnCustomAttribute(value)
                                        }
                                    }"
                                /> -->
                            </div>
                            <div class="col-span-3">
                                <SelectField :of :path="[...path, index, 'type']" :options/>
                            </div>
                            <div class="col-span-6">
                                <InputField :of :path="[...path, index, 'label']"/>
                                <!-- <InputField :form :name="`${name}[${index}].label`"/> -->
                            </div>
                        </div>
                        <Button
                            type="button"
                            variant="ghost"
                            size="icon-sm"
                            class="group hover:bg-white"
                            @click="remove(of, { path: path, at: index })"
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
        <FieldError v-if="fieldArray.errors">{{ fieldArray.errors[0] }}</FieldError>
        <!-- ff -->
    </FieldArray>
</template>

<script setup lang="ts" generic="T">
import type { FormStore } from '@formisch/vue'
import { XIcon, Plus } from "@lucide/vue"
import { FIELD_TYPES } from "@/types/field"

import { FieldArray, insert, remove } from '@formisch/vue'

import InputField from '@/components/form/formishField/InputField.vue'
import SelectField from '@/components/form/formishField/SelectField.vue'

withDefaults(defineProps<{
    of: FormStore
    path: readonly [string]
    validateUniqNameOnCustomAttribute?: (value: string) => string | undefined
}>(),{
    validateUniqNameOnCustomAttribute: (value: string) => undefined,
})

const options = ref(FIELD_TYPES.map((value) => ({
    label: value.charAt(0).toUpperCase() + value.slice(1),
    value
})))

</script>