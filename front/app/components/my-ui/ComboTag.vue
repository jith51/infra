<script setup lang="ts">
import { CheckIcon, ChevronRight, XIcon } from '@lucide/vue'
import { ListboxContent, ListboxFilter, ListboxItem, ListboxItemIndicator, ListboxRoot, useFilter } from 'reka-ui'

// Model
const modelValue = defineModel<string[]>({
  default: () => [],
})

// Types
type Option = {
    id: string
    name: string
}

 // Props
const props = defineProps<{
    label?: string
    disabled?: boolean
    options: Option[]
}>()


const emit = defineEmits<{
  add: [name: string]
  remove: [id: string]
}>()

// SEARCH
const searchTerm = ref('')
const open = ref(false)
const { contains } = useFilter({ sensitivity: 'variant' })

const filteredOptions = computed(() =>
  searchTerm.value === ''
    ? props.options
    : props.options.filter(option => contains(option.name, searchTerm.value)),
)

watch(searchTerm, (f) => {
  if (f) {
    open.value = true
  }
})

const result = computed(() => Object.fromEntries(
  props.options.map(item => [item.id, item.name])
))

// CREATION
const canCreate = computed(() => {
  const term = searchTerm.value.trim()

  if (!term) { return false }

  return !props.options.some( option => option.name === term )
})

function createTag() {
  const name = searchTerm.value.trim()

  if (!name || !canCreate.value) {
    return
  }

  emit('add', name)
}

// SUPPRESSION
function removeTag(id: string) {
  modelValue.value = modelValue.value.filter(value => value !== id)
  emit('remove', id)
}

</script>

<template>
  <Popover v-model:open="open">
    <ListboxRoot
      v-model="modelValue"
      highlight-on-hover
      multiple
    >
      <PopoverAnchor class="inline-flex w-full">
        <TagsInput v-slot="{ modelValue: tags }" v-model="modelValue" class="w-full">
          <TagsInputItem v-for="item in tags" :key="item.toString()" :value="item.toString()">
            <TagsInputItemText> {{ result[item as string] }}</TagsInputItemText>
            <TagsInputItemDelete />
          </TagsInputItem>
          <ListboxFilter v-model="searchTerm" as-child>
            <TagsInputInput :placeholder="`${label}...` || 'Tags...'" @keydown.enter.prevent @keydown.down="open = true" />
          </ListboxFilter>
          <PopoverTrigger as-child>
            <Button size="icon-sm" variant="link" class="order-last self-start ml-auto">
              <ChevronRight class="size-4 shrink-0 opacity-50 mt-1 transition-transform" :class="{'rotate-90': open}"/>
            </Button>
          </PopoverTrigger>
        </TagsInput>
      </PopoverAnchor>
      <PopoverContent
        class="p-1"
        @open-auto-focus.prevent
      >
        <ListboxContent class="max-h-75 scroll-py-1 overflow-x-hidden overflow-y-auto empty:after:content-['No_options'] empty:p-1 empty:after:block" tabindex="0">
          <!-- <CommandEmpty>No results found.</CommandEmpty> -->
          <ListboxItem
            v-for="item in filteredOptions" :key="item.id" class="cursor-pointer data-[highlighted]:bg-accent data-[highlighted]:text-accent-foreground [&_svg:not([class*=\'text-\'])]:text-muted-foreground relative flex cursor-default items-center gap-2 rounded-sm px-2 py-1.5 text-sm outline-hidden select-none data-[disabled]:pointer-events-none data-[disabled]:opacity-50 [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*=\'size-\'])]:size-4"
            :value="item.id"
            @select="() => { searchTerm = '' }" 
          >
            <div class="group w-full flex justify-between">
              <span>{{ item.name }}</span>
              <button
                type="button"
                class="group/icon ml-2 cursor-pointer text-muted-foreground opacity-0 transition-opacity group-hover:opacity-100"
                @click.stop="removeTag(item.id)"
                
						  >
							  <XIcon class="size-4 transition-transform duration-150 group-hover/icon:stroke-destructive/70" />
					  	</button>
            </div>
            <ListboxItemIndicator class="ml-auto inline-flex items-center justify-center" >
              <CheckIcon />
            </ListboxItemIndicator> 
          </ListboxItem>
          <ListboxItem
            v-if="canCreate"
            value="__create__"
            class="relative flex cursor-default items-center gap-2 justify-center rounded-sm px-2 py-1.5 text-sm outline-hidden select-none data-[highlighted]:bg-accent data-[highlighted]:text-accent-foreground"
            @select="(event) => {
              event.preventDefault()
              createTag()
            }"
          >
            <span>
              Créer « {{ searchTerm.trim() }} »
            </span>
            </ListboxItem>
        </ListboxContent>
      </PopoverContent>
    </ListboxRoot>
  </Popover>
</template>