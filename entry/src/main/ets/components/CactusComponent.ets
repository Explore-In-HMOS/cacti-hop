import { Obstacle, ObstacleType } from '../models/GameModels'

export class CactusComponent {
  drawCactus(
    c: CanvasRenderingContext2D,
    obs: Obstacle
  ): void {
    c.fillStyle = '#2d5a27'
    const x = obs.x
    const y = obs.y
    switch (obs.type) {
      case ObstacleType.SMALL_CACTUS:
        this.drawSmallCactus(c, x, y)
        break
      case ObstacleType.LARGE_CACTUS:
        this.drawLargeCactus(c, x, y)
        break
    }
  }

  private drawSmallCactus(c: CanvasRenderingContext2D, x: number, y: number): void {
    c.fillRect(x + 5, y, 5, 24)
    c.fillRect(x, y + 7, 6, 4)
    c.fillRect(x, y + 3, 4, 6)
    c.fillRect(x + 9, y + 10, 5, 4)
    c.fillRect(x + 11, y + 6, 3, 6)
  }

  private drawLargeCactus(c: CanvasRenderingContext2D, x: number, y: number): void {
    c.fillRect(x + 5, y, 6, 32)
    c.fillRect(x, y + 9, 7, 5)
    c.fillRect(x, y + 4, 5, 7)
    c.fillRect(x + 10, y + 13, 6, 5)
    c.fillRect(x + 12, y + 7, 4, 8)
    c.fillStyle = '#1a3d14'
    c.fillRect(x + 6, y, 3, 4)
    c.fillStyle = '#2d5a27'
  }
}
