<script setup lang="ts">
  import type { EolBulletinType, SwitchType, EquipementType } from '@/types/device'

  import { switchColumns } from '@/components/dna/data-table/switchColumns'

  import TableSwitches from './TableSwitches.vue'
  import TableEquipements from './TableEquipements.vue'
  import TableSupport from './TableSupport.vue'

  interface DataTableProps {
    eolBulletins: EolBulletinType[]
    switches: SwitchType[]
    equipements: EquipementType[]
  }

  const props = defineProps<DataTableProps>()

</script>

<template>
  <div class="flex flex-col gap-4 p-2">
    <div 
      v-if="props.switches.length != 0"
      class="w-full flex flex-col pt-2"
    >
      <div class="pb-2">Switchs</div>
      <TableSwitches
        :data="props.switches" 
        :columns="switchColumns"
      />
    </div>
    <div class="w-full grid grid-cols-2 gap-6">
      <div 
        v-if="equipements.length != 0"
        class="flex flex-col"
      >
        <div class="pb-2">Equipements</div>
        <TableEquipements :equipements="equipements"/>
      </div>
      <div 
        v-if="eolBulletins.length != 0"
        class="flex flex-col"
      >
        <div class="pb-2">Support</div>
        <TableSupport :eol_bulletins="eolBulletins"/>
      </div>
    </div>
  </div>
</template>