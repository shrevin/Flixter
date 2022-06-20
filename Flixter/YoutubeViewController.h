//
//  YoutubeViewController.h
//  Flixter
//
//  Created by Shreya Vinjamuri on 6/19/22.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YoutubeViewController : UIViewController
@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;
- (IBAction)playVideo:(id)sender;
- (IBAction)stopVideo:(id)sender;
@property (strong, nonatomic) NSNumber *movie_id;
@end



NS_ASSUME_NONNULL_END
