//
//  ThirdBeautyViewController.m
//  MLVB-API-Example-OC
//
//  Created by adams on 2021/4/22.
//

/*
 第三方美颜功能示例
 MLVB APP 支持第三方美颜功能
 本文件展示如何集成第三方美颜功能
 1、打开扬声器 API:[self.livePusher startMicrophone];
 2、打开摄像头 API: [self.livePusher startCamera:true];
 3、开始推流 API：[self.livePusher startPush:url];
 4、开启自定义视频处理 API: [self.livePusher enableCustomVideoProcess:true pixelFormat:V2TXLivePixelFormatNV12 bufferType:V2TXLiveBufferTypePixelBuffer];
 5、使用第三方美颜SDK<Demo中使用的是Faceunity>: API: [[FUManager shareManager] renderItemsToPixelBuffer:srcFrame.pixelBuffer];

 参考文档：https://cloud.tencent.com/document/product/647/34066
 第三方美颜：https://github.com/Faceunity/FUTRTCDemo
 */
/*
 Third-Party Beauty Filter Example
 The MLVB app supports third-party beauty filters.
 This document shows how to integrate third-party beauty filters.
 1. Turn speaker on: [self.livePusher startMicrophone]
 2. Turn camera on: [self.livePusher startCamera:true]
 3. Start publishing: [self.livePusher startPush:url]
 4. Enable custom video processing: [self.livePusher enableCustomVideoProcess:true pixelFormat:V2TXLivePixelFormatNV12 bufferType:V2TXLiveBufferTypePixelBuffer]
 5. Use a third-party beauty filter SDK (FaceUnity is used in the demo): [[FUManager shareManager] renderItemsToPixelBuffer:srcFrame.pixelBuffer]

 Documentation: https://cloud.tencent.com/document/product/647/34066
 Third-party beauty filter: https://github.com/Faceunity/FUTRTCDemo
 */

#import "ThirdBeautyViewController.h"
//#import "FUManager.h"

#import "TuSDKManager.h"

#define RTMPURL @"rtmp://155883.livepush.myqcloud.com/live/tu_test?txSecret=3694b4d1e6054f630f29a04c3b30cb1d&txTime=61CEC446"

@interface ThirdBeautyViewController () <V2TXLivePusherObserver>
@property (weak, nonatomic) IBOutlet UILabel *setBeautyLabel;
@property (weak, nonatomic) IBOutlet UILabel *beautyNumLabel;
@property (weak, nonatomic) IBOutlet UISlider *setBeautySlider;

@property (weak, nonatomic) IBOutlet UILabel *streamIdLabel;
@property (weak, nonatomic) IBOutlet UITextField *streamIdTextField;

@property (weak, nonatomic) IBOutlet UIButton *startPushStreamButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (strong, nonatomic) V2TXLivePusher *livePusher;
//@property (strong, nonatomic) FUBeautyParam *beautyParam;

//是否在当前context
@property (nonatomic, assign) BOOL isCurrentContext;

@property (nonatomic, strong) EAGLContext *currentContext;

@end

@implementation ThirdBeautyViewController

//- (FUBeautyParam *)beautyParam {
//    if (!_beautyParam) {
//        _beautyParam = [[FUBeautyParam alloc] init];
//        _beautyParam.type = FUDataTypeBeautify;
//        _beautyParam.mParam = @"blur_level";
//    }
//    return _beautyParam;
//}

- (V2TXLivePusher *)livePusher {
    if (!_livePusher) {
        _livePusher = [[V2TXLivePusher alloc] initWithLiveMode:V2TXLiveMode_RTMP];
        [_livePusher setObserver:self];
    }
    return _livePusher;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDefaultUIConfig];
    [self addKeyboardObserver];
    
    [self initTuSDKConfig];
}

- (void)initTuSDKConfig
{
    [[TuSDKManager sharedManager] configTuSDKViewWithSuperView:self.view];
}

- (void)viewDidAppear:(BOOL)animated {
    [self setupBeautySDK];
}

- (void)setupDefaultUIConfig {
    self.streamIdTextField.text = [NSString generateRandomStreamId];
    
    self.streamIdLabel.text = Localize(@"MLVB-API-Example.ThirdBeauty.streamIdInput");
    self.streamIdLabel.adjustsFontSizeToFitWidth = true;
    
    self.startPushStreamButton.backgroundColor = [UIColor themeBlueColor];
    [self.startPushStreamButton setTitle:Localize(@"MLVB-API-Example.ThirdBeauty.startPush") forState:UIControlStateNormal];
    [self.startPushStreamButton setTitle:Localize(@"MLVB-API-Example.ThirdBeauty.stopPush") forState:UIControlStateSelected];

    self.setBeautyLabel.text = Localize(@"MLVB-API-Example.ThirdBeauty.beautyLevel");
    NSInteger value = self.setBeautySlider.value * 6;
    self.beautyNumLabel.text = [NSString stringWithFormat:@"%ld",value];
    
    [self startRenderView];
}

