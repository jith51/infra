<template>
    <form.Field>
        <template #default="{ field }">
          	<FormFieldContextProvider :field>
          		<slot/>
        	</FormFieldContextProvider>
      	</template>
    </form.Field>
</template>

<script setup lang="ts" generic="T">
// On utilise ici le mécanisme de allthrough Attributes --> https://vuejs.org/guide/components/attrs.html
// Tous les props et emits passer lors de l'appel de FormField sont passer à form.Field
import type { FormApi } from "@tanstack/vue-form"
defineProps<{
	form: FormApi<T>
}>()
</script>
