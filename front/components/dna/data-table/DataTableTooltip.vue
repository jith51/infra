<script setup lang="ts">
  interface DataTableProps {
    value?: string
    number?: number
  }

  const props = defineProps<DataTableProps>()

</script>

<template>
  <TooltipProvider>
    <Tooltip>
      <TooltipTrigger>
        {{ useTruncate(props.value, {'length': props.number || 20 }) }}
      </TooltipTrigger>
      <TooltipContent>
        {{ props.value }}
      </TooltipContent>
    </Tooltip>
  </TooltipProvider>
</template>