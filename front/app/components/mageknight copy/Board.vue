<template>
  <div>
    <h1>Jeu de Plateau - Tuiles Hexagonales</h1>
    <svg width="800" height="600" style="background: #333; border: 1px solid #000;">
      <Tile
        v-for="(tile, index) in tiles"
        :key="index"
        :x="tile.x"
        :y="tile.y"
        :size="30"
        :playerHexagon="playerHexagon"
        @hexagon-click="handleHexagonClick"
      />
    </svg>
    <p>Position du joueur : Tuile ({{ currentTile.x }}, {{ currentTile.y }}), Hexagone {{ playerHexagon }}</p>
    <button @click="addRandomTile">Ajouter une tuile aléatoire</button>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import Tile from './Tile.vue';

const tiles = ref([{ x: 400, y: 300 }]); // Tuile initiale
const currentTile = ref({ x: 400, y: 300 }); // Tuile actuelle du joueur
const playerHexagon = ref(0); // Hexagone actuel du joueur

const handleHexagonClick = (index) => {
  playerHexagon.value = index;
  console.log(`Hexagone ${index} sélectionné sur la tuile (${currentTile.value.x}, ${currentTile.value.y}).`);
};

const addRandomTile = () => {
  const newX = 200 + Math.random() * 400; // Position X aléatoire entre 200 et 600
  const newY = 200 + Math.random() * 200; // Position Y aléatoire entre 200 et 400
  tiles.value.push({ x: newX, y: newY });
};
</script>