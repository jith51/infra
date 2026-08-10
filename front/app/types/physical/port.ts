import * as v from 'valibot'

// Port
export const portSchema = v.object({
    id: v.string(),
    name: v.pipe(v.string(), v.nonEmpty()),
    description: v.nullish(v.string()),
    serialNumber: v.nullish(v.string()),
    portTypeId: v.string(),
})

export const portFormSchema = v.partial(portSchema, ['id'])

// Export des types
export type PortType = v.InferInput<typeof portSchema>
export type PortTypeForm = v.InferInput<typeof portFormSchema>
