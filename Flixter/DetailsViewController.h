//
//  DetailsViewController.h
//  Flixter
//
//  Created by Shreya Vinjamuri on 6/16/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (strong, nonatomic) NSDictionary *detailDict;
@property (strong, nonatomic) NSIndexPath *myPath;
@end

NS_ASSUME_NONNULL_END
