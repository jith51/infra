import * as v from 'valibot'

import  { fieldSchema } from '@/types/field'

export const customAttributeDefinitionSchema = v.object({
  name: v.pipe(v.string(), v.nonEmpty()),
  label: v.pipe(v.string(), v.nonEmpty()),
  type: fieldSchema,
  // required: v.boolean()
})

export type CustomAttributeDefinitionType = v.InferInput<typeof customAttributeDefinitionSchema>


