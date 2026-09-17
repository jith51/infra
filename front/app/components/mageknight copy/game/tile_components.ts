
export const TILE_DEFINITIONS = {
    'Portal A': {
        level: 1,
        terrains: ['plains:portal', 'cost', 'cost', 'plains', 'forest', 'plains', 'cost'],
    },
    'Portal B': { 
        level: 1, 
        terrains: ['plains:portal', 'cost', 'cost', 'plains', 'forest', 'plains', 'plains']
    },
    'Green 1': {
        level: 1, 
        terrains: ['forest:magical_glade', 'plains', 'forest', 'forest:marauding_orcs', 'wasteland', 'plains:village', 'plains']
    },
    'Green 2': {
        level: 1, 
        terrains: ['hills', 'hills:green_crystal_mines', 'plains', 'hills:marauding_orcs', 'forest:magical_glade', 'plains:village', 'plains']
    },
    'Green 3': {
        level: 1, 
        terrains: ['forest', 'plains:village', 'plains', 'plains', 'hills:keep', 'hills', 'hills:blank_crystal_mines']
    },
    'Green 4': {
        level: 1, 
        terrains: ['desert:magic_tower', 'plains', 'hills:marauding_orcs', 'desert', 'desert', 'mountain', 'plains:village']
    },
}
// const TILE_COMPONENTS = TILE_DEFINITIONS.objectMap [
//     createTile({id: 'Portal A', position, rotation, terrains: [
//         'plains', 'cost', 'cost', 'plains', 'forest', 'plains', 'cost'
//     ]})
// ] 