#import "Tweak.h"
#import <Foundation/Foundation.h>
#define CFWBackgroundViewTagNumber 796541

static BOOL YTMU(NSString *key) {
    NSDictionary *YouTubeMusicMitsuhaForeverDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"YouTubeMusicMitsuhaForever"];
    return [YouTubeMusicMitsuhaForeverDict[key] boolValue];
}

bool MSHFColorFlowYouTubeMusicEnabled = NO;
bool MSHFYouTubeMusicMinimalWaveHighEnabled = NO;

%group MitsuhaVisuals

MSHFConfig *config = NULL;

%hook YTImageView

-(void)setImage:(UIImage*)image animated:(BOOL)arg1{
    %orig;
    [config colorizeView:image];
}

%end

%hook YTMContentViewController

%property (retain,nonatomic) MSHFView *mshfview;

-(void)viewDidAppear:(BOOL)arg1{
    %orig;
    NSLog(@"[Mitsuha]: viewDidAppear");
    //Configure WaveView until
    if (![config view]) {
        CGRect frame = CGRectMake(0, config.waveOffset, self.view.bounds.size.width, self.view.bounds.size.height);
        [config initializeViewWithFrame:frame];
        self.mshfview = [config view];
        [self.mshfview setUserInteractionEnabled:NO];
        [self.view insertSubview:self.mshfview atIndex:6];

        self.mshfview.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.mshfview.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [self.mshfview.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [self.mshfview.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
            [self.mshfview.heightAnchor constraintEqualToConstant:self.mshfview.frame.size.height]
        ]];
    }
    if (MSHFColorFlowYouTubeMusicEnabled){
    CFWYouTubeMusicStateManager *stateManager = [%c(CFWYouTubeMusicStateManager) sharedManager];
    UIColor *backgroundColor = [stateManager.mainColorInfo.backgroundColor colorWithAlphaComponent:0.5];
    [[config view] updateWaveColor:backgroundColor subwaveColor:backgroundColor];
  }
}

-(void)watchViewControllerDidExpand:(id)arg1{
    %orig;
    //Show MitsuhaWave
    [[config view] start];
    [UIView animateWithDuration:0.30 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [config view].center = CGPointMake([config view].center.x, [config view].frame.size.height/2 + config.waveOffset);
    } completion:nil];
    [[config view] resetWaveLayers];
}
//Stop the WaveView when dismissed
-(void)watchViewControllerDidCollapse:(id)arg2{
    %orig;
    [[config view] stop];
    [UIView animateWithDuration:0.01 delay:0.0 usingSpringWithDamping:3.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [config view].center = CGPointMake([config view].center.x, [config view].frame.size.height + config.waveOffset);
    } completion:nil];
}

%end
%end
%ctor{
    config = [MSHFConfig loadConfigForApplication:@"YouTubeMusic"];
    if (config.enabled){
      if (config.colorMode == 2) {
          [config colorizeView:nil];
      } else if (config.colorMode == 3) {
          [config colorizeView:nil];
      }
      if (YTMU(@"YouTubeMusicMitsuhaIsEnabled")){
        %init(MitsuhaVisuals);
      }
      if (YTMU(@"colorflowenabled")){
        MSHFColorFlowYouTubeMusicEnabled = YES;
      }
      if (YTMU(@"minimalwavehigh")){
        config.waveOffsetOffset = 860;
      }else{
        config.waveOffsetOffset = 710;
      }
    }
}
