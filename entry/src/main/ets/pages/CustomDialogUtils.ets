@CustomDialog
export struct CustomDialogView {
  dialogCtrl?: CustomDialogController
  onClickConfirm: () => void = () => {}

  build() {
    Column() {
      Text("我是弹窗")
      Button("确定").onClick(() => {
        this.dialogCtrl?.close()
        this.onClickConfirm()
      }).margin({ top: 30 })
    }.width(200).height(200).backgroundColor(Color.White)
  }
}


@Component
struct CustomDialogEasyUtil {
  show() {

    let ctrl = new CustomDialogController({
      builder: CustomDialogView({
        onClickConfirm: () => {
          ctrl.close()
        }
      }),
      //设置为true，默认弹窗样式都会去掉
      customStyle: true,
      alignment: DialogAlignment.Center
    });
    ctrl.open()
  }

  build() {
  }
}


// export class CustomDialogManager {
//   dialogUtil = new CustomDialogUtil()
// }
//
// export let CustomDialogUtils = new CustomDialogManager().dialogUtil


export let CustomDialogUtils = new CustomDialogEasyUtil()
