//
//  FinalProjectsTableViewController.m
//  FinalProjectsViewer
//
//  Created by Norimasa Nabeta on 2012/08/31.
//  Copyright (c) 2012 Norimasa Nabeta. All rights reserved.
//

#import "FinalProjectsTableViewController.h"
#import "FinalProjectsYouTubeViewController.h"

#import "AppDelegate.h"

@interface FinalProjectsTableViewController ()
@property (nonatomic,strong) NSArray *students;
@end

@implementation FinalProjectsTableViewController
@synthesize students=_students;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *title = @"CodingTogetherSummer2012";
    NSURL *url = [[NSBundle mainBundle] URLForResource:title withExtension:@"plist"];

    NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfURL:url];
    self.students = [plist objectForKey:@"students"];
    self.title = [plist objectForKey:@"description"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.students count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Student Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *entry = [self.students objectAtIndex:indexPath.row];
    NSString *videoID   = [entry objectForKey:@"youtube"];
    NSString *appID     = [entry objectForKey:@"app"];
    cell.textLabel.text = [entry objectForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ [%@]", appID,videoID];
   
    UIImage *thumbnail = [UIImage imageWithData:[entry objectForKey:@"thumbnail"]];
    if (! thumbnail){
        thumbnail = [UIImage imageNamed:@"crimson.png"];
    }
    cell.imageView.image = thumbnail;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"Youtube Show"]) {
        [segue.destinationViewController setStudent:[self.students objectAtIndex:indexPath.row]];
    }
}


@end
