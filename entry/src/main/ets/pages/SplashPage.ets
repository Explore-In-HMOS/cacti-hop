import { NavigationService } from '../services/NavigationService';

@Component
export struct SplashPage {
  navigationService: NavigationService = NavigationService.getInstance();

  async aboutToAppear() {
    setTimeout(async () => {
      this.navigationService.pageInfos.clear();
      this.navigationService.navigateTo('CactusRunPage');
    }, 2000);
  }

  build() {
    Column() {
      Image($r('app.media.cactus'))
        .width(50)
        .height(50)
      Text('Cacti Hop')
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Black)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
    .justifyContent(FlexAlign.Center)
  }
}