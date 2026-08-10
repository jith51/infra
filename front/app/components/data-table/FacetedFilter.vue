<script setup lang="ts">
  // Utilitaire tailwind
  import { cn } from '@/lib/utils'

  // Icones
  import { CirclePlusIcon, CheckIcon }from "@lucide/vue"

  // Type
  type Option = {
    value: string | number
    label: string
    numberOfThings?: number
    children?: Option[]
  }

  // Props
  const props = defineProps<{
    title?: string
    options: Option[]
  }>()

  // v-model
  const filter = defineModel<string[] | number[]>()

  // mise à jour du filtre en update
  function onSelect(event: CustomEvent) { 
    const value = event.detail.value
    const wasSelected = useIncludes(filter.value, value)
    filter.value = wasSelected ? useWithout(filter.value, value) : useConcat(filter.value, value)
  }

  // selection des options selectionnées pour affichage en badge
  const selectedOptions = computed<Option[]>(() => {
    return useFilter(props.options, (option) => useIncludes(filter.value, option.value))
  })

</script>

<template>
  <Popover>
    <PopoverTrigger as-child>
      <Button variant="outline" size="sm" class="h-8 border-dashed">
        <CirclePlusIcon class="mr-2 h-4 w-4" />
        {{ title }}
        <template v-if="filter && filter.length > 0">
          <Separator orientation="vertical" class="mx-2 h-4" />
          <Badge
            variant="secondary"
            class="rounded-sm px-1 font-normal lg:hidden"
          >
            {{ filter.length }}
          </Badge>
          <div class="hidden space-x-1 lg:flex">
            <Badge
              v-if="filter.length > 2"
              variant="secondary"
              class="rounded-sm px-1 font-normal"
            >
              {{ filter.length }} selected
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
    <PopoverContent class="w-[270px] p-0 relative" align="start">
      <!-- :filter-function="(list: DataTableFacetedFilter['options'], term: string) => list.filter(i => i.label.toLowerCase()?.includes(term)) " -->
      <Command
        :filter-function="(list: Option[], term: string) => list.filter((i: Option) => i.label.toLowerCase()?.includes(term)) "
      >
        <CommandInput :placeholder="title" />
        <CommandList>
          <CommandEmpty>No results found.</CommandEmpty>
          <CommandGroup>
            <CommandItem
              v-for="option in options"
              :key="option.value"
              :value="option.value"
              @select="(e) => onSelect(e)"
            >
              <div
                :class="cn(
                  'mr-2 flex h-4 w-4 items-center justify-center rounded-sm border border-primary',
                  useIncludes(filter, option.value) ? 'bg-primary text-primary-foreground' : 'opacity-50 [&_svg]:invisible',
                )"
              >
                <CheckIcon :class="cn('h-4 w-4')" />
              </div>
              <!-- <component :is="option.icon" v-if="option.icon" class="mr-2 h-4 w-4 text-muted-foreground" /> -->
              <span>
                <TooltipProvider>
                  <Tooltip>
                    <TooltipTrigger>
                      {{ useTruncate(option.label, {'length': 25 }) }}
                    </TooltipTrigger>
                    <TooltipContent>
                      {{option.label }}
                    </TooltipContent>
                  </Tooltip>
                </TooltipProvider>
              </span>
              <span class="ml-auto flex h-4 w-4 items-center justify-center font-mono text-xs">
                {{ option.numberOfThings }}
              </span>
            </CommandItem>
          </CommandGroup>

          <template v-if="filter && filter.length > 0">
            <CommandGroup class="sticky bottom-0 bg-white">
              <CommandSeparator />
              <CommandItem
                :value="{ label: 'Clear filters' }"
                class="justify-center text-center"
                @select="filter = []"
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