export const useAuthStore = () => {

    const authStore = useState('authStore',  () => { 
        const item = localStorage.getItem('authStore')
        return item
            ? JSON.parse(item)
            : {
                user: null,
                token: ""
            }
    })

    watch(
        authStore,
        (object) => {
            localStorage.setItem('authStore', JSON.stringify(object))
        },
        { deep: true }
    )
    
    const user = computed(() => authStore.value.user)
    const token = computed(() => authStore.value.token)

    const saveLogoutState = () => {
        authStore.value.user = null
        authStore.value.token = ''
    }

    const saveLoginState = (userData: any, tokenValue: string) => {
        authStore.value.user = userData
        authStore.value.token = tokenValue
    }
    return { user, token, saveLogoutState, saveLoginState }
}