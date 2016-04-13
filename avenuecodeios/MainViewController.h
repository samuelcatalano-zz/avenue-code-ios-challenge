//
//  MainViewController.h
//  avenuecodeios
//
//  Created by Samuel D. N. Catalano on 4/13/16.
//  Copyright © 2016 Avenue Code. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableViewCell.h"

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDelegate>

@property(nonatomic, weak) IBOutlet UITextField *searchText;
@property(nonatomic, weak) IBOutlet UIButton *btnSearch;
@property(nonatomic, weak) IBOutlet UITableView *tableView;

@end