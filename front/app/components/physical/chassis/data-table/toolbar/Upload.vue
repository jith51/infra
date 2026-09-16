<script setup lang="ts">
// Alerte
import { toast } from 'vue-sonner'

// Icones
import { Upload } from "@lucide/vue"

// Mutation
const { importChassis, onImportDone, onImportError } = useChassisGraphQl()

onImportDone(() => toast.success('Chassis importés.'))

import { CombinedGraphQLErrors } from "@apollo/client/errors";

onImportError((error) => {
    if (CombinedGraphQLErrors.is(error)) {
            const error_message = error.errors[0]!.message
            const err = error.errors[0].extensions.details[0]!

            let error_extension = ""
            if (err) {
                error_extension = ' : ' + err.error + ' ligne ' + err.row
            }
            toast.error(error_message + error_extension)
    }
})

</script>

<template>
    <Dialog v-slot="{ close }">
        <DialogTrigger as-child>
            <Button
            variant="outline"
            size="sm"
            class="ml-auto hidden h-8 lg:flex"
            >
                <Upload class="h-4 w-4" />
            </Button>
        </DialogTrigger>
        <DialogContent class="sm:max-106.25">
            <DialogHeader>
                <DialogTitle>Upload File</DialogTitle>
                <DialogDescription>
                Import de chassis
                </DialogDescription>
            </DialogHeader>
            <form @submit.prevent="(e) => {
                importChassis(e.target?.file.files[0]);
                close()
            }">
                <Input name="file" id="picture" type="file" />
                <DialogFooter class="mt-4">
                    <DialogClose as-child>
                        <Button variant="outline">
                        Cancel
                        </Button>
                    </DialogClose>
                    <Button type="submit">
                        Send
                    </Button>
                </DialogFooter>
            </form>
        </DialogContent>
    </Dialog>
</template>
