//
//  ViewController.m
//  GPUImage 美颜
//
//  Created by LIXIANG on 2019/1/7.
//  Copyright © 2019 LIXIANG. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"

#import "NSString+LXDFile.h"


#import <AVKit/AVKit.h>

@interface ViewController ()

@property(nonatomic,strong)GPUImageVideoCamera * videoCamera;
@property(nonatomic,strong)GPUImageView * filterView;

@property(nonatomic,strong)GPUImageFilterGroup *filterGroup;
@property(nonatomic,strong)GPUImageBilateralFilter *bilateralFilter;
@property(nonatomic,strong)GPUImageExposureFilter *exposureFilter;
@property(nonatomic,strong)GPUImageSaturationFilter *saturationFilter;
@property(nonatomic,strong)GPUImageBrightnessFilter *brightnessFilter;

@property(nonatomic,strong)GPUImageMovieWriter * movieWriter;
@property(nonatomic,assign)BOOL isWritering;
@property(nonatomic,strong) AVPlayerViewController * playerViewController;
@end

@implementation ViewController

- (GPUImageVideoCamera *)videoCamera{
    if (!_videoCamera) {
        _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
        _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        _videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    }    return _videoCamera;
}

- (GPUImageView *)filterView{
    if (!_filterView) {
        _filterView = [[GPUImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _filterView.fillMode =  kGPUImageFillModePreserveAspectRatioAndFill;
    }
    return _filterView;
}
- (IBAction)baoHe:(UISlider *)sender {
    
    
    NSLog(@"====%f",sender.value * 2);
    _saturationFilter.saturation = sender.value * 2;
}
- (IBAction)baoGuang:(UISlider *)sender {
    
     NSLog(@"====%f",sender.value * 10);
    _exposureFilter.exposure = sender.value * 10;
}

- (IBAction)moPi:(UISlider *)sender {
     NSLog(@"====%f",sender.value * 8);
    _bilateralFilter.distanceNormalizationFactor = sender.value * 8;
}
- (IBAction)meiBai:(UISlider *)sender {
     NSLog(@"====%f",sender.value );
    _brightnessFilter.brightness = sender.value * 1;
}

- (IBAction)startRecord:(id)sender {
    if ( !self.isWritering) {
//        GPUImageCannyEdgeDetectionFilter * cannyEdgeDetectionFilter = [[GPUImageCannyEdgeDetectionFilter alloc]init];
//        GPUImagePrewittEdgeDetectionFilter *prewittEdgeDetectionFilter = [[GPUImagePrewittEdgeDetectionFilter alloc]init];
        
//        [_videoCamera addTarget:prewittEdgeDetectionFilter];
        
        [[NSFileManager defaultManager]removeItemAtURL:[self getTepFileUrl] error:nil];
        
        _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:[self getTepFileUrl] size:_filterView.bounds.size];
        _movieWriter.encodingLiveVideo = YES;
        [_filterGroup addTarget:_movieWriter];
        _videoCamera.audioEncodingTarget = _movieWriter;
        
        [_movieWriter startRecording];
        self.isWritering = YES;
    }
}


- (IBAction)stopRecord:(id)sender {
    
    if (self.isWritering) {

        [_filterGroup removeTarget:_movieWriter];
        _videoCamera.audioEncodingTarget = nil;
        [_movieWriter finishRecording];
        
        self.isWritering = NO;
    }
}

-(NSURL *)getTepFileUrl{
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pathToMovie = [path stringByAppendingPathComponent:@"Movie.mp4"];
    return  [NSURL fileURLWithPath:pathToMovie];
}



- (IBAction)play:(id)sender {
     
    _playerViewController = [[AVPlayerViewController alloc]init];
    AVPlayer * player = [[AVPlayer alloc]initWithURL:[self getTepFileUrl]];
    _playerViewController.player = player;
    [_playerViewController.player play];
    [self presentViewController:_playerViewController animated:YES completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.view insertSubview:self.filterView atIndex:0];
    
     _filterGroup = [[GPUImageFilterGroup alloc]init];
    //磨皮
    _bilateralFilter = [[GPUImageBilateralFilter alloc]init];
    //曝光
    _exposureFilter = [[GPUImageExposureFilter alloc]init];
    //饱和
    _saturationFilter = [[GPUImageSaturationFilter alloc]init];
    //美白
    _brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    
    [_bilateralFilter addTarget:_exposureFilter];
    [_exposureFilter addTarget:_saturationFilter];
    [_saturationFilter addTarget:_brightnessFilter];
    _filterGroup.initialFilters = @[_bilateralFilter];
    _filterGroup.terminalFilter = _brightnessFilter;


    [_filterGroup addTarget:self.filterView];
    [self.videoCamera addTarget:_filterGroup];
    [self.videoCamera startCameraCapture];
    
    _saturationFilter.saturation = 1;
    _exposureFilter.exposure = 0;
    _bilateralFilter.distanceNormalizationFactor = 0.5* 8;
    _brightnessFilter.brightness = 0;

    
}

@end
