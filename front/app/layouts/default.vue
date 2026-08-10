<template>
  <SidebarProvider>
    <AppSidebar />
    <SidebarInset>
      <header class="flex h-16 shrink-0 bg-background sticky inset-x-0 top-0 z-10 items-center gap-2 transition-[width,height] ease-linear group-has-data-[collapsible=icon]/sidebar-wrapper:h-12">
        <div class="flex items-center gap-2 px-4">
          <SidebarTrigger class="-ml-1" />
          <Separator
            orientation="vertical"
            class="mr-2 data-[orientation=vertical]:h-4"
          />
          <Breadcrumb>
            <BreadcrumbList>
              <template v-for="(crumb, index) in breadcrumbs" :key="crumb.path">
                <BreadcrumbItem class="hidden md:block">
                  <BreadcrumbLink :href="crumb.path">
                    {{ crumb.name }}
                  </BreadcrumbLink>
                </BreadcrumbItem>
                <BreadcrumbSeparator v-if="index != breadcrumbs.length - 1" class="hidden md:block" />
              </template>
            </BreadcrumbList>
          </Breadcrumb>
        </div>
      </header>
      <div class="flex flex-1 justify-center gap-4 p-4 pt-0 overflow-hidden">
        <slot/>
      </div>
    </SidebarInset>
  </SidebarProvider>
</template>

<script setup lang="ts">
  // const authStore = useAuthStore()
  const breadcrumbs = useBreadcrumbs()
  // const { userLogOut } = useUserAuth()

  // export const description= "A sidebar that collapses to icons."
  // export const iframeHeight = "800px"
  // export const containerClass = "w-full h-full"
  // This is sample data.
  // const data = {
  //   user: {
  //     name: 'shadcn',
  //     email: 'm@example.com',
  //     avatar: '/avatars/shadcn.jpg',
  //   },
  //   teams: [
  //     {
  //       name: 'Système & Hébergement',
  //       logo: GalleryVerticalEnd,
  //       plan: 'Enterprise',
  //     },
  //     {
  //       name: 'Réseau & Telecom',
  //       logo: AudioWaveform,
  //       plan: 'Startup',
  //     },
  //     {
  //       name: 'Support & Exploitation',
  //       logo: Command,
  //       plan: 'Free',
  //     },
  //     {
  //       name: 'Poste de Travail',
  //       logo: Command,
  //       plan: 'Free',
  //     },
  //   ],
  //   navMain: [
  //     {
  //       title: 'Réseau',
  //       url: '#',
  //       icon: SquareTerminal,
  //       isActive: true,
  //       items: [
  //         {
  //           title: 'Apic',
  //           url: '/apic',
  //         },
  //         {
  //           title: 'Dna',
  //           url: '/dna',
  //         },
  //       ],
  //     },
  //     {
  //       title: 'DataCenter',
  //       url: '#',
  //       icon: SquareTerminal,
  //       isActive: true,
  //       items: [
  //         {
  //           title: 'Rack',
  //           url: '/rack',
  //         },
  //       ],
  //     },
  //     {
  //       title: 'Physical',
  //       url: '#',
  //       icon: SquareTerminal,
  //       isActive: true,
  //       items: [
  //         {
  //           title: 'Chassis Class',
  //           url: '/physical/chassis_class',
  //         },
  //         {
  //           title: 'Chassis',
  //           url: '/physical/chassis',
  //         },
  //       ],
  //     }
  //   ],
  //   projects: [
  //     {
  //       name: 'test',
  //       url: '#',
  //       icon: Frame,
  //     },
  //   ],
  // }
// const breadcrumbs = ref([])

// const activeTeam = ref(data.teams[0])

// function setActiveTeam(team: typeof data.teams[number]) {
//   activeTeam.value = team
// }
</script>