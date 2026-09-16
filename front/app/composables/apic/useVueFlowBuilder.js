export const useVueFlowBuilder = (tenant, contrats, applicationProfileName) => {

    let nodes = []
    let edges = []

    let counter = 1
    
    let applicationProfile = tenant.applicationProfiles.find(ap => ap.name === applicationProfileName)

    const getUsedContrats = (epg, usedContratType) => {
        return epg["usedContrats"].filter(uc => uc['type'] == usedContratType).map(uc => uc["contrat"])
    }
    
    const getContractables = (contratId, usedContratType) => {
        return (contrats.find(c => c.id == contratId)["usedContrats"] ?? []).filter(c => c["type"] == usedContratType).map(c => c["contractable"])
    }

    if (applicationProfile !== undefined) {
    
        // Création du node Application Profile
        nodes.push({
            id: counter.toString(),
            label: applicationProfile.name,
            objectType: 'rootApp'
        })
        counter++
    
        debugger
        // Création des nodes Epg de l'Application Profile et de ses contrats
        applicationProfile.epgs.forEach( (epg) => {
            let epgNodeId = counter++
            nodes.push({
            id: epgNodeId.toString(),
            label: epg.name,
            objectType: 'epg',
            parentNode: '1'
            })
            getUsedContrats(epg, 'Apic::ProvidedContrat').forEach( (contrat) => {
                let contratId = counter++
                let contratLabel = ( contrat.name.substr(0,3) === '_AP' ? contrat.name : contrat.name.split(':').slice(-1)[0] )
                // Création des contrats 
                nodes.push({
                    id: contratId.toString(),
                    label: contratLabel,
                    objectType: 'contrat',
                    parentNode: epgNodeId.toString(),
                })
            })
        })
    
        applicationProfile.epgs.forEach( (epg) => {
            // On recher l'ID du node correspondant à l'EPG
            let epgNodeId = nodes.find(n => n.objectType == 'epg' && n.label == epg.name && n.parentNode == '1').id.toString()
            //
            // ON TRAITE LES PROVIDED CONTRATS (sauf les _AP:Any et le LEGACY)
            //
            getUsedContrats(epg, 'Apic::ProvidedContrat').filter(c => c.name != '_AP:Any' && c.name != 'LEGACY').forEach( (contrat) => {

                // let contratLabel = ( contrat.name.substr(0,3) === '_AP' ? contrat.name : contrat.name.split(':').slice(-1)[0] )
                let contratLabel = contrat.name.split(':').slice(-1)[0]
                // On recher l'ID du node correspondant au contrat
                let contratId = nodes.find(n => n.objectType == 'contrat' && n.label == contratLabel && n.parentNode == epgNodeId).id.toString()
                
                // On va recherché les consummers
                getContractables(contrat.id, 'Apic::ConsumedContrat').forEach( (contractable) => {
                    let targetId
                    // On recherche dans les nodes si ce contractable a déja été créé
                    let searchedContractable = contractable["__typename"] == 'L3Out' ?
                    nodes.find(c => c.objectType == 'consummerL3Out') :
                    nodes.find(c => c.objectType == 'epg'
                        && c.label == contractable.name
                        && useSome(nodes, { id: c.parentNode, label: contractable.applicationProfile.name }) )

                    if (searchedContractable != undefined) {
                        targetId = searchedContractable.id
                    } else {
                        // Si on ne le trouve pas, on le créé
                        targetId = counter++
                        if ( contractable["__typename"] == 'L3Out' ) {
                            // Si L3Out
                            nodes.push({
                            id: targetId.toString(),
                            label: contractable.name,
                            objectType: 'consummerL3Out',
                            })
                        } else {
                            // Si Epg
                            let targetAppId
                            // On regarde si le Node de l'application de l'epg existe
                            let searchedApp = nodes.find(c => ['rootApp', 'consumerApp'].includes(c.objectType) && c.label == contractable.applicationProfile.name)
                            
                            if (searchedApp != undefined) {
                                targetAppId = searchedApp.id
                            } else {
                            // Si on ne le trouve pas on le créé
                            targetAppId = counter++
                            
                            nodes.push({
                                id: targetAppId.toString(),
                                label: contractable.applicationProfile.name,
                                objectType: 'consumerApp'
                            })
                            }
                            // On créé le node de l'epg
                            nodes.push({
                                id: targetId.toString(),
                                label: contractable.name,
                                objectType: 'epg',
                                parentNode: targetAppId.toString()
                            })
                        }
                    }
                    // Finalement on créé le edge
                    edges.push({id: (counter++).toString(), source: contratId.toString(), target: targetId.toString() })
                })
            })
            //
            // ON TRAITE LES CONSUMMED CONTRATS
            //
            getUsedContrats(epg, 'Apic::ConsumedContrat').filter(c => c.name !== '_AP:Any').forEach( (contrat) => {            
            // On va recherché les providers
                if (contrat.name == 'LEGACY') {

                    let legacy = nodes.find(n => n.objectType == 'legacy')
                    let legacyId
                    if (legacy == undefined) {
                        legacyId = counter++
                        nodes.push({
                            id: legacyId.toString(),
                            label: 'LEGACY',
                            objectType: 'legacy',
                        })
                    } else {
                        legacyId = legacy.id
                    }
                    
                    edges.push({id: (counter++).toString(), source: legacyId.toString(), target: epgNodeId.toString() })

                } else {
                    getContractables(contrat.id, 'Apic::ProvidedContrat').forEach( (contractable) => {
                        let providerId
                        // On recherche dans les nodes si ce contractable a déja été créé
                        let searchedContractable = nodes.find(c => c.objectType == 'epg'
                            && c.label == contractable.name
                            && ( useSome(nodes, { id: c.parentNode, label: contractable.applicationProfile.name, objectType: 'rootApp' }) ||
                                useSome(nodes, { id: c.parentNode, label: contractable.applicationProfile.name, objectType: 'providerApp' }) ))
                    
                        if (searchedContractable != undefined) {
                            providerId = searchedContractable.id
                        } else {
                            // Si on ne le trouve pas, on le créé
                            providerId = counter++
                            if ( contractable["__typename"] == 'L3Out' ) {
                                // Si L3Out
                                nodes.push({
                                    id: providerId.toString(),
                                    label: contractable.name,
                                    objectType: 'L3Out',
                                })
                            } else {
                                // Si Epg
                                let targetAppId
                                // On regarde si le Node de l'application de l'epg existe
                                let searchedApp = nodes.find(c => ['rootApp', 'providerApp'].includes(c.objectType) && c.label == contractable.applicationProfile.name)
                                    
                                if (searchedApp != undefined) {
                                    targetAppId = searchedApp.id
                                } else {
                                    // Si on ne le trouve pas on le créé
                                    targetAppId = counter++
                                    
                                    nodes.push({
                                    id: targetAppId.toString(),
                                    label: contractable.applicationProfile.name,
                                    objectType: 'providerApp'
                                    })
                                }
                                // On créé le node de l'epg
                                nodes.push({
                                    id: providerId.toString(),
                                    label: contractable.name,
                                    objectType: 'epg',
                                    parentNode: targetAppId.toString()
                                })
                            }
                        }
                        // On crée le contrat et le edge si ils n'ont pas été créé avec les consumers
                        
                        let contratLabel = contrat.name.split(':').slice(-1)[0]

                        if (!useSome(nodes, { objectType: 'contrat', label: contratLabel, parentNode: providerId.toString() })) {
                            let contratId = counter++
                            
                            nodes.push({
                                id: contratId.toString(),
                                label: contratLabel,
                                objectType: 'contrat',
                                parentNode: providerId.toString()
                            })

                            edges.push({id: (counter++).toString(), source: contratId.toString(), target: epgNodeId.toString() })
                        }
                    })
                }
            })
        })
    
        // Mise en forme
        const formeEpg = (appId) => {
            let epgPosition = 10
            nodes.filter(c => c.parentNode == appId).forEach( (epg) => {
            let contrats = nodes.filter(c => c.parentNode == epg.id)
            useExtend(epg, {height: (contrats.length == 0 ? '40px' : '90px'), width: (contrats.length == 0 ? 120 : (contrats.length * 110 + 10)) +'px', position: { x: epgPosition, y: 40 }})
            epgPosition += (contrats.length == 0 ? 120 : (contrats.length * 110 + 10)) + 10
            contrats.forEach( (contrat, idx) => {
                useExtend(contrat, { height: '40px', width: '100px', position: { x:(10  + idx * 110), y: 40 }})
            })
            })
            return epgPosition
        }
        useExtend(nodes[0], { width: formeEpg('1') + 'px', height: '140px', position: { x: 0, y: 250 } })

        let appPosition = 0
        nodes.filter(c => c.objectType == 'consumerApp').forEach( (app) => {
            let appSize = formeEpg(app.id)
            useExtend(app, { width: appSize + 'px', height: '90px', position: { x: appPosition, y: 500 }})
            appPosition += appSize + 10
        })

        nodes.filter(c => c.objectType == 'consummerL3Out').forEach( (l3) => {
            useExtend(l3, {height: '40px', position: {x: appPosition, y: 500} })
        })

        appPosition = 0
        nodes.filter(c => c.objectType == 'providerApp').forEach( (app) => {
            let appSize = formeEpg(app.id)
            useExtend(app, { width: appSize + 'px', height: '140px', position: { x: appPosition, y: 0 }})
            appPosition += appSize + 10
        })
        
        nodes.filter(c => c.objectType == 'legacy').forEach( (l3) => {
            useExtend(l3, {height: '40px', position: {x: appPosition, y: 0} })
        })
    }
  
    return { nodes: nodes, edges: edges }
}