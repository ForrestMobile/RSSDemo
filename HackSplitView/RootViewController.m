//
//  RootViewController.m
//  HackSplitView
//
//  Created by Forrest Shi on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

#import "DetailViewController.h"
#import "ASIHTTPRequest.h"
#import "RSSParser.h"
#import "FeedItem.h"

@implementation RootViewController
		
@synthesize detailViewController;
@synthesize feedItems;

#pragma mark -
#pragma mark HTTP Response Handlers

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[request responseData]];
	RSSParser *rssParser = [[RSSParser alloc] init];
	xmlParser.delegate = rssParser;
	if ([xmlParser parse]) {
        //[self.feedItems release];
		self.feedItems = rssParser.feedItems;
	}	
	
	[rssParser release];
	[xmlParser release];
	[self.tableView reloadData];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"Error: %@", [error description]);
  //  rssRequestFailed = YES;
    [self.tableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    
    if (!feedItems) {
        //Attention : this autoreleased instance is dangerous !!! 
        //_itemsArray = [NSMutableArray array];
        //Need to do like this 
        feedItems = [[NSMutableArray alloc] init ];
    }
    
    // Load the Building43 RSS Feed
    NSURL *url = [NSURL URLWithString:@"http://building43.com/feed"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

		
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    		
}

		
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [feedItems count];
    
}

		
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell.
    FeedItem *item = (FeedItem*)[feedItems objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

+ (CGFloat) findLabelHeight:(NSString*) text font:(UIFont *)font label:(UILabel *)label {
    CGSize textLabelSize = CGSizeMake(label.frame.size.width, 9000.0f);
    CGSize stringSize = [text sizeWithFont:font constrainedToSize:textLabelSize lineBreakMode:UILineBreakModeWordWrap];
    return stringSize.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here -- for example, create and push another view controller.
    
//    if (!detailViewController) {
//        detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailView.xib" bundle:nil];
//    }
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     //[detailViewController release];
 
    if (detailViewController) {
        FeedItem *item = (FeedItem*)[feedItems objectAtIndex:indexPath.row];
        //detailViewController.detailItem = [item.content description];
        [detailViewController.webView loadHTMLString:item.content baseURL:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [feedItems release];
    [detailViewController release];
    [super dealloc];
}

@end
