<script setup lang="ts">
import type { SidebarProps } from '@/components/ui/sidebar'

import {
  AudioWaveform,
  BookOpen,
  Bot,
  Command,
  Frame,
  GalleryVerticalEnd,
  Map,
  PieChart,
  Settings2,
  SquareTerminal,
  Server,
  Network,
  LogOut,
  AppWindowMac,
  LogOutIcon
} from "@lucide/vue"
import NavTeams from './NavTeams.vue'
import NavProjects from './NavProjects.vue'
import NavUser from './NavUser.vue'
import TeamSwitcher from './TeamSwitcher.vue'


import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarHeader,
  SidebarRail,
} from '@/components/ui/sidebar'

const props = withDefaults(defineProps<SidebarProps>(), {
  collapsible: "icon",
})

// This is sample data.
const data = {
  user: {
    name: "shadcn",
    email: "m@example.com",
    avatar: "/avatars/shadcn.jpg",
  },
  teams: [
    {
      name: "Acme Inc",
      logo: GalleryVerticalEnd,
      plan: "Enterprise",
    },
    {
      name: "Acme Corp.",
      logo: AudioWaveform,
      plan: "Startup",
    },
    {
      name: "Evil Corp.",
      logo: Command,
      plan: "Free",
    },
  ],
  navDatacenter: [
    {
      title: "Physique",
      url: "#",
      icon: Server,
      isActive: true,
      items: [
        {
          title: "Chassis Powertypes",
          url: "/physical/chassis_powertypes",
        },
        {
          title: "Chassis Classes",
          url: '/physical/chassis_classes',
        },
        {
          title: "Chassis",
          url: '/physical/chassis',
        },
      ],
    },
    {
      title: "Operating Systems",
      url: "#",
      icon: AppWindowMac,
      items: [
        {
          title: "OS Types",
          url: "#",
        },
      ],
    },
    {
      title: "Réseau",
      url: "#",
      icon: Network,
      items: [
        {
          title: "Apic",
          url: "/apic",
        },
      ],
    },
    // {
    //   title: "Settings",
    //   url: "#",
    //   icon: Settings2,
    //   items: [
    //     {
    //       title: "General",
    //       url: "#",
    //     },
    //     {
    //       title: "Team",
    //       url: "#",
    //     },
    //     {
    //       title: "Billing",
    //       url: "#",
    //     },
    //     {
    //       title: "Limits",
    //       url: "#",
    //     },
    //   ],
    // },
  ],
   navReseau: [
    {
      title: "Réseau",
      url: "#",
      icon: Network,
      isActive: true,
      items: [
        {
          title: "DNA",
          url: "/dna",
        },
      ],
    },
  ],
  projects: [
    {
      name: "Design Engineering",
      url: "#",
      icon: Frame,
    },
    {
      name: "Sales & Marketing",
      url: "#",
      icon: PieChart,
    },
    {
      name: "Travel",
      url: "#",
      icon: Map,
    },
  ],
}
const { user } = useAuthStore()
const { userLogOut } = useUserAuth()

</script>

<template>
  <Sidebar v-bind="props">
    <SidebarHeader>
      <SidebarMenu>
        <SidebarMenuButton
          size="lg"
          class="data-[state=open]:bg-sidebar-accent data-[state=open]:text-sidebar-accent-foreground"
        >
          <div class="flex aspect-square size-8 items-center justify-center rounded-lg bg-sidebar-primary text-sidebar-primary-foreground">
            <GalleryVerticalEnd class="size-4" />
          </div>
          <div class="grid flex-1 text-left text-sm leading-tight">
            <span class="truncate font-medium">
              CHU de REIMS
            </span>
            <span class="truncate text-xs">Secteur Infrastructure</span>
          </div>
        </SidebarMenuButton>
      </SidebarMenu>
      <!-- <TeamSwitcher :teams="data.teams" /> -->
    </SidebarHeader>
    <SidebarContent>
      <NavTeams :items="data.navDatacenter" title="Système & Hébergement"/>
      <NavTeams :items="data.navReseau" title="Réseau & telecom"/>
      <!-- <NavProjects :projects="data.projects" /> -->
    </SidebarContent>
    <SidebarFooter>
      <!-- <NavUser :user="data.user" /> -->
      <SidebarMenu>
        <SidebarMenuItem>
          <SidebarMenuButton
            size="lg"
            class="data-[state=open]:bg-sidebar-accent data-[state=open]:text-sidebar-accent-foreground"
          >
            <Avatar class="h-8 w-8 rounded-lg">
              <!-- <AvatarImage :src="user.avatar" :alt="user.name" /> -->
              <AvatarFallback class="rounded-lg">
                CN
              </AvatarFallback>
            </Avatar>
            <div class="grid flex-1 text-left text-sm leading-tight">
              <span class="truncate font-medium">{{ user?.id }}</span>
            </div>
            <Button
              variant="outline"
              size="sm"
              @click="userLogOut()"
            >
              <LogOutIcon class="ml-auto size-4" />
            </Button>
          </SidebarMenuButton>
        </SidebarMenuItem>
      </SidebarMenu>
    </SidebarFooter>
    <SidebarRail />
  </Sidebar>
</template>
