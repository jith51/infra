import * as v from 'valibot'

// Port
export const connectionSchema = v.object({
    id: v.nullish(v.string()),
    distantPortId: v.nullish(v.string()),
    linkTypeId: v.nullish(v.string()),
})


// Export des types
export type connectionType = v.InferInput<typeof connectionSchema>
