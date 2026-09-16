<script setup lang="ts" generic="T">
// Icon Import
import { ChevronRight, XIcon , EraserIcon} from "@lucide/vue"
// Type
type Option = {
	id: string,
    name: string
}
// Props
const { options = [], withDeleteOption = true } = defineProps<{
	options: Option[],
	withDeleteOption?: boolean
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
const canCreate = computed<boolean>(() => 
	withDeleteOption && filter.value != '' && !options.some(item => item.name === filter.value)
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
				class="border rounded-md px-3 py-2 w-full text-left group overflow-hidden"
			>
				<div class="w-full flex justify-between space-x-2">
					
					<div class="group w-full flex">
						<span>{{ options.find(o=> o.id === model)?.name ?? "Sélectionner..." }}</span>
						<button
							v-if="model"
							type="button"
							class="ml-2 text-muted-foreground opacity-0 transition-opacity group-hover:opacity-100"
							@click.stop="model = null"
						>
							<XIcon class="size-4" />
						</button>
					</div>
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
				<CommandEmpty v-if="!withDeleteOption" >No results found.</CommandEmpty>
				<CommandGroup :hidden="false" >
					<CommandList class="max-h-75 overflow-auto">
						<CommandItem 
							v-for="option in _options"
							:key="option.id"
							:value="option.id"
							class="flex items-center gap-1 px-2 py-1.5 rounded-sm hover:bg-accent cursor-pointer"
							:class="{'bg-gray-50': option.id === model}"
							@select="(v) => emit('optionSelected', v.detail.value as string)"
							>
							<div class="group w-full flex justify-between">
								<span>{{ option.name }}</span>
								<button
									v-if="withDeleteOption"
									type="button"
									class="group/icon cursor-pointer ml-2 text-muted-foreground opacity-0 transition-opacity group-hover:opacity-100"
									@click.stop="emit('removeOption', option.id)"
						  		>
									<XIcon class="size-4 transition-transform duration-150 group-hover/icon:stroke-destructive/70" />
								</button>
							</div>
						</CommandItem>
						<CommandItem
							value="__fake__"
							v-if="canCreate"
							:always-render="true"
							@select="(event) => {
								event.preventDefault()
								emit('addOption', filter)
								}"
							class="flex flex-row items-center justify-center gap-1 pt-1 py-1 hover:bg-accent rounded cursor-pointer"
						>
							<span>Créer « {{ filter.trim() }} »</span>
						</CommandItem>
					</CommandList>
				</CommandGroup>
			</Command>
    	</PopoverContent>
  	</Popover>
</template>
