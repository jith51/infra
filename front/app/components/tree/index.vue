<script setup lang="ts" generic="T">
  import TreeItem from "./TreeItem.vue"

  import type { TreeNode } from "./tree_node.ts"

  const props = defineProps<{
    nodes: TreeNode<T>[]
  }>()

  // Gestion de l'ouverture des nodes
  const openNodes = ref<Set<string>>(new Set())

  const isOpen = (id: string): boolean => {
    return openNodes.value.has(id)
  }

  const toggleNode = (id: string, open: boolean): void => {
    const newSet = new Set(openNodes.value)

    if (open) {
      newSet.add(id)
    } else {
      newSet.delete(id)
    }

    openNodes.value = newSet
  }

  const openNode = (id: string): void => {
    const newSet = new Set(openNodes.value)
    newSet.add(id)
    openNodes.value = newSet
  }

  const closeNode = (id: string): void => {
    const newSet = new Set(openNodes.value)
    newSet.delete(id)
    openNodes.value = newSet
  }

  const toggleAll = (open: boolean) => {
    if (open) {
      const ids = new Set<string>()

      const walk = (nodes: TreeNode<T>[]) => {
        nodes.forEach(node => {
          if (node.id) {
            ids.add(node.id)
          }

          walk(node.children)
        })
      }

      walk(props.nodes)
      openNodes.value = ids

    } else {
      openNodes.value = new Set()
    }
  }

  provide("treeState", {
    isOpen,
    toggleNode
  })
  
  defineExpose({
    openNode,
    closeNode,
    toggleAll
  })

</script>

<template>
  <div class="space-y-1">
    <TreeItem
      v-for="node in nodes"
      :key="node.id"
      :node="node"
      :depth="0"
    >
      <template #label="props">
        <slot
          name="label"
          v-bind="props"
        />
      </template>
    </TreeItem>
  </div>
</template>