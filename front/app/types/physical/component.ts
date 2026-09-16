import * as v from 'valibot'

// Components
export const componentSchema = v.object({
    id: v.string(),
    name: v.pipe(v.string(), v.nonEmpty()),
    serialNumber: v.nullish(v.string()),
    description: v.nullish(v.string()),
    componentTypeId: v.nullish(v.string()),
})

export const componentFormSchema = v.partial(componentSchema, ['id'])

// Export des types
export type ComponentType = v.InferInput<typeof componentSchema>
// export type ComponentFormType = v.InferInput<typeof componentFormSchema>