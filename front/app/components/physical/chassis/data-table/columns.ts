import type { ColumnDef } from '@tanstack/vue-table'
import type { ChassisType } from '@/types/physical/chassis'
import { Badge } from '@/components/ui/badge'
import ColumnHeader from '@/components/data-table/ColumnHeader.vue'
import Action from './Action.vue'
import { h } from 'vue'

export const columns: ColumnDef<ChassisType>[] = [
  {
    accessorKey: 'name',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Name' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.getValue('name')),
    enableHiding: false,
    enableSorting: false,
  },
  {
    accessorKey: 'model',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Chassis Class' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.original.chassisClass.name),
    enableSorting: false,
  },
  {
    accessorKey: 'type',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Type' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.original.chassisClass.chassisPowertype?.name || ''),
    enableSorting: false,
  },
  {
    accessorKey: 'serialNumber',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Serial Number' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.getValue('serialNumber')),
    enableSorting: false,
  },
  {
    accessorKey: 'tagIds',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Tags' }),
    cell: ({ row }) => {
      return h('div', { class: 'w-full flex gap-2'},
        (row.original.tags ?? []).map((v) => h(Badge, {variant: "secondary", class: "rounded-sm px-1 font-normal"}, {default: () => v}))
      )
    }
    ,
    enableSorting: false,
  },
  {
    id: 'actions',
    enableHiding: false,
    enableSorting: false,
    cell: ({ row }) => {
      const chassis_id = <string>row.original.id
      const chassis_name = <string>row.original.name
      return h('div', { class: 'relative' }, h(Action, { chassis_id, chassis_name }))
  },
  },
]