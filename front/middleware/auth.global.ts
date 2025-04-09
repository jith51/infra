export default defineNuxtRouteMiddleware(async (to) => {
    const CAS_URL = 'https://cas.chu-reims.fr/login?service='
    const urlOrigine = useRequestURL().origin

    const urlAvecTicket = to.fullPath.match(/ST.+/)
    
    // Do not run on server
    if (process.server || (to.path == '/' && urlAvecTicket == null)) {
        return
    }

    if (to.path == '/' && urlAvecTicket == null) {
        return
    }

    const { checkAuth, userLogIn} = useUserAuth()

    // ON CHECK SI USER LOGGE
    let isLogged =  false
    await checkAuth().then((value: any) => {
        isLogged = (value != null)
    }).catch(() => {}) // Mieux gerer l'erreur

    // SI LOGGE ON POURSUIT
    if (isLogged) {
        return
    }

    // SINON : On regarde si on vient de se logger sur le CAS
    if ( (urlAvecTicket?.length ?? 0) > 0 && urlAvecTicket !== null) {
        // Si c'est le cas, on se loggue sur l'api et on récupére le tocken de l'appli
        let IsRegistred = false
        await userLogIn({ticket: urlAvecTicket[0], service: useRequestURL().origin + to.path }).then((value) => {
            IsRegistred =  (value != null)
        }).catch((error: any) => {console.log(error)})  // Mieux gerer l'erreur
        return await navigateTo(IsRegistred ? to.path : "/", {replace: true })
    } else {
        // Si ce n'est pas le cas, on appelle le CAS pour authentification
        return  await navigateTo(CAS_URL + urlOrigine + to.path, { external: true })
    }
});