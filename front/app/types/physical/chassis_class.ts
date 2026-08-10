import * as v from 'valibot'

import { chassisPowertypeSchema } from './chassis_powertype'
import { customAttributeDefinitionSchema } from '@/types/physical/custom_attribute_definition'
import { componentSchema, componentFormSchema } from '@/types/physical/component'
import { portSchema, portFormSchema} from '@/types/physical/port'

function arraySchemaWithUniqueName<T extends { name: string }>(
  schema: v.GenericSchema<T>,
  message = "Chaque attribut doit avoir un nom unique."
) {
    return v.pipe(
        v.array(schema),
        v.custom<T[]>(
        (items: unknown): items is T[] => {
            const values = items as T[];
            const names = values.map((item) => item.name);
            // debugger
            return new Set(names).size === names.length;
        },
        message
        )
    );
}

// ChassiClass
export const chassisClassSchema = v.object({
    id: v.pipe(v.string(), v.nonEmpty()),
    name: v.pipe(v.string(), v.nonEmpty()),
    chassisPowertypeId: v.nullish(v.string()),
    chassisPowertype: v.nullish(chassisPowertypeSchema),
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
    customAttributes: v.nullish(v.record(
      v.string(),
      v.union([
        v.string(),
        v.number(),
        v.boolean(),
    ]))),
    customAttributesDefinition: v.nullish(arraySchemaWithUniqueName(customAttributeDefinitionSchema, 'Chaque attribut doit avoir un nom unique.')),
    components: v.nullish(arraySchemaWithUniqueName(componentSchema, 'Chaque composant doit avoir un nom unique.')),
    ports: v.nullish(arraySchemaWithUniqueName(portSchema, 'Chaque port doit avoir un nom unique.')),
})

// Pour la form on supprime l'obligation de l'id
export const chassisClassFormSchema = v.object({
	...v.partial(v.omit(chassisClassSchema, ['chassisPowertype']), ['id']).entries,
	components: v.nullish(arraySchemaWithUniqueName(componentFormSchema, 'Chaque composant doit avoir un nom unique.')),
	ports: v.nullish(arraySchemaWithUniqueName(portFormSchema, 'Chaque port doit avoir un nom unique.')),
})

export type ChassisClassType = v.InferInput<typeof chassisClassSchema>
export type ChassisClassFormType = v.InferInput<typeof chassisClassFormSchema>

// ChassiClassFilter
const chassisClassFilterSchema = v.object({
  name: v.string(),
  chassisPowertypeIds: v.array(v.string())
})
export type ChassisClassFilterType = v.InferInput<typeof chassisClassFilterSchema>