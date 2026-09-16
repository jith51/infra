import type { ColumnDef } from '@tanstack/vue-table'
import type { SwitchType, BasicDeviceTable } from '@/types/device'

import ColumnHeader from '@/components/data-table/ColumnHeader.vue'
import Tooltip from '@/components/data-table/Tooltip.vue'

import ExpensionCell from './ExpensionCell.vue'

import { h } from 'vue'

function getNameFor(cell: BasicDeviceTable) {
  return cell ? cell["name"] : ""
}

export const switchColumns: ColumnDef<SwitchType>[] = [
  {
    id: 'select',
    header: () => "",
    cell: ({ row }) => {
        return h('div', { class: 'flex w-[2px] p-0' }, h(ExpensionCell, { row }))
      },
    enableSorting: false,
  },  
  {
    accessorKey: 'description',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Description' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.getValue('description')),
    enableSorting: false,
  },
  {
    accessorKey: 'uuid',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Id' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, h(Tooltip, {value: row.getValue('uuid') as string })),
    enableSorting: false,
  },
  {
    accessorKey: 'serialNumber',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Serial Number' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.getValue('serialNumber')),
    enableSorting: false,
  },

  {
    accessorKey: 'macAddress',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Adresse Mac' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.getValue('macAddress')),
    enableSorting: false,
  },
  {
    accessorKey: 'stackMemberNumber',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Stack Number' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.getValue('stackMemberNumber')),
    enableSorting: false,
  },

  {
    accessorKey: 'role',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Role' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.getValue('role')),
    enableSorting: false,
  },
  {
    accessorKey: 'softwareImage',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Software' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.getValue('softwareImage')),
    enableSorting: false,
  }, 
  {
    accessorKey: 'serialNumber',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Serial Number' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.getValue('serialNumber')),
    enableSorting: false,
  },
  {
    accessorKey: 'switchPlatformId',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Platform Id' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, getNameFor(row.getValue('switchPlatformId'))),
    enableSorting: false,
  },
  {
    accessorKey: 'equipementType',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Type' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, getNameFor(row.getValue('equipementType'))),
    enableSorting: false,
  },

]