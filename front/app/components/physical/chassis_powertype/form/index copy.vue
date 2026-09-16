<script setup lang="ts">
    // Types
    import type { ChassisPowertypeType } from '@/types/physical/chassis_powertype.ts'
    import type { ChassisPowertypeFormType } from '@/types/physical/chassis_powertype.ts'

    // Schema valibot
    import { chassisPowertypeFormSchema } from '@/types/physical/chassis_powertype'
    
    // Validation Form
    import { useForm } from '@tanstack/vue-form'

    // Composants
    import ParentCustomAttributes from "./ParentCustomAttributes.vue"
    
    // Toast
    import { toast } from 'vue-sonner'    
    
    // Props
    const props = defineProps<{
        chassisPowertype: ChassisPowertypeFormType
        chassisPowertypeAscendants?: ChassisPowertypeType[]
    }>()

    // Listes des custom attributes des ascendants
    const customAttributesDefinitionOfAscendant = computed(() => 
        (props.chassisPowertypeAscendants ?? []).flatMap((cp) => cp.customAttributesDefinition)
    )

    // Emits : Annulation et validation
    const emit = defineEmits<{
        (e: 'cancel'): void
        (e: 'chassisPowertypeIdUpdated', chassisPowertypeId: string): void
    }>()

    // Déclaration de la form
    const form = useForm({
        defaultValues: props.chassisPowertype,
        // defaultValues: currentChassisPowertype.value,
        validators: {
            onSubmit: chassisPowertypeFormSchema,
            onChange: chassisPowertypeFormSchema,
            onChangeAsyncDebounceMs: 500,
        },
        onSubmit: ({ value }) => {
            mutateObject(value)
        },
    })

    watch(
        () => props.chassisPowertype,
        (cp) => form.reset(cp)
    )

    // Mutation de la forme
    import { CombinedGraphQLErrors } from "@apollo/client/errors";

    const { mutateObject, onMutationDone, onMutationError } = useChassisPowertypeGraphQl()
    onMutationDone(({data}) => {
        emit('chassisPowertypeIdUpdated', data?.chassisPowertype.id!)
    })
    onMutationError((error) => {
        if (CombinedGraphQLErrors.is(error)) {
            toast.error(error.errors[0]!.message)
        }
    })

    //  Custom attributes definition
    import CustomAttributesDefinitionField from "@/components/physical/component/CustomAttributesDefinitionField.vue"
    //      Utilitaire : validation du name d'un custom attribute
    function validateUniqNameOnCustomAttribute (value: string)  {
        let attributes = [
            // les customAttibutes de la form
            ...(form.getFieldValue('customAttributesDefinition') ?? []),
            // les customAttibutes des ascendants
            ...customAttributesDefinitionOfAscendant.value
        ]

        const count = attributes.filter(
            a => a?.name.trim() === value.trim()
        ).length

        if (value && count > 1) {
            return 'Chaque attribut doit avoir un nom unique.'
        }
        return undefined
    }

</script>

<template>
    <!-- :key est indispensable pour reconstruire la form apres un reset sinon tanstack ne met pas bien a jour le tableau de la forme -->
    <form
        id="physical_powertype_form"
        :key="props.chassisPowertype?.id ?? 'new'"
        @submit.prevent.stop="form.handleSubmit()"
    >
        <FieldGroup class="mb-4 border-l border-grey-200 gap-10 pl-3 pr-1">
            <!-- Name Field -->
            <FieldSet class="gap-10 mt-1">
                <InputField :form name="name" label="Nom"/>
            </FieldSet>
            <!-- Tableau des Custum Attributes -->
            <CustomAttributesDefinitionField
                :form
                name="customAttributesDefinition"
                :validateUniqNameOnCustomAttribute="validateUniqNameOnCustomAttribute"
            />
            <!-- Tableaux Custum Attributes Parents -->
            <template v-for="parent in chassisPowertypeAscendants" class="gap-2">
                <ParentCustomAttributes
                    v-if="parent.customAttributesDefinition"
                    :customAttributesDefinition="parent.customAttributesDefinition"
                    :parentName="parent.name"
                />
            </template>
        </FieldGroup>
        <form.Subscribe>
            <template v-slot="{ canSubmit, isSubmitting }">
                <div class="flex w-full justify-end">
                    <Button type="submit" form="physical_powertype_form" :disabled="!canSubmit">
                        {{ isSubmitting ? '...' : 'Submit' }}
                    </Button>
                </div>
                <pre>{{ form.state.values }}</pre>
                <pre>{{ form.state.errors }}</pre>
            </template>
        </form.Subscribe>
    </form>
</template>