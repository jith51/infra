import USER_LOGOUT_QUERY from '~/graphql/auth/userLogout.mutation.gql'
import USER_CAS_LOGIN_QUERY from '~/graphql/auth/userCasLogin.mutation.gql'
import CHECK_AUTH_QUERY from '~/graphql/auth/checkAuth.query.gql'

import type { CheckAuthResponse, LogInResponse, IUser, User } from '@/types/auth'

import { useMutation, useLazyQuery } from '@vue/apollo-composable'

export const useUserAuth = () => {

  	const { saveLogoutState, saveLoginState } = useAuthStore()

	// CHECK AUTHENTIFICATION
	const { load: loadCheckAuth } = useLazyQuery<CheckAuthResponse>(
		CHECK_AUTH_QUERY,
		{
			fetchPolicy: 'no-cache'
		}
	)

	const checkAuth = async () => {
		const result = await loadCheckAuth()
		if (!result?.checkAuth) {
			saveLogoutState()
		}

		const { user, token } = (result as CheckAuthResponse).checkAuth
		const { __typename, ...userWithoutTypeName } = user

		// Le serveur nous renvoie un nouveau JWT
		saveLoginState(userWithoutTypeName, token)
		console.log('CHECK AUTH - NOUVEAU TOKEN:', token)

		return userWithoutTypeName
	}


	// LOGIN SUR LE SERVEUR API
	// Le token reçu du CAS est envoyé à l'API.
	// L'API le valide et crée la session applicative.
	const {
		mutate: userLogIn,
		onDone: onLogInDone,
	} = useMutation<LogInResponse>(
		USER_CAS_LOGIN_QUERY,
		{
			context: { authSchema: true },
			fetchPolicy: 'no-cache'
		}
	)

	onLogInDone(({ data }) => {
		if (data?.userCasLogin) {
		saveLoginState(
			data?.userCasLogin?.user,
			data?.userCasLogin?.token,
		)
		}
	})

	// LOGOUT
	const {
		mutate: userLogOut,
		onDone: onLogOutDone
	} = useMutation(
		USER_LOGOUT_QUERY,
		{
			context: { authSchema: true },
			variables: { fake: '' },
			fetchPolicy: 'no-cache'
		}
	)

	onLogOutDone(() => {
		saveLogoutState()
		return navigateTo('/')
	})


	return {
		userLogIn,
		userLogOut,
		checkAuth
	}
}
