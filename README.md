> **Note:** To access all shared projects, get information about environment setup, and view other guides, please visit [Explore-In-HMOS Index](https://github.com/Explore-In-HMOS/hmos-index).

# Cacti Hop
Jump, hop, and dodge your way across the desert in CactiHop! Leap over prickly cacti, avoid tricky obstacles, and see how far you can go. Simple to play, but hard to master—perfect for quick fun or a high-score challenge.
# Preview

<div>
  <img src="./screenshots/output.gif" width="25%">
</div>

# Use Cases
* Start Game: Jump into the action instantly and start hopping across cacti with a single tap.
* Real-Time Gameplay: Track your current score and see your speed increase as you hop further.
* End Game: The game ends if you hit a cactus. Check your final high score and try to beat it in the next run.

# Technology

## Stack
**Languages**: ArkTS

**Frameworks**: HarmonyOS SDK 5.1.0(18)

**Tools**: DevEco Studio Vers 5.1.0.842

**Libraries**: 
* '@kit.CryptoArchitectureKit': For creating random numbers.
* ArkUI - Canvas: For game screen and components

# Directory Structure
```
|---components
|   |---CactusComponent.ets       # Handles rendering and behavior of cacti obstacles
|   |---DinoComponent.ets         # Handles the player character and its animations

|---models
|   |---GameModels.ets            # Defines game state, score, speed, and player data

|---pages
|   |---Index.ets                 # Entry point for routing and initialization
|   |---SplashPage.ets            # Intro/loading screen
|   |---CactusRunPage.ets         # Main gameplay page where hopping action occurs

|---services
|   |---GameEngine.ets            # Core game logic: obstacle generation, collision detection, speed control
|   |---NavigationService.ets     # Manages screen navigation

|---utils
|   |---GameConstants.ets         # Constants like speed increments, cactus spacing, and scoring rules
|   |---GlobalContext.ets         # Shared context or global state for the game
```
# Constraints and Restrictions

## Supported Device
- Huawei Watch 5

# License

CactiHop is distributed under the terms of the MIT License.

See the [LICENSE](/LICENSE) for more information.