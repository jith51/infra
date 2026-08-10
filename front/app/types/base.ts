import * as v from 'valibot'

export const optionSchema = v.object({
    id: v.string(),
    name: v.string(),
})

export type OptionType = v.InferInput<typeof optionSchema>

export type FilterTableType = OptionType & {
    numberOfThings: number
} 