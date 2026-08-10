import * as v from 'valibot'

const basicDeviceTableSchema = v.object({
  id: v.string(),
  name: v.string(),
  numberOfDevices: v.optional(v.number())
})

export const equipementSchema = v.object({
  id: v.string(),
  name: v.optional(v.string()),
  description: v.optional(v.string()),
  serialNumber: v.optional(v.string()),
  uuid: v.optional(v.string()),
  productId: basicDeviceTableSchema,
  equipementType: basicDeviceTableSchema,

})

export const switchSchema = v.object({
  id: v.string(),
  uuid: v.optional(v.string()),
  description: v.optional(v.string()),
  macAddress: v.optional(v.string()),
  serialNumber: v.optional(v.string()),
  role: v.optional(v.string()),
  stackMemberNumber: v.optional(v.string()),
  softwareImage: v.optional(v.string()),
  switchPlatformId: basicDeviceTableSchema,
  equipementType: basicDeviceTableSchema,
  equipements: v.array(equipementSchema)
})

export const eolBulletinSchema = v.object({
  id: v.string(),
  number: v.optional(v.string()),
  name: v.optional(v.string()),
  eolType: v.optional(v.string()),
  url: v.optional(v.string()),
  endOfLifeDate: v.optional(v.date()),
  lastDateOfSupport: v.optional(v.date()),
})

export const deviceSchema = v.object({
    id: v.string(),
    description: v.optional(v.string()),
    hostname: v.optional(v.string()),
    softwareVersion: v.optional(v.string()),
    macAddress: v.optional(v.string()),
    serialNumber: v.optional(v.string()),
    managementIp: v.optional(v.string()),
    location: v.optional(v.string()),
    uuid: v.optional(v.string()),
    deviceFamily: basicDeviceTableSchema,
    devicePlatformId: basicDeviceTableSchema,
    deviceSoftwareType: basicDeviceTableSchema,
    deviceSeries: basicDeviceTableSchema,
    deviceType: basicDeviceTableSchema,
    deviceRole: basicDeviceTableSchema,
    equipements: v.array(equipementSchema),
    switches: v.array(switchSchema),
    eolBulletins: v.array(eolBulletinSchema)
  })

const deviceFilterSchema = v.object({
  hostname: v.string(),
  deviceFamilyIds: v.array(v.number()),
  devicePlatformIdIds: v.array(v.number()),
  deviceSoftwareTypeIds: v.array(v.number()),
  deviceSeriesIds: v.array(v.number()),
  deviceTypeIds: v.array(v.number()),
  deviceRoleIds: v.array(v.number()),
})

export type DeviceType = v.InferInput<typeof deviceSchema>
export type EquipementType = v.InferInput<typeof equipementSchema>
export type SwitchType = v.InferInput<typeof switchSchema>
export type EolBulletinType = v.InferInput<typeof eolBulletinSchema>
export type BasicDeviceTable = v.InferInput<typeof basicDeviceTableSchema>
export type DeviceFilter = v.InferInput<typeof deviceFilterSchema>

export const defaultDeviceFilter = {
  hostname: "",
  deviceFamilyIds: [],
  devicePlatformIdIds: [],
  deviceSoftwareTypeIds: [],
  deviceSeriesIds: [],
  deviceTypeIds: [],
  deviceRoleIds: [],
}
