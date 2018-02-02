/*  HBRenamePresetController.m

 This file is part of the HandBrake source code.
 Homepage: <http://handbrake.fr/>.
 It may be used under the terms of the GNU General Public License. */

#import "HBRenamePresetController.h"

#import "HBPresetsManager.h"
#import "HBPreset.h"

@import HandBrakeKit;

@interface HBRenamePresetController () <NSTextFieldDelegate>

@property (nonatomic, strong) IBOutlet NSTextField *name;
@property (nonatomic, strong) IBOutlet NSButton *renameButton;

@property (nonatomic, strong) HBPreset *preset;
@property (nonatomic, strong) HBMutablePreset *mutablePreset;

@property (nonatomic, strong) HBPresetsManager *manager;

@end

@implementation HBRenamePresetController

- (instancetype)initWithPreset:(HBPreset *)preset presetManager:(HBPresetsManager *)manager
{
    self = [super initWithWindowNibName:@"HBRenamePresetController"];
    if (self)
    {
        NSParameterAssert(preset);
        _preset = preset;
        _mutablePreset = [preset mutableCopy];
        _manager = manager;
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    self.name.stringValue = self.name.placeholderString = self.preset.name;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controlTextDidChange:)
                                                 name:NSControlTextDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSControlTextDidChangeNotification object:nil];
}

- (void)controlTextDidChange:(NSNotification *)obj {
    self.renameButton.enabled = self.name.stringValue.length > 0 ? YES : NO;
}

- (IBAction)dismiss:(id)sender
{
    [self.window orderOut:nil];
    [NSApp endSheet:self.window returnCode:NSModalResponseCancel];
}

- (IBAction)rename:(id)sender
{
    if (self.name.stringValue.length == 0)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:NSLocalizedString(@"The preset name cannot be empty.", @"")];
        [alert setInformativeText:NSLocalizedString(@"Please enter a name.", @"")];
        [alert runModal];
    }
    else
    {
        HBMutablePreset *renamedPreset = self.mutablePreset;
        renamedPreset.name = self.name.stringValue;
        self.preset = [renamedPreset copy];

        [self.window orderOut:nil];
        [NSApp endSheet:self.window returnCode:NSModalResponseContinue];
    }
}


@end
