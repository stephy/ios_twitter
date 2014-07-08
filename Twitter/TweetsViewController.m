//
//  TweetsViewController.m
//  Twitter
//
//  Created by Stephani Alves on 6/28/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import "TweetsViewController.h"
#import "TweetViewController.h"

int const BAR_HEIGHT = 40;
int const BAR_WIDTH = 230;
int const BUTTON_HEIGHT = 40;
int const BUTTON_WIDTH = 70;

@interface TweetsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIButton *addTweetButton;
@property (strong, nonatomic) UIButton *signoutButton;
@property (strong, nonatomic) NSMutableArray *favorites;

@end

@implementation TweetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView reloadData];
    UIColor *mainColor = [UIColor colorWithRed:13/255.0f green:105/255.0f blue:255/255.0f alpha:1.0f];
    //creating signout button
    self.signoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [self.signoutButton setTitle:@"Sign Out" forState:UIControlStateNormal];
    [self.signoutButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    //creating button to add a new tweet
    self.addTweetButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 0.0, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [self.addTweetButton setTitle:@"New" forState:UIControlStateNormal];
    [self.addTweetButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    
    //adding action to buttons
    [self.addTweetButton addTarget:self action:@selector(onAddTweetButton) forControlEvents:UIControlEventTouchDown];
    [self.signoutButton addTarget:self action:@selector(onSignoutButton) forControlEvents:UIControlEventTouchDown];
    //creating a view
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300, BAR_HEIGHT)];
    
    [barView addSubview:self.signoutButton];
    [barView addSubview:self.addTweetButton];
    
    self.navigationItem.titleView = barView;
    
    //adding pull to refresh feature
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    //load personalized cell
    //registration process
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    //set row height
    self.tableView.rowHeight = 120;
    
    //initialize favorites array
    self.favorites = [[NSMutableArray alloc] initWithCapacity:20];
    
    //change navigation controller color
    self.navigationController.navigationBar.barTintColor = mainColor;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//number of rows
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return the number of rows you want in this table view
    return [self.timeline count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"table view indexpath.row = %d", indexPath.row);
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    NSDictionary *tweet = [self.timeline objectAtIndex:indexPath.row];
    [self.favorites insertObject:tweet[@"favorited"] atIndex:indexPath.row];
    
    //NSLog(@"tweet: %@", tweet[@"favorited"]);
    //check to see if tweet has been retweeted
    if ([@"0" isEqualToString:tweet[@"retweeted"]]) {
        //show retweeted label
        cell.retweetLabel.text =@"somebody retweeted this";
    }else{
        //don't show retweeted label
        cell.retweetLabel.text = @"";
    }
    
    cell.name_label.text = tweet[@"user"][@"name"];
    NSMutableString *screen_name = [[NSMutableString alloc]init];
    [screen_name appendString:@"@"];
    [screen_name appendString:tweet[@"user"][@"screen_name"]];
    
    cell.screen_name_label.text = screen_name;
    NSString *profile_image_url = tweet[@"user"][@"profile_image_url"];
    [cell.profile_image_view setImageWithURL: [NSURL URLWithString:profile_image_url]];
    
    cell.text_label.text = tweet[@"text"];
    
    cell.timestamp_label.text = [self retrivePostTime:tweet[@"created_at"]];
    
    //adding button event handlers
    [cell.replyButton setImage:[UIImage imageNamed:@"01-refresh.png"] forState:UIControlStateNormal];
    [cell.replyButton addTarget:self action:@selector(onTweetReply:event:) forControlEvents:UIControlEventTouchDown];
    
    [cell.retweetButton setImage:[UIImage imageNamed:@"02-redo.png"] forState:UIControlStateNormal];
    [cell.retweetButton addTarget:self action:@selector(onRetweet:event:) forControlEvents:UIControlEventTouchDown];
    
    
    //button states
    //user has not favorited the tweet
    
    [cell.favoriteButton setImage:[UIImage imageNamed:@"28-star.png"] forState:UIControlStateNormal];
    [cell.favoriteButton addTarget:self action:@selector(onTweetFavorite:event:) forControlEvents:UIControlEventTouchDown];
    
    
    
    return cell;
}

