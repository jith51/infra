<script lang="ts">
	import { createContext } from 'reka-ui'

	export type FormFieldContext = {
		id: string
		name: string
		field: AnyFieldApi
		descriptionId: string,
		formMessageId: string
		invalid: ComputedRef<boolean>
	}

	export const [injectFormFieldContext, provideFormFieldContext]
  		= createContext<FormFieldContext>('FormField')
</script>

<script setup lang="ts">
import type { AnyFieldApi } from "@tanstack/vue-form"

const props = defineProps<{
	field: AnyFieldApi
}>()

const uid = useId()

const id = `${uid}-input`
const descriptionId = `${uid}-description`
const messageId = `${uid}-message`
const invalid = computed(
	() => props.field.state.meta.isTouched && !props.field.state.meta.isValid
)

provideFormFieldContext({
	id,
	name: props.field.name,
	field: props.field,
	descriptionId: descriptionId,
	formMessageId: messageId,
	invalid: invalid,
})
</script>

<template>
  <slot />
</template>