//
//  TweetsViewController.m
//  Twitter
//
//  Created by Stephani Alves on 6/28/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import "TweetsViewController.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import <AFNetworking/UIKit+AFNetworking.h>

@interface TweetsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TweetsViewController

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
    // Do any additional setup after loading the view from its nib.
    
    //load personalized cell
    //registration process
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    //set row height
    self.tableView.rowHeight = 120;
    
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
    NSLog(@"tweet: %@", tweet);
    cell.name_label.text = tweet[@"user"][@"name"];
    NSMutableString *screen_name = [[NSMutableString alloc]init];
    [screen_name appendString:@"@"];
    [screen_name appendString:tweet[@"user"][@"screen_name"]];
    
    cell.screen_name_label.text = screen_name;
    NSString *profile_image_url = tweet[@"user"][@"profile_image_url"];
    [cell.profile_image_view setImageWithURL: [NSURL URLWithString:profile_image_url]];
    
    cell.text_label.text = tweet[@"text"];
    
    cell.timestamp_label.text = [self retrivePostTime:tweet[@"created_at"]];
    
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

@end
