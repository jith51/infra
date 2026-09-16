import * as v from 'valibot'
import { connectionSchema } from '@/types/physical/connection'

// Port
export const portSchema = v.object({
    id: v.string(),
    name: v.pipe(v.string(), v.nonEmpty()),
    description: v.nullish(v.string()),
    serialNumber: v.nullish(v.string()),
    portTypeId: v.nullish(v.string()),
    connection: v.nullish(connectionSchema),
})

export const portFormSchema = v.partial(portSchema, ['id'])

// Export des types
export type PortType = v.InferInput<typeof portSchema>
export type PortTypeForm = v.InferInput<typeof portFormSchema>
