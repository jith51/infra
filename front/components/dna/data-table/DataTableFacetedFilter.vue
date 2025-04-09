<script setup lang="ts">
  import { cn } from '@/lib/utils'

  import CheckIcon from '@radix-icons/vue/CheckIcon'
  import PlusCircledIcon from '@radix-icons/vue/PlusCircledIcon'

  import DataTableTooltip from './DataTableTooltip.vue'

  type Option = {
    value: number
    label: string
    numberOfDevices: number
  }

  interface DataTableFacetedFilter {
    title?: string
    filter: number[]
    options: Option[]
  }

  const props = defineProps<DataTableFacetedFilter>()

  const emit = defineEmits<{
    (e: 'filterChange', value: number[]): void
  }>()
  
  // Emission d'un event pour le parent lorsqu'une option est selectionné
  // On passe le tableau des options selectionnées
  function onSelect(event: Event) { 
    const value = event.detail.value.value
    const isSelected = useIncludes(props.filter, value)
    if (isSelected) {
      emit('filterChange', useWithout(props.filter, value))
    }
    else {
      emit('filterChange', useConcat(props.filter, value))
    }
  }

  // selection des options selectionnées pour affichage en badge
  const selectedOptions = computed<Option[]>(() => {
    return useFilter(props.options, (option) => useIncludes(props.filter, option.value))
  })

</script>

<template>
  <Popover>
    <PopoverTrigger as-child>
      <Button variant="outline" size="sm" class="h-8 border-dashed">
        <PlusCircledIcon class="mr-2 h-4 w-4" />
        {{ title }}
        <template v-if="props.filter.length > 0">
          <Separator orientation="vertical" class="mx-2 h-4" />
          <Badge
            variant="secondary"
            class="rounded-sm px-1 font-normal lg:hidden"
          >
            {{ props.filter.length }}
          </Badge>
          <div class="hidden space-x-1 lg:flex">
            <Badge
              v-if="props.filter.length > 2"
              variant="secondary"
              class="rounded-sm px-1 font-normal"
            >
              {{ props.filter.length }} selected
            </Badge>

            <template v-else>
              <Badge
                v-for="option in selectedOptions"
                :key="option.value"
                variant="secondary"
                class="rounded-sm px-1 font-normal"
              >
                {{ option.label }}
              </Badge>
            </template>
          </div>
        </template>
      </Button>
    </PopoverTrigger>
    <PopoverContent class="w-[200px] p-0 relative" align="start">
      <Command
        :filter-function="(list: DataTableFacetedFilter['options'], term) => list.filter(i => i.label.toLowerCase()?.includes(term)) "
      >
        <CommandInput :placeholder="title" />
        <CommandList>
          <CommandEmpty>No results found.</CommandEmpty>
          <CommandGroup>
            <CommandItem
              v-for="option in options"
              :key="option.value"
              :value="option"
              @select="(e) => onSelect(e)"
            >
              <div
                :class="cn(
                  'mr-2 flex h-4 w-4 items-center justify-center rounded-sm border border-primary',
                  useIncludes(props.filter, option.value)
                    ? 'bg-primary text-primary-foreground'
                    : 'opacity-50 [&_svg]:invisible',
                )"
              >
                <CheckIcon :class="cn('h-4 w-4')" />
              </div>
              <component :is="option.icon" v-if="option.icon" class="mr-2 h-4 w-4 text-muted-foreground" />
              <span>
                <DataTableTooltip :value="option.label"/>
              </span>
              <span class="ml-auto flex h-4 w-4 items-center justify-center font-mono text-xs">
                {{ option.numberOfDevices }}
              </span>
            </CommandItem>
          </CommandGroup>

          <template v-if="props.filter.length > 0">
            <CommandGroup class="sticky bottom-0 bg-white">
              <CommandSeparator />
              <CommandItem
                :value="{ label: 'Clear filters' }"
                class="justify-center text-center"
                @select=" emit('filterChange',[])"
              >
                Clear filters
              </CommandItem>
            </CommandGroup>
          </template>
        </CommandList>
      </Command>
    </PopoverContent>
  </Popover>
</template>