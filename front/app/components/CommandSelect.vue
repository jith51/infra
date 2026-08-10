<script setup lang="ts" generic="T">
// Icon Import
import { ChevronRight, XIcon } from "@lucide/vue"
// Type
type Option = {
	id: string,
    name: string
}
// Props
const {options = []} = defineProps<{
  options: Option[]
}>()
// Model
const model = defineModel<string | null>({
  default: null,
})
// Emit : demande de creation d'un nouveau objec
const emit = defineEmits<{
	(e: 'addOption', name: string): void
	(e: 'removeOption', id: string): void
	(e: 'optionSelected', id: string | undefined | null): void
}>()
// Filtre
const filter = ref<string>('')
// 	Check si le filtre vide la list
const optionsIsEmpty = computed<boolean>(() => 
	!options.some(item => item.name === filter.value) && filter.value != ''
)

// On créer une computed option (pas de reactivite au niveau des props)
const _options = computed(() => options)

// On relance le filtre lorsqu'une nouvelle option est ajouter
watch(_options, async () => await reloadList())

async function reloadList() {
	const current = filter.value
	filter.value = ''
	await nextTick()
	filter.value = current
}

</script>

<template>
	<Popover v-slot="{close}">
		<PopoverTrigger as-child>
			<button
				class="border rounded-md px-3 py-2 w-full text-left group"
			>
				<div class="w-full flex justify-between">
					<span>{{ options.find(o=> o.id === model)?.name ?? "Sélectionner..." }}</span>
					<ChevronRight class="h-4 w-4 shrink-0 opacity-50 group-data-[state=open]:rotate-90 mt-1"/>
				</div>
			</button>
		</PopoverTrigger>
		<PopoverContent class="w-75 p-0">
			<Command 
				v-model="model"
				 @update:model-value="close()"
			>	
				<CommandInputForFilter placeholder="Rechercher..." v-model="filter"/>
				<CommandGroup>
					<CommandList class="max-h-75 overflow-auto p-2">
						<CommandItem 
							v-for="option in _options"
							:key="option.id"
							:value="option.id"
							class="flex items-center gap-1 py-1 hover:bg-accent rounded cursor-pointer"
							:class="{'bg-gray-50': option.id === model}"
							@select="(v) => emit('optionSelected', v.detail.value as string)"
							>
							<div class="w-full flex justify-between">
								<span>{{ option.name }}</span>
								<div class="absolute right-2 z-40" @click.stop="emit('removeOption', option.id)">
									<XIcon class="size-4 group-hover:size-6 mt-1 "/>
								</div>
							</div>
						</CommandItem>
					</CommandList>
				</CommandGroup>
				<div 
					v-if="optionsIsEmpty"
					class="flex flex-row items-center justify-center gap-1 py-1 hover:bg-accent rounded cursor-pointer"
					@click="emit('addOption', filter)"
				>
					<span>Créer le type</span>
				</div>
			</Command>
    	</PopoverContent>
  	</Popover>
</template>
