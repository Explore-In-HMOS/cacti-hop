import { NavigationService } from '../services/NavigationService';
import { SplashPage } from './SplashPage';
import { common } from '@kit.AbilityKit';
import GlobalContext from '../utils/GlobalContext';
import { CactusRunPage } from './CactusRunPage';

@Entry
@Component
struct Index {
  navigationService: NavigationService = NavigationService.getInstance();

  @Builder
  routeMap(name: string) {
    NavDestination() {
      if (name === 'SplashPage') {
        SplashPage()
      } else if (name === 'CactusRunPage') {
        CactusRunPage()
      }
    }
    .onBackPressed(() => {
      if (name === 'CactusRunPage' || name === 'SplashPage') {
        this.terminateApp();
        return true;
      }
      return false;
    })
    .hideTitleBar(true)
  }

  build() {
    Navigation(this.navigationService.pageInfos)
      .onAppear(() => {
        this.navigationService.navigateTo('SplashPage');
      })
      .mode(NavigationMode.Stack)
      .navDestination(this.routeMap)
      .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.BOTTOM])
      .hideTitleBar(true)
      .width('100%')
      .height('100%')
  }

  private terminateApp() {
    const context = GlobalContext.getInstance().getCntx() as common.UIAbilityContext;
    if (context) {
      context.terminateSelf();
    }
  }
}
