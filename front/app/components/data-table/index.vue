<template>
    <div  class="w-full h-full flex flex-col gap-4">
        <!-- TOOLBAR -->
        <div class="flex items-center justify-between ps-1 pt-2">
            <div class="flex flex-1 items-center space-x-2">
                <slot name="toolbar-filter"/>
            </div>
            <div class="flex space-x-2">
                <slot name="toolbar-options"/>
            </div>
        </div>
        <div id="e" ref="el" class="relative w-full overflow-auto max-h-full border rounded-md [&>div]:data-[slot=table-container]:max-h-full">
            <!-- TABLE -->
            <Table class="w-full caption-bottom text-sm">
                <!-- HEADER -->
                <TableHeader class="sticky top-0 bg-white z-10 [&_th]:after:border-b [&_th]:last:w-8">
                    <TableRow v-for="headerGroup in table.getHeaderGroups()" :key="headerGroup.id">
                        <TableHead v-for="header in headerGroup.headers" :key="header.id">
                            <FlexRender v-if="!header.isPlaceholder" :render="header.column.columnDef.header" :props="header.getContext()"/>
                        </TableHead>
                    </TableRow>
                </TableHeader>
                <!-- BODY -->
                <TableBody>
                    <template v-if="table.getRowModel().rows?.length">
                        <template v-for="row in table.getRowModel().rows" :key="row.id">
                            <slot name="row" :row="row"/>
                        </template>
                    </template>
                    <TableRow v-else>
                        <TableCell :colspan="table.getIsAllColumnsVisible.length" class="h-24 text-center">
                            No results.
                        </TableCell>
                    </TableRow>
                </TableBody>
            </Table>
        </div>
    </div>
</template>

<script setup lang="ts" generic="T">
  import type { Table } from '@tanstack/vue-table'
  import { FlexRender } from '@tanstack/vue-table'

  const props = defineProps<{
    table: Table<T>
    canloadMore?: boolean
  }>()

  const emit = defineEmits<{
    (e: 'loadMore'): void
  }>()

  // Infinite Scroll
  const el = useTemplateRef<HTMLElement>('el')

  useInfiniteScroll(
    el,
    () => { emit('loadMore') },
    { distance: 5, canLoadMore: () => {
        return (props.canloadMore == undefined) ? false : props.canloadMore} }
  )
  
</script>

<style scoped>
  th::after {
    content: '';
    position: absolute;
    left: 0;
    width: 100%;
    height: 100%;
    display: block;
    top : 0px;
    color: lightgrey
  }
</style>
