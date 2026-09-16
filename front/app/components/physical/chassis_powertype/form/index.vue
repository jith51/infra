<template>
    <!-- :key est indispensable pour reconstruire la form apres un reset sinon tanstack ne met pas bien a jour le tableau de la forme -->
     <Form id="physical_powertype_form" :of="chassisPowertypeForm" @submit="submitForm" >
        <FieldGroup class="mb-4 border-l border-grey-200 gap-10 pl-3 pr-1">
            <!-- Name Field -->
            <FieldSet class="gap-10 mt-1">    
                <InputField :of="chassisPowertypeForm" :path="['name']" label="Nom"/> 
            </FieldSet>
            <!-- Tableau des Custum Attributes -->
            <CustomAttributesDefinitionFormishField
                :of="chassisPowertypeForm"
                :path="['customAttributesDefinition']"
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
        <div class="flex w-full justify-end">
            <!-- Validation -->
            <Button type="submit" form="physical_powertype_form" :disabled="!chassisPowertypeForm.isValid">
                {{ chassisPowertypeForm.isSubmitting ? '...' : 'Submit' }}
            </Button>
        </div>
        <div>
            <!-- Pre -->
            <pre>{{ getInput(chassisPowertypeForm) }} </pre>
            <pre>{{ getDeepErrorEntries(chassisPowertypeForm) }} </pre>
        </div>
    </Form>
</template>

<script setup lang="ts">
    //
    // Le composant est rechargé par le parent (via :key) ce qui permet de declarer un nouveau Schema a chaque fois
    //

    // Composants
    import ParentCustomAttributes from "./ParentCustomAttributes.vue"
    import CustomAttributesDefinitionFormishField from '../../component/CustomAttributesDefinitionFormishField.vue'
    import InputField from '@/components/form/formishField/InputField.vue'

    // Props
    import type { ChassisPowertypeType } from '@/types/physical/chassis_powertype.ts'
    import type { ChassisPowertypeFormType } from '@/types/physical/chassis_powertype.ts'

    const props = defineProps<{
        chassisPowertype: ChassisPowertypeFormType
        chassisPowertypeAscendants?: ChassisPowertypeType[]
    }>()

    // Emits : Annulation et validation
    const emit = defineEmits<{
        (e: 'cancel'): void
        (e: 'chassisPowertypeIdUpdated', chassisPowertypeId: string): void
    }>()

    // Déclaration de la form
    import { chassisPowertypeFormSchema, setChassiPowertypeSchema } from '@/types/physical/chassis_powertype'
    import { Form, Field, useForm, getDeepErrorEntries, getInput, focus } from '@formisch/vue'
    import type { SubmitHandler } from '@formisch/vue'
        // Récupération des noms des customs attributes des parents
    const forbiddenNames = (props.chassisPowertypeAscendants ?? [])
        .flatMap(a => a.customAttributesDefinition ?? [])
        .map(attribute => attribute.name)
        // Constrcutiondu Schema
    const Schema = setChassiPowertypeSchema(forbiddenNames)
        // Définition de la forme
    const chassisPowertypeForm =  useForm({
        schema: Schema,
        validate: 'blur',
        revalidate: 'input',
        initialInput: props.chassisPowertype
    })
        // Validation de la form
    const submitForm: SubmitHandler<typeof chassisPowertypeFormSchema> = async (output) => {
        focus(chassisPowertypeForm, { path: ['name'] })
    //    mutateObject(output)
    };

    focus(chassisPowertypeForm, { path: ['name'] })
    // Mutation de la forme
    import { toast } from 'vue-sonner'
    import { CombinedGraphQLErrors } from "@apollo/client/errors";

    const { mutateObject, onMutationDone, onMutationError } = useChassisPowertypeGraphQl()
    onMutationDone(({data}) => {
        emit('chassisPowertypeIdUpdated', data?.chassisPowertype.id!)
    })
    onMutationError((error) => {
        if (CombinedGraphQLErrors.is(error)) {
            toast.error(error.errors[0]!.message +' : ' + error.errors[0]?.extensions?.field_errors?.name)
        }
    })
    

</script>

