<template>
  <DropdownMenu>
    <DropdownMenuTrigger as-child>
      <Button variant="ghost" class="h-8 w-8 p-0">
        <EllipsisVertical class="h-4 w-4"/>
      </Button>
    </DropdownMenuTrigger>
    <DropdownMenuContent align="end">
      <DropdownMenuItem @click="navigateTo(`/physical/chassis_classes/edit/${chassis_class_name}`)">
        Edit
      </DropdownMenuItem>
      <DropdownMenuItem @click="navigateTo(`/physical/chassis_classes/edit/${chassis_class_name}`)">
        Make a copy
      </DropdownMenuItem>
      <DropdownMenuSeparator/>
      <DropdownMenuItem @click="deleteChassisClass(chassis_class_id)">
        Delete
      </DropdownMenuItem>
    </DropdownMenuContent>
  </DropdownMenu>
</template>

<script setup lang="ts">
  // Icones
  import { EllipsisVertical } from "@lucide/vue"

  // Alerte
  import { toast } from 'vue-sonner'

  // Props
  defineProps<{
    chassis_class_id: string,
    chassis_class_name: string 
  }>()
    
  // DELETE
 const {  deleteChassisClass, onDeleteError, onDeleteDone} = useChassisClassGraphQl()

  onDeleteDone(() => toast(`ChassisClass supprimé`))
  onDeleteError((error) => {
    console.log(error)
    toast(`Suppression impossible`)
  })

</script>