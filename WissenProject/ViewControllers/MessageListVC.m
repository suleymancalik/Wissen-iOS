//
//  MessageListVC.m
//  WissenProject
//
//  Created by Suleyman Calik on 02/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import "MessageListVC.h"
#import "MessageDetailVC.h"

@interface MessageListVC ()
<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tblMessages;
@property (strong,nonatomic) NSArray * messages;
@property (strong,nonatomic) UIRefreshControl * pullToRefresh;

@end

@implementation MessageListVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pullToRefresh = [[UIRefreshControl alloc] init];
    [self.pullToRefresh addTarget:self
                           action:@selector(pulledForRefresh)
                 forControlEvents:UIControlEventValueChanged];
    [self.tblMessages addSubview:self.pullToRefresh];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.tabBarItem.badgeValue = nil;
    [self getMyMessages];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MessageDetailSegue"])
    {
        MessageDetailVC * detailVC = segue.destinationViewController;
        
        UITableViewCell * selectedCell = sender;
        if([selectedCell isKindOfClass:[UITableViewCell class]])
        {
            NSIndexPath * indexpath = [self.tblMessages indexPathForCell:selectedCell];
            detailVC.message = self.messages[indexpath.row];
        }
    }
    
}

#pragma mark - Utility Methods

-(void)pulledForRefresh
{
    [self getMyMessages];
}


-(void)getMyMessages
{
    PFQuery * query = [WPMessage query];
    [query includeKey:@"from"];
    [query whereKey:@"to" equalTo:[WPUser currentUser]];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.messages = objects;
        [self.tblMessages reloadData];
        
        [self.pullToRefresh endRefreshing];
    }];

}


#pragma mark - TableView Methods


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    
    WPMessage * message = self.messages[indexPath.row];
    

    cell.textLabel.text = message.text;
    cell.detailTextLabel.text = message.from.username;
    
    if(message.isRead)
    {
        cell.imageView.image = nil;
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"blue-dot"];
        message.isRead = YES;
        [message saveInBackground];
    }
    
    return cell;
}


@end
