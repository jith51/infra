<script setup lang="ts">
  import type { EolBulletinType } from '@/types/device'

  import DataTableTooltip from './DataTableTooltip.vue'

  interface DataTableProps {
    eol_bulletins?: EolBulletinType[]
  }

  const props = defineProps<DataTableProps>()

  const formateDate = (date: Date | undefined):string => {
    return date == undefined ? "" : (new Date(date)).toLocaleDateString("en-GB")
  }

</script>

<template>
  <Table class="rounded-md border">
    <TableHeader class="border-b">
      <TableRow>
        <TableHead>Number</TableHead>
        <TableHead>Name</TableHead>
        <TableHead>Type</TableHead>
        <TableHead>Url</TableHead>
        <TableHead>End Of Life</TableHead>
        <TableHead>Last Date Support</TableHead>
      </TableRow>
    </TableHeader>
    <TableBody>
      <TableRow v-for="eol in props.eol_bulletins">
        <TableCell>
          <DnaDataTableTooltip :value="eol.number"/>
        </TableCell>
        <TableCell>
          <DnaDataTableTooltip :value="eol.name"/>
        </TableCell>
        <TableCell>{{ eol.eolType }}</TableCell>
        <TableCell>
          <NuxtLink  :to="eol.url" target="_blank">
            <DnaDataTableTooltip :value="eol.url"/>
          </NuxtLink>
        </TableCell>
        <TableCell>
          {{ formateDate(eol.endOfLifeDate) }}
        </TableCell>
        <TableCell>{{ formateDate(eol.lastDateOfSupport) }}</TableCell>
      </TableRow>
    </TableBody>
  </Table>
</template>