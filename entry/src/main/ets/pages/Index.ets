import { window } from '@kit.ArkUI';
import { StorageKeys } from './StorageKeys';
import { Toast } from './ToastUtils';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        }).onClick((e)=>{
          Toast.showSuccess("nihaoaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
      })
    }
    .height('100%')
    .width('100%')
  }

  onPageShow(): void {
    //监听键盘
    window.getLastWindow(getContext(this)).then(currentWindow => {

      // 监视软键盘的弹出和收起

      currentWindow.on('avoidAreaChange', async data => {
        // 初始化显示区域高度
        let property = currentWindow.getWindowProperties();
        let avoidArea = currentWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);

        // this.screenHeight = px2vp(property.windowRect.height - avoidArea.topRect.height - avoidArea.bottomRect.height);
        AppStorage.setOrCreate(StorageKeys.SCREEN_WIDTH, px2vp(property.windowRect.width))
        AppStorage.setOrCreate(StorageKeys.SCREEN_HEIGHT, px2vp(property.windowRect.height))

        if (data.type !== window.AvoidAreaType.TYPE_KEYBOARD) {

          return;

        }
        // this.screenHeight = px2vp(property.windowRect.height - avoidArea.topRect.height - data.area.bottomRect.height);
        console.log("data.area.bottomRect.height:" + data.area.bottomRect.height)



      })

    })
  }

}