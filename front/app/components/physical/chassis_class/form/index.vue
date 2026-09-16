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
                            <CustomAttributesField :form :customAttributesDefinition="customAttributesFields ?? []" />
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
                            <ComponentSlotsField :form name="componentSlots"/>
                        </FieldSet>
                        <!-- Ports definition -->
                         <FieldSet class="mb-4 border-l border-grey-200 pl-3">
                            <PortSlotsField :form name="portSlots"/>
                        </FieldSet>
                    </FieldGroup>
                </div>
                <form.Subscribe>
                    <template v-slot="{ canSubmit, isSubmitting }">
                        <div class="flex w-full justify-end gap-4">
                            <Button type="submit" form="physical_chassis_class_form" :disabled="!canSubmit">
                                {{ isSubmitting ? '...' : 'Submit' }}
                            </Button>
                            <Button variant="outline" @click.prevent="navigateTo('/physical/chassis_classes/edit/')">
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
    import ComponentSlotsField from '@/components/physical/component/ComponentSlotsField.vue'
    import PortSlotsField from '@/components/physical/component/PortSlotsField.vue'
    import CustomAttributesDefinitionField from '@/components/physical/component/CustomAttributesDefinitionField.vue'
    import CustomAttributesField from '@/components/physical/component/CustomAttributesField.vue'

    // Schema valibot
    import { chassisClassFormSchema } from '@/types/physical/chassis_class'

    // Validation Form
    import { useForm } from '@tanstack/vue-form'
    
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
        (e: 'chassisClassUpdated', chassisClass: ChassisClassType): void
    }>()

    // Construction de l'arbre des chassisPowertypes
    import { useTree } from '@/components/tree/tree_node'
    const { tree: chassisPowertypesTree, getAncestors, getNode } = useTree(props.chassisPowertypes)    

    const initialValue = computed(()=> {
        if(!props.chassisClass) {
            return {}
        }
        
        const { allCustomAttributesDefinition, ...result } = props.chassisClass
        return result
    })
    // Définition de la form
    const form = useForm({
        defaultValues: initialValue.value,
        validators: {
            onSubmit: chassisClassFormSchema,
            onChange: chassisClassFormSchema,
            onChangeAsyncDebounceMs: 500,
        },
        onSubmit: ({ value }) => {
            muteChassisClass(value)
        },
    })
    // Lorsque l'initialValue change on met à jour la form
    watch(initialValue,
        (value) => { form.reset(value) },
        { deep: true }
    )
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
        customAttributesFields.value = <CustomAttributeDefinitionType[]>[getNode(chassisPowertypeId), ...getAncestors(chassisPowertypeId)].map(cp => cp?.customAttributesDefinition).flat()
    }
    
    // Mutation de la forme
    import { CombinedGraphQLErrors } from "@apollo/client/errors";

    const { muteChassisClass, onMutationError, onMutationDone } = useChassisClassGraphQl()
    
    onMutationDone ((value) => {
         emit('chassisClassUpdated', value!.data!.chassisClass)
        toast('Chassis Class enregistré.')
    })

    onMutationError((error) => {
        if (CombinedGraphQLErrors.is(error)) {
            console.log(error.errors)
            toast("Echec de l'enregistrement : " + error.errors)
        }
    })

</script>