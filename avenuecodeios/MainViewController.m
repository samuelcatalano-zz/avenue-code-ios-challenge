//
//  MainViewController.m
//  avenuecodeios
//
//  Created by Samuel D. N. Catalano on 4/13/16.
//  Copyright © 2016 Avenue Code. All rights reserved.
//

#import "MainViewController.h"
#import "CustomTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "Constants.h"

@interface MainViewController ( )

@end

@implementation MainViewController

NSArray *itemsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableview Delegate and Datasource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (itemsArray != nil) {
        return [[itemsArray objectAtIndex:0] count];
    }
    else {
        return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"CustomTableViewCell";
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (itemsArray != nil) {
        NSArray *data = [itemsArray objectAtIndex:0];
        NSDictionary *dictionary = [data objectAtIndex:indexPath.row];
        cell.itemDescriptionLabel.text = [dictionary objectForKey:@"lf"];
    }

    return cell;
}

- (IBAction)btnClicked:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *value = [[NSString alloc]initWithString:_searchText.text];
    NSString *acronym = URLToJSONNactem;
    acronym = [acronym stringByAppendingString:value];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    __block NSMutableDictionary *innerJson;
    NSURL *URL = [NSURL URLWithString:acronym];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                                           message:@"This acronym/initialism does not exist"
                                                                           delegate:self
                                                                           cancelButtonTitle:@"OK"
                                                                           otherButtonTitles:nil];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [alert show];
            
            // If you're not using ARC, you will need to release the alert view.
            // [alert release];
        } else {
            if (response) {
                NSError *error1;
                innerJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error1];
            }
            
            if (innerJson.count == 0) {
                NSLog(@"Error: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                                               message:@"This acronym/initialism does not exist"
                                                                               delegate:self
                                                                               cancelButtonTitle:@"OK"
                                                                               otherButtonTitles:nil];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [alert show];
                return;
            }
            else {
                itemsArray = [[NSMutableArray alloc] init];
                itemsArray = [innerJson valueForKey:@"lfs"];
                
                [_tableView reloadData];
                [_tableView setHidden:FALSE];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }
    }];
    [dataTask resume];
    
}

@end
