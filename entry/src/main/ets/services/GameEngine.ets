import { Cloud, GameState, Obstacle, ObstacleType } from '../models/GameModels'
import {
  CLOUD_COUNT,
  CLOUD_SPEED_MAX,
  CLOUD_SPEED_MIN,
  DINO_GROUND_Y,
  DINO_HEIGHT,
  DINO_WIDTH,
  DINO_X,
  GAME_WIDTH,
  GRAVITY,
  GROUND_Y,
  INITIAL_SPEED,
  JUMP_VELOCITY,
  LARGE_CACTUS_H,
  LARGE_CACTUS_W,
  MAX_OBSTACLE_GAP,
  MAX_SPEED,
  MIN_OBSTACLE_GAP,
  OBSTACLE_SPAWN_X,
  SCORE_MILESTONE,
  SMALL_CACTUS_H,
  SMALL_CACTUS_W,
  SPEED_INCREMENT,
  SPEED_MILESTONE_BOOST
} from '../utils/GameConstants'
import { cryptoFramework } from '@kit.CryptoArchitectureKit'

export class GameEngine {
  dinoY: number = DINO_GROUND_Y
  dinoVelocityY: number = 0
  isJumping: boolean = false
  dinoFrame: number = 0
  frameCounter: number = 0
  gameState: GameState = GameState.IDLE
  score: number = 0
  highScore: number = 0
  speed: number = INITIAL_SPEED
  milestoneFlash: boolean = false
  obstacles: Obstacle[] = []
  nextObstacleDistance: number = 400
  obstacleIdCounter: number = 0
  clouds: Cloud[] = []
  cloudIdCounter: number = 0
  groundOffset: number = 0

  constructor() {
    this.initClouds()
  }

  doRandBySync(): number {
    const rand = cryptoFramework.createRandom();
    const len = 6;

    while (true) {
      try {
        const randData = rand.generateRandomSync(len);
        if (randData.data.length !== 0) {
          let value = 0;
          for (let i = 0; i < randData.data.length; i++) {
            value = value * 256 + randData.data[i];
          }
          const maxValue = Math.pow(2, len * 8) - 1;
          const normalized = value / maxValue;
          console.info(`[Sync]: rand result (0-1): ${normalized}`);
          return normalized;
        } else {
          console.warn('[Sync]: empty randData, retrying...');
        }
      } catch (error) {
        const e: BusinessError = error as BusinessError;
        console.error(`do rand failed, ${e.code}, ${e.message}, retrying...`);
      }
    }
  }

  private initClouds(): void {
    for (let i = 0; i < CLOUD_COUNT; i++) {
      this.clouds.push({
        id: this.cloudIdCounter++,
        x: 100 + i * 250,
        y: 40 + this.doRandBySync() * 60,
        speed: CLOUD_SPEED_MIN + this.doRandBySync() * (CLOUD_SPEED_MAX - CLOUD_SPEED_MIN)
      })
    }
  }

  startGame(): void {
    this.dinoY = DINO_GROUND_Y
    this.dinoVelocityY = 0
    this.isJumping = false
    this.dinoFrame = 0
    this.frameCounter = 0
    this.score = 0
    this.speed = INITIAL_SPEED
    this.obstacles = []
    this.nextObstacleDistance = 400
    this.groundOffset = 0
    this.milestoneFlash = false
    this.gameState = GameState.PLAYING
  }

  jump(): void {
    if (this.gameState === GameState.IDLE || this.gameState === GameState.GAME_OVER) {
      this.startGame()
      return
    }
    if (!this.isJumping) {
      this.dinoVelocityY = JUMP_VELOCITY
      this.isJumping = true
    }
  }

  update(): void {
    if (this.gameState !== GameState.PLAYING) {
      return
    }

    this.frameCounter++

    if (this.speed < MAX_SPEED) {
      this.speed += SPEED_INCREMENT
    }

    if (this.frameCounter % 5 === 0) {
      this.score++
      if (this.score % SCORE_MILESTONE === 0) {
        this.milestoneFlash = true
        this.speed = Math.min(this.speed + SPEED_MILESTONE_BOOST, MAX_SPEED)
        setTimeout(() => {
          this.milestoneFlash = false
        }, 600)
      }
    }

    if (this.frameCounter % 6 === 0) {
      this.dinoFrame = (this.dinoFrame + 1) % 2
    }

    if (this.isJumping) {
      this.dinoVelocityY += GRAVITY
      this.dinoY += this.dinoVelocityY
      if (this.dinoY >= DINO_GROUND_Y) {
        this.dinoY = DINO_GROUND_Y
        this.dinoVelocityY = 0
        this.isJumping = false
      }
    }

    this.groundOffset = (this.groundOffset + this.speed) % GAME_WIDTH

    for (const cloud of this.clouds) {
      cloud.x -= cloud.speed
      if (cloud.x < -120) {
        cloud.x = GAME_WIDTH + 50
        cloud.y = 30 + this.doRandBySync() * 70
        cloud.speed = CLOUD_SPEED_MIN + this.doRandBySync() * (CLOUD_SPEED_MAX - CLOUD_SPEED_MIN)
      }
    }

    this.nextObstacleDistance -= this.speed
    if (this.nextObstacleDistance <= 0) {
      this.nextObstacleDistance = MIN_OBSTACLE_GAP +
        this.doRandBySync() * (MAX_OBSTACLE_GAP - MIN_OBSTACLE_GAP)
    }

    for (let i = this.obstacles.length - 1; i >= 0; i--) {
      this.obstacles[i].x -= this.speed
      if (this.obstacles[i].x < -80) {
        this.obstacles.splice(i, 1)
      }
    }

    this.checkCollision()
  }

  spawnObstacle(obstacles: Obstacle[]): Obstacle[] {
    const roll = this.doRandBySync()
    let type: ObstacleType
    let w: number
    let h: number

    if (roll < 0.4) {
      type = ObstacleType.SMALL_CACTUS
      w = SMALL_CACTUS_W
      h = SMALL_CACTUS_H
    } else {
      type = ObstacleType.LARGE_CACTUS
      w = LARGE_CACTUS_W
      h = LARGE_CACTUS_H
    }

    obstacles.push({
      x: OBSTACLE_SPAWN_X,
      y: GROUND_Y - h,
      w: w,
      h: h,
      type: type
    })

    return obstacles
  }

  private checkCollision(): void {
    const dinoPad = 2
    const obsPad = 1
    const dinoCurrentH = DINO_HEIGHT
    const dinoTop = this.dinoY + dinoPad
    const dinoBottom = this.dinoY + dinoCurrentH - dinoPad
    const dinoLeft = DINO_X + dinoPad
    const dinoRight = DINO_X + DINO_WIDTH - dinoPad

    for (const obs of this.obstacles) {
      const obsLeft = obs.x + obsPad
      const obsRight = obs.x + obs.w - obsPad
      const obsTop = obs.y + obsPad
      const obsBottom = obs.y + obs.h - obsPad

      const hit =
        dinoRight > obsLeft &&
          dinoLeft < obsRight &&
          dinoBottom > obsTop &&
          dinoTop < obsBottom

      if (hit) {
        this.gameOver()
        return
      }
    }
  }

  gameOver(): void {
    if (this.score > this.highScore) {
      this.highScore = this.score
    }
    this.gameState = GameState.GAME_OVER
  }

  getDinoHeight(): number {
    return DINO_HEIGHT
  }
}
