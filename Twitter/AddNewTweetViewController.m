//
//  AddNewTweetViewController.m
//  Twitter
//
//  Created by Stephani Alves on 6/29/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import "AddNewTweetViewController.h"
#import "User.h"
#import "TwitterClient.h"
//int const BAR_HEIGHT = 40;
//int const BAR_WIDTH = 230;
//int const BUTTON_HEIGHT = 40;
//int const BUTTON_WIDTH = 70;

@interface AddNewTweetViewController ()

@property (strong, nonatomic) IBOutlet UITextField *tweet_text_field;
@property (strong, nonatomic) IBOutlet UIImageView *thumb_img;
@property (strong, nonatomic) IBOutlet UILabel *name_label;
@property (strong, nonatomic) IBOutlet UILabel *screen_name_label;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *tweetButton;
@end

@implementation AddNewTweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //creating signout button
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0,90, 70, 40)];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
    //creating button to add a new tweet
    self.tweetButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 90, 70, 40)];
    [self.tweetButton setTitle:@"Tweet" forState:UIControlStateNormal];
    [self.tweetButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
    
    //adding action to buttons
    [self.cancelButton addTarget:self action:@selector(onCancelButton) forControlEvents:UIControlEventTouchDown];
    [self.tweetButton addTarget:self action:@selector(onTweetButton) forControlEvents:UIControlEventTouchDown];
    //creating a view
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300, 230)];
    
    [barView addSubview:self.cancelButton];
    [barView addSubview:self.tweetButton];
    
    self.navigationItem.titleView = barView;
    
    User *currentUser = [User currentUser];
    self.screen_name_label.text = currentUser.screen_name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCancelButton{
    //would be nice to refresh view
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTweetButton{
    //post tweet
    NSLog(@"post tweet");
    NSString *tweet = self.tweet_text_field.text;
    TwitterClient *client = [TwitterClient instance];
    [client tweetWithText:tweet
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Tweet posted with sucess");
        //load timeline
        [self onCancelButton];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Tweet not posted %@", [error description]);
        //alert error
    }];
    
}


@end
