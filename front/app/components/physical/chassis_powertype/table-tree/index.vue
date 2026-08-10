<template>
    <Tree ref="tree" :nodes="chassisPowertypeTree">
        <template #label="{ node }">
            <div
                class="group flex items-center justify-between rounded-md py-1 hover:bg-gray-100"
                :class="{ 'bg-gray-50': selected?.id == node.id }"
                @click="emit('select', node)"
            >
                <!-- Affichage du nom du node -->
                <div class="flex items-center gap-2">
                    <span>{{ node.name }}</span>
                </div>
                <div class="flex gap-1 mr-1">
                    <!-- Bouton de création d'un enfant avec tooltip -->
                    <TooltipProvider>
                        <Tooltip>
                            <TooltipTrigger as-child>
                                <Button
                                    variant="ghost"
                                    size="icon-sm"
                                    class="opacity-0 transition-opacity group-hover:opacity-100 group-focus-within:opacity-100"
                                    @click.stop="emit('createChildFor', node.id as string)"
                                >
                                    <Plus class="size-4"/>
                                </Button>
                            </TooltipTrigger>
                            <TooltipContent>
                                <p>Création d'un enfant</p>
                            </TooltipContent>
                        </Tooltip>
                    </TooltipProvider>
                    <!-- Bouton de suppression avec tooltip si pas d'enfant -->
                    <TooltipProvider v-if="node.children.length == 0">
                        <Tooltip>
                            <TooltipTrigger as-child>
                                <Button
                                    variant="ghost"
                                    size="icon-sm"
                                    class="opacity-0 transition-opacity group-hover:opacity-100 group-focus-within:opacity-100"
                                    @click.stop="emit('removeNode', node)"
                                >
                                    <XIcon class="size-4"/>
                                </Button>
                            </TooltipTrigger>
                            <TooltipContent>
                                <p>Suppression du Chassis Powertype</p>
                            </TooltipContent>
                        </Tooltip>
                    </TooltipProvider>
                </div>
            </div>
        </template>
    </Tree>
</template>


<script setup lang="ts">
    // Icones
    import { XIcon, Plus } from "@lucide/vue"

    // Types
    import type { ChassisPowertypeType } from '@/types/physical/chassis_powertype.ts'
    import type { TreeNode } from '@/components/tree/tree_node'
    
    defineProps<{
        chassisPowertypeTree: TreeNode<ChassisPowertypeType>[],
        selected?: TreeNode<ChassisPowertypeType> 
    }>()

    const emit = defineEmits<{
        (e: 'select', value: TreeNode<ChassisPowertypeType>): void
        (e: 'createChildFor', value: string): void
        (e: 'removeNode', value: TreeNode<ChassisPowertypeType>): void
    }>()

    const tree = useTemplateRef('tree')

    defineExpose({
        tree
    })
</script>