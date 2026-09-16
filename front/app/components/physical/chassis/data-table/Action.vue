<template>
    <div class=" flex gap-2">
      <Button 
        variant="outline"
        size="sm"
        @click="navigateTo(`/physical/chassis/edit/${chassis_name}`)"
			>
        <Pencil/>
      </Button>
      <Button
        variant="outline"
        size="sm"
        @click="deleteObject(chassis_id)"
      >
        <Trash2Icon/>
      </Button>
    </div>
</template>

<script setup lang="ts">
// Icones
import { Pencil, Trash2Icon } from '@lucide/vue'

// Alerte
import { toast } from 'vue-sonner'

// Props
const props = defineProps<{
  chassis_id: string,
  chassis_name: string 
}>()
  
// DELETE
const { deleteObject, onDeleteDone, onDeleteError } = useChassisGraphQl()

onDeleteDone(() => { toast.success(`Chassis supprimé.`) })

// TODO : détaillé l'erreur
onDeleteError(() => { toast.error(`Suppression impossible.`) })


</script>