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

#define YOUTUBE_THUMBNAIL2  @"http://img.youtube.com/vi/%@/2.jpg"
- (void) preFetchThumbnails
{
    UIImage *dummy = [UIImage imageNamed:@"crimson.png"];
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    for (NSDictionary *entry in self.students) {
        NSString *videoID = [entry objectForKey:@"youtube"];
        UIImage *image = [[appDelegate imageCache] objectForKey:videoID];
        if (! image) {
            [[appDelegate imageCache] setObject:dummy forKey:videoID];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:YOUTUBE_THUMBNAIL2, videoID]];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    // TODO: if failed to fetch, remove dummy image from the cache.
                    [[appDelegate imageCache] setObject:image forKey:videoID];
                    [self.tableView reloadData];
                });
            });
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *title = @"CodingTogetherSummer2012";
    NSURL *url = [[NSBundle mainBundle] URLForResource:title withExtension:@"plist"];

    NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfURL:url];
    self.students = [plist objectForKey:@"students"];
    self.title = [plist objectForKey:@"description"];

    [self preFetchThumbnails];
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
   
    UIImage *dummy = [UIImage imageNamed:@"crimson.png"];
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    UIImage *image = [[appDelegate imageCache] objectForKey:videoID];
    if (image) { cell.imageView.image = image;}
    else {
        [[appDelegate imageCache] setObject:dummy forKey:videoID];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/2.jpg", videoID]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_sync(dispatch_get_main_queue(), ^{
                // TODO: if failed to fetch, remove dummy image from the cache.
                [[appDelegate imageCache] setObject:image forKey:videoID];
                cell.imageView.image = image;
                [self.tableView reloadData];
            });
        });
    }
    
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
