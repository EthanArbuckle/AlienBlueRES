#import <UIKit/UIKit.h>

@interface RedditAPI : NSObject 
@property(assign) int karmaComment;
@property(assign) int karmaLink;
@property(assign) BOOL hasModMail;
@property(assign) BOOL hasMail;
@property(retain) NSString* authenticatedUser;
@property(retain) NSString* cookie;
@property(retain) NSString* modhash;
@end

@interface AlienBlueAppDelegate : NSObject
@property(retain) RedditAPI* redditAPI;
@end

@interface OptionTableViewController : UIViewController
@end

@interface UserDetailsViewController : OptionTableViewController <UITextFieldDelegate> {
	NSString* username;
}
-(id)createLabelForIndexPath:(id)indexPath;
-(void)createInteractionForIndexPath:(id)indexPath forOption:(id)option;
-(int)calculateNumberOfRowsInSection:(int)section;
-(void)didChoosePrimaryOptionAtIndexPath:(id)indexPath;
-(void)tableView:(id)view willDisplayCell:(id)cell forRowAtIndexPath:(id)indexPath;
-(id)tableView:(id)view cellForRowAtIndexPath:(id)indexPath;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
@property(retain) NSString* username;
@end

@interface JMOutlineViewController : UIViewController
@end
 
@interface ABOutlineViewController : JMOutlineViewController
@end
 
@interface RedditsViewController : ABOutlineViewController
-(id)titleForUserProfileSection;
@end
///////////////////////////////////////////////////////////////////////////////////////////////
// 'Add as Friend' option || User Tagging
///////////////////////////////////////////////////////////////////////////////////////////////
%hook UserDetailsViewController

-(int)calculateNumberOfRowsInSection:(int)section {
	if (section == 0) {
		return 5;
	}
	return %orig;
}

-(id)createLabelForIndexPath:(NSIndexPath *)indexPath {
	if ((indexPath.section == 0) && (indexPath.row == 3)) {
		return @"Add as Friend";
	}
	if ((indexPath.section == 0) && (indexPath.row == 4)) {
		return @"Tag: ";
	}
	return %orig;
}

-(void)tableView:(id)view willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ((indexPath.section == 0) && (indexPath.row == 3)) {
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(friendCellTapped)];
		[tap setNumberOfTapsRequired:1];
		[cell addGestureRecognizer:tap];
	}
	else if ((indexPath.section == 0) && (indexPath.row == 4)) {
		UITextField *tagBox = [[UITextField alloc] initWithFrame:CGRectMake(50, 6, 225, 25)];
		[tagBox setBorderStyle:UITextBorderStyleRoundedRect];
		[tagBox setReturnKeyType:UIReturnKeyDone];
		tagBox.delegate = self; //that doest work worth shit
		[cell addSubview:tagBox];
	}
	else {
		%orig;
	}
}

-(id)tableView:(id)view cellForRowAtIndexPath:(id)indexPath {
	UITableViewCell *cell = [(UITableView *)view cellForRowAtIndexPath:indexPath];
		for (id sub in [cell.contentView subviews]) {
			return cell;
		}
	return %orig;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	NSLog(@"i hope i see this");
}

%new(v@:)
- (void)friendCellTapped {
	//TODO: Add api crap
}
%end
///////////////////////////////////////////////////////////////////////////////////////////////
// Show full karma numbers
///////////////////////////////////////////////////////////////////////////////////////////////
%hook RedditsViewController
 
-(id)titleForUserProfileSection {
    RedditAPI *adAPI = [(AlienBlueAppDelegate *)[[UIApplication sharedApplication] delegate] redditAPI];
    int ckarma = [adAPI karmaComment];
    int lkarma = [adAPI karmaLink];
    NSString *user = [adAPI authenticatedUser];
    return [NSString stringWithFormat:@"%@ (%d : %d)", user, lkarma, ckarma];
}
 
%end



