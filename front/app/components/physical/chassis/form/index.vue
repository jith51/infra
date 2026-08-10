<template>
    <div class="w-full h-full flex justify-center mx-auto py-5 overflow-auto">
        <div class="relative max-h-full w-full mx-20 flex flex-col">
             <!-- :key est indispensable pour reconstruire la form apres un reset sinon tanstack ne met pas bien a jour le tableau de la forme -->
             <form
                id="physical_chassis_form"
                :key="props.chassis?.id ?? 'new'"
                @submit.prevent.stop="form.handleSubmit()"
            >
                <div class="grid grid-cols-2 4xl:grid-cols-4  gap-10 [&>div]:gap-5">
                    <FieldGroup>
                        <!-- Name, Type -->
                        <FieldSet class="mb-4 border-l border-grey-200 pl-3">
                            <InputField :form name='name' label="Nom" />
                            <CommandSelectField 
                                :form 
                                name="chassisClassId" 
                                label="Classe de chassis"
                                :options="chassisClasses"
                                @option-selected="chassisClassChange"
                            />
                            <ComboTag2/>
                            <form.Field name="tagIds">
                                <template #default="{ field }">
                                     <div class="h-full flex flex-col gap-5 overflow-hidden">
                                        <ComboTag :id="field.name"
                                            :name="field.name"
                                            :model-value="field.state.value"
                                            :options="props.tags"
                                        />
                                    </div>
                                </template>
                            </form.Field>
                        </FieldSet>
                        <ComboTag :model-value="toto" :options="props.tags" name="test"/>
                        {{ toto }}
                        <!-- Custom Attribute -->
                        <FieldSet class="mb-4 border-l border-grey-200 pl-3">
                            <template v-for="customAttributesField in chassisClass?.customAttributesDefinition">
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
                   </FieldGroup>
                </div>
                <form.Subscribe>
                    <template v-slot="{ canSubmit, isSubmitting }">
                        <div class="flex w-full justify-end gap-4">
                            <Button type="submit" form="physical_chassis_form" :disabled="!canSubmit">
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
    import type { ChassisType, ChassisFormType } from '@/types/physical/chassis'
    import type { ChassisClassType } from '@/types/physical/chassis_class'
    import type { OptionType } from '@/types/base'
    // import type { CustomAttributeDefinitionType } from '@/types/physical/custom_attribute_definition'
    // // Composants
    import CommandSelectField from '@/components/form/field/CommandSelectField.vue'
    // import PortsField from '@/components/physical/component/portsField.vue'
    // import CustomAttributesDefinitionField from '@/components/physical/custom_attributes/CustomAttributesDefinitionField.vue'
    import { validateField } from '@/types/field'
    // // Schema valibot
    // import { chassisClassFormSchema } from '@/types/physical/chassis_class'

    // // Validation Form
    // import { useForm } from '@tanstack/vue-form'
    // import { validateField } from '@/types/field'
    const toto = ref([])
    // // Props : le ChassisClass et tous les powertypes
    const props = defineProps<{
        chassis?: ChassisType,
        chassisClasses: ChassisClassType[],
        tags: OptionType[],
        componentTypes: OptionType[],
        portTypes: OptionType[],
    }>()

    // Emits : Annulation et validation
    const emit = defineEmits<{
        (e: 'cancel'): void
        (e: 'chassisUpdated', chassisClass: ChassisClassType): void
    }>()

    // Définition de la form
    import { chassisFormSchema }  from '@/types/physical/chassis'
    import { useForm } from '@tanstack/vue-form'

    const initialeValue = computed(() => {
        // On enleve tags et chassisClass si on pass un chassis en props (et pas un undefined)
        const { tags, chassisClass, ...result } = { tags: [], chassisClass: undefined, ...props.chassis}
        return result as ChassisFormType
    })
    const form = useForm({
        defaultValues: initialeValue.value,
        validators: {
            onSubmit: chassisFormSchema,
            onChange: chassisFormSchema,
            onChangeAsyncDebounceMs: 500,
        },
        onSubmit: ({ value }) => {
            mutateChassis(value)
        },
    })

    // Gestion du chassisClass du chassis
    const { loadQuery, refetchQuery, queryResult, onQueryError } = useChassisClassGraphQl()
    async function loadChassisClass(id: string) {
        if (!queryResult.value) {
            await loadQuery(id, true)
        } else {
            await refetchQuery(id, true)
        }
    }
    // TODO : gérer l'erreru
    const chassisClass = ref(props.chassis?.chassisClass)
    const chassisClassChange = async (id: string | null | undefined) => {
        if (id == null) {
            chassisClass.value = undefined
            return
        } else {
            if (props?.chassis?.chassisClass && props.chassis.chassisClass.id == id) {
                chassisClass.value = props.chassis.chassisClass
            } else {
                await loadChassisClass(id, true)
                chassisClass.value = queryResult?.value?.chassisClass as ChassisClassType
            }
        }
    }

    // // Définition des fields de la form
    // import type { FieldType } from "@/types/field"

    // const definedFields = ref<{name: string, label: string, type: FieldType}[]>([
    //     // { name: "name", label: "Nom", type: "text"},
    //     { name: "fournisseur", label: "Fournisseur", type: "text"},
    //     { name: "model", label: "Model", type: "text"},
    //     { name: "version", label: "Version", type: "text"},
    //     { name: "partNumber", label: "Part Number", type: "text"},
    //     { name: "vendorEquipmentType", label: "Vendeur Equipement Type", type: "text"},
    //     { name: "height", label: "Hauteur (U)", type: "number"},
    //     { name: "urlLink", label: "Lien Constructeur", type: "url"},
    // ])

    // // Gestion des customAttributesFields
    // const customAttributesFields = ref<CustomAttributeDefinitionType[]>()
    // //      Initialisation à partir du chassisClass passé en props
    // setCustomAttributesField(props.chassisClass?.chassisPowertypeId)

    // function setCustomAttributesField(chassisPowertypeId: string | null | undefined): void {
    //     if (chassisPowertypeId == undefined) {
    //         customAttributesFields.value = []
    //         return
    //     }
    //     customAttributesFields.value = <CustomAttributeDefinitionType[]>[getNode(chassisPowertypeId), ...getAncestors(chassisPowertypeId)].map(cp => cp?.customAttributes).flat()
    // }
    
    // // Mutation de la forme
    import { CombinedGraphQLErrors } from "@apollo/client/errors";
    import { toast } from 'vue-sonner'

    const { mutateObject, onMutationError, onMutationDone, } = useChassisGraphQl()
    
    onMutationDone ((value) => {
         emit('chassisUpdated', value!.data!.chassis)
        toast.success('Chassis Class enregistré.')
    })

    onMutationError((error) => {
        if (CombinedGraphQLErrors.is(error)) {
            console.log(error.errors)
            toast.error("Echec de l'enregistrement : " + error.errors)
        }
    })

    function mutateChassis(chassis: ChassisFormType) {        
        mutateObject(chassis)
    }


</script>