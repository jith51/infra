// https://nuxt.com/docs/api/configuration/nuxt-config
import tailwindcss from '@tailwindcss/vite'
import graphql from '@rollup/plugin-graphql'
import { twVariantGroups } from './app/utils/parse_variants'

export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },
  ssr: false,
  css: ['./app/assets/css/main.css'],
  runtimeConfig: {
    public: {
      baseURL: "defini_dans_le_dot_ENV",
      casUrl: process.env.NUXT_PUBLIC_CAS_URL
    }
  },
  imports: {
    dirs: ['~/composables/**'],
  },
  components: [
    // ~/calendar-module/components/event/Update.vue => <EventUpdate />
    { path: '~/components/form/field' },
    '~/components',
  ],
  modules: [
    'shadcn-nuxt',
    '@nuxt/devtools',
    '@vueuse/nuxt',
    '@nuxt/image',
    '@chettapong/nuxt-lodash',
    'vue-sonner/nuxt'
  ],
  typescript: {
    strict: true
  },
  vite: {
    plugins: [
      tailwindcss(),
      twVariantGroups(),
      graphql(), // ADD
    ],
    optimizeDeps: {
      include: [
        '@lucide/vue',
        'class-variance-authority',
        'clsx',
        'reka-ui',
        'tailwind-merge',
      ]
    },
    define: {
      "global": { navigator: {}},
      "globalThis.__DEV__": JSON.stringify(true),
    },
  },
  shadcn: {
    prefix: '',
    componentDir: './app/components/ui'
  },
})
