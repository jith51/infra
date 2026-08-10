<template>
    <BaseField :form :label :type #default="{ inputProps }">
        <TreeSelect
            :tree="tree"
            v-bind="usePick(inputProps, ['modelValue', 'onUpdate:model-value'])"
        />            
    </BaseField>
</template>

<script setup lang="ts" generic="T, N">
// On utilise ici le mécanisme de allthrough Attributes --> https://vuejs.org/guide/components/attrs.html
// Tous les props et emits passer lors de l'appel de InputField sont passer à FormField
import type { FormApi } from "@tanstack/vue-form"
import type { FieldType } from "@/types/field"
import type { TreeNode } from '@/components/tree/tree_node' 

withDefaults(
    defineProps<{
        form: FormApi<T>
        label: string
        type?: FieldType
        tree?: TreeNode<N>[]
}>(), {
    type: 'text',
    tree: []
})
</script>