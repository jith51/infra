import USER_LOGOUT_QUERY from '~/graphql/auth/userLogout.mutation.gql'
import USER_CAS_LOGIN_QUERY from '~/graphql/auth/userCasLogin.mutation.gql'
import USER_QUERY from '~/graphql/auth/user.query.gql'

import { useMutation, useLazyQuery } from '@vue/apollo-composable'

export const useUserAuth = () => {

  const authStore = useAuthStore()

  const saveLogInState = (token: string, user: string) => {
    authStore.value.user = user
    authStore.value.token = token
  }

  const saveLogOutState = () => {
    authStore.value.user = ""
    authStore.value.token = ""

  }

  // USER CHECK AUTHENTIFICATION
  const { load: checkAuth } = useLazyQuery(USER_QUERY, {}, {
      fetchPolicy: "no-cache"
    }
  )
    
  // LOG IN SUR LE SERVEUR API
  // on envoi le token reçu par le CAS et on le fait valider par l'API qui nous retounr le user si OK
  const { mutate: userLogIn, onDone: onLogInDone, onError: onLogInError  }  = useMutation(USER_CAS_LOGIN_QUERY, {
    context: { RequestForAuth: true },
    fetchPolicy: 'no-cache'
  })

  onLogInError(() => {
    // A revoir le message d'erreur
    saveLogOutState()
  })

  onLogInDone(({ data }) => {
    saveLogInState(data.userCasLogin?.token, data.userCasLogin?.user)
  })

  // LOGOUT
  const { mutate: userLogOut, onDone: onLogOutDone  }  = useMutation(USER_LOGOUT_QUERY, {
    context: { RequestForAuth: true },
    variables: { fake: ''},
    fetchPolicy: 'no-cache'
  })

  onLogOutDone( () => {
    saveLogOutState()
    return navigateTo('/')
  })

  return { userLogIn, userLogOut, checkAuth }

}