//
//  SVPrefsWindowController.m
//  Ascension
//
//  Coded by Stefan Vogt.
//  Released under the FreeBSD license.
//  http://www.byteproject.net
//

#import "SVPrefsWindowController.h"
static SVPrefsWindowController *_sharedPrefsWindowController = nil;

@implementation SVPrefsWindowController

# pragma mark -
# pragma mark class methods

+ (SVPrefsWindowController *)sharedPrefsWindowController
{
	if (!_sharedPrefsWindowController) {
		_sharedPrefsWindowController = [[self alloc] initWithWindowNibName:[self nibName]];
	}
	return _sharedPrefsWindowController;
}

+ (NSString *)nibName
{
	return @"Preferences";
}

# pragma mark -
# pragma mark initialization

- (void)awakeFromNib
{
	// Configure the preferences window.
	[self.window setContentSize:[generalPreferenceView frame].size];
	[[self.window contentView] addSubview:generalPreferenceView];
	[prefsBar setSelectedItemIdentifier:@"General"];
	[self.window center];
}

# pragma mark -
# pragma mark view methods

- (NSView *)viewForTag:(NSInteger)tag 
{
    // Helper method for our Preferences window controller.
	NSView *view = nil;
	
	switch(tag) {
		case 0: default: view = generalPreferenceView; break;
		case 1: view = advancedPreferenceView; break;
		case 2: view = colorsPreferenceView; break;
	}
    return view;
}

- (NSRect)newFrameForNewContentView:(NSView *)view 
{
	// Calculates the window frame based on the new view.
    NSRect newFrameRect = [self.window frameRectForContentRect:[view frame]];
    NSRect oldFrameRect = [self.window frame];
    NSSize newSize = newFrameRect.size;
    NSSize oldSize = oldFrameRect.size;    
    NSRect frame = [self.window frame];
    frame.size = newSize;
	frame.origin.y -= (newSize.height - oldSize.height);
    
    return frame;
}

- (IBAction)switchView:(id)sender 
{	
	// Changes the view based on the view tag.
	NSInteger tag = [sender tag];
	
	NSView *view = [self viewForTag:tag];
	NSView *previousView = [self viewForTag:currentViewTag];
	currentViewTag = tag;
	NSRect newFrame = [self newFrameForNewContentView:view];
	
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0.1];
	
	if ([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask)
	    [[NSAnimationContext currentContext] setDuration:1.0];
	
	[[[self.window contentView] animator] replaceSubview:previousView with:view];
	[[self.window animator] setFrame:newFrame display:YES];
	
	[NSAnimationContext endGrouping];
}

# pragma mark -
# pragma mark appearance

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar 
{
	return [[toolbar items] valueForKey:@"itemIdentifier"];
}

@end