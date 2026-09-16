import * as v from 'valibot'

// PortSlot
export const portSlotSchema = v.object({
    id: v.string(),
    name: v.pipe(v.string(), v.nonEmpty()),
    description: v.nullish(v.string()),
    portTypeId: v.nullish(v.string()),
})

export const portSlotFormSchema = v.partial(portSlotSchema, ['id'])

// Export des types
export type PortSlotType = v.InferInput<typeof portSlotSchema>
export type PortSlotTypeForm = v.InferInput<typeof portSlotFormSchema>
