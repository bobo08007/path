//
//  EventsVC.m
//  Pathways
//
//  Created by iMac on 23/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventsVC.h"
#import "EventCell.h"
#import "Three20.h"
#import "ShadowView.h"
#import "FTAnimation.h"
#import "DropDownView.h"
#import "GlobalSettings.h"

#define kSegmentedControlHeight 40.0
#define kLabelHeight			20.0
#define kLeftMargin				20.0
#define kTopMargin				20.0
#define kRightMargin			20.0
#define kTweenMargin			10.0

#define kTextFieldHeight		30.0

static UIImage *selected_image = nil;
static UIImage *unSelected_image = nil;

@interface EventsVC ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation EventsVC
+(void)initialize{
	selected_image = [[UIImage imageNamed:@"pobut_select.png"] retain];
	unSelected_image = [[UIImage imageNamed:@"pobut_normal.png"] retain];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
 
    }
    return self;
}
NSString *up = @"▴";
NSString *down = @"▾";
NSString *tick = @"✓";
- (void)viewDidLoad {
   [super viewDidLoad];
	self.title = @"Events";
	self.view.backgroundColor = TTSTYLEVAR(screenBackgroundColor);
	UIImage *logoImage = [UIImage imageNamed:@"smallogo2.png"];
	UIImageView *logoView = [[UIImageView alloc] initWithImage:logoImage];
	logoView.frame = CGRectMake(0, 0, logoImage.size.width, 44);
	
	UIBarButtonItem* camera = [[UIBarButtonItem alloc] initWithCustomView:logoView];
	[self.navigationItem setRightBarButtonItem:camera animated:YES];
	[camera release];
	[logoView release];
	
	tableView.separatorColor	= [GlobalSettings cellSeperatorColor];
	tableView.backgroundColor	= [GlobalSettings appBackgroundColor];
	tableView.rowHeight		= [GlobalSettings customTableViewRowHeight];
	
	
	headerView = [[ShadowView alloc] initWithFrame:CGRectMake(0, 2, 250, 40)];
	dropDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[dropDownButton addTarget:self action:@selector(dropDownButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	UIImage *ddimage = [UIImage imageNamed:@"drop_down.png"];
	dropDownButton.frame = CGRectMake(60, (CGRectGetHeight(headerView.frame)-ddimage.size.height)/2, ddimage.size.width, ddimage.size.height);
	[dropDownButton setBackgroundImage:ddimage forState:UIControlStateNormal];
	[dropDownButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[dropDownButton setTitle:@"City" forState:UIControlStateNormal];
	dropDownButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
	[headerView addSubview:dropDownButton];
	
	CGRect frame = CGRectMake(0, 0, 60, 40);

	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.textAlignment = UITextAlignmentLeft;
	label.text = @"Sort By:";
	label.font = [UIFont boldSystemFontOfSize:15];
	label.textColor = [UIColor whiteColor];
	label.shadowOffset = [GlobalSettings labelShadowOffset];
	label.shadowColor = [GlobalSettings labelShadowColor];
	label.backgroundColor = [UIColor clearColor];
	[headerView addSubview:label];	
	[label release];

	self.navigationItem.titleView = headerView;
}

-(void)viewWillAppear:(BOOL)animated{
	self.navigationController.navigationBar.tintColor = TTSTYLEVAR(navigationBarTintColor);	
}
-(void)dropDownButtonAction:(id)sender{
	if(!dropDownView){
		UIImage *ddimage = [UIImage imageNamed:@"pobg.png"];
		dropDownView = [[DropDownView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-ddimage.size.width)/2, -8, ddimage.size.width, ddimage.size.height)];
		dropDownView.backgroundColor = [UIColor clearColor];
		[dropDownView setImage:ddimage];
		[self.view addSubview:dropDownView];
		
		float yPadding = 33;
		float xPadding = 27;
		{		
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			button.frame = CGRectMake(xPadding, yPadding, selected_image.size.width, selected_image.size.height);
			[button setBackgroundImage:selected_image forState:UIControlStateNormal];
			[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			[button setTitle:@"City" forState:UIControlStateNormal];
			button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
			[button addTarget:self action:@selector(dropDownViewButtonActios:) forControlEvents:UIControlEventTouchUpInside];
			button.tag = 1;
			[dropDownView addSubview:button];
			
		}
		{
			yPadding += 53;
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			button.frame = CGRectMake(xPadding, yPadding, selected_image.size.width, selected_image.size.height);
			[button setBackgroundImage:unSelected_image forState:UIControlStateNormal];
			[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[button setTitle:@"History" forState:UIControlStateNormal];
			button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
			[button addTarget:self action:@selector(dropDownViewButtonActios:) forControlEvents:UIControlEventTouchUpInside];
			button.tag = 2;
			[dropDownView addSubview:button];
			
		}
		
		{
			yPadding += 53;

			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			button.frame = CGRectMake(xPadding, yPadding, selected_image.size.width, selected_image.size.height);
			[button setBackgroundImage:unSelected_image forState:UIControlStateNormal];
			[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[button setTitle:@"Future" forState:UIControlStateNormal];
			button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
			[button addTarget:self action:@selector(dropDownViewButtonActios:) forControlEvents:UIControlEventTouchUpInside];
			button.tag = 3;
			[dropDownView addSubview:button];
			
		}
		
	}
	tableView.userInteractionEnabled = NO;
	[dropDownView popIn:0.3 delegate:nil];

}
-(void)dropDownViewButtonActios:(UIButton*)button{

	
	for (UIButton *btn in dropDownView.subviews) {
		if([btn backgroundImageForState:UIControlStateNormal] != unSelected_image){
			[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];		
			[btn setBackgroundImage:unSelected_image forState:UIControlStateNormal];
			break;
		}
	}

	[button setBackgroundImage:selected_image forState:UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		
	[dropDownButton setTitle:[button titleForState:UIControlStateNormal] forState:UIControlStateNormal];

	[dropDownView popOut:0.3 delegate:nil];
	tableView.userInteractionEnabled = YES;
	//TODO : SORT ACtion
}
//TableView
//////////////////////////////////////////////////////

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 20;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	
	UILabel *categoryNameLabel = (UILabel *)[cell.contentView viewWithTag:2];
	categoryNameLabel.text = [NSString stringWithFormat:@"Event Name %d",indexPath.row];
	
	UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:3];
	dateLabel.text = [[GlobalSettings dateFormatter] stringFromDate:[NSDate date]];
	dateLabel.alpha = 0.85;
	
	UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:4];
	titleLabel.text = [NSString stringWithFormat:@"Event City %d",indexPath.row];;
	
	UILabel *contentLabel = (UILabel *)[cell.contentView viewWithTag:5];
	contentLabel.text = [NSString stringWithFormat:@"This overview of the Pathway to Excellence Program web-based narrated course is a great way to explain Pathway to Excellence to leadership and key staff at your hospital. "];;
	
}
- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell;
	UILabel *categoryNameLabel ;
	UILabel *titleLabel ;
	UILabel *contentLabel;
		
	static NSString *CellIdentifier = @"Cell";
	
	CGPoint sPoint = CGPointMake(30, 3);
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[EventCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
			
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			
			categoryNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(sPoint.x , sPoint.y, 150, 15)];
		//	categoryNameLabel.autoresizingMask =	UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
			categoryNameLabel.font				= [GlobalSettings cellLableFont];
			categoryNameLabel.shadowOffset    = [GlobalSettings labelShadowOffset];
			categoryNameLabel.textColor			=	[GlobalSettings labelReadContentColor];
			categoryNameLabel.backgroundColor = [UIColor clearColor];
			categoryNameLabel.textAlignment   = UITextAlignmentLeft;
			categoryNameLabel.contentMode = UIViewContentModeTopLeft;
			categoryNameLabel.numberOfLines = 2;
			categoryNameLabel.tag = 2;
			[cell.contentView addSubview:categoryNameLabel];
			[categoryNameLabel release];
			
			UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(200 , sPoint.y,120, 30)];
			dateLabel.autoresizingMask	=	UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
			dateLabel.font				=	[GlobalSettings textFieldFont];
			dateLabel.textColor			=	[GlobalSettings labelUnReadContentColor];
			dateLabel.shadowColor		=	[GlobalSettings labelTextColor];
			dateLabel.shadowOffset		=	[GlobalSettings labelShadowOffset];
			dateLabel.backgroundColor	=	[UIColor clearColor];
			dateLabel.textAlignment		=	UITextAlignmentRight;
			dateLabel.contentMode = UIViewContentModeCenter;
			dateLabel.tag = 3;
			[cell.contentView addSubview:dateLabel];
			[dateLabel release];
			
			
			sPoint.y += CGRectGetHeight(categoryNameLabel.frame);
			
			titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(sPoint.x,sPoint.y , 320-sPoint.x +5, 20)];
			//titleLabel.autoresizingMask =	UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
			titleLabel.font				= [GlobalSettings cellLableFont];
			titleLabel.shadowOffset    = [GlobalSettings labelShadowOffset];
			titleLabel.textColor			=	[GlobalSettings labelUnReadContentColor];
			titleLabel.lineBreakMode	= UILineBreakModeWordWrap;
			titleLabel.backgroundColor = [UIColor clearColor];
			titleLabel.textAlignment   = UITextAlignmentLeft;
			titleLabel.contentMode = UIViewContentModeCenter;
			titleLabel.numberOfLines = 2;
			titleLabel.tag = 4;
			[cell.contentView addSubview:titleLabel];
			[titleLabel release];
			
			sPoint.y += CGRectGetHeight(titleLabel.frame);
			
			contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(sPoint.x, sPoint.y, 320-sPoint.x, tableView.rowHeight - CGRectGetMaxY(titleLabel.frame) -2)];
		//	contentLabel.autoresizingMask =	UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
			contentLabel.font           = [GlobalSettings textFieldFont];
			contentLabel.textColor		=	[GlobalSettings labelUnReadContentColor];
			contentLabel.backgroundColor= [UIColor clearColor];
			contentLabel.textAlignment  = UITextAlignmentLeft;
			contentLabel.lineBreakMode	= UILineBreakModeTailTruncation;
			contentLabel.contentMode = UIViewContentModeTop;
			contentLabel.numberOfLines = 3;
			contentLabel.tag = 5;
			[cell.contentView addSubview:contentLabel];
			[contentLabel release];
	}
	
	[self configureCell:cell atIndexPath:indexPath];
	
	
	return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
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
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}





///////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	SS_RELEASE_SAFELY(tableView);
	SS_RELEASE_SAFELY(headerView);
	SS_RELEASE_SAFELY(dropDownView);	
    [super dealloc];
}


@end
