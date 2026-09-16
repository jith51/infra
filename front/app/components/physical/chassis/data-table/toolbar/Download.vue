<script setup lang="ts">
// Alerte
import { toast } from 'vue-sonner'

// Icones
import { Download } from "@lucide/vue"

import CommandSelect from '@/components/my-ui/CommandSelect.vue'
// Récupération du context et construction de l'arbre des powertypes
// import { useChassisClassesTableContext } from '../context'
// const { chassisPowertypes } = useChassisClassesTableContext()

const props = defineProps<{
    chassisClasses: {
        id: string,
        name: string
    }[]
}>()


// Pour l'upload
const formValue = ref({
    structOnly: false,
    chassisClassId: null
})
const {loadFile, fileResult, onLoadFileError } = useChassisGraphQl()
import { CombinedGraphQLErrors } from "@apollo/client/errors"
onLoadFileError((error) => {
    if (CombinedGraphQLErrors.is(error)){ 
        toast.error('Erreur de chargement : ' + error.errors)
    }
})
    
watchResult(fileResult, (newResult) => {
    const file = newResult.chassisFile

    if (!file?.contentBase64 || !file?.filename || !file?.type) return

    const bytes = Uint8Array.from(atob(file.contentBase64!), c => c.charCodeAt(0))
    const blob = new Blob([bytes], { type: file.type})

    const link = document.createElement("a")
    link.href = URL.createObjectURL(blob)
    link.download = file.filename
    link.click()

    requestAnimationFrame(() => {
        link.remove()
        URL.revokeObjectURL(link.href)
    })
})
</script>

<template>
    <!-- Download File -->
     <!-- {{ queryResult }} -->
    <Dialog v-slot="{ close }">
        <DialogTrigger as-child>
        <!-- <DefaultTooltip text="Download des Chassis Classes"> -->
          <Button
            variant="outline"
            size="sm"
            class="ml-auto hidden h-8 lg:flex"
          >
            <Download class="h-4 w-4" />
          </Button>
        <!-- </DefaultTooltip> -->
        </DialogTrigger>
        <DialogContent class="sm:max-w-106.25">
            <DialogHeader>
                <DialogTitle>Téléchargement</DialogTitle>
                <DialogDescription>
                    Génération d'un fichier excel de chassis
                </DialogDescription>
            </DialogHeader>
            <form 
                class="flex flex-col gap-5"
                @submit.prevent="() => {
                    loadFile(formValue)
                    close()
                }"
            >
                <div v-if="!formValue.structOnly" class="flex flex-col gap-2">
                    <Label for="airplane-mode">Classe de chassis</Label>
                    <CommandSelect v-model="formValue.chassisClassId" :options="chassisClasses" :with-delete-option="false"/>
                    <!-- <CommandSelect v-model="formValue.chassisClassId" />                     -->
                </div>
                <div class="flex w-full items-end space-x-2">
                    <Switch id="airplane-mode" v-model="formValue.structOnly" @update:model-value="formValue.chassisClassId = null"/>
                    <Label for="airplane-mode">Uniquement la structure</Label>
                </div>
                <DialogFooter class="mt-4">
                    <DialogClose as-child>
                        <Button variant="outline"">
                            Cancel
                        </Button>
                    </DialogClose>
                    <Button type="submit">
                        Download
                    </Button>
                </DialogFooter>
            </form>
        </DialogContent>
    </Dialog>
</template>