-(NSString*)retrivePostTime:(NSString*)postDate{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *userPostDate = [df dateFromString:postDate];
    
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval distanceBetweenDates = [currentDate timeIntervalSinceDate:userPostDate];
    
    NSTimeInterval theTimeInterval = distanceBetweenDates;
    
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    
    NSString *returnDate;
    if ([conversionInfo month] > 0) {
        returnDate = [NSString stringWithFormat:@"%ldmth ago",(long)[conversionInfo month]];
    }else if ([conversionInfo day] > 0){
        returnDate = [NSString stringWithFormat:@"%ldd ago",(long)[conversionInfo day]];
    }else if ([conversionInfo hour]>0){
        returnDate = [NSString stringWithFormat:@"%ldh ago",(long)[conversionInfo hour]];
    }else if ([conversionInfo minute]>0){
        returnDate = [NSString stringWithFormat:@"%ldm ago",(long)[conversionInfo minute]];
    }else{
        returnDate = [NSString stringWithFormat:@"%lds ago",(long)[conversionInfo second]];
    }
    return returnDate;
}

//on row click open detailed view
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //dismiss keyboard
    
    NSDictionary *tweet = [self.timeline objectAtIndex:indexPath.row];
    
    TweetViewController *tvc = [[TweetViewController alloc] initWithNibName:@"TweetViewController" bundle:[NSBundle mainBundle]];
    tvc.currentTweet = tweet;
    [self.navigationController pushViewController:tvc animated:YES];
}


- (void)onAddTweetButton{
    NSLog(@"clicked on add new tweet");
    AddNewTweetViewController *newTweetViewController =[[AddNewTweetViewController alloc] init];
    //newTweetViewController.currentClient = client;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:newTweetViewController];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onSignoutButton{
    NSLog(@"signing out");
    
    //set current user to nil
    [[User alloc] setCurrentUser:nil];
    
    //load login page
    LoginViewController *lvc = [[LoginViewController alloc] init];
    [self presentViewController:lvc animated:YES completion:nil];
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self loadData];
    [refreshControl endRefreshing];
}

- (void)onTweetReply:(id)sender event:(id)event{
    NSLog(@"reply tweet");
    CGPoint touchPosition = [[[event allTouches] anyObject] locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchPosition];
    if (indexPath != nil){
        NSDictionary *tweet = [self.timeline objectAtIndex:indexPath.row];
        NSLog(@"tweet: %@", tweet[@"id"]);
        //do Something here
    }
}

- (void)onTweetFavorite:(id)sender event:(id)event{
    NSLog(@"destroy favorite tweet");
    CGPoint touchPosition = [[[event allTouches] anyObject] locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchPosition];
    if (indexPath != nil){
        NSDictionary *tweet = [self.timeline objectAtIndex:indexPath.row];
        
        TwitterClient *client = [TwitterClient instance];
        
        if ( (int)[self.favorites objectAtIndex:indexPath.row] == 1) {
            //destroy it
            [client favoritesDestroyId:tweet[@"id"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //favorited, change button state
                NSLog(@"favorite destroyed");
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error when destroying a favorite");
            }];
            
        }else{
            //favorite it
            [client favoritesCreateId:tweet[@"id"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //favorited, change button state
                NSLog(@"favorited");
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error when creating a favorite");
            }];
        }
        
    }
}

- (void)onRetweet:(id)sender event:(id)event{
    NSLog(@"Retweet");
    CGPoint touchPosition = [[[event allTouches] anyObject] locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchPosition];
    if (indexPath != nil){
        NSDictionary *tweet = [self.timeline objectAtIndex:indexPath.row];
        NSString *url = [NSString stringWithFormat:@"%@%@%@", @"https://api.twitter.com/1.1/statuses/retweet/",tweet[@"id"],@".json"];
        NSLog(@"url: %@", url);
        NSLog(@"tweet: %@", tweet[@"id"]);
        TwitterClient *client = [TwitterClient instance];
        
        [client retweetURL:url success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"retweeted successfully");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error retweeting");
        }];
        
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // here you can reload needful views, for example, tableView:
    [self.tableView reloadData];
}


-(void)loadData {
    TwitterClient *client = [TwitterClient instance];
    [self loadTimeline:client];
    [self.tableView reloadData];
}

- (void)loadTimeline:(TwitterClient *)client{
    [client homeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"loaded timeline with success");
        self.timeline = responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"homeTimeline response error");
        self.timeline = nil;
        
    }];
}

@end
