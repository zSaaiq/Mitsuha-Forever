#import "YouTubeMusicMitsuhaForeverSettingsController.h"
#import "Localization.h"

@implementation YouTubeMusicMitsuhaForeverSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"xmark"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(closeButtonTapped:)];

    UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"checkmark"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(applyButtonTapped:)];

    self.navigationItem.leftBarButtonItem = closeButton;
    self.navigationItem.rightBarButtonItem = applyButton;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.tableView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.tableView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
        [self.tableView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor]
    ]];

    //Init isEnabled for first time
    NSMutableDictionary *YouTubeMusicMitsuhaForeverDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"YouTubeMusicMitsuhaForever"]];
    if (!YouTubeMusicMitsuhaForeverDict[@"YouTubeMusicMitsuhaForever"]) {
        [YouTubeMusicMitsuhaForeverDict setObject:@(1) forKey:@"YouTubeMusicMitsuhaIsEnabled"];
        [[NSUserDefaults standardUserDefaults] setObject:YouTubeMusicMitsuhaForeverDict forKey:@"YouTubeMusicMitsuhaForever"];
    }

}

#pragma mark - Table view stuff
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 2 ? LOC(@"LINKS") : nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return LOC(@"RESTART_FOOTER");
    } if (section == 2) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = infoDictionary[@"CFBundleShortVersionString"];
        return [NSString stringWithFormat:@"\nYouTubeMusic: v%@\nMitsuhaForeverYouTubeMusic: v%@\n\n© zSaaiq (@0x1585D65F0) 2024", appVersion, @(OS_STRINGIFY(TWEAK_VERSION))];
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    if (section == 2) {
        UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
        footer.textLabel.textAlignment = NSTextAlignmentCenter;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
        //IF A TOGGLE IS ADDED INCREMENT THE RETUN
        case 1:
            return 3;
        case 2:
            return 1;
        default:
            return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    } else {
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }

    NSMutableDictionary *YouTubeMusicMitsuhaForeverDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"YouTubeMusicMitsuhaForever"]];

    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell0"];
        cell.textLabel.text = LOC(@"ENABLED");
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.textColor = [UIColor colorWithRed:75/255.0 green:230/255.0 blue:75/255.0 alpha:1.0];
        cell.imageView.image = [UIImage systemImageNamed:@"power"];
        cell.imageView.tintColor = [UIColor colorWithRed:75/255.0 green:230/255.0 blue:75/255.0 alpha:1.0];

        UISwitch *masterSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        masterSwitch.onTintColor = [UIColor colorWithRed:75/255.0 green:230/255.0 blue:75/255.0 alpha:1.0];
        [masterSwitch addTarget:self action:@selector(toggleMasterSwitch:) forControlEvents:UIControlEventValueChanged];
        masterSwitch.on = [YouTubeMusicMitsuhaForeverDict[@"YouTubeMusicMitsuhaIsEnabled"] boolValue];
        cell.accessoryView = masterSwitch;
    } else if (indexPath.section == 1) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell1"];

      NSArray *settingsData = @[
          @{@"title": LOC(@"MITSUHAFOREVER_COLORFLOWENABLED"), @"desc": LOC(@"MITSUHAFOREVER_COLORFLOWENABLED_DESC"), @"key": @"colorflowenabled"},
          @{@"title": LOC(@"MITSUHAFOREVER_MINIMALWAVEHIGH"), @"desc": LOC(@"MITSUHAFOREVER_MINIMALWAVEHIGH_DESC"), @"key": @"minimalwavehigh"},
          @{@"title": LOC(@"MITSUHAFOREVER_MINIMALWAVEHIGHNOHIDING"), @"desc": LOC(@"MITSUHAFOREVER_MINIMALWAVEHIGHNOHIDING_DESC"), @"key": @"minimalwavehighnohiding"}
      ];

      NSDictionary *data = settingsData[indexPath.row];

      cell.textLabel.text = data[@"title"];
      cell.textLabel.adjustsFontSizeToFitWidth = YES;
      cell.detailTextLabel.text = data[@"desc"];
      cell.detailTextLabel.numberOfLines = 0;
      cell.detailTextLabel.textColor = [UIColor secondaryLabelColor];

      UISwitch *switchControl = [[UISwitch alloc] initWithFrame:CGRectZero];
      switchControl.onTintColor = [UIColor colorWithRed:30.0/255.0 green:150.0/255.0 blue:245.0/255.0 alpha:1.0];
      [switchControl addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventValueChanged];
      switchControl.tag = indexPath.row;
      switchControl.on = [YouTubeMusicMitsuhaForeverDict[data[@"key"]] boolValue];
      cell.accessoryView = switchControl;
    }
     else if (indexPath.section == 2) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell3"];

        NSArray *settingsData = @[
            @{@"text": [NSString stringWithFormat:LOC(@"TWITTER"), @"0x1585D65F0"],  @"detail": LOC(@"TWITTER_DESC"), @"image": @"zsaaiq-24@2x"}
        ];

        NSDictionary *settingData = settingsData[indexPath.row];

        cell.textLabel.text = settingData[@"text"];
        cell.textLabel.textColor = [UIColor systemBlueColor];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.text = settingData[@"detail"];
        cell.detailTextLabel.numberOfLines = 0;

        NSString *imageName = settingData[@"image"];
        UIImage *image = [UIImage imageWithContentsOfFile:[YouTubeMusicMitsuhaForeverBundle() pathForResource:imageName ofType:@"png" inDirectory:@"icons"]];
        cell.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        cell.detailTextLabel.textColor = [UIColor secondaryLabelColor];
    } return cell;
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? NO : YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
    NSArray *urls = @[@"https://twitter.com/0x1585D65F0"];

    if (indexPath.row >= 0 && indexPath.row < urls.count) {
        NSURL *url = [NSURL URLWithString:urls[indexPath.row]];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }
}
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Nav bar stuff
- (NSString *)title {
    return @"YouTubeMusicMitsuhaForever";
}

- (void)closeButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)applyButtonTapped:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LOC(@"WARNING") message:LOC(@"APPLY_MESSAGE") preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:LOC(@"CANCEL") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:LOC(@"YES") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] performSelector:@selector(suspend)];
            [NSThread sleepForTimeInterval:1.0];
            exit(0);
        });
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}
- (void)toggleSwitch:(UISwitch *)sender {
    NSArray *settingsData = @[
        @{@"key": @"colorflowenabled"},
        @{@"key": @"minimalwavehigh"},
        @{@"key": @"minimalwavehighnohiding"}
    ];

    NSDictionary *data = settingsData[sender.tag];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *YouTubeMusicMitsuhaForeverDict = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:@"YouTubeMusicMitsuhaForever"]];

    [YouTubeMusicMitsuhaForeverDict setObject:@([sender isOn]) forKey:data[@"key"]];
    [defaults setObject:YouTubeMusicMitsuhaForeverDict forKey:@"YouTubeMusicMitsuhaForever"];
}
- (void)toggleMasterSwitch:(UISwitch *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *twitchDvnDict = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:@"YouTubeMusicMitsuhaForever"]];

    [twitchDvnDict setObject:@([sender isOn]) forKey:@"YouTubeMusicMitsuhaIsEnabled"];
    [defaults setObject:twitchDvnDict forKey:@"YouTubeMusicMitsuhaForever"];
}

@end
