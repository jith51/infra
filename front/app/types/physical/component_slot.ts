import * as v from 'valibot'

// Components Slot
export const componentSlotSchema = v.object({
    id: v.string(),
    name: v.pipe(v.string(), v.nonEmpty()),
    description: v.nullish(v.string()),
    componentTypeId: v.nullish(v.string()),
})

export const componentSlotFormSchema = v.partial(componentSlotSchema, ['id'])

// Export des types
export type ComponentSlotType = v.InferInput<typeof componentSlotSchema>
