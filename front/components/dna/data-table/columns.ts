import type { ColumnDef } from '@tanstack/vue-table'
import type { DeviceType } from '@/types/device'

import type { BasicDeviceTable } from '@/types/device'

import { h } from 'vue'

import ColumnHeader from './ColumnHeader.vue'
import ExpensionCell from './ExpensionCell.vue'
import DataTableTooltip from './DataTableTooltip.vue'
  
function getNameFor(cell: BasicDeviceTable) {
  return cell ? cell["name"] : ""
}

export const columns: ColumnDef<DeviceType>[] = [
  {
    id: 'select',
    header: ({ table }) => "",
    cell: ({ row }) => {
        return h('div', { class: 'flex w-[2px] p-0' }, h(ExpensionCell, { row }))
      },
    enableHiding: false,
  },
  {
    accessorKey: 'hostname',
    header: ({ column }) => h(ColumnHeader, { column, title: 'HostName' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.getValue('hostname')),
    enableHiding: false,
    enableSorting: false,
  },
  {
    accessorKey: 'uuid',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Id' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.getValue('uuid')),
    enableSorting: false,
  },
  {
    accessorKey: 'softwareVersion',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Software Version' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.getValue('softwareVersion')),
    enableSorting: false,
  },
  {
    accessorKey: 'managementIp',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Management Ip' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.getValue('managementIp')),
    enableSorting: false,
  },
  {
    accessorKey: 'macAddress',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Addresse Mac' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.getValue('macAddress')),
    enableSorting: false,
  },
  {
    accessorKey: 'serialNumber',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Serial Number' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.getValue('serialNumber')),
    enableSorting: false,
  },
  {
    accessorKey: 'description',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Description' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, h(DataTableTooltip, {value: row.getValue('description') })),
    enableSorting: false,
  },
  {
    accessorKey: 'location',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Location' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, row.getValue('location')),
    enableSorting: false,
  },
  {
    accessorKey: 'deviceFamily',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Famille' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, getNameFor(row.getValue('deviceFamily'))),
    enableSorting: false,
  },
  {
    accessorKey: 'devicePlatformId',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Platform Id' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, getNameFor(row.getValue('devicePlatformId'))),
    enableSorting: false,
  },
  {
    accessorKey: 'deviceSoftwareType',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Software Type' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, getNameFor(row.getValue('deviceSoftwareType'))),
    enableSorting: false,
  },
  {
    accessorKey: 'deviceSeries',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Serie' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, getNameFor(row.getValue('deviceSeries'))),
    enableSorting: false,
  },
  {
    accessorKey: 'deviceRole',
    header: ({ column }) => h(ColumnHeader, { column, title: 'Role' }),
    cell: ({ row }) => h('div', { class: 'w-full' }, getNameFor(row.getValue('deviceRole'))),
    enableSorting: false,
  },

  {
    id: 'actions',
    cell: ({ row }) => h('Actions', { row }),
  },
]