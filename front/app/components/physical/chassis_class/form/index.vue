<template>
    <div class="w-full h-full flex justify-center mx-auto py-5 overflow-auto">
        <div class="relative max-h-full w-full mx-20 flex flex-col">
             <!-- :key est indispensable pour reconstruire la form apres un reset sinon tanstack ne met pas bien a jour le tableau de la forme -->
            <form
                id="physical_chassis_class_form"
                :key="props.chassisClass?.id ?? 'new'"
                @submit.prevent.stop="form.handleSubmit()"
            >
                <div class="grid grid-cols-2 4xl:grid-cols-4  gap-10 [&>div]:gap-5">
                    <FieldGroup>
                        <!-- Name, Type -->
                        <FieldSet class="mb-4 border-l border-grey-200 pl-3">
                            <InputField :form name='name' label="Nom" />
                            <TreeSelectField :form name='chassisPowertypeId' label="Type"
                                :tree="chassisPowertypesTree"
                                :listeners="{
                                    // Quand le type change on redéfinit les customs attributes et on supprime les anciennes
                                    onChange: ({ value }: { value: string}) => {
                                        form.setFieldValue('customAttributes', {})
                                        setCustomAttributesField(value)
                                    },
                                }"
                            />
                        </FieldSet>
                        <!-- Custom Attribute -->
                        <FieldSet class="mb-4 border-l border-grey-200 pl-3">
                            <template v-for="customAttributesField in customAttributesFields">
                                <DynamicField
                                    :form 
                                    :type="customAttributesField.type"
                                    :name="`customAttributes.${customAttributesField!.name}`"
                                    :label="customAttributesField!.label"
                                    :validators="{
                                        onChange: ({ value } : {value: string}) => {
                                            const result = validateField(customAttributesField.type, value)
                                            if (!result.success) {
                                                return result.issues[0].message
                                            }
                                            return undefined
                                        }
                                    }"
                                />
                            </template>
                        </FieldSet>
                    </FieldGroup>
                    <FieldGroup>
                        <!-- Attributes -->
                        <FieldSet class="mb-4 border-l border-grey-200 pl-3">
                            <InputField
                                v-for="definedField in definedFields"
                                :form
                                :type="definedField.type"
                                :name="definedField!.name"
                                :label="definedField!.label"
                            />
                        </FieldSet>
                    </FieldGroup>
                    <FieldGroup class="col-span-2">
                        <!-- Custom Attributes definition -->
                         <FieldSet class="mb-4 border-l border-grey-200 pl-3">
                            <CustomAttributesDefinitionField :form name="customAttributesDefinition"/>
                        </FieldSet>
                        <!-- Components definition -->
                         <FieldSet class="mb-4 border-l border-grey-200 pl-3">
                            <ComponentsField :form name="components"/>
                        </FieldSet>
                        <!-- Ports definition -->
                         <FieldSet class="mb-4 border-l border-grey-200 pl-3">
                            <PortsField :form name="ports"/>
                        </FieldSet>
                    </FieldGroup>
                </div>
                <form.Subscribe>
                    <template v-slot="{ canSubmit, isSubmitting }">
                        <div class="flex w-full justify-end gap-4">
                            <Button type="submit" form="physical_chassis_class_form" :disabled="!canSubmit">
                                {{ isSubmitting ? '...' : 'Submit' }}
                            </Button>
                            <Button variant="outline" @click="navigateTo('/physical/chassis_classes/edit/')">
                                New
                            </Button>
                        </div>
                        <pre>{{ form.state.values }}</pre>
                        <pre>{{ form.state.errors }}</pre>
                    </template>
                </form.Subscribe>
            </form>
        </div>
    </div>    
</template>

<script setup lang="ts">
    // Types
    import type { ChassisClassType, ChassisClassFormType } from '@/types/physical/chassis_class'
    import type { ChassisPowertypeType } from '@/types/physical/chassis_powertype'
    import type { CustomAttributeDefinitionType } from '@/types/physical/custom_attribute_definition'
    
    // Composants
    import ComponentsField from '@/components/physical/component/componentsField.vue'
    import PortsField from '@/components/physical/component/portsField.vue'
    import CustomAttributesDefinitionField from '@/components/physical/custom_attributes/CustomAttributesDefinitionField.vue'
    
    // Schema valibot
    import { chassisClassFormSchema } from '@/types/physical/chassis_class'

    // Validation Form
    import { useForm } from '@tanstack/vue-form'
    import { validateField } from '@/types/field'
    
    // Toast
    import { toast } from 'vue-sonner'

    // Props : le ChassisClass et tous les powertypes
    const props = defineProps<{
        chassisClass?: ChassisClassFormType,
        chassisPowertypes: ChassisPowertypeType[]
    }>()

    // Emits : Annulation et validation
    const emit = defineEmits<{
        (e: 'cancel'): void
        (e: 'chassisUpdated', chassisClass: ChassisClassType): void
    }>()

    // Construction de l'arbre des chassisPowertypes
    import { useTree } from '@/components/tree/tree_node'
    const { tree: chassisPowertypesTree, getAncestors, getNode } = useTree(props.chassisPowertypes)    

    // Définition de la form
    const form = useForm({
        defaultValues: props.chassisClass,
        validators: {
            onSubmit: chassisClassFormSchema,
            onChange: chassisClassFormSchema,
            onChangeAsyncDebounceMs: 500,
        },
        onSubmit: ({ value }) => {
            muteChassisClass(value)
        },
    })

    // Définition des fields de la form
    import type { FieldType } from "@/types/field"

    const definedFields = ref<{name: string, label: string, type: FieldType}[]>([
        // { name: "name", label: "Nom", type: "text"},
        { name: "fournisseur", label: "Fournisseur", type: "text"},
        { name: "model", label: "Model", type: "text"},
        { name: "version", label: "Version", type: "text"},
        { name: "partNumber", label: "Part Number", type: "text"},
        { name: "vendorEquipmentType", label: "Vendeur Equipement Type", type: "text"},
        { name: "height", label: "Hauteur (U)", type: "number"},
        { name: "urlLink", label: "Lien Constructeur", type: "url"},
    ])

    // Gestion des customAttributesFields
    const customAttributesFields = ref<CustomAttributeDefinitionType[]>()
    //      Initialisation à partir du chassisClass passé en props
    setCustomAttributesField(props.chassisClass?.chassisPowertypeId)

    function setCustomAttributesField(chassisPowertypeId: string | null | undefined): void {
        if (chassisPowertypeId == undefined) {
            customAttributesFields.value = []
            return
        }
        customAttributesFields.value = <CustomAttributeDefinitionType[]>[getNode(chassisPowertypeId), ...getAncestors(chassisPowertypeId)].map(cp => cp?.customAttributes).flat()
    }
    
    // Mutation de la forme
    import { CombinedGraphQLErrors } from "@apollo/client/errors";

    const { muteChassisClass, onMutationError, onMutationDone } = useChassisClassGraphQl()
    
    onMutationDone ((value) => {
         emit('chassisUpdated', value!.data!.chassisClass)
        toast('Chassis Class enregistré.')
    })

    onMutationError((error) => {
        if (CombinedGraphQLErrors.is(error)) {
            console.log(error.errors)
            toast("Echec de l'enregistrement : " + error.errors)
        }
    })

</script>