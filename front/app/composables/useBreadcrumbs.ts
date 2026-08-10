type NamedPath = {
    name: string | undefined
    path: string | undefined
}

const isMathPatternPath = (pathA: string, pathB: string) => {
    const partsA = pathA.split('/');
    const partsB = pathB.split('/');

    if (partsA.length !== partsB.length) return false;

    const isMatch = partsA.every((part: string, i: number) => {
        return part === partsB[i] || part.startsWith(':');
    })
    
    return isMatch;
}

export const useBreadcrumbs = (): Ref<NamedPath[]> => {
    const router = useRouter()
    const route = useRoute()
    const routes = router.getRoutes()

    const HOMEPAGE = { name: 'Infra Explorer', path: '/' }
    
    const breadcrumbs = ref<NamedPath[]>([ HOMEPAGE ])

    function getBreadcrumbs(currRoute: string): NamedPath[] {
        // 1. When we reach the root, return the array with Home route
        if (currRoute === '') return [ HOMEPAGE ]

        // 2. Continue building the breadcrumb for the parent's path
        const paths = getBreadcrumbs(currRoute.slice(0, currRoute.lastIndexOf('/')))
        
        // 3. Get the matching route object
        const founds = routes.filter(r => isMathPatternPath(r.path, currRoute))

        // 3.1 Return Paths if route not exist
        if (founds.length == 0) return paths

        const matchRoute = founds.find(r => r.path === currRoute)
        
        const newPathName = matchRoute == undefined 
            // Case of route like :(id) : get the id
            ? useLast(currRoute.split('/'))
            : useStartCase(useLast(((matchRoute?.meta?.breadcrumb || matchRoute?.name || matchRoute?.path) as string).split('-')))

        return [ ...paths, { path: currRoute, name: newPathName } ]
    }

    watch(() => ({
        path: route.path,
        name: route.name,
        meta: route.meta,
        matched: route.matched,
    }), (route) => {
        if (route.path === '/') return;

        breadcrumbs.value = getBreadcrumbs(route.path);
    }, {
        immediate: true,
    })

    return breadcrumbs
}