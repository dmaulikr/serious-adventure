//
//  SoundManager.h
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"

enum eEffects
{
	kMonoCoinDrop = 0,
    kLimb_0,
	kWarning,
    kMono_Wow,
    kJump,
    kbMono_GameOver,
    kEffectCount
};

enum eBackground
{
	kbMenu = 0,
    kbEndStage,
    kBAudio1,
    kBAudio2,
    kBAudio3,
    kBAudio4,
  	kBackgroundCount
};

@interface SoundManager : NSObject {
	SimpleAudioEngine *soundEngine;
	CDAudioManager* audioManager;
	
	BOOL mbBackgroundMute;
	BOOL mbEffectMute;
}

+ (SoundManager*) sharedSoundManager;
+ (void) releaseSoundManager;

- (id) init;

- (void) loadData;
- (void) playEffect: (int) effectId bForce: (BOOL) bForce;
- (void) playBackgroundMusic:(int) soundId;
-(void) playBackgroundMusic:(int) soundId bLoopState:(BOOL)bLoop;
- (void) stopBackgroundMusic;
- (void) playRandomBackground;

- (void) setBackgroundMusicMute: (BOOL) bMute;
- (void) setEffectMute: (BOOL) bMute;

- (BOOL) getBackgroundMusicMuted;
- (BOOL) getEffectMuted;

- (void) setBackgroundVolume: (float) fVolume;
- (void) setEffectVolume: (float) fVolume;

- (float) backgroundVolume;
- (float) effectVolume;
@end