- (void)setupBeautySDK {
//    [[FUManager shareManager] loadFilter];
//    [FUManager shareManager].isRender = YES;
//    [FUManager shareManager].flipx = YES;
//    [FUManager shareManager].trackFlipx = YES;
}

- (void)startRenderView
{
    [self.livePusher setRenderView:self.view];
    [self.livePusher startCamera:true];
    [self.livePusher startMicrophone];
    
//    [self.livePusher enableCustomVideoProcess:true pixelFormat:V2TXLivePixelFormatNV12 bufferType:V2TXLiveBufferTypePixelBuffer];
    //纹理方案 - TuSDK
    [self.livePusher enableCustomVideoProcess:true pixelFormat:V2TXLivePixelFormatTexture2D bufferType:V2TXLiveBufferTypeTexture];
}

- (void)startPush:(NSString*)streamId {
    self.title = streamId;
//    [self.livePusher setRenderView:self.view];
//    [self.livePusher startCamera:true];
//    [self.livePusher startMicrophone];
//
////    [self.livePusher enableCustomVideoProcess:true pixelFormat:V2TXLivePixelFormatNV12 bufferType:V2TXLiveBufferTypePixelBuffer];
//    //纹理方案 - TuSDK
//    [self.livePusher enableCustomVideoProcess:true pixelFormat:V2TXLivePixelFormatTexture2D bufferType:V2TXLiveBufferTypeTexture];
    
//    [self.livePusher startPush:[LiveUrl generateTRTCPushUrl:streamId]];
    [self.livePusher startPush:RTMPURL];
}

- (void)stopPush {
    [self.livePusher stopCamera];
    [self.livePusher stopMicrophone];
    [self.livePusher stopPush];
}

#pragma mark - IBActions
- (IBAction)onPushStreamClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self startPush:self.streamIdTextField.text];
    } else {
        [self stopPush];
    }
}

#pragma mark - Slider ValueChange
- (IBAction)setBeautySliderValueChange:(UISlider *)sender {
//    self.beautyParam.mValue = sender.value;
//    [[FUManager shareManager] filterValueChange:self.beautyParam];
    NSInteger value = sender.value * 6;
    self.beautyNumLabel.text = [NSString stringWithFormat:@"%ld",value];
}

#pragma mark - V2TXLivePusherObserver
- (void)onProcessVideoFrame:(V2TXLiveVideoFrame *)srcFrame dstFrame:(V2TXLiveVideoFrame *)dstFrame {
//    [[FUManager shareManager] renderItemsToPixelBuffer:srcFrame.pixelBuffer];
    
    _currentContext = [EAGLContext currentContext];
    if (!_isCurrentContext) {
        [TUPEngine Init:_currentContext];
        [TuSDKManager sharedManager].pixelFormat = TuSDKPixelFormatTexture2D;
        _isCurrentContext = YES;
        return;
    }
    
    if ([TuSDKManager sharedManager].isInitFilterPipeline) {
        GLuint texture2D = [[TuSDKManager sharedManager] syncProcessTexture2D:srcFrame.textureId width:srcFrame.width height:srcFrame.height];
        dstFrame.bufferType = V2TXLiveBufferTypeTexture;
        dstFrame.pixelFormat = V2TXLivePixelFormatTexture2D;
        dstFrame.textureId = texture2D;
//        dstFrame.rotation = V2TXLiveRotation180;
    }
    
//    dstFrame.bufferType = V2TXLiveBufferTypePixelBuffer;
//    dstFrame.pixelFormat = V2TXLivePixelFormatNV12;
//    dstFrame.pixelBuffer = srcFrame.pixelBuffer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}

- (void)dealloc {
//    [[FUManager shareManager] destoryItems];
    [self removeKeyboardObserver];
    [[TuSDKManager sharedManager] destoryTuSDKConfig];
}

#pragma mark - Notification
- (void)addKeyboardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)keyboardWillShow:(NSNotification *)noti {
    CGFloat animationDuration = [[[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardBounds = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:animationDuration animations:^{
        self.bottomConstraint.constant = keyboardBounds.size.height;
    }];
    return YES;
}

- (BOOL)keyboardWillHide:(NSNotification *)noti {
     CGFloat animationDuration = [[[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
     [UIView animateWithDuration:animationDuration animations:^{
         self.bottomConstraint.constant = 25;
     }];
     return YES;
}


@end
