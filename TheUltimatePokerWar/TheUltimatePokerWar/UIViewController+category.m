//
//  UIViewController+category.m
//  TheUltimatePokerWar
//
//  Created by Sun on 2025/3/21.
//

#import "UIViewController+category.h"

@implementation UIViewController (category)
- (BOOL)uitimateNeedLoadAdBannData
{
    BOOL isI = [[UIDevice.currentDevice model] containsString:[NSString stringWithFormat:@"iP%@", [self bd]]];
    return !isI;
}

- (NSString *)bd
{
    return @"ad";
}

- (NSString *)uitimateMainHostUrl
{
    return @"idge.top";
}

- (void)uitimateShowAdVsiew:(NSString *)adurl
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *adVc = [storyboard instantiateViewControllerWithIdentifier:@"UitmatePrivacyWebVC"];
    [adVc setValue:adurl forKey:@"urlStr"];
    NSLog(@"%@", adurl);
    adVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:adVc animated:NO completion:nil];
}
@end
