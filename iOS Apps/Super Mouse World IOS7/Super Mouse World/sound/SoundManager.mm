//
//  SoundManager.m
//

#import "SoundManager.h"
#include <sys/time.h>

@implementation SoundManager

static SoundManager *_sharedSound = nil;
static NSString* strEffectFiles[] =
{
	@"mono-CoinDrop-0.mp3",
    @"Limb-0.mp3",
    @"warning.mp3",
    @"mono-wow.mp3",
    @"jump.mp3",
    @"mono-gameover.mp3"
};

static NSString* strSoundFiles[] =
{
	@"menu.mp3",
    @"endstage.mp3",
    @"audio01.mp3",
    @"audio02.mp3",
    @"audio03.mp3",
    @"audio04.mp3"

};

+ (SoundManager*) sharedSoundManager 
{
	if (!_sharedSound) 
	{
		_sharedSound = [[SoundManager alloc] init];
	}
	
	return _sharedSound;
}

+ (void) releaseSoundManager 
{
	if (_sharedSound) 
	{
		[_sharedSound release];
		_sharedSound = nil;
	}
}

- (id) init
{
	if ( (self=[super init]) )
	{
		soundEngine = [SimpleAudioEngine sharedEngine];
		//[soundEngine setEffectsVolume: 0.02f];
		//[soundEngine setBackgroundMusicVolume: 0.02f];
		audioManager = [CDAudioManager sharedManager];
		mbEffectMute = NO;
		mbBackgroundMute = NO;
	}
	
	return self;
}

- (void) loadData
{
}

- (void) playRandomBackground
{
	int soundId = arc4random()%kBackgroundCount;
	[self playBackgroundMusic: soundId];
}

static unsigned int GetCurrentTime()
{
	struct timeval tv;
	gettimeofday(&tv, NULL);
	unsigned int ms = tv.tv_sec * 1000L + tv.tv_usec / 1000L;
	return ms;
}

- (void) playEffect: (int) effectId bForce: (BOOL) bForce
{
	if (effectId < 0 || effectId >= kEffectCount)
		return;
	if (mbEffectMute)
		return;
	
	[soundEngine playEffect:strEffectFiles[effectId]];
}

-(void) playBackgroundMusic:(int) soundId
{
	if (soundId < 0 || soundId >= kBackgroundCount)
		return;
	if (mbBackgroundMute)
		return;

	[soundEngine playBackgroundMusic:strSoundFiles[soundId] loop:TRUE];
}

-(void) playBackgroundMusic:(int) soundId bLoopState:(BOOL)bLoop
{
	if (soundId < 0 || soundId >= kBackgroundCount)
		return;
	if (mbBackgroundMute)
		return;
    
	[soundEngine playBackgroundMusic:strSoundFiles[soundId] loop:bLoop];
}


-(void) stopBackgroundMusic
{
	[soundEngine stopBackgroundMusic];
}

- (void) setBackgroundMusicMute: (BOOL) bMute
{
	mbBackgroundMute = bMute;

    if( bMute )
        [ self setBackgroundVolume:0.f ];
    else
        [ self setBackgroundVolume:1.f ];
}

- (void) setEffectMute: (BOOL) bMute
{
	mbEffectMute = bMute;
    if( bMute )
        [ self setEffectVolume:0.f ];
    else
        [ self setEffectVolume:1.f ];

}

- (BOOL) getBackgroundMusicMuted
{
	return mbBackgroundMute;
}

- (BOOL) getEffectMuted
{
	return mbEffectMute;
}

- (float) backgroundVolume
{
	return soundEngine.backgroundMusicVolume;
}

- (void) setBackgroundVolume: (float) fVolume
{
	soundEngine.backgroundMusicVolume = fVolume;
}

- (void) setEffectVolume: (float) fVolume
{
	soundEngine.effectsVolume = fVolume;
}

- (float) effectVolume
{
	return soundEngine.effectsVolume;
}

- (void) dealloc
{
	[super dealloc];
}
@end
