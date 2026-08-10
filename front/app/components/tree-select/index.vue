<script setup lang="ts" generic="T">
import type { TreeNode } from '@/components/tree/tree_node'
import { ChevronRight } from "@lucide/vue"

const props = defineProps<{
  tree: TreeNode<T>[]
}>()

const model = defineModel<string | null>({
  default: null,
})

// Node selectionné et synchronisation avec model (qui ne contient que l'id)
const selectedNode = computed<TreeNode<T> | null>({
  get() {
    if (!model.value) return null

    return findNode(props.tree, model.value) ?? null
  },

  set(node) {
    model.value = node?.id ?? null
  }
})

function findNode<T>(nodes: TreeNode<T>[], id: string): TreeNode<T> | undefined {
  for (const node of nodes) {
    if (node.id === id) return node
    const found = findNode(node.children, id)
    if (found) return found
  }
  return undefined
}
// Filtre
const search = ref("")

const filteredTree = computed(() => {
    return filterTree(props.tree, search.value)
})

const filterTree = (nodes: TreeNode<T>[], query: string): TreeNode<T>[] => {
    // debugger
    if (!query.trim()) return nodes
  
    const lowerQuery = query.toLowerCase()

    return nodes.map(node => {
        const children = filterTree(node.children, query)

        const matches = node.name
            .toLowerCase()
            .includes(lowerQuery)
    
        if (matches || children.length > 0) {
            return { ...node, children }
        }

        return null
    })
    .filter(Boolean) as TreeNode<T>[]
}
</script>

<template>
  <Popover v-slot="{close}">
    <PopoverTrigger as-child>
      <button
        class="border rounded-md px-3 py-2 w-full text-left group"
      >
        <div class="w-full flex justify-between">
            <span>{{ selectedNode?.name ?? "Sélectionner..." }}</span>
            <ChevronRight class="h-4 w-4 shrink-0 opacity-50 group-data-[state=open]:rotate-90 mt-1"/>
        </div>
      </button>
    </PopoverTrigger>
    <PopoverContent class="w-75 p-0">
      <Command 
        v-model="selectedNode"
        :should-filter="false"
        @update:model-value="close()"
    >
        <CommandInput
            placeholder="Rechercher..."
            v-model="search"
        />
        <CommandEmpty> Aucun résultat</CommandEmpty>
        <CommandGroup>
        <CommandList class="max-h-75 overflow-auto p-2">
            <TreeSelectItem
                v-for="node in filteredTree"
                :key="node.id"
                :node="node"
                :level="0"
                :selected-id="selectedNode?.id"
            />
        </CommandList>
        </CommandGroup>
      </Command>
    </PopoverContent>
  </Popover>
</template>
