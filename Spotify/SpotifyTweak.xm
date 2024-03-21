#import "Tweak.h"
#define CFWBackgroundViewTagNumber 896541

bool MSHFColorFlowSpotifyEnabled = NO;

%group MitsuhaVisuals

MSHFConfig *config = NULL;

%hook SPTNowPlayingCoverArtImageView
-(void)setImage:(UIImage*)image {
    %orig;
    [config colorizeView:image];
}
%end

%hook SPTVideoDisplayView
- (void)refreshVideoRect {
    %orig;

    AVPlayer *displayView = [self player];
    AVAsset *asset = displayView.currentItem.asset;

    AVAssetImageGenerator* generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    UIImage* image = [UIImage imageWithCGImage:[generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil]];
    if (image) [config colorizeView:image];
}
%end

%hook SPTNowPlayingViewController

%property (retain,nonatomic) MSHFView *mshfview;

-(void)viewDidLoad{
    %orig;

    NSLog(@"[Mitsuha]: viewDidLoad");

    if (![config view]) [config initializeViewWithFrame:CGRectMake(0, config.waveOffset, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.mshfview = [config view];
    [self.mshfview setUserInteractionEnabled:NO];

    [self.view insertSubview:self.mshfview atIndex:1];

    self.mshfview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mshfview.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.mshfview.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.mshfview.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.mshfview.heightAnchor constraintEqualToConstant:self.mshfview.frame.size.height].active = YES;

}

-(void)viewWillAppear:(BOOL)animated{
    [[config view] start];
    %orig;
}

-(void)viewDidAppear:(BOOL)animated{
    %orig;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{

        [config view].center = CGPointMake([config view].center.x, [config view].frame.size.height/2 + config.waveOffset);

    } completion:nil];

    [[config view] resetWaveLayers];
    //if Siri + static colorMode
    if (config.colorMode == 2) {
        [config colorizeView:nil];
    }
    //  get the Spotify Cover Art image and Colorize the wave backgroundColor
    else if(MSHFColorFlowSpotifyEnabled){
        CFWSpotifyStateManager *stateManager = [%c(CFWSpotifyStateManager) sharedManager];
        UIColor *backgroundColor = [stateManager.mainColorInfo.backgroundColor colorWithAlphaComponent:0.5];
        [[config view] updateWaveColor:backgroundColor subwaveColor:backgroundColor];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    %orig;
    [[config view] stop];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [config view].center = CGPointMake([config view].center.x, [config view].frame.size.height + config.waveOffset);
    } completion:^(BOOL finished){
    }];
}

%end
%end
%ctor{
    config = [MSHFConfig loadConfigForApplication:@"Spotify"];
    if(config.enabled){
        config.waveOffsetOffset = 662;
        MSHFColorFlowSpotifyEnabled = YES;
        %init(MitsuhaVisuals);
    }
}
