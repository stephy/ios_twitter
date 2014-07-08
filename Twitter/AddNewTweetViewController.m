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

@property (strong, nonatomic) IBOutlet UILabel *charCounterLabel;
@property (strong, nonatomic) IBOutlet UITextView *tweetTextView;
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
    //to be able to count chars
    self.tweetTextView.delegate = self;
    
    UIColor *mainColor = [UIColor colorWithRed:13/255.0f green:105/255.0f blue:255/255.0f alpha:1.0f];
    //creating signout button
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(-10, 90, 70, 40)];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    //creating button to add a new tweet
    self.tweetButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 90, 70, 40)];
    [self.tweetButton setTitle:@"Tweet" forState:UIControlStateNormal];
    [self.tweetButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    
    //adding action to buttons
    [self.cancelButton addTarget:self action:@selector(onCancelButton) forControlEvents:UIControlEventTouchDown];
    [self.tweetButton addTarget:self action:@selector(onTweetButton) forControlEvents:UIControlEventTouchDown];
    
    //character counter
    self.charCounterLabel = [[UILabel alloc] initWithFrame:CGRectMake(200,90, 70, 40)];
    self.charCounterLabel.text = @"140";
    //creating a view
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300, 230)];
    
    [barView addSubview:self.cancelButton];
    [barView addSubview:self.tweetButton];
    [barView addSubview:self.charCounterLabel];
    
    
    [self loadUser];
    self.navigationItem.titleView = barView;
    self.navigationController.navigationBar.barTintColor = mainColor;


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
    NSString *tweet = self.tweetTextView.text;
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

- (void)loadUser {
    TwitterClient *client = [TwitterClient instance];
    
    User *currentUser = [User currentUser];
    self.screen_name_label.text = currentUser.screen_name;
    
    [client getUserWithID:currentUser.screen_name success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *user = [responseObject objectAtIndex:0];
        NSLog(@"user loaded successfully, response: %@", user);
        self.name_label.text = user[@"name"];
        
        NSString *profile_image_url = user[@"profile_image_url"];
       [self.thumb_img setImageWithURL: [NSURL URLWithString:profile_image_url]];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error");
    }];

}

- (void)textViewDidChange:(UITextView *)textView{
    int len = textView.text.length;
    self.charCounterLabel.text=[NSString stringWithFormat:@"%i",140-len];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text length] == 0){
        if([textView.text length] != 0){
            return YES;
        }
    }else if([[textView text] length] > 139){
        return NO;
    }
    return YES;
}




@end
