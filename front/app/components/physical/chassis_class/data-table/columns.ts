import type { ColumnDef } from '@tanstack/vue-table'
import type { ChassisClassType } from '@/types/physical/chassis_class'
import ColumnHeader from '@/components/data-table/ColumnHeader.vue'

import Action from './Action.vue'
import { h } from 'vue'

export const columns: ColumnDef<ChassisClassType>[] = [
  {
    accessorKey: 'name',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Nom' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.getValue('name')),
    enableHiding: false,
    enableSorting: false,
  },
  {
    accessorKey: 'type',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Type' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.original.chassisPowertype?.name || ''),
    enableSorting: false,
  },
  {
    accessorKey: 'model',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Model' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.getValue('model')),
    enableSorting: false,
  },
  {
    accessorKey: 'fournisseur',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Fournisseur' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.getValue('fournisseur')),
    enableSorting: false,
  },
  
  {
    accessorKey: 'version',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Version' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.getValue('version')),
    enableSorting: false,
  },
  {
    accessorKey: 'partNumber',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Part Number' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.getValue('partNumber')),
    enableSorting: false,
  },
  // {
  //   accessorKey: 'tagIds',
  //   header: ({ column }) => h(ColumnHeader, { column, title: 'Tags' }),
  //   cell: ({ row }) => {
  //     return h('div', { class: 'w-full flex gap-2'},
  //       (row.original.tags ?? []).map((v) => h(Badge, {variant: "secondary", class: "rounded-sm px-1 font-normal"}, {default: () => v}))
  //     )
  //   }
  //   ,
  //   enableSorting: false,
  // },  
  {
    id: 'actions',
    enableHiding: false,
    enableSorting: false,
    cell: ({ row }) => {
      const chassis_class_id = <string>row.original.id
      const chassis_class_name = <string>row.original.name
      return h('div', { class: 'relative' }, h(Action, { chassis_class_id, chassis_class_name }))
  },
  },
]