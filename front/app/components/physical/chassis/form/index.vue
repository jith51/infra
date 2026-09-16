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
                    <FieldGroup class="order-1">
                        <!-- Name, Type -->
                        <FieldSet class="mb-4 border-l border-grey-200 pl-3">
                            <!-- Name -->
                            <InputField :form name='name' label="Nom" />
                            <!-- Class de Chassis -->
                            <CommandSelectField 
                                :form
                                name="chassisClassId" 
                                label="Classe de chassis"
                                :options="chassisClasses"
                                :with-delete-option="false"
                                @option-selected="chassisClassChange"
                            />
                            <!-- Name -->
                            <InputField :form name='serialNumber' label="Serial Number" />
                            <!-- Tags -->
                             <ComboTagField
                                :form
                                name="tagIds"
                                label="Tags"
                                :options="props.tags"
                                @add="mutateTag"
                                @remove="deleteTag"
                             />
                        </FieldSet>
                        <!-- Custom Attribute -->
                        <FieldSet class="mb-4 border-l border-grey-200 pl-3">
                            <CustomAttributesField :form :customAttributesDefinition="chassisClass?.customAttributesDefinition ?? []" />
                        </FieldSet>
                    </FieldGroup>
                    <FieldGroup v-if="chassisClass" class="order-2 4xl:order-3">
                        <FieldSet class="mb-4 border-l border-grey-200 pl-3">
                            <ChassisClassCard :chassisClass/>
                        </FieldSet>
                    </FieldGroup>
                    <FieldGroup class="col-span-2 order-3 4xl:order-2">
                        <!-- Components -->
                         <FieldSet class="mb-4 border-l border-grey-200 pl-3">
                            <ComponentsField :form name="components"/>
                        </FieldSet>
                        <!-- Ports -->
                         <FieldSet class="mb-4 border-l border-grey-200 pl-3">
                            <PortsField :form name="ports" :availablePorts/>
                        </FieldSet>
                   </FieldGroup>
                </div>
                <form.Subscribe>
                    <template v-slot="{ canSubmit, isSubmitting }">
                        <div class="flex w-full justify-end gap-4 pt-2">
                            <Button type="submit" form="physical_chassis_form" :disabled="!canSubmit">
                                {{ isSubmitting ? '...' : 'Submit' }}
                            </Button>
                            <Button variant="outline" @click="navigateTo('/physical/chassis/edit/')">
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

    import { CombinedGraphQLErrors } from "@apollo/client/errors";
    import { toast } from 'vue-sonner'

    // // Composants

    import ComponentsField from '@/components/physical/component/ComponentsField.vue'
    import PortsField from '@/components/physical/component/PortsField.vue'
    import CustomAttributesField from '@/components/physical/component/CustomAttributesField.vue'
    import ChassisClassCard from './ChassisClassCard.vue'

    // import { validateField } from '@/types/field'
    
    // // Props : le ChassisClass et tous les powertypes
    const props = defineProps<{
        chassis?: ChassisType,
        chassisClasses: ChassisClassType[],
        tags: OptionType[],
        availablePorts: OptionType[],
    }>()

    // Emits : Annulation et validation
    const emit = defineEmits<{
        (e: 'cancel'): void
        (e: 'chassisUpdated', chassisClass: ChassisClassType): void
    }>()

    // DEFINITION ET GESTION DE LA FORM
    import { chassisFormSchema }  from '@/types/physical/chassis'
    import { useForm } from '@tanstack/vue-form'

    const initialValue = computed(() => { // Dépend de props.chassis 
        // On enleve tags (liste de nom ) et chassisClass si on pass un chassis en props (et pas un undefined)
        const { tags, chassisClass, ...result } = { tags: [], chassisClass: undefined, ...props.chassis}
        return result as ChassisFormType
    })
    const form = useForm({
        defaultValues: initialValue.value,
        validators: {
            onSubmit: chassisFormSchema,
            onChange: chassisFormSchema,
            onChangeAsyncDebounceMs: 500,
        },
        onSubmit: ({ value }) => {
            mutateChassis(value)
        },
    })
        // Lorsque l'initialValue change on met à jour la form (après un update) : TRES IMPORTANT
        // Renseigne les id des objects crées notement (synchronisation)
    watch(initialValue,
        (value) => { form.reset(value) },
        { deep: true }
    )

    // GESTION DU CHASSIS CLASS
    
    const chassisClass = ref(props.chassis?.chassisClass)

        // Load du Chassis Class
    const { loadQuery, queryResult, onQueryError } = useChassisClassGraphQl()
    // TODO : gérer l'erreur

        // Gestion du changement du chassis Class
    const chassisClassChange = async (id: string | null | undefined) => {
        // On va load le chassisClass si nécessaire
        await setChassisClass(id)
        // On remplie les composants et le ports avec celui du chassis
        fillInComponentsAndPorts()
    }
    
    async function setChassisClass(id: string | null | undefined) {
        if (id == null) {
            chassisClass.value = undefined
            return
            }

        if (props.chassis?.chassisClass?.id === id) {
            chassisClass.value = props.chassis.chassisClass
            return
        }

        await loadQuery(id)
        chassisClass.value = queryResult?.value?.chassisClass as ChassisClassType
    }

    function fillInComponentsAndPorts() {
        if (!chassisClass.value) {
            form.setFieldValue('components', [])
            form.setFieldValue('ports', [])
            return
        }

        const components = chassisClass.value.componentSlots!.map((componentSlot) => {
            const { id, ...componentSansId } = componentSlot
            return componentSansId
        })
        form.setFieldValue('components', components)

        const ports = chassisClass.value.portSlots!.map((portSlot) => {
            const { id, ...portSansId } = portSlot

            return portSansId
        })

        form.setFieldValue('ports', ports)
    }

    // MUATATION DE LA FORM
    const { mutateObject: mutateChassis, onMutationError, onMutationDone, } = useChassisGraphQl()
    
    onMutationDone ((value) => {
         emit('chassisUpdated', value!.data!.chassis)
        toast.success('Chassis enregistré.')
    })

    onMutationError((error) => {
        if (CombinedGraphQLErrors.is(error)) {
            console.log(error.errors)
            toast.error("Echec de l'enregistrement : " + error.errors)
        }
    })

    // AJOUT ET SUPPRESSION DES TAGS
    const {mutateObject: mutateTag, onMutationError : onMutationTagError, deleteObject: deleteTag, onDeleteError: onDeleteTagError } = useTagGraphQl()
    onMutationTagError((error) => {
        if (CombinedGraphQLErrors.is(error)) {
            console.log(error.errors)
            toast.error("Echec de l'enregistrement du tag : " + error.errors)
        }
    })
    onDeleteTagError((error) => {
        if (CombinedGraphQLErrors.is(error)) {
            console.log(error.errors)
            toast.error("Echec de la suppression du tag : " + error.errors)
        }
    })

</script>