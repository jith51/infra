import * as v from 'valibot'

import { chassisClassSchema } from '@/types/physical/chassis_class'
import { portSchema, portFormSchema } from '@/types/physical/port'
import { componentSchema, componentFormSchema} from '@/types/physical/component'
import type { FilterTableType } from '@/types/base'

// Schema  et type du chassis
const chassisSchema = v.object({
    id: v.string(),
    name: v.pipe(v.string(), v.nonEmpty()),
    serialNumber: v.nullish(v.string()),
    chassisClassId: v.string(),
    chassisClass: chassisClassSchema,
    ports: v.optional(v.array(portSchema)),
    components: v.optional(v.array(componentSchema)),
    tags: v.optional(v.array(v.string())),
    tagIds: v.optional(v.array(v.string()))
})

export type ChassisType = v.InferInput<typeof chassisSchema>

// Schema et type du chassis pour les forms
export const chassisFormSchema = v.object({
    id: v.nullish(v.string()),
    name: v.pipe(v.string(), v.nonEmpty()),
    serialNumber: v.nullish(v.string()),
    chassisClassId: v.string(),
    ports: v.optional(v.array(portFormSchema)),
    components: v.optional(v.array(componentFormSchema)),
    tagIds: v.optional(v.array(v.string()))
})

export type ChassisFormType = v.InferInput<typeof chassisFormSchema>


// Type du Filtre et des tables de Filtres

export type ChassisFilterType = {
    name: string,
    tagIds: string[],
    chassisClassIds: string[],
}

export type ChassisFilterTablesType = {
    tags: FilterTableType[],
    chassisClasses: FilterTableType[]
}

// Connections
// const connectionFormSchema = v.object({
//     id: v.optional(v.string()),
//     distantId: v.nullish(v.string()),
//     linkTypeId: v.nullish(v.string()),
//     _destroy: v.nullish(v.boolean())
// })

// // Components
// const componentFormSchema = v.object({
//     id: v.optional(v.string()),
//     name: v.pipe(v.string(), v.nonEmpty()),
//     serialNumber: v.nullish(v.string()),
//     description: v.nullish(v.string()),
//     componentTypeId: v.string(),
//     _destroy: v.nullish(v.boolean())
// })

// // Ports
// const portFormSchema = v.object({
//     id: v.optional(v.string()),
//     name: v.pipe(v.string(), v.nonEmpty()),
//     macAddress: v.nullish(v.string()),
//     interfaceTypeId: v.nullish(v.string()),
//     connection: v.nullish(connectionFormSchema),
//     _destroy: v.nullish(v.boolean())
// })
