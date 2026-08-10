<script setup lang="ts">
import type { DateValue } from '@internationalized/date'
import { getLocalTimeZone, CalendarDate } from '@internationalized/date'

import { ChevronDownIcon } from '@lucide/vue'

const model = defineModel<string | null>({
  default: null,
})

const _model = computed<DateValue | undefined>({
  get() {
    if (!model.value) return undefined
    const [year, month, day] = model.value.split('/').map(Number)
    return new CalendarDate(year, month, day)
  },
  set(value) {
    model.value = value ? value.toDate(getLocalTimeZone()).toLocaleDateString() : null
  },
})

</script>

<template>
  <Popover v-slot="{ close }">
    <PopoverTrigger as-child>
      <Button
        id="date"
        variant="outline"
        class="w-48 justify-between font-normal"
      >
        {{ model ?? "Select date" }}
        <ChevronDownIcon />
      </Button>
    </PopoverTrigger>
    <PopoverContent class="w-auto overflow-hidden p-0" align="start">
      <Calendar
        :model-value="_model"
        layout="month-and-year"
        @update:model-value="(value) => {
          if (value) {
            _model = value
            close()
          }
        }"
      />
    </PopoverContent>
  </Popover>
</template>
