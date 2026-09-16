import * as v from 'valibot'

import { customAttributeDefinitionSchema } from '@/types/physical/custom_attribute_definition'
import { arraySchemaWithUniqueName, arraySchemaWithUniqueNameAndForbiddenNames } from '../utils';

export const chassisPowertypeSchema = v.object({
    id: v.pipe(v.string(), v.nonEmpty()),
    name: v.pipe(v.string(), v.nonEmpty()),
    parentId: v.nullish(v.string()),
    // chassisClassesNumber: v.nullish(v.number()),
    customAttributesDefinition: v.nullish(arraySchemaWithUniqueName(customAttributeDefinitionSchema, 'Chaque attribut doit avoir un nom unique.')),
})

export const chassisPowertypeFormSchema = v.partial(chassisPowertypeSchema, ['id'])

export function setChassiPowertypeSchema(forbiddenNames: string[] = []) {
    return v.object({
        ...chassisPowertypeFormSchema.entries,
        customAttributesDefinition: v.nullish(arraySchemaWithUniqueNameAndForbiddenNames(customAttributeDefinitionSchema, forbiddenNames))
    })
}

export type ChassisPowertypeType = v.InferInput<typeof chassisPowertypeSchema>
export type ChassisPowertypeFormType = v.InferInput<typeof chassisPowertypeFormSchema>
