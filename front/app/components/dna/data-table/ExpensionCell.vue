
<script setup lang="ts">
  import { ChevronRightIcon, ChevronDownIcon } from '@lucide/vue'
  
  const props = defineProps<{
    row: any;
  }>();

  const clickRow = () => {
    const toggleExpandedHandler = props.row.getToggleExpandedHandler();
    toggleExpandedHandler();
  };
</script>
<template>
    <div
      :style="{
        paddingLeft: `${row.depth * 2}rem`,
      }"
    >
      <button
        v-if="row.getCanExpand()"
        @click="clickRow"
        :style="{
          cursor: 'pointer',
        }"
      >
        <ChevronDownIcon v-if="row.getIsExpanded()" class="ml-2 h-4 w-4" />
        <ChevronRightIcon v-else class="ml-2 h-4 w-4" />
      </button>
    </div>
  </template>
