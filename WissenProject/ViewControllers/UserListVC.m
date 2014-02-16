//
//  UserListVC.m
//  WissenProject
//
//  Created by Suleyman Calik on 02/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import "UserListVC.h"
#import "NewMessageVC.h"
#import "WPAppDelegate.h"

#define SegueNewMessage @"NewMessageSegue"

@interface UserListVC ()
<UITableViewDataSource , UITableViewDelegate , UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblUsers;

@property(nonatomic,strong) NSArray * allUsers;
@property(nonatomic,strong) NSMutableArray * searchedUsers;
@property(nonatomic) BOOL searching;

@end

@implementation UserListVC


-(NSMutableArray *)searchedUsers
{
    if(!_searchedUsers)
        _searchedUsers = [NSMutableArray array];
    return _searchedUsers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WPAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.tabbar = self.tabBarController;
    [self.tblUsers setContentOffset:CGPointMake(0,44) animated:NO];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    WPUser * currentUser = [WPUser currentUser];
    if (currentUser)
    {
        [SVProgressHUD show];
        [currentUser refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            [self getAllUsers];
        }];
    }
    else
    {
        self.allUsers = nil;
        [self.tblUsers reloadData];
        
        [self performSegueWithIdentifier:SegueLogin sender:self];
    }

}



#pragma mark - Utility Methods

-(void)getUnreadMessageCount
{
    PFQuery * query = [WPMessage query];
    [query whereKey:@"to" equalTo:[WPUser currentUser]];
    [query whereKey:@"isRead" notEqualTo:@(YES)];
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error)
        {
            UITabBarItem * messagesItem = self.tabBarController.tabBar.items[2];
            if(number > 0)
                messagesItem.badgeValue = [NSString stringWithFormat:@"%d" , number];
            else
                messagesItem.badgeValue = nil;
        }
    }];
}

-(void)getAllUsers
{
    PFQuery * query = [WPUser query];
    
    WPUser * currentUser = [WPUser currentUser];
    [query whereKey:@"username" notEqualTo:currentUser.username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        [SVProgressHUD dismiss];
        if (error)
        {
            [self showAlertWithTitle:@"Oops" message:@"Cannot find other users!"];
        }
        else
        {
            self.allUsers = objects;
            [self.tblUsers reloadData];
            [self.tblUsers setContentOffset:CGPointMake(0,-20) animated:NO];
            
            [self getUnreadMessageCount];
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


#pragma mark - SearchBar Methods

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searching = YES;
}


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.searching = NO;
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchedUsers removeAllObjects];
    
    [self.allUsers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        WPUser * user = obj;
        NSRange range = [user.username rangeOfString:searchText options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch];
        if(range.location != NSNotFound)
        {
            [self.searchedUsers addObject:user];
        }
    }];
    
}



#pragma mark - TableView Methods


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.searching)
        return self.searchedUsers.count;
    else
        return self.allUsers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UserCell"];
    }
    WPUser * user;
    if(self.searching && self.searchedUsers.count > 0)
        user = self.searchedUsers[indexPath.row];
    else
        user = self.allUsers[indexPath.row];
    cell.textLabel.text = user.username;
    cell.detailTextLabel.text = user.updatedAt.description;
    
    if(user.image)
    {
        [cell.imageView setImage:user.image];
    }
    else
    {
        [cell.imageView setImage:nil];
        
        [user.photo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            user.image = [UIImage imageWithData:data];
            NSIndexPath * ip = [self.tblUsers indexPathForCell:cell];
            [self.tblUsers reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }
    
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:SegueNewMessage sender:indexPath];
}


@end
