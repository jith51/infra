import * as v from 'valibot'

const tagSchema = v.object({
  id: v.string(),
  name: v.string(),
})

const tagWithNumberOfThinkgSchema = v.object({
  ...tagSchema.entries,
  numberOfThings: v.optional(v.number())
})

export type TagType = v.InferInput<typeof tagSchema>
export type tagWithNumberOfThinkgType = v.InferInput<typeof tagWithNumberOfThinkgSchema>
