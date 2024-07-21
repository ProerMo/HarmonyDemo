import promptAction from '@ohos.promptAction';
import MeasureText from '@ohos.measure';
import { StorageKeys } from './StorageKeys';

const DEFAULT_TOAST_DURATION = 2000

export default function showToast(message: string, duration: number = DEFAULT_TOAST_DURATION) {
  try {
    promptAction.showToast({
      message: message,
      duration: duration,
      bottom: "center",
    })
  } catch (error) {
    console.error(`showToast args error code is ${error.code}, message is ${error.message}`);
  }
}


@CustomDialog
struct StateToastDialog {
  config?: ToastConfig
  //弹窗控制器
  controller?: CustomDialogController

  build() {
    if (this.config!.isMultiLine) {
      Row() {
        Image(this.config?.icon)
          .width(this.config!.iconWidth)
          .height(this.config!.iconHeight)
          .margin({ right: this.config!.spaceBetweenIconAndText })
        Text(this.config!.message)
          .fontSize(this.config!.fontSize)
          .lineHeight(this.config!.fontLineHeight)
          .fontColor(Color.Black)
          .layoutWeight(1)


      }
      .margin({
        top: this.config!.parentMarginTop,
        left: this.config!.parentMarginLeft,
        right: this.config!.parentMarginRight
      })
      .padding(this.config!.parentPadding)
      .backgroundColor(this.config?.backgroundColor)
      .borderWidth(1)
      .borderColor(this.config?.borderColor)
      .borderRadius(4)
    } else {
      Row() {
        Image(this.config?.icon)
          .width(this.config!.iconWidth)
          .height(this.config!.iconHeight)
          .margin({ right: this.config!.spaceBetweenIconAndText })
        Text(this.config!.message)
          .fontSize(this.config!.fontSize)
          .lineHeight(this.config!.fontLineHeight)
          .fontColor(Color.Black)


      }
      .margin({
        top: this.config!.parentMarginTop,
        left: this.config!.parentMarginLeft,
        right: this.config!.parentMarginRight
      })
      .padding(this.config!.parentPadding)
      .backgroundColor(this.config?.backgroundColor)
      .borderWidth(1)
      .borderColor(this.config?.borderColor)
      .borderRadius(4)
    }


  }
}

@Component
export struct ToastComponent {
  showSuccess(message: string, duration: number = DEFAULT_TOAST_DURATION) {
    let config = new ToastConfig()
    this.showStateToast(config, duration, message);
  }

  showError(message?: string, duration: number = DEFAULT_TOAST_DURATION) {
    let config = new ToastConfig()
    config.icon = $r('app.media.icon_toast_err')
    config.backgroundColor = $r('app.color.red_ffe8e5')
    config.borderColor = $r('app.color.red_ffa399')
    this.showStateToast(config, duration, message);
  }

  private showStateToast(config: ToastConfig, duration: number, message?: string,) {
    config.message = message;

    //测量文本单行宽高
    let textSizeSingleLine = MeasureText.measureTextSize({
      textContent: config.message,
      fontSize: config.fontSize
    });
    let measureTextWidthSingleLine = px2vp(textSizeSingleLine.width as number);
    let measureTextHeightSingleLine = px2vp(textSizeSingleLine.height as number);
    //计算面积
    let textSingleLineArea = measureTextWidthSingleLine * measureTextHeightSingleLine;
    //窗口宽度
    let screenWidth = AppStorage.get<number | null>(StorageKeys.SCREEN_WIDTH) ?? 0;
    //文本框可用最大宽度
    let textComponentMaxWidth =
      screenWidth - config.parentMarginLeft - config.parentMarginRight - config.parentPadding - config.iconWidth -
      config.spaceBetweenIconAndText;
    //是否显示多行文本
    config.isMultiLine = textComponentMaxWidth < measureTextWidthSingleLine;

    if (textComponentMaxWidth < measureTextWidthSingleLine) {
      //如果多行文本，宽度是最大值，高度是 （（面积 / 宽度 / 行高）进一法取整）* 行高
      config.calTextWidth = textComponentMaxWidth;
      config.calTextHeight =
        Math.ceil(textSingleLineArea / textComponentMaxWidth / config.fontLineHeight) * config.fontLineHeight;
    } else {
      //单行文本，宽高就是测量的单行宽高
      config.calTextWidth = measureTextWidthSingleLine;
      config.calTextHeight = measureTextHeightSingleLine;
    }


    //多行则mask为全宽度，单行则是控件宽度，这里*1.2是做一些兼容性处理
    let singleLineMaskRectWidth =
      (config.parentPadding * 2 + config.iconWidth + config.spaceBetweenIconAndText + config.calTextWidth) * 1.1;
    let maskRectWidth = config.isMultiLine ? '100%' : singleLineMaskRectWidth;

    //多行高度则是控件高度，单行则是 图标高度 或 文本行高 的较大者在加上 控件padding，这里*1.2是做一些兼容性处理
    let maskRectHeight = (config.isMultiLine ? config.parentPadding * 2 + config.calTextHeight :
      (config.iconHeight > config.fontLineHeight ? config.iconHeight : config.fontLineHeight) +
        config.parentPadding * 2) * 1.1;

    let maskRectX = config.isMultiLine ? 0 : (screenWidth - singleLineMaskRectWidth) / 2;
    let maskRectY = config.parentMarginTop;
    console.log("maskRectX:" + maskRectX + "---maskRectY:" + maskRectY + "---maskRectWidth:" + maskRectWidth +
      "---maskRectHeight:" + maskRectHeight);


    let toastController: CustomDialogController = new CustomDialogController({
      builder: StateToastDialog({ config: config }),
      alignment: DialogAlignment.Top,
      showInSubWindow: false,
      autoCancel: false,
      //设置mask大小为弹窗大小，mask覆盖的地方触摸事件会被拦截，非mask覆盖的地方会传递到页面中。
      maskRect: {
        x: maskRectX,
        y: maskRectY,
        width: maskRectWidth,
        height: maskRectHeight
      },
      //设置为true，默认弹窗样式都会去掉
      customStyle: true,
      maskColor: Color.Transparent,
    });
    this.showDuration(toastController, duration);
  }

  private showDuration(toastController: CustomDialogController, duration: number) {
    toastController.open();
    setTimeout(() => {
      toastController.close();
    }, duration);
  }

  build() {
  }
}

export class ToastConfig {
  //字体大小
  fontSize: number = 16
  //字体行高
  fontLineHeight: number = 18
  //消息
  message?: string
  //父布局的margin
  // { top: 100, left: 16, right: 16 }
  parentMarginTop: number = 100
  parentMarginLeft: number = 16
  parentMarginRight: number = 16
  //父布局的padding
  parentPadding: number = 16
  //图标的宽高
  iconWidth: number = 20
  iconHeight: number = 20
  //图标跟文字的距离
  spaceBetweenIconAndText: number = 10
  //是否多行
  isMultiLine: boolean = false
  //计算出来的文本宽高
  calTextWidth: number = 0
  calTextHeight: number = 0
  icon: Resource = $r('app.media.icon_toast_success')
  backgroundColor: Resource = $r('app.color.green_e0fff6')
  borderColor: Resource = $r('app.color.green_1bd39e')
}

export class ToastManager {
  getToast = new ToastComponent()
}

export let Toast = new ToastManager().getToast
