<template>
    <div class="h-full w-full max-w-7xl overflow-auto">
        <div class="flex justify-between border-b border-grey-200 mb-7 pb-1">
            <div class="flex space-x-4">
                <span class="inline-flex items-end">Liste des Chassis Powertypes</span>
                <TooltipProvider>
                    <Tooltip>
                        <TooltipTrigger as-child>
                            <ChevronRight 
                                class="ml-auto self-end mb-1 h-4 w-4 transition-transform duration-200"
                                :class="{'rotate-90': openNodes}"
                                @click="toggleNodes()"
                                />
                        </TooltipTrigger>
                        <TooltipContent>
                            <p>Toggle de l'arbre</p>
                        </TooltipContent>
                    </Tooltip>
                </TooltipProvider>
            </div>
            <div class="pb-1">
                <Button size="sm" variant="outline" @click="initializeChassisPowertype"> Nouveau </Button>
            </div>
        </div>
        <div class="flex w-full overflow-auto">
            <div class="w-5/12">
                <PhysicalChassisPowertypeTableTree
                    ref="tableTree"
                    :chassisPowertypeTree="chassisPowertypesTree"
                    :selected="selectedChassisPowertype"
                    @select="select"
                    @create-child-for="initializeChassisPowertype"
                    @remove-node="(v) => deleteChassisPowertype(v.id)"
                />
            </div>
            <div class="w-7/12 pl-2">
                <PhysicalChassisPowertypeForm
                    v-if="chassisPowertypeOnForm"
                    :chassisPowertypeAscendants="getChassisPowertypeAscendants(chassisPowertypeOnForm)"
                    :chassisPowertype="chassisPowertypeOnForm"
                    @chassis-powertype-id-updated="onChassisPowertypeIdUpdated"
                />
            </div>
        </div>
    </div>
</template>


<script setup lang="ts">
    // IMPORTS
    import { ChevronRight } from "@lucide/vue"
    import { useTree } from '@/components/tree/tree_node'
    // Toast
    import { toast } from 'vue-sonner'
    
    // TYPES
    import type { ChassisPowertypeType } from '@/types/physical/chassis_powertype'
    import type { TreeNode } from '@/components/tree/tree_node'
    
    type ChassisPowertypeForm = Omit<ChassisPowertypeType, 'id'> | undefined

    // QUERY / MUTATIONs
    const { 
        loadObjects, objects: chassisPowertypes, onLoadError, 
        deleteObject: deleteChassisPowertype, onDeleteError, onDeleteDone
    } = useChassisPowertypeGraphQl()
    
    // Récupération des powertypes
    loadObjects()

    // Callback aprés suppression
    onDeleteDone(() => {
        selectedChassisPowertype.value = undefined
        chassisPowertypeOnForm.value = undefined
        toast.success('Chassis Powertype supprimé')
    })

    import { CombinedGraphQLErrors } from "@apollo/client/errors";
    onDeleteError((error) => {
        if (CombinedGraphQLErrors.is(error)) {
            toast.error(error.errors[0]!.message)
        }
    })
    // TREE
    // L'arbre chassisPowertypesTree est un computed synchronisé avec chassisPowertypes
    const { tree: chassisPowertypesTree, getNode } = useTree<ChassisPowertypeType>(chassisPowertypes)

    // La reference du composant TableTree
    const tree = useTemplateRef('tableTree')
    
    // L'état de l'ouverture de tous les noeuds
    const openNodes = ref<boolean>(false)

    // Le node selectionné
    const selectedChassisPowertype = ref<TreeNode<ChassisPowertypeType> | undefined>(undefined)

    // Le powertype en cours dans la form
    const chassisPowertypeOnForm = ref<ChassisPowertypeForm>(undefined)

    // FUNCTIONs

    // Utilitaire : selection d'un node après update d'un ChassisPowertype
    // Quand le chassis est updaté on remet à jour la form (car avec l'update du cache de la mutation, il réinitialise 
    // avec le selectedNode qui a l'ancienne valeur
    function onChassisPowertypeIdUpdated(id: string): void {
        select(getNode(id)!)
        toast.success('Chassis Powertype enregistré')
    }
    // Utilitaire : Selection d'un node
    function select(node: TreeNode<ChassisPowertypeType>): void {
        // Mise à jour du ChassisPowertype selectionné
        selectedChassisPowertype.value = node
        // Mise à jour de la ref envoyé à la form
        const { children, ...input } = node
        chassisPowertypeOnForm.value = input
        // Ouverture du parent si il en possède un
        if (tree && tree.value && tree.value.tree && tree.value.tree && node.parentId !== '') {
            tree.value.tree.openNode(node.parentId!)
        }
    }
    // Utilitaire : Toggle de tous les nodes
    function toggleNodes(): void {
        openNodes.value = !openNodes.value
        if (tree && tree.value && tree.value.tree && tree.value.tree) tree.value.tree.toggleAll(openNodes.value)
    }

    // Utilitaire : initialisation d'un powertype 
    function initializeChassisPowertype(parentId?: string) {
        chassisPowertypeOnForm.value = { parentId: parentId ?? null, name: '', customAttributes: [] }
        selectedChassisPowertype.value = undefined
    }
    
    // Utilitaire : retourne un tableau des parents d'un Powertype
    function getChassisPowertypeAscendants(chassisPowertype: ChassisPowertypeForm): TreeNode<ChassisPowertypeType>[] {
        const ancestors: TreeNode<ChassisPowertypeType>[] = []
        if (chassisPowertype?.parentId && chassisPowertype.parentId !== '') {
            let parent = getNode(chassisPowertype.parentId)
            while (parent) {
                if (parent.customAttributes && parent.customAttributes.length !== 0) ancestors.push(parent) // Racine -> parent direct
                parent = parent.parentId ? getNode(parent.parentId) : undefined
            }
        }
        return ancestors
    }
</script>