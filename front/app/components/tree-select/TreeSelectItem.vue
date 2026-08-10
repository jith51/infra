<script setup lang="ts" generic="T">
import type { TreeNode } from '@/components/tree/tree_node'

const props = defineProps<{
    node: TreeNode<T>
    level: number
    selectedId: string | null | undefined
}>()
</script>


<template>
<CommandItem 
    :key="node.id"
    :value="node"
    class="flex items-center gap-1 py-1 hover:bg-accent rounded cursor-pointer"
    :class="{'bg-gray-50': node.id === selectedId}"
>
    <span :style="{ paddingLeft: `${level * 16}px` }">
        {{ node.name }}
    </span>
</CommandItem>
<TreeSelectItem
    v-for="child in node.children"
    :key="child.id"
    :node="child"
    :level="level + 1"
    :selected-id
/>
</template>
