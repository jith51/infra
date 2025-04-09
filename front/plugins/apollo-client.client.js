import { ApolloClient, HttpLink, ApolloLink, InMemoryCache, from, split } from "@apollo/client/core"
import { setContext } from '@apollo/client/link/context'

import { getMainDefinition } from '@apollo/client/utilities'
import { DefaultApolloClient, provideApolloClient } from '@vue/apollo-composable'
import { createUploadLink } from 'apollo-upload-client'
import { onError } from '@apollo/client/link/error'

import ActionCableLink from 'graphql-ruby-client/subscriptions/ActionCableLink'
import ActionCable from 'actioncable'

export default defineNuxtPlugin(nuxtApp => {
  
  const cable = ActionCable.createConsumer('ws://localhost:4000/cable');
  const actionCableLink = new ActionCableLink({ cable });

  const authStore = useAuthStore()

  // Link pour retirer les _typename
  const cleanTypenameLink = new ApolloLink((operation, forward) => {
    if (operation.variables) {
      operation.variables = omitTypename(operation)
    }    
    return forward(operation)
  })

  // Handle errors
  const errorLink = onError(error => {
    console.log(error)
  })

  // Handle authentification
  const authLink = setContext((_, { headers }) => {
    // const { userToken } = useUserToken()
    // let token = localStorage.getItem('authToken')
    let token = authStore.value.token

    return {
      headers: {
        ...headers,
        authorization: token ? `Bearer ${token}` : "",
      }
    }
  });

  const link = from([
      // Link pour ajouter l'authentification
    authLink,
      // Link pour gérer les erreurs
    errorLink,
    split(
      ({ query }) => {
        const definition = getMainDefinition(query)
        return (
          definition.kind === 'OperationDefinition' && definition.operation === 'subscription'
        )
      },
      // Terminal Link pour sourcription
      actionCableLink,
      from([
      // Link pour retirer les _typename
        cleanTypenameLink,
        split(
          (operation) => operation.getContext().RequestForAuth,
      // Terminal Link pour authentification
          new HttpLink({ uri: 'http://localhost:4000/auth' }),
          split(
            (operation) => operation.getContext().hasUpload,
      // Terminal Link pour mutation avec File
            createUploadLink({ credentials: 'same-origin', uri: 'http://localhost:4000/graphql' }),
      // Terminal Link les autres cas
            new HttpLink({ uri: 'http://localhost:4000/graphql' }),
          )
        ),
      ])
    )
  ])

  const apolloClient = new ApolloClient({
    link: link,
    cache: new InMemoryCache(),
  })

  provideApolloClient(apolloClient)
  nuxtApp.provide("apollo", { DefaultApolloClient, apolloClient })

})