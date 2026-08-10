<template>
    <DefaultTooltip text="Création d'un Chassis">
        <Button
			variant="outline"
			size="sm"
			class="ml-auto hidden h-8 lg:flex"
			@click="navigateTo('/physical/chassis/edit/')"
        >
          <SquarePen class="h-4 w-4" />
        </Button>    
    </DefaultTooltip>
</template>

<script setup lang="ts">
    // Icones
    import { SquarePen } from "@lucide/vue"
</script>