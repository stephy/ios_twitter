//
//  TweetsViewController.h
//  Twitter
//
//  Created by Stephani Alves on 6/28/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface TweetsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id timeline;

@end
