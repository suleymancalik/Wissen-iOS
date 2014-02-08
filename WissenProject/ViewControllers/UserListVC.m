//
//  UserListVC.m
//  WissenProject
//
//  Created by Suleyman Calik on 02/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import "UserListVC.h"
#import "NewMessageVC.h"

#define SegueNewMessage @"NewMessageSegue"

@interface UserListVC ()
<UITableViewDataSource , UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblUsers;
@property(nonatomic,strong) NSArray * allUsers;
@end

@implementation UserListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    WPUser * currentUser = [WPUser currentUser];
    if (currentUser)
    {
        [self getAllUsers];
    }
    else
    {
        self.allUsers = nil;
        [self.tblUsers reloadData];
        
        [self performSegueWithIdentifier:SegueLogin sender:self];
    }

}



#pragma mark - Utility Methods


-(void)getAllUsers
{
    PFQuery * query = [WPUser query];
    
    WPUser * currentUser = [WPUser currentUser];
    [query whereKey:@"username" notEqualTo:currentUser.username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            [self showAlertWithTitle:@"Oops" message:@"Cannot find other users!"];
        }
        else
        {
            self.allUsers = objects;
            [self.tblUsers reloadData];
        }
    }];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SegueNewMessage])
    {
        if([sender isKindOfClass:[NSIndexPath class]])
        {
            NSIndexPath * indexpath = sender;
            WPUser * selectedUser = self.allUsers[indexpath.row];
            NewMessageVC * newMessageVC = segue.destinationViewController;
            newMessageVC.toUser = selectedUser;
        }
    }
}

#pragma mark - TableView Methods


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allUsers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    
    WPUser * user = self.allUsers[indexPath.row];
    cell.textLabel.text = user.username;
    cell.detailTextLabel.text = user.updatedAt.description;
    
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:SegueNewMessage sender:indexPath];
}


@end
