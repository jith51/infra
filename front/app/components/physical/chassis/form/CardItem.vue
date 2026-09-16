<template>
    <div class="space-y-3">
        <Label class="flex w-fit gap-2 leading-snug">{{label}}</Label>
        <template v-if="(type ?? 'text') == 'boolean'">
            <Switch :default-value="(value as boolean)" :disabled="true" />
        </template>
        <template v-else>
            <span class="flex h-9 w-full min-w-0 items-center rounded-md border border-input bg-transparent px-3 py-1 text-base shadow-xs md:text-sm">
                <template v-if="(type ?? 'text') == 'url'">
                    <a target="_blank" rel="noopener noreferrer" :href="(value as string) ?? undefined">
                        {{ value }}
                    </a>
                </template>
                <template v-else>
                    {{ value }}
                </template>
            </span>
        </template>
    </div>
</template>

<script setup lang="ts">
    import type { FieldType } from "@/types/field"

    const props = defineProps<{
        label: string,
        value?: string | number | boolean | null,
        type?: FieldType
    }>()
</script>