<script setup lang="ts">
  // Types
  import type { EolBulletinType } from '@/types/device'

  // Props
  const props = defineProps<{
    eol_bulletins?: EolBulletinType[]
  }>()

  // Utilitaires
  const formateDate = (date: Date | undefined): string => {
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
          <DataTableTooltip :value="eol.number"/>
        </TableCell>
        <TableCell>
          <DataTableTooltip :value="eol.name"/>
        </TableCell>
        <TableCell>
          {{ eol.eolType }}
        </TableCell>
        <TableCell>
          <NuxtLink  :to="eol.url" target="_blank">
            <DataTableTooltip :value="eol.url"/>
          </NuxtLink>
        </TableCell>
        <TableCell>
          {{ formateDate(eol.endOfLifeDate) }}
        </TableCell>
        <TableCell>
          {{ formateDate(eol.lastDateOfSupport) }}
        </TableCell>
      </TableRow>
    </TableBody>
  </Table>
</template>