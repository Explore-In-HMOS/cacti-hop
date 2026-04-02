import { GameEngine } from '../services/GameEngine';
import { GameState, Obstacle } from '../models/GameModels';
import {
  DINO_X,
  FRAME_INTERVAL,
  GAME_HEIGHT,
  GAME_WIDTH,
  GROUND_HEIGHT,
  GROUND_Y,
  INITIAL_SPEED,
  MAX_OBSTACLE_GAP,
  MIN_OBSTACLE_GAP
} from '../utils/GameConstants';
import { CactusComponent } from '../components/CactusComponent';
import { DinoComponent } from '../components/DinoComponent';

@Component
export struct CactusRunPage {
  private engine: GameEngine = new GameEngine()
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private ctx: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private timer: number = -1
  private obstacles: Array<Obstacle> = []
  private nextSpawn: number = 150
  private obstacleSpeed: number = INITIAL_SPEED
  private dinoRenderer: DinoComponent = new DinoComponent()
  private cactusRenderer: CactusComponent = new CactusComponent()

  resetCactuses(): void {
    this.obstacles = []
    this.nextSpawn = 150
    this.obstacleSpeed = INITIAL_SPEED
  }

  updateCactuses(): void {
    for (let i = 0; i < this.obstacles.length; i++) {
      this.obstacles[i].x -= this.obstacleSpeed
    }
    this.obstacles = this.obstacles.filter(c => c.x > -40)
    this.obstacleSpeed = this.engine.speed

    this.nextSpawn -= this.obstacleSpeed
    if (this.nextSpawn <= 0) {
      this.obstacles = this.engine.spawnObstacle(this.obstacles)
      this.nextSpawn = MIN_OBSTACLE_GAP + this.engine.doRandBySync() * (MAX_OBSTACLE_GAP - MIN_OBSTACLE_GAP)
    }
  }

  checkHit(): boolean {
    const dx = DINO_X
    const dy = this.engine.dinoY
    const dw = 22
    const dh = 26
    for (const c of this.obstacles) {
      if (dx + dw - 2 > c.x + 1 &&
        dx + 2 < c.x + c.w - 1 &&
        dy + dh - 2 > c.y + 1 &&
        dy + 2 < c.y + c.h - 1) {
        return true
      }
    }
    return false
  }

  startLoop(): void {
    if (this.timer !== -1) {
      clearInterval(this.timer)
    }
    this.resetCactuses()
    this.timer = setInterval(() => {
      this.engine.update()
      this.updateCactuses()
      if (this.checkHit()) {
        this.engine.gameOver()
        this.stopLoop()
      }
      this.renderScene()
    }, FRAME_INTERVAL)
  }

  stopLoop(): void {
    if (this.timer !== -1) {
      clearInterval(this.timer);
      this.timer = -1
    }
    this.renderScene()
  }

  onTap(): void {
    if (this.engine.gameState !== GameState.PLAYING) {
      this.engine.jump()
      this.startLoop()
    } else {
      this.engine.jump()
    }
  }

  aboutToDisappear(): void {
    this.stopLoop()
  }

  renderScene(): void {
    const c = this.ctx
    const e = this.engine
    const W = GAME_WIDTH
    const H = GAME_HEIGHT

    c.fillStyle = '#f5f5f5'
    c.fillRect(0, 0, W, H)

    // Clouds
    c.fillStyle = '#cccccc'
    for (const cl of e.clouds) {
      c.fillRect(cl.x, cl.y + 3, 26, 6)
      c.fillRect(cl.x + 4, cl.y, 16, 9)
      c.fillRect(cl.x + 14, cl.y + 2, 10, 6)
    }

    // Grand
    c.fillStyle = '#555555'
    c.fillRect(0, GROUND_Y, W, GROUND_HEIGHT)
    c.fillStyle = '#888888'
    for (const d of [0, 30, 65, 105, 145, 185]) {
      c.fillRect(((d - e.groundOffset % W) + W) % W, GROUND_Y + 3, 4, 2)
    }

    // Cactus
    for (const obs of this.obstacles) {
      this.cactusRenderer.drawCactus(c, obs)
    }

    // Dinosaur
    const dy = e.dinoY
    const dx = DINO_X
    this.dinoRenderer.drawDino(c, dx, dy, e)

    // Score
    c.textAlign = 'center'
    c.fillStyle = '#222222'
    c.font = 'bold 20px monospace'
    c.fillText(String(e.score).padStart(4, '0'), W / 2, 18)
    if (e.highScore > 0) {
      c.fillStyle = '#999999'
      c.font = '16px monospace'
      c.fillText(`HIGH ${String(e.highScore).padStart(4, '0')}`, W / 2, 32)
    }

    if (e.gameState === GameState.IDLE) {
      c.fillStyle = 'rgba(245,245,245,0.88)'
      c.fillRect(30, 70, W - 60, 60)
      c.fillStyle = '#333333'
      c.font = 'bold 22px sans-serif'
      c.textAlign = 'center'
      c.fillText('Tap to Start', W / 2, 95)
      c.fillStyle = '#888888'
      c.font = '9px sans-serif'
    } else if (e.gameState === GameState.GAME_OVER) {
      c.fillStyle = 'rgba(245,245,245,0.90)'
      c.fillRect(20, 60, W - 40, 95)
      c.fillStyle = '#cc3333'
      c.font = 'bold 22px sans-serif'
      c.textAlign = 'center'
      c.fillText('GAME OVER', W / 2, 90)
      c.fillStyle = '#333333'
      c.font = 'bold 24px monospace'
      c.fillText(String(e.score).padStart(4, '0'), W / 2, 118)
      c.fillStyle = '#aaaaaa'
      c.font = '16px sans-serif'
      c.fillText('Try Again!', W / 2, 140)
    }
  }

  build() {
    Canvas(this.ctx)
      .width(GAME_WIDTH)
      .height(GAME_HEIGHT)
      .onReady(() => {
        this.renderScene()
      })
      .onClick(() => {
        this.onTap()
      })
  }
}
