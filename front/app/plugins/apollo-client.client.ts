import { ApolloClient, HttpLink, ApolloLink, InMemoryCache } from "@apollo/client"
import { SetContextLink } from "@apollo/client/link/context"
import { getMainDefinition } from '@apollo/client/utilities'
import { DefaultApolloClient, provideApolloClient } from '@vue/apollo-composable'
import UploadHttpLink from "apollo-upload-client/UploadHttpLink.mjs";
import { ErrorLink } from '@apollo/client/link/error'
import { CombinedGraphQLErrors } from "@apollo/client/errors";
// import type { GraphQLApiError  } from '@/types/graphql'
import type { GraphQLFormattedError } from 'graphql'
import { toast } from 'vue-sonner'

type ApiGraphQLExtensions = {
  code?: string
  field_errors?: Record<string, string[]>
}

// import ActionCableLink from 'graphql-ruby-client/subscriptions/ActionCableLink'
// import ActionCable from 'actioncable'

export default defineNuxtPlugin(nuxtApp => {
  // const cableUrl = "/cable"
  const apiUrl = "/graphql"
  const authUrl ="/auth"

  // const cable = ActionCable.createConsumer(cableUrl);
  // const actionCableLink = new ActionCableLink({ cable });

  const { token } = useAuthStore()

  // Gestion des erreurs
  function handleGraphQLError(error: GraphQLFormattedError) {
    const extensions = error.extensions as ApiGraphQLExtensions

    switch (extensions.code) {
      case 'UNAUTHORIZED':
        // logout / redirect
        break

      case 'FORBIDDEN':
        toast.error('Action non autorisée.')
        break

      case 'NOT_FOUND':
        toast.error('Resssource non trouvée.')
        break

      case 'CONFLICT':
        toast.error('Cette resssource existe déjà.')
        break

      case 'DATABASE_ERROR':
        toast.error('Erreur de base de donnée.')
        break

      case 'VALIDATION_ERROR':
        // Rien :
        // géré au niveau de la mutation
        break

      default:
        console.error('[GraphQL]', error)
    }
  }

  function handleNetworkError(error: unknown) {
    console.error('[Network]', error)
    toast.error('Impossible de contacter le serveur.')
  }

  const errorLink = new ErrorLink(({ error }) => {
    if (CombinedGraphQLErrors.is(error)) {
      console.log('COMBINED ERRORS', error.errors)
      for (const graphQLError of error.errors) {
        handleGraphQLError(graphQLError)
      }
      return
    }

    handleNetworkError(error)
  })

  // Link pour retirer les _typename
  const cleanTypenameLink = new ApolloLink((operation, forward) => {
    if (operation.variables) {
      operation.variables = omitTypename(operation)
    }
    return forward(operation)
  })

  // Handle authentification
  const authLink = new SetContextLink(({ headers }, _) => {
    return {
      headers: {
        ...headers,
        authorization: token ? `Bearer ${token.value}` : "",
      }
    }
  });

  const link = ApolloLink.from([
    // Link pour ajouter l'authentification
    authLink,
    // Link pour gérer les erreurs
    errorLink,
    // ApolloLink.split(
    //   ({ query }) => {
    //     const definition = getMainDefinition(query)
    //     return (
    //       definition.kind === 'OperationDefinition' && definition.operation === 'subscription'
    //     )
    //   },
    //   // Terminal Link pour sourcription
    //   actionCableLink,
    // ApolloLink.from([
    // Link pour retirer les _typename
    cleanTypenameLink,
    ApolloLink.split(
      (operation) => !!operation.getContext().authSchema,
      // Terminal Link pour authentification
      new HttpLink({ uri: authUrl }),
      ApolloLink.split(
        (operation) => !!operation.getContext().hasUpload,
      // Terminal Link pour mutation avec File
      new UploadHttpLink({ uri: apiUrl }),
      // Terminal Link les autres cas
        new HttpLink({ uri: apiUrl }),
      )
    ),
    // ])
    // )
  ])

  const apolloClient = new ApolloClient({
    // connectToDevTools: true,
    devtools: {
      enabled: true
    },
    defaultOptions: {
      watchQuery: {
        fetchPolicy: "cache-first",
      },
      query: {
        fetchPolicy: "cache-first",
      },
    },
    link: link,
    cache: new InMemoryCache(),
    
  })

  provideApolloClient(apolloClient)
  nuxtApp.provide("apollo", { DefaultApolloClient, apolloClient })

})