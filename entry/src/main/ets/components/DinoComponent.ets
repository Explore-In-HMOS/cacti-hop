import { GameState } from '../models/GameModels'
import { GameEngine } from '../services/GameEngine'

export class DinoComponent {
  drawDino(
    c: CanvasRenderingContext2D,
    dx: number,
    dy: number,
    e: GameEngine
  ): void {

    c.fillStyle = '#333333'
    c.fillRect(dx + 4, dy + 2, 12, 12)
    c.fillRect(dx + 10, dy, 9, 8)
    c.fillStyle = '#ffffff'
    c.fillRect(dx + 16, dy + 2, 2, 2)
    c.fillStyle = '#333333'
    c.fillRect(dx, dy + 5, 4, 3)
    c.fillRect(dx, dy + 8, 3, 3)

    if (e.gameState === GameState.GAME_OVER) {
      this.drawDeadDino(c, dx, dy)
    } else {
      this.drawRunningDino(c, e.dinoFrame, dx, dy)
    }
  }

  private drawRunningDino(c: CanvasRenderingContext2D, frame: number, dx: number, dy: number): void {
    if (frame === 0) {
      c.fillRect(dx + 4, dy + 15, 4, 8)
      c.fillRect(dx + 11, dy + 15, 4, 5)
    } else {
      c.fillRect(dx + 4, dy + 15, 4, 5)
      c.fillRect(dx + 11, dy + 15, 4, 8)
    }
  }

  private drawDeadDino(c: CanvasRenderingContext2D, dx: number, dy: number): void {
    c.strokeStyle = '#ffffff'
    c.lineWidth = 1.5
    c.beginPath()
    c.moveTo(dx + 11, dy + 1);
    c.lineTo(dx + 17, dy + 6)
    c.moveTo(dx + 17, dy + 1);
    c.lineTo(dx + 11, dy + 6)
    c.stroke()
    c.fillRect(dx + 4, dy + 15, 4, 9)
    c.fillRect(dx + 11, dy + 15, 4, 9)
  }
}
