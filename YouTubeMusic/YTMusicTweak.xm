#import "Tweak.h"
#define CFWBackgroundViewTagNumber 796541

bool MSHFColorFlowYouTubeMusicEnabled = NO;

%group MitsuhaVisuals

MSHFConfig *config = NULL;

%hook YTImageView

-(void)setImage:(UIImage*)image {
    %orig;
    [config colorizeView:image];
}

%end

%hook YTMVideoOverlayView
- (void)loadView {
    %orig;

    AVPlayer *displayView = [self player];
    AVAsset *asset = displayView.currentItem.asset;

    AVAssetImageGenerator* generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    UIImage* image = [UIImage imageWithCGImage:[generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil]];
    if (image) [config colorizeView:image];
}
%end

%hook YTMContentViewController

%property (retain,nonatomic) MSHFView *mshfview;

-(void)viewDidLoad{
    %orig;
    NSLog(@"[Mitsuha]: viewDidLoad");
}

-(void)viewWillAppear:(BOOL)animated{
    %orig;
    [[config view] resetWaveLayers];
    if (![config view]) {
        CGRect frame = CGRectMake(0, config.waveOffset, self.view.bounds.size.width, self.view.bounds.size.height);
        [config initializeViewWithFrame:frame];
        self.mshfview = [config view];
        [self.mshfview setUserInteractionEnabled:NO];
        [self.view insertSubview:self.mshfview atIndex:3];

        self.mshfview.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.mshfview.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.mshfview.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.mshfview.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
            [self.mshfview.heightAnchor constraintEqualToConstant:self.mshfview.frame.size.height]
        ]];
    }
    [[config view] start];
}

-(void)viewDidAppear:(BOOL)animated{
    %orig;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [config view].center = CGPointMake([config view].center.x, [config view].frame.size.height/2 + config.waveOffset);
    } completion:nil];
    if (config.colorMode == 1) {
        [config colorizeView:nil];
    }
    else if(MSHFColorFlowYouTubeMusicEnabled){
        CFWYouTubeMusicStateManager *stateManager = [%c(CFWYouTubeMusicStateManager) sharedManager];
        UIColor *backgroundColor = [stateManager.mainColorInfo.backgroundColor colorWithAlphaComponent:0.5];
        [[config view] updateWaveColor:backgroundColor subwaveColor:backgroundColor];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    [[config view] stop];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [config view].center = CGPointMake([config view].center.x, [config view].frame.size.height + config.waveOffset);
    } completion:nil];
}

%end
%end

%ctor{
    config = [MSHFConfig loadConfigForApplication:@"YouTubeMusic"];
    if(config.enabled){
        config.waveOffsetOffset = 662;
        MSHFColorFlowYouTubeMusicEnabled = YES;
        %init(MitsuhaVisuals);
    }
}
