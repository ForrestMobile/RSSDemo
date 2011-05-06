//
//  RootViewController.h
//  HackSplitView
//
//  Created by Forrest Shi on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface RootViewController : UITableViewController {
    NSMutableArray  *feedItems;
}

		
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) NSMutableArray  *feedItems;
@end
