export const useAuthStore = () => useState('authStore', 
    () => (
        {
            user: "",
            token: ""
        }
    )
)