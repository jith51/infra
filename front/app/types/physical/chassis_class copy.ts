import * as v from 'valibot'

import { customAttributeDefinitionSchema } from '@/types/physical/custom_attribute_definition'
import { componentSchema, componentFormSchema } from '@/types/physical/component'
import { portSchema, portFormSchema} from '@/types/physical/port'

// ChassiClass
const chassisClassSchema = v.object({
    id: v.pipe(v.string(), v.nonEmpty()),
    name: v.pipe(v.string(), v.nonEmpty()),
    chassisPowertypeId: v.nullish(v.string()),
    fournisseur: v.nullish(v.string()),
    model: v.nullish(v.string()),
    version: v.nullish(v.string()),
    partNumber: v.nullish(v.string()),
    vendorEquipmentType: v.nullish(v.string()),
    height: v.nullish(v.pipe(v.number(), v.integer())),
    urlLink: v.nullish(v.union([
        v.literal(""),
        v.pipe(v.string(), v.url()),
    ])),
    frontImage: v.nullish(v.union([
        v.pipe(v.string()),
        v.pipe(v.file(),v.mimeType(['image/jpeg', 'image/png']),v.maxSize(500 * 200 * 10))
    ])),
    backImage: v.nullish(v.union([
        v.pipe(v.string()),
        v.pipe(v.file(),v.mimeType(['image/jpeg', 'image/png']),v.maxSize(500 * 200 * 10))
    ])),
    components: v.nullish(v.array(componentSchema)),
    ports: v.nullish(v.array(portSchema)),
    customAttributes: v.nullish(v.record(
      v.string(),
      v.union([
        v.string(),
        v.number(),
        v.boolean(),
    ]))),
    customAttributesDefinition: v.nullish(v.array(customAttributeDefinitionSchema))
})

// Pour la form on supprime l'obligation de l'id
export const chassisClassFormSchema = v.object({
  ...v.partial(chassisClassSchema, ['id']).entries,
  components: v.nullish(v.array(componentFormSchema)),
  ports: v.nullish(v.array(portFormSchema)),
})

export type ChassisClassType = v.InferInput<typeof chassisClassSchema>
export type ChassisClassFormType = v.InferInput<typeof chassisClassFormSchema>

// ChassiClassFilter
const chassisClassFilterSchema = v.object({
  name: v.string()
})
export type ChassisClassFilterType = v.InferInput<typeof chassisClassFilterSchema>