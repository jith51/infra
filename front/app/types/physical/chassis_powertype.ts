import * as v from 'valibot'

import { customAttributeDefinitionSchema } from '@/types/physical/custom_attribute_definition'

export const chassisPowertypeSchema = v.object({
    id: v.pipe(v.string(), v.nonEmpty()),
    name: v.pipe(v.string(), v.nonEmpty(), v.title('Id'), v.metadata({label:'toto'})),
    parentId: v.nullable(v.string()),
    chassisClassesNumber: v.nullish(v.number()),
    // customAttributes: v.optional(v.array(v.variant('type', [customAttributeSchema, customSelectAttributeSchema])))
    // customAttributes: v.nullish(v.array(customAttributesSchema))
    customAttributes: v.nullish(
        v.pipe(
        v.array(customAttributeDefinitionSchema),
        v.check((attributes) => {
            const names = attributes.map((a) => a.name);
            return new Set(names).size === names.length;
        }, "Chaque attribut doit avoir un nom unique.")
        )
    ),
})

// const toto = v.getTitle(chassisPowertypeFormSchema.entries.name)

export const chassisPowertypeFormSchema = v.partial(chassisPowertypeSchema, ['id'])

export type ChassisPowertypeType = v.InferInput<typeof chassisPowertypeSchema>
export type ChassisPowertypeFormType = v.InferInput<typeof chassisPowertypeFormSchema>