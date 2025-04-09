import * as s from 'superstruct'

const basicDeviceTableSchema = s.object({
  id: s.string(),
  name: s.string(),
  numberOfDevices: s.optional(s.number())
})

export const equipementSchema = s.object({
  id: s.string(),
  name: s.optional(s.string()),
  description: s.optional(s.string()),
  serialNumber: s.optional(s.string()),
  uuid: s.optional(s.string()),
  producId: basicDeviceTableSchema,
  equipementType: basicDeviceTableSchema,

})

export const switchSchema = s.object({
  id: s.string(),
  uuid: s.optional(s.string()),
  description: s.optional(s.string()),
  macAddress: s.optional(s.string()),
  serialNumber: s.optional(s.string()),
  role: s.optional(s.string()),
  stackMemberNumber: s.optional(s.string()),
  softwareImage: s.optional(s.string()),
  switchPlatformId: basicDeviceTableSchema,
  equipementType: basicDeviceTableSchema,
  equipements: s.array(equipementSchema)
})

export const eolBulletinSchema = s.object({
  id: s.string(),
  number: s.optional(s.string()),
  name: s.optional(s.string()),
  eolType: s.optional(s.string()),
  url: s.optional(s.string()),
  endOfLifeDate: s.optional(s.date()),
  lastDateOfSupport: s.optional(s.date()),
})

export const deviceSchema = s.object({
    id: s.string(),
    description: s.optional(s.string()),
    hostname: s.optional(s.string()),
    softwareVersion: s.optional(s.string()),
    macAddress: s.optional(s.string()),
    serialNumber: s.optional(s.string()),
    managementIp: s.optional(s.string()),
    location: s.optional(s.string()),
    uuid: s.optional(s.string()),
    deviceFamily: basicDeviceTableSchema,
    devicePlatformId: basicDeviceTableSchema,
    deviceSoftwareType: basicDeviceTableSchema,
    deviceSeries: basicDeviceTableSchema,
    deviceType: basicDeviceTableSchema,
    deviceRole: basicDeviceTableSchema,
    equipements: s.array(equipementSchema),
    switches: s.array(switchSchema),
    eolBulletins: s.array(eolBulletinSchema)
  })
const deviceFilterSchema = s.object({
  _limit: s.optional(s.number()),
  _page: s.optional(s.number()),
  hostname: s.optional(s.string()),
  deviceFamilyIds: s.array(s.number()),
  devicePlatformIdIds: s.array(s.number()),
  deviceSoftwareTypeIds: s.array(s.number()),
  deviceSeriesIds: s.array(s.number()),
  deviceTypeIds: s.array(s.number()),
  deviceRoleIds: s.array(s.number()),
})

export type DeviceType = s.Infer<typeof deviceSchema>
export type EquipementType = s.Infer<typeof equipementSchema>
export type SwitchType = s.Infer<typeof switchSchema>
export type EolBulletinType = s.Infer<typeof eolBulletinSchema>
export type BasicDeviceTable = s.Infer<typeof basicDeviceTableSchema>
export type DeviceFilter = s.Infer<typeof deviceFilterSchema>
