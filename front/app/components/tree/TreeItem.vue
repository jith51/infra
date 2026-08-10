<script setup lang="ts" generic="T">
  import { ChevronRight } from "@lucide/vue"
  import { Collapsible, CollapsibleContent } from "@/components/ui/collapsible"
  
  import type { TreeNode } from "./tree_node.ts"

  const props = defineProps<{
    node: TreeNode<T>
    depth: number
  }>()

  defineSlots<{
    label(props: {
      node: TreeNode<T>
      depth: number
      open: boolean
    }): any
  }>()

  // Gestion de l'ouverture des noeuds
  const treeState = inject<{
    isOpen: (id: string) => boolean
    toggleNode: (id: string, open: boolean) => void
  }>("treeState")

  const open = computed({
    get() {
      return props.node.id
        ? treeState?.isOpen(props.node.id) ?? false
        : false
    },

    set(value: boolean) {
      if (props.node.id) {
        treeState?.toggleNode(props.node.id, value)
      }
    }
  })
</script>

<template>
  <div>
    <Collapsible
      v-if="node.children?.length"
      v-model:open="open"
      as-child
    >
      <div
        class="flex items-center justify-between gap-2"
        :style="{ paddingLeft: `${depth * 10}px` }"
      >
        <div class="flex-1">
          <slot
            name="label"
            :node="node"
            :depth="depth"
            :open="open"
          >
            {{ node.name }}
          </slot>
        </div>
        <!-- Icone uniquement pour le dépliage -->
        <CollapsibleTrigger as-child>
            <ChevronRight class="ml-auto h-4 w-4 transition-transform duration-200 data-[state=open]:rotate-90"/>
        </CollapsibleTrigger>
      </div>
      <CollapsibleContent>
        <TreeItem
          v-for="child in node.children"
          :key="child.id"
          :node="child"
          :depth="depth + 1"
        >
          <template #label="slotProps">
            <slot
              name="label"
              v-bind="slotProps"
            />
          </template>
        </TreeItem>
      </CollapsibleContent>
    </Collapsible>

    <div
      v-else
      class="flex items-center py-1"
      :style="{ paddingLeft: `${depth * 10}px` }"
    >
      <div class="flex-1">
        <slot
          name="label"
          :node="node"
          :depth="depth"
          :open="false"
        >
          {{ node.name }}
        </slot>
      </div>
    </div>
  </div>
</template>