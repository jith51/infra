export const useAuthStore = () => {

    const authStore = useState('authStore',  () => { 
        const item = localStorage.getItem('authStore')
        return item ? JSON.parse(item) : {
                user: "",
                token: ""
            }
    })

    watch(authStore, (object) => {
        localStorage.setItem('authStore', JSON.stringify(object))
      }, { deep: true })

    return authStore
}