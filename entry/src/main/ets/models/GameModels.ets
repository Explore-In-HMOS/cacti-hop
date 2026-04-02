export interface Position {
  x: number
  y: number
}

export interface Size {
  width: number
  height: number
}

export interface Obstacle {
  x: number;
  y: number;
  w: number;
  h: number;
  type: ObstacleType;
}

export enum ObstacleType {
  SMALL_CACTUS = 'SMALL_CACTUS',
  LARGE_CACTUS = 'LARGE_CACTUS'
}

export enum GameState {
  IDLE = 'IDLE',
  PLAYING = 'PLAYING',
  GAME_OVER = 'GAME_OVER'
}

export interface Cloud {
  id: number
  x: number
  y: number
  speed: number
}
