// https://v3.nuxtjs.org/api/configuration/nuxt.config
import graphql from '@rollup/plugin-graphql'
import { twVariantGroups } from './utils/parse_variants'
import path from 'path'
import Aura from '@primeuix/themes/aura'

export default defineNuxtConfig({
  ssr: false,
  future: {
    compatibilityVersion: 4,
  },
  runtimeConfig: {
    public: {
      baseURL: "fake"
    }
  },
  imports: {
    dirs: [
      // ... or scan all modules within given directory
      'composables/**'
    ]
  },
  buildModules: ['@nuxt/typescript-build'],
  modules: [
    '@nuxtjs/tailwindcss',
    '@primevue/nuxt-module',
    'shadcn-nuxt',
    'nuxt-lodash',
    '@vueuse/nuxt',
  ],
  build: {
    transpile: ['radix-vue'],
    extend(config, ctx) {
      config.module.rules.push({
        test: /\.(graphql|gql)$/,
        loader: 'graphql-tag/loader',
        use: 'graphql-tag/loader',
        options: {
          name: 'graphql'
        }
      })
    },
  },
  typescript: {
    strict: true
  },
  primevue: {
    components: {
      prefix: 'Prime',
    },
    options: {
      theme: {
          preset: Aura,
      }
    },
  },
  vite: {
    resolve: {
      alias:{
        '@/': path.resolve( __dirname, '../'),
      }
    },
    plugins: [
      twVariantGroups(),
      graphql(), // ADD
    ],
    define: {
      "global": { navigator: {}},
    },
  },
  shadcn: {
    prefix: '',
    componentDir: './components/ui'
  },
})