//
//  CCMoviePlayer.h
//
//  Created by sunxiaoyu on 13-4-12.
//

#include "CCMoviePlayer.h"
#import "MediaPlayer/MediaPlayer.h"
static void* delegate;
@interface CCMoivePlayerDelegate : NSObject
{
    
}
@property bool isFinsh;
-(id) init;
-(void) movieFinishedCallback:(id) _player;
@end
@implementation CCMoivePlayerDelegate
-(id)init
{
    if(self == [super init])
    {
        self.isFinsh = false;
    }
    return self;
}
-(void) movieFinishedCallback:(NSNotification*) aNotification
{
    MPMoviePlayerController *_player = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];    
    [[_player view] removeFromSuperview];
    [_player release];
    
    self.isFinsh = true;
}
@end

void CCMoviePlayer::playMovieWithFile(const char *_file)
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:[NSString stringWithFormat:@"%s",_file] ofType:@"mp4"];
    if (moviePath)
    {
        NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
        MPMoviePlayerController* theMovie = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
        [theMovie setControlStyle:MPMovieControlStyleNone];
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        [keyWindow addSubview: [theMovie view]];
        [[theMovie view] setHidden:NO];
        [[theMovie view] setFrame:CGRectMake( 0, 0, keyWindow.frame.size.width, keyWindow.frame.size.height)];
        [[theMovie view] setCenter:keyWindow.center];
        [theMovie play];
        
        delegate = [[CCMoivePlayerDelegate alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:(CCMoivePlayerDelegate*)delegate
                                                 selector:@selector(movieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:theMovie];
    }
}
bool CCMoviePlayer::getIsFinshed()
{
    if (delegate) {
        if ([(CCMoivePlayerDelegate*)delegate isFinsh]) {
            [(CCMoivePlayerDelegate*)delegate release];
            delegate = NULL;
            return true;
        }
    }
    return false;
}


