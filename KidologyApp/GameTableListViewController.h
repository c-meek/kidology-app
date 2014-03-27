//
//  GameTableListViewController.h
//  KidologyApp
//
//  Created by klimczak, andrew edward on 3/27/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameTableListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property NSArray *gameArray;
@end
