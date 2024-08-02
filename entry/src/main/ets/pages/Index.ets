import { window } from '@kit.ArkUI';
import { CustomDialogUtils, CustomDialogView } from './CustomDialogUtils';
import { StorageKeys } from './StorageKeys';
import { Toast } from './ToastUtils';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  ctrl = new CustomDialogController({
    builder: CustomDialogView(),
    alignment: DialogAlignment.Center,
    //设置为true，默认弹窗样式都会去掉
    customStyle: true,
  });

  build() {
    Column() {
      Blank().height(20)
      Button("show CustomDialog normal").onClick(() => {

        this.ctrl.open()
      })

      Button("show CustomDialog easy").onClick(() => {

        CustomDialogUtils.show()
      }).margin({ top: 30 })
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