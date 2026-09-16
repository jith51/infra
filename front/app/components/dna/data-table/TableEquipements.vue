<script setup lang="ts">
  import type { EquipementType } from '@/types/device'

  interface DataTableProps {
    equipements?: EquipementType[]
  }

  const props = defineProps<DataTableProps>()

</script>

<template>
  <Table class="rounded-md border h-full">
    <TableHeader class="border-b">
      <TableRow>
        <TableHead>Name</TableHead>
        <TableHead>Description</TableHead>
        <TableHead>Serial Number</TableHead>
        <TableHead>Product Id</TableHead>
        <TableHead>Type</TableHead>
      </TableRow>
    </TableHeader>
    <TableBody>
      <TableRow v-for="equipement in props.equipements">
        <TableCell>
          <DataTableTooltip :value="equipement.name"/>
        </TableCell>
        <TableCell> 
          <DataTableTooltip :value="equipement.description"/> 
        </TableCell>
        <TableCell>{{ equipement.serialNumber }}</TableCell>
        <TableCell>{{ equipement.productId?.name }}</TableCell>
        <TableCell>{{ equipement.equipementType?.name }}</TableCell>
      </TableRow>
    </TableBody>
  </Table>
</template>