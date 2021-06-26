//
//  TrailerViewController.h
//  Flix_App
//
//  Created by rutvims on 6/25/21.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrailerViewController : UIViewController
@property  NSInteger* movie_id;
@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;
@end

NS_ASSUME_NONNULL_END
