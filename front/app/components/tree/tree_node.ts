export type TreeNode<T> = T & {
    id: string
    name: string
    children: TreeNode<T>[]
} 

export function useTree<T extends {id: string, parentId: string | null, name: string}>(items: MaybeRef<T[]>) {
    // Construction de l'arbre
    const tree = computed(() => buildTree(unref(items)))

    const buildTree = (items: T[]): TreeNode<T>[] => {
        const map = new Map<string, TreeNode<T>>()
        // init nodes
        items.forEach(item => map.set(<string>item.id, { ...item, children: [] }))
        
        const roots: TreeNode<T>[] = []

        items.forEach(item => {
            const node = map.get(<string>item.id)!

            if (item.parentId) {
                map.get(item.parentId)?.children.push(node)
            } else {
                roots.push(node)
            }
        })
        return roots
    }

    // Construction des indexes
    const index = computed(() => buildIndex(unref(tree)))

    const buildIndex = (nodes: TreeNode<T>[]) => {
        const map = new Map<string, TreeNode<T>>()

        const walk = (nodes: TreeNode<T>[]) => {
            for (const node of nodes) {
                map.set(node.id, node)
                walk(node.children)
            }
        }

        walk(nodes)

        return map
    }

    // Utilitaire : récupération d'un node de l'arbre à partir de son id
    const getNode = (id: string) => index.value.get(id)

    // Utilitaire : upgrade d'un node de l'arbre à partir de son id
    const updateNodeInTree = (id: string, patch: Partial<T>) => {
        const node = getNode(id)
        if (!node) return

        Object.assign(node, patch)
    }

    // Utilitaire : construction d'un tableau des ancetres d'un node à partir de son id
    const getAncestors = (id: string): TreeNode<T>[] => {
        const ancestors: TreeNode<T>[] = []

        let node = getNode(id)

        while (node?.parentId) {
            const parent = getNode(node.parentId)

            if (!parent) break

            ancestors.unshift(parent)
            node = parent
        }

        return ancestors
    }

    return { tree, updateNodeInTree, getNode, getAncestors }
}