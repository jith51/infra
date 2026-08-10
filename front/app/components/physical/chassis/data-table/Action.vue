<template>
    <div class=" flex gap-2">
      <Button  @click="navigateTo(`/physical/chassis/edit/${props.chassis_name}`)">
        <View/>
      </Button>
      <Button @click="deleteObject(props.chassis_id)">
        <Eraser/>
      </Button>
    </div>
</template>

<script setup lang="ts">
// Icones
import { View, Eraser } from '@lucide/vue'

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