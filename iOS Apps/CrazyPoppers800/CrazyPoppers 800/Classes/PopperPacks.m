//
//  PopperPacks.m
//  CrazyPlay
//
//  Created by Alan Trippe on 2/23/12.
//  Copyright (c) 2012 Trippin' Software. All rights reserved.
//
//


#import "PopperPacks.h"
#import "CrazyPoppersLevels.h"
#import "SimpleAudioEngine.h"
#import "Reachability.h"
#import "Flurry.h"


// Popper Packs implementation
@implementation PopperPacks 

-(id) init {
	
	if( (self=[super init])) {
	}
	return self;
}

+(void) returnLevelID:(NSString *)LevelID {
    
    [[NSUserDefaults standardUserDefaults] setObject:LevelID forKey:@"levelID_request"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void) returnMaxTaps:(int)taps {
    
    [[NSUserDefaults standardUserDefaults] setInteger:taps forKey:@"maxTaps_request"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void) returnHints:(int)h1 h2:(int)h2 h3:(int)h3 h4:(int)h4 h5:(int)h5 h6:(int)h6 h7:(int)h7 h8:(int)h8 h9:(int)h9 h10:(int)h10 {
    
    [[NSUserDefaults standardUserDefaults] setInteger:h1 forKey:@"hint1_request"];
    [[NSUserDefaults standardUserDefaults] setInteger:h2 forKey:@"hint2_request"];
    [[NSUserDefaults standardUserDefaults] setInteger:h3 forKey:@"hint3_request"];
    [[NSUserDefaults standardUserDefaults] setInteger:h4 forKey:@"hint4_request"];
    [[NSUserDefaults standardUserDefaults] setInteger:h5 forKey:@"hint5_request"];
    [[NSUserDefaults standardUserDefaults] setInteger:h6 forKey:@"hint6_request"];
    [[NSUserDefaults standardUserDefaults] setInteger:h7 forKey:@"hint7_request"];
    [[NSUserDefaults standardUserDefaults] setInteger:h8 forKey:@"hint8_request"];
    [[NSUserDefaults standardUserDefaults] setInteger:h9 forKey:@"hint9_request"];
    [[NSUserDefaults standardUserDefaults] setInteger:h10 forKey:@"hint10_request"];
}

+(void) loadPack2:(int)pack level:(int)level {
    
    if (level == 1) {
        [self returnLevelID:@"222132212122101032303012023023"];
        [self returnMaxTaps:2];
        [self returnHints:33 h2:35 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 2) {
        [self returnLevelID:@"403320212113021233331200130303"];
        [self returnMaxTaps:3];
        [self returnHints:24 h2:54 h3:36 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 3) {
        [self returnLevelID:@"002223031220233233222230213302"];
        [self returnMaxTaps:3];
        [self returnHints:23 h2:34 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 4) {
        [self returnLevelID:@"101022201132320200131003133312"];
        [self returnMaxTaps:2];
        [self returnHints:43 h2:54 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 5) {
        [self returnLevelID:@"001302002134302002132120312201"];
        [self returnMaxTaps:3];
        [self returnHints:44 h2:14 h3:26 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 6) {
        [self returnLevelID:@"312122310230302230320310030010"];
        [self returnMaxTaps:3];
        [self returnHints:22 h2:24 h3:52 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 7) {
        [self returnLevelID:@"300230300200311110301100112313"];
        [self returnMaxTaps:1];
        [self returnHints:32 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 8) {// 1.01
        [self returnLevelID:@"310000003002323101100131031321"];
        [self returnMaxTaps:4];
        [self returnHints:34 h2:12 h3:32 h4:11 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 9) {
        [self returnLevelID:@"322324012242002002021013202322"];
        [self returnMaxTaps:3];
        [self returnHints:45 h2:33 h3:16 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 10) {
        [self returnLevelID:@"211403202242350142302100300321"];
        [self returnMaxTaps:5];
        [self returnHints:35 h2:35 h3:35 h4:23 h5:23 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 11) {
        [self returnLevelID:@"313213220020100201013331333012"];
        [self returnMaxTaps:4];
        [self returnHints:46 h2:15 h3:25 h4:42 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 12) {
        [self returnLevelID:@"123023122101340332112311022030"];
        [self returnMaxTaps:3];
        [self returnHints:24 h2:43 h3:13 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 13) {
        [self returnLevelID:@"321330112122103022200203001301"];
        [self returnMaxTaps:2];
        [self returnHints:22 h2:46 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 14) {
        [self returnLevelID:@"002100421302200022302223010333"];
        [self returnMaxTaps:5];
        [self returnHints:23 h2:54 h3:56 h4:44 h5:44 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 15) {
        [self returnLevelID:@"432222320010114253042011221401"];
        [self returnMaxTaps:4];
        [self returnHints:45 h2:32 h3:22 h4:34 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 16) {
        [self returnLevelID:@"101302031033000321332200113131"];
        [self returnMaxTaps:4];
        [self returnHints:23 h2:52 h3:35 h4:35 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 17) {
        [self returnLevelID:@"240232200232120330222201231002"];
        [self returnMaxTaps:4];
        [self returnHints:24 h2:24 h3:32 h4:32 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 18) {
        [self returnLevelID:@"012032320221320213012132033222"];
        [self returnMaxTaps:2];
        [self returnHints:44 h2:34 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 19) {
        [self returnLevelID:@"322324012242002002021013202322"];
        [self returnMaxTaps:3];
        [self returnHints:45 h2:33 h3:16 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 20) {
        [self returnLevelID:@"011220223334232001021321111211"];
        [self returnMaxTaps:2];
        [self returnHints:36 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 21) {
        [self returnLevelID:@"111030023312101200120212223132"];
        [self returnMaxTaps:2];
        [self returnHints:33 h2:25 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 22) {
        [self returnLevelID:@"032202131032313333013101002200"];
        [self returnMaxTaps:3];
        [self returnHints:44 h2:32 h3:23 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 23) {
        [self returnLevelID:@"321330112122103022200203001301"];
        [self returnMaxTaps:2];
        [self returnHints:25 h2:25 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 24) { // 1.01
        [self returnLevelID:@"230012000300012202330213003322"];
        [self returnMaxTaps:4];
        [self returnHints:24 h2:44 h3:33 h4:33 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 25) {
        [self returnLevelID:@"101313032233413522322111012332"];
        [self returnMaxTaps:3];
        [self returnHints:44 h2:35 h3:31 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 26) {
        [self returnLevelID:@"300223243230021042300011113022"];
        [self returnMaxTaps:5];
        [self returnHints:55 h2:24 h3:23 h4:32 h5:32 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 27) {
        [self returnLevelID:@"240232200232120330222201231002"];
        [self returnMaxTaps:4];
        [self returnHints:24 h2:24 h3:32 h4:32 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 28) {
        [self returnLevelID:@"012032320221320213012132033222"];
        [self returnMaxTaps:2];
        [self returnHints:44 h2:34 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 29) {
        [self returnLevelID:@"321230200200310322203200032003"];
        [self returnMaxTaps:5];
        [self returnHints:32 h2:24 h3:24 h4:34 h5:53 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 30) {
        [self returnLevelID:@"010212200311011023003132100013"];
        [self returnMaxTaps:1];
        [self returnHints:33 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 31) {
        [self returnLevelID:@"112333121231333202322421300331"];
        [self returnMaxTaps:4];
        [self returnHints:11 h2:34 h3:34 h4:43 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 32) {
        [self returnLevelID:@"403011312322100100011323121012"];
        [self returnMaxTaps:2];
        [self returnHints:42 h2:11 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 33) { // 1.01
        [self returnLevelID:@"303101123223224133043222221003"];
        [self returnMaxTaps:5];
        [self returnHints:16 h2:34 h3:25 h4:23 h5:32 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 34) {
        [self returnLevelID:@"213101104110321331303322021132"];
        [self returnMaxTaps:3];
        [self returnHints:36 h2:53 h3:33 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 35) {
        [self returnLevelID:@"001211020113200310420042232111"];
        [self returnMaxTaps:2];
        [self returnHints:35 h2:31 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 36) {
        [self returnLevelID:@"220304222032011212334013330002"];
        [self returnMaxTaps:3];
        [self returnHints:33 h2:25 h3:42 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 37) {
        [self returnLevelID:@"311233103312133100033202000110"];
        [self returnMaxTaps:3];
        [self returnHints:34 h2:44 h3:42 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 38) {
        [self returnLevelID:@"201110002321112101032010002101"];
        [self returnMaxTaps:1];
        [self returnHints:34 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 39) {
        [self returnLevelID:@"131133212011030133132233023213"];
        [self returnMaxTaps:1];
        [self returnHints:25 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 40) {
        [self returnLevelID:@"111301313231030323000341001103"];
        [self returnMaxTaps:5];
        [self returnHints:13 h2:46 h3:44 h4:44 h5:44 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 41) {
        [self returnLevelID:@"101032213330124211312200321021"];
        [self returnMaxTaps:2];
        [self returnHints:35 h2:44 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 42) {
        [self returnLevelID:@"333323102223331022323033011200"];
        [self returnMaxTaps:3];
        [self returnHints:53 h2:24 h3:25 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 43) {
        [self returnLevelID:@"302321101031331201333200222210"];
        [self returnMaxTaps:3];
        [self returnHints:21 h2:43 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 44) {
        [self returnLevelID:@"003232203222211000131320020222"];
        [self returnMaxTaps:3];
        [self returnHints:32 h2:24 h3:26 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 45) {
        [self returnLevelID:@"312331212212012233320322332120"];
        [self returnMaxTaps:2];
        [self returnHints:22 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 46) {
        [self returnLevelID:@"320321012330032330332232022115"];
        [self returnMaxTaps:5];
        [self returnHints:54 h2:44 h3:33 h4:23 h5:24 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 47) {
        [self returnLevelID:@"211111121235123223304301301302"];
        [self returnMaxTaps:4];
        [self returnHints:31 h2:24 h3:34 h4:34 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 48) {
        [self returnLevelID:@"323013023000032111120200120120"];
        [self returnMaxTaps:2];
        [self returnHints:34 h2:32 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 49) {
        [self returnLevelID:@"000112002311134120322021300230"];
        [self returnMaxTaps:4];
        [self returnHints:34 h2:43 h3:43 h4:42 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 50) {
        [self returnLevelID:@"321112001303320232333323122202"];
        [self returnMaxTaps:4];
        [self returnHints:13 h2:44 h3:34 h4:34 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 51) {
        [self returnLevelID:@"340321202202210223033322111123"];
        [self returnMaxTaps:4];
        [self returnHints:54 h2:32 h3:14 h4:24 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 52) {
        [self returnLevelID:@"232211232313112032201231102220"];
        [self returnMaxTaps:2];
        [self returnHints:32 h2:26 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 53) {
        [self returnLevelID:@"003003200002301201322102320310"];
        [self returnMaxTaps:5];
        [self returnHints:55 h2:33 h3:43 h4:13 h5:16 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 54) {
        [self returnLevelID:@"010123320102032020030121100003"];
        [self returnMaxTaps:4];
        [self returnHints:14 h2:56 h3:33 h4:32 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 55) {
        [self returnLevelID:@"200222243354011233312210313322"];
        [self returnMaxTaps:3];
        [self returnHints:24 h2:34 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 56) {
        [self returnLevelID:@"415321302322022132420211122131"];
        [self returnMaxTaps:3];
        [self returnHints:33 h2:23 h3:23 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 57) {
        [self returnLevelID:@"252133022312413233232010232321"];
        [self returnMaxTaps:4];
        [self returnHints:25 h2:14 h3:24 h4:33 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 58) {
        [self returnLevelID:@"200301200212220321000330111113"];
        [self returnMaxTaps:2];
        [self returnHints:25 h2:35 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 59) {
        [self returnLevelID:@"102020301321113220312310223120"];
        [self returnMaxTaps:2];
        [self returnHints:42 h2:23 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 60) {
        [self returnLevelID:@"001132303231232120223121312233"];
        [self returnMaxTaps:2];
        [self returnHints:34 h2:35 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 61) {
        [self returnLevelID:@"011102011002230201020200232030"];
        [self returnMaxTaps:3];
        [self returnHints:42 h2:42 h3:22 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 62) {
        [self returnLevelID:@"332213202230232211103200100021"];
        [self returnMaxTaps:3];
        [self returnHints:23 h2:23 h3:35 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 63) {
        [self returnLevelID:@"032211303133101000021122030010"];
        [self returnMaxTaps:1];
        [self returnHints:43 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 64) {
        [self returnLevelID:@"141413312303020200421313213122"];
        [self returnMaxTaps:2];
        [self returnHints:43 h2:23 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 65) {
        [self returnLevelID:@"213401222322323103200002012032"];
        [self returnMaxTaps:4];
        [self returnHints:34 h2:23 h3:23 h4:22 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 66) {
        [self returnLevelID:@"301123233333322204022002113201"];
        [self returnMaxTaps:4];
        [self returnHints:14 h2:52 h3:42 h4:43 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 67) {
        [self returnLevelID:@"020231023313401031023002111331"];
        [self returnMaxTaps:4];
        [self returnHints:53 h2:33 h3:35 h4:35 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 68) {
        [self returnLevelID:@"232023303341330203122213222231"];
        [self returnMaxTaps:5];
        [self returnHints:26 h2:45 h3:34 h4:34 h5:43 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 69) {
        [self returnLevelID:@"230221103313000222022202232123"];
        [self returnMaxTaps:3];
        [self returnHints:44 h2:44 h3:53 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 70) {
        [self returnLevelID:@"112212112210032320303212012303"];
        [self returnMaxTaps:2];
        [self returnHints:22 h2:34 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 71) {
        [self returnLevelID:@"021230020312131221033331331112"];
        [self returnMaxTaps:3];
        [self returnHints:53 h2:34 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 72) {
        [self returnLevelID:@"342210202331203001202033100022"];
        [self returnMaxTaps:5];
        [self returnHints:23 h2:23 h3:33 h4:33 h5:24 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 73) {
        [self returnLevelID:@"111021222231232200420012130323"];
        [self returnMaxTaps:4];
        [self returnHints:13 h2:42 h3:42 h4:41 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 74) {
        [self returnLevelID:@"201010222023322200033131211231"];
        [self returnMaxTaps:2];
        [self returnHints:23 h2:23 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 75) {
        [self returnLevelID:@"510302031021112210200020331430"];
        [self returnMaxTaps:3];
        [self returnHints:32 h2:35 h3:16 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 76) {
        [self returnLevelID:@"302301232020002111030333012313"];
        [self returnMaxTaps:4];
        [self returnHints:35 h2:23 h3:45 h4:11 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 77) {
        [self returnLevelID:@"202122330223023200202110101021"];
        [self returnMaxTaps:2];
        [self returnHints:44 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 78) {
        [self returnLevelID:@"111223223200023221203110121113"];
        [self returnMaxTaps:2];
        [self returnHints:44 h2:12 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 79) {
        [self returnLevelID:@"012020222103213120020331222302"];
        [self returnMaxTaps:2];
        [self returnHints:23 h2:23 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 80) {
        [self returnLevelID:@"212101102332210303232100123131"];
        [self returnMaxTaps:3];
        [self returnHints:14 h2:44 h3:26 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 81) {
        [self returnLevelID:@"123312321150211423301103020304"];
        [self returnMaxTaps:2];
        [self returnHints:44 h2:56 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 82) {
        [self returnLevelID:@"523133213200322331201211022224"];
        [self returnMaxTaps:3];
        [self returnHints:45 h2:33 h3:15 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 83) {
        [self returnLevelID:@"334201301131100112200402232013"];
        [self returnMaxTaps:2];
        [self returnHints:24 h2:52 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 84) {
        [self returnLevelID:@"421201103300213230322230002210"];
        [self returnMaxTaps:4];
        [self returnHints:16 h2:21 h3:23 h4:23 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 85) {
        [self returnLevelID:@"313033033011001220024212122011"];
        [self returnMaxTaps:3];
        [self returnHints:45 h2:42 h3:16 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 86) {
        [self returnLevelID:@"005230310302212120002220413101"];
        [self returnMaxTaps:3];
        [self returnHints:22 h2:34 h3:45 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 87) {
        [self returnLevelID:@"410321233232020102000113202131"];
        [self returnMaxTaps:2];
        [self returnHints:34 h2:14 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 88) {
        [self returnLevelID:@"240400221111313321011101301211"];
        [self returnMaxTaps:1];
        [self returnHints:23 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 89) {
        [self returnLevelID:@"203322243232101343120213113103"];
        [self returnMaxTaps:4];
        [self returnHints:33 h2:45 h3:25 h4:46 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 90) {
        [self returnLevelID:@"315403200212422421224003110130"];
        [self returnMaxTaps:6];
        [self returnHints:25 h2:24 h3:12 h4:14 h5:33 h6:33 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 91) {
        [self returnLevelID:@"122103210012230131321013124200"];
        [self returnMaxTaps:1];
        [self returnHints:25 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 92) {
        [self returnLevelID:@"212302000312020331212212222022"];
        [self returnMaxTaps:2];
        [self returnHints:36 h2:45 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 93) {
        [self returnLevelID:@"321032241214334010001220020213"];
        [self returnMaxTaps:3];
        [self returnHints:35 h2:22 h3:32 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 94) {
        [self returnLevelID:@"400030210132141122342033132200"];
        [self returnMaxTaps:3];
        [self returnHints:34 h2:53 h3:41 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 95) {
        [self returnLevelID:@"320100112330031202302211314111"];
        [self returnMaxTaps:2];
        [self returnHints:44 h2:44 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 96) {
        [self returnLevelID:@"203340303210141022012021002213"];
        [self returnMaxTaps:3];
        [self returnHints:33 h2:24 h3:24 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 97) {
        [self returnLevelID:@"112120313010133000131312301220"];
        [self returnMaxTaps:2];
        [self returnHints:12 h2:41 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 98) {
        [self returnLevelID:@"300132022101022220220310121320"];
        [self returnMaxTaps:1];
        [self returnHints:24 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 99) {
        [self returnLevelID:@"412132000042210020002121313233"];
        [self returnMaxTaps:2];
        [self returnHints:44 h2:46 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 100) {
        [self returnLevelID:@"301334200023022203210230213331"];
        [self returnMaxTaps:5];
        [self returnHints:52 h2:44 h3:25 h4:53 h5:54 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 101) {
        [self returnLevelID:@"111202221020000023100020133321"];
        [self returnMaxTaps:2];
        [self returnHints:23 h2:45 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 102) {
        [self returnLevelID:@"000305002131214213302132033223"];
        [self returnMaxTaps:3];
        [self returnHints:34 h2:34 h3:43 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 103) {
        [self returnLevelID:@"040031343101112102302332014020"];
        [self returnMaxTaps:5];
        [self returnHints:15 h2:44 h3:32 h4:12 h5:12 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 104) {
        [self returnLevelID:@"132232222122041122302303023010"];
        [self returnMaxTaps:1];
        [self returnHints:24 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 105) {
        [self returnLevelID:@"332123130000432200433221110210"];
        [self returnMaxTaps:4];
        [self returnHints:33 h2:33 h3:32 h4:32 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
}

+(void) loadPack3:(int)pack level:(int)level {
    
    if (level == 1) {
        [self returnLevelID:@"132300001331020332310202122211"];
        [self returnMaxTaps:4];
        [self returnHints:26 h2:42 h3:32 h4:13 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 2) {
        [self returnLevelID:@"303210300323023202131311300100"];
        [self returnMaxTaps:4];
        [self returnHints:36 h2:34 h3:34 h4:33 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 3) {
        [self returnLevelID:@"110222211221301101332121330203"];
        [self returnMaxTaps:2];
        [self returnHints:33 h2:51 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 4) {
        [self returnLevelID:@"223321130221332332133013300220"];
        [self returnMaxTaps:5];
        [self returnHints:45 h2:24 h3:34 h4:34 h5:34 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 5) {
        [self returnLevelID:@"304242413100323101210220212000"];
        [self returnMaxTaps:3];
        [self returnHints:34 h2:13 h3:15 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 6) {
        [self returnLevelID:@"100121033213322232110121202211"];
        [self returnMaxTaps:1];
        [self returnHints:44 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 7) {
        [self returnLevelID:@"303131111201132031223000203130"];
        [self returnMaxTaps:2];
        [self returnHints:23 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 8) {
        [self returnLevelID:@"142020331021000233022333321423"];
        [self returnMaxTaps:5];
        [self returnHints:23 h2:25 h3:35 h4:35 h5:45 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 9) {
        [self returnLevelID:@"342110223111311022003211220231"];
        [self returnMaxTaps:1];
        [self returnHints:14 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 10) {
        [self returnLevelID:@"003101130002213002212332033221"];
        [self returnMaxTaps:3];
        [self returnHints:14 h2:32 h3:43 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 11) {
        [self returnLevelID:@"312321232012110233021010302023"];
        [self returnMaxTaps:2];
        [self returnHints:43 h2:25 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 12) {
        [self returnLevelID:@"122243100303134210200130232013"];
        [self returnMaxTaps:5];
        [self returnHints:31 h2:45 h3:24 h4:24 h5:33 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 13) {
        [self returnLevelID:@"202330233322333132211210011102"];
        [self returnMaxTaps:3];
        [self returnHints:34 h2:24 h3:24 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 14) {
        [self returnLevelID:@"230211102023322102033231202130"];
        [self returnMaxTaps:3];
        [self returnHints:15 h2:33 h3:45 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 15) {
        [self returnLevelID:@"113010330314333210230312013013"];
        [self returnMaxTaps:5];
        [self returnHints:24 h2:34 h3:34 h4:42 h5:32 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 16) {
        [self returnLevelID:@"310130031100030020023131302032"];
        [self returnMaxTaps:5];
        [self returnHints:23 h2:46 h3:43 h4:35 h5:11 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 17) {
        [self returnLevelID:@"022001320223121333010332024023"];
        [self returnMaxTaps:4];
        [self returnHints:35 h2:34 h3:34 h4:34 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 18) {
        [self returnLevelID:@"312322010130233110120010232330"];
        [self returnMaxTaps:2];
        [self returnHints:45 h2:42 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 19) {
        [self returnLevelID:@"222020003311210203200132021302"];
        [self returnMaxTaps:3];
        [self returnHints:26 h2:44 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 20) {
        [self returnLevelID:@"421120320000331112230030323023"];
        [self returnMaxTaps:4];
        [self returnHints:13 h2:42 h3:21 h4:55 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 21) {
        [self returnLevelID:@"251142314220332040103033112021"];
        [self returnMaxTaps:5];
        [self returnHints:52 h2:14 h3:22 h4:33 h5:33 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 22) {
        [self returnLevelID:@"003130120303110032031200230102"];
        [self returnMaxTaps:5];
        [self returnHints:32 h2:43 h3:36 h4:15 h5:26 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 23) {
        [self returnLevelID:@"301131201220223300022200102020"];
        [self returnMaxTaps:2];
        [self returnHints:23 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 24) {
        [self returnLevelID:@"220313113120123033131133031312"];
        [self returnMaxTaps:1];
        [self returnHints:43 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 25) {
        [self returnLevelID:@"231202121210023300002220021111"];
        [self returnMaxTaps:2];
        [self returnHints:23 h2:24 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 26) {
        [self returnLevelID:@"111322112121221232023030032302"];
        [self returnMaxTaps:2];
        [self returnHints:33 h2:34 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 27) {
        [self returnLevelID:@"312412012000241332322100112331"];
        [self returnMaxTaps:2];
        [self returnHints:12 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 28) {
        [self returnLevelID:@"243001033001331012111332023033"];
        [self returnMaxTaps:4];
        [self returnHints:33 h2:56 h3:11 h4:12 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 29) {
        [self returnLevelID:@"220033201333342303103131320222"];
        [self returnMaxTaps:5];
        [self returnHints:44 h2:16 h3:34 h4:34 h5:33 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 30) {
        [self returnLevelID:@"231000204212200323122123202011"];
        [self returnMaxTaps:3];
        [self returnHints:44 h2:43 h3:12 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 31) {
        [self returnLevelID:@"133012100102221202101310023113"];
        [self returnMaxTaps:1];
        [self returnHints:24 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 32) {
        [self returnLevelID:@"313342201011232202120110302013"];
        [self returnMaxTaps:2];
        [self returnHints:44 h2:16 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 33) {
        [self returnLevelID:@"203232151302211334243123120303"];
        [self returnMaxTaps:3];
        [self returnHints:23 h2:34 h3:46 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 34) {
        [self returnLevelID:@"143322312003243023000122301123"];
        [self returnMaxTaps:4];
        [self returnHints:22 h2:45 h3:45 h4:14 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 35) {
        [self returnLevelID:@"324331003031220033022312131133"];
        [self returnMaxTaps:6];
        [self returnHints:54 h2:35 h3:35 h4:35 h5:14 h6:14 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 36) {
        [self returnLevelID:@"030212304222431202220021102012"];
        [self returnMaxTaps:5];
        [self returnHints:46 h2:33 h3:32 h4:42 h5:32 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 37) {
        [self returnLevelID:@"232034324031210213010202111323"];
        [self returnMaxTaps:3];
        [self returnHints:34 h2:34 h3:13 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 38) {
        [self returnLevelID:@"031021203340102101302103313031"];
        [self returnMaxTaps:2];
        [self returnHints:34 h2:25 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 39) {
        [self returnLevelID:@"222320423403320412112131221210"];
        [self returnMaxTaps:3];
        [self returnHints:42 h2:23 h3:13 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 40) {
        [self returnLevelID:@"400010302230002021211212130212"];
        [self returnMaxTaps:2];
        [self returnHints:45 h2:25 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 41) {
        [self returnLevelID:@"200132010221341220102202000123"];
        [self returnMaxTaps:2];
        [self returnHints:33 h2:43 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 42) {
        [self returnLevelID:@"020101142225024111421210134212"];
        [self returnMaxTaps:2];
        [self returnHints:43 h2:34 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 43) {
        [self returnLevelID:@"000223112303213242323232211011"];
        [self returnMaxTaps:5];
        [self returnHints:55 h2:34 h3:34 h4:33 h5:33 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 44) {
        [self returnLevelID:@"220021313210033031130031332110"];
        [self returnMaxTaps:4];
        [self returnHints:23 h2:23 h3:23 h4:52 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 45) {
        [self returnLevelID:@"131302433121130230223001320203"];
        [self returnMaxTaps:4];
        [self returnHints:24 h2:25 h3:35 h4:32 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 46) {
        [self returnLevelID:@"120130102301223133212102002231"];
        [self returnMaxTaps:2];
        [self returnHints:44 h2:46 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 47) {
        [self returnLevelID:@"130121200122100013201001313200"];
        [self returnMaxTaps:2];
        [self returnHints:43 h2:25 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 48) {
        [self returnLevelID:@"221303030120212121003012000030"];
        [self returnMaxTaps:2];
        [self returnHints:24 h2:45 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 49) {
        [self returnLevelID:@"222403322303121131022302310110"];
        [self returnMaxTaps:2];
        [self returnHints:23 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 50) {
        [self returnLevelID:@"233120343021034220212203230102"];
        [self returnMaxTaps:6];
        [self returnHints:42 h2:43 h3:15 h4:23 h5:23 h6:23 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 51) {
        [self returnLevelID:@"121111303031330214301013420210"];
        [self returnMaxTaps:3];
        [self returnHints:35 h2:41 h3:51 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 52) {
        [self returnLevelID:@"112120022102003201010022132220"];
        [self returnMaxTaps:1];
        [self returnHints:24 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 53) {
        [self returnLevelID:@"100331030233200131030201230132"];
        [self returnMaxTaps:2];
        [self returnHints:34 h2:24 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 54) {
        [self returnLevelID:@"003233021121214001010320230200"];
        [self returnMaxTaps:3];
        [self returnHints:24 h2:45 h3:52 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 55) { // 1.01
        [self returnLevelID:@"140041323031313301033202133233"];
        [self returnMaxTaps:6];
        [self returnHints:32 h2:34 h3:34 h4:44 h5:44 h6:23 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 56) {
        [self returnLevelID:@"110120331312210332401022202121"];
        [self returnMaxTaps:2];
        [self returnHints:43 h2:14 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 57) {
        [self returnLevelID:@"132232103210322033214031113132"];
        [self returnMaxTaps:3];
        [self returnHints:42 h2:33 h3:43 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 58) {
        [self returnLevelID:@"213130232231222312213122000103"];
        [self returnMaxTaps:2];
        [self returnHints:44 h2:35 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 59) {
        [self returnLevelID:@"133140321301223002221022003030"];
        [self returnMaxTaps:4];
        [self returnHints:26 h2:23 h3:43 h4:45 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 60) {
        [self returnLevelID:@"333210200100334112332001000310"];
        [self returnMaxTaps:5];
        [self returnHints:24 h2:33 h3:32 h4:32 h5:32 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 61) {
        [self returnLevelID:@"021102330200211333003022100220"];
        [self returnMaxTaps:3];
        [self returnHints:33 h2:34 h3:35 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 62) {
        [self returnLevelID:@"300311221120022101302030133002"];
        [self returnMaxTaps:3];
        [self returnHints:41 h2:34 h3:43 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 63) {
        [self returnLevelID:@"103112112220212022123202510232"];
        [self returnMaxTaps:1];
        [self returnHints:22 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 64) {
        [self returnLevelID:@"320332123332332212202021012121"];
        [self returnMaxTaps:2];
        [self returnHints:35 h2:54 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 65) {
        [self returnLevelID:@"223210012022133000201200312230"];
        [self returnMaxTaps:4];
        [self returnHints:15 h2:43 h3:44 h4:26 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 66) {
        [self returnLevelID:@"200301233123231100310030110310"];
        [self returnMaxTaps:2];
        [self returnHints:33 h2:32 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 67) {
        [self returnLevelID:@"203140101212321302104000211112"];
        [self returnMaxTaps:1];
        [self returnHints:33 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 68) {
        [self returnLevelID:@"032023310131423002000013022000"];
        [self returnMaxTaps:5];
        [self returnHints:24 h2:25 h3:36 h4:32 h5:31 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 69) {
        [self returnLevelID:@"002210102223001303021332201311"];
        [self returnMaxTaps:3];
        [self returnHints:34 h2:34 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 70) {
        [self returnLevelID:@"302232341222012343211120302023"];
        [self returnMaxTaps:2];
        [self returnHints:32 h2:14 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 71) {
        [self returnLevelID:@"232030220122313220402310210122"];
        [self returnMaxTaps:2];
        [self returnHints:34 h2:32 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 72) { // 1.01
        [self returnLevelID:@"403032024202022231312033121231"];
        [self returnMaxTaps:6];
        [self returnHints:36 h2:26 h3:24 h4:34 h5:13 h6:33 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 73) {
        [self returnLevelID:@"050201321011203020211233232230"];
        [self returnMaxTaps:2];
        [self returnHints:25 h2:12 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 74) {
        [self returnLevelID:@"020301310203201100332001133102"];
        [self returnMaxTaps:2];
        [self returnHints:33 h2:43 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 75) {
        [self returnLevelID:@"123404233220121131320022302213"];
        [self returnMaxTaps:3];
        [self returnHints:33 h2:24 h3:16 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 76) {
        [self returnLevelID:@"303323012331222333002120021020"];
        [self returnMaxTaps:4];
        [self returnHints:24 h2:23 h3:23 h4:33 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 77) {
        [self returnLevelID:@"334002033211331122312222112220"];
        [self returnMaxTaps:3];
        [self returnHints:34 h2:12 h3:11 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 78) {
        [self returnLevelID:@"200302000221141412202023220212"];
        [self returnMaxTaps:3];
        [self returnHints:26 h2:35 h3:31 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 79) {
        [self returnLevelID:@"321133011124341210130233033242"];
        [self returnMaxTaps:1];
        [self returnHints:33 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 80) {
        [self returnLevelID:@"030031232303423223011020212032"];
        [self returnMaxTaps:4];
        [self returnHints:43 h2:23 h3:15 h4:15 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 81) {
        [self returnLevelID:@"302204330123232330021101022203"];
        [self returnMaxTaps:3];
        [self returnHints:44 h2:33 h3:16 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 82) {
        [self returnLevelID:@"143210301210323202102000030011"];
        [self returnMaxTaps:2];
        [self returnHints:23 h2:24 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 83) {
        [self returnLevelID:@"304301122103302323020322101030"];
        [self returnMaxTaps:4];
        [self returnHints:44 h2:23 h3:23 h4:33 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 84) {
        [self returnLevelID:@"123120203133233321133030302131"];
        [self returnMaxTaps:4];
        [self returnHints:24 h2:34 h3:35 h4:15 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 85) {
        [self returnLevelID:@"313201331014332231321231103023"];
        [self returnMaxTaps:2];
        [self returnHints:25 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 86) {
        [self returnLevelID:@"323100220311302000223110012002"];
        [self returnMaxTaps:4];
        [self returnHints:44 h2:43 h3:22 h4:21 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 87) {
        [self returnLevelID:@"023241200100300211013200020301"];
        [self returnMaxTaps:4];
        [self returnHints:24 h2:43 h3:43 h4:43 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 88) {
        [self returnLevelID:@"334210013222021301230311022312"];
        [self returnMaxTaps:3];
        [self returnHints:46 h2:23 h3:11 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 89) { // 1.01
        [self returnLevelID:@"122221104303123023031013343303"];
        [self returnMaxTaps:6];
        [self returnHints:31 h2:43 h3:35 h4:33 h5:15 h6:24 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 90) {
        [self returnLevelID:@"230013002230040110332122222210"];
        [self returnMaxTaps:3];
        [self returnHints:43 h2:43 h3:12 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 91) {
        [self returnLevelID:@"340120004413122133011100112200"];
        [self returnMaxTaps:2];
        [self returnHints:34 h2:26 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 92) {
        [self returnLevelID:@"252002202221203120210330331000"];
        [self returnMaxTaps:4];
        [self returnHints:26 h2:34 h3:24 h4:44 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 93) {
        [self returnLevelID:@"213321143301201010100330003224"];
        [self returnMaxTaps:5];
        [self returnHints:45 h2:45 h3:23 h4:23 h5:23 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 94) {
        [self returnLevelID:@"004101224110034113211303332023"];
        [self returnMaxTaps:2];
        [self returnHints:34 h2:13 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 95) {
        [self returnLevelID:@"202202012320012202220313322101"];
        [self returnMaxTaps:2];
        [self returnHints:33 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 96) {
        [self returnLevelID:@"232032230112320222231330020011"];
        [self returnMaxTaps:2];
        [self returnHints:24 h2:34 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 97) {
        [self returnLevelID:@"411021211311122130300002033203"];
        [self returnMaxTaps:2];
        [self returnHints:23 h2:53 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 98) {
        [self returnLevelID:@"003212132322323201221323112222"];
        [self returnMaxTaps:3];
        [self returnHints:52 h2:45 h3:22 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 99) {
        [self returnLevelID:@"012020331011323103123210101010"];
        [self returnMaxTaps:2];
        [self returnHints:23 h2:21 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 100) {
        [self returnLevelID:@"250113310221101320103012032202"];
        [self returnMaxTaps:2];
        [self returnHints:33 h2:22 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 101) { // 1.01
        [self returnLevelID:@"320030030230302012113001030202"];
        [self returnMaxTaps:6];
        [self returnHints:42 h2:46 h3:25 h4:25 h5:24 h6:24 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 102) {
        [self returnLevelID:@"002312203034021201120301232133"];
        [self returnMaxTaps:3];
        [self returnHints:36 h2:33 h3:44 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 103) {
        [self returnLevelID:@"033414223110121303120013111303"];
        [self returnMaxTaps:2];
        [self returnHints:24 h2:23 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 104) {
        [self returnLevelID:@"221243223410212012123203100300"];
        [self returnMaxTaps:4];
        [self returnHints:41 h2:25 h3:44 h4:16 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 105) {
        [self returnLevelID:@"012301210232031321201022332003"];
        [self returnMaxTaps:2];
        [self returnHints:45 h2:45 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
}

+(void) loadPack4:(int)pack level:(int)level {
    
    if (level == 1) {
        [self returnLevelID:@"330231010232113022130021222300"];
        [self returnMaxTaps:3];
        [self returnHints:22 h2:35 h3:35 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 2) {
        [self returnLevelID:@"121431233420031002101232211332"];
        [self returnMaxTaps:2];
        [self returnHints:33 h2:25 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 3) {
        [self returnLevelID:@"144110040031012322033102122012"];
        [self returnMaxTaps:4];
        [self returnHints:14 h2:35 h3:35 h4:22 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 4) {
        [self returnLevelID:@"132213301222103200103130300201"];
        [self returnMaxTaps:2];
        [self returnHints:44 h2:34 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 5) {
        [self returnLevelID:@"000112130111302402312122232202"];
        [self returnMaxTaps:2];
        [self returnHints:25 h2:31 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 6) {
        [self returnLevelID:@"003111120002130132431331121322"];
        [self returnMaxTaps:2];
        [self returnHints:34 h2:54 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 7) {
        [self returnLevelID:@"021343033431422321203112032312"];
        [self returnMaxTaps:5];
        [self returnHints:26 h2:34 h3:33 h4:33 h5:32 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 8) {
        [self returnLevelID:@"210335332313241011101200202203"];
        [self returnMaxTaps:2];
        [self returnHints:25 h2:16 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 9) {
        [self returnLevelID:@"132233220102102021311222012301"];
        [self returnMaxTaps:1];
        [self returnHints:43 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 10) {
        [self returnLevelID:@"242032210023322231122030203023"];
        [self returnMaxTaps:3];
        [self returnHints:36 h2:32 h3:32 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 11) {
        [self returnLevelID:@"212310113033321233213302021320"];
        [self returnMaxTaps:3];
        [self returnHints:35 h2:34 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 12) {
        [self returnLevelID:@"322312020201303220320302013022"];
        [self returnMaxTaps:5];
        [self returnHints:52 h2:35 h3:24 h4:24 h5:35 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 13) {
        [self returnLevelID:@"331332341400322122210131313223"];
        [self returnMaxTaps:1];
        [self returnHints:34 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 14) {
        [self returnLevelID:@"012022123320213230132222130320"];
        [self returnMaxTaps:4];
        [self returnHints:32 h2:45 h3:44 h4:44 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 15) {
        [self returnLevelID:@"412132133220001222003200310102"];
        [self returnMaxTaps:2];
        [self returnHints:24 h2:24 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 16) {
        [self returnLevelID:@"242122122430002200120113012122"];
        [self returnMaxTaps:2];
        [self returnHints:54 h2:16 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 17) {
        [self returnLevelID:@"021013231501320310110121041320"];
        [self returnMaxTaps:2];
        [self returnHints:44 h2:21 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 18) {
        [self returnLevelID:@"224000342231022211103210023322"];
        [self returnMaxTaps:4];
        [self returnHints:24 h2:34 h3:34 h4:12 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 19) {
        [self returnLevelID:@"231001402211011203232021224100"];
        [self returnMaxTaps:1];
        [self returnHints:33 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 20) {
        [self returnLevelID:@"222204122311212022332223001011"];
        [self returnMaxTaps:2];
        [self returnHints:32 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 21) {
        [self returnLevelID:@"233103322200003030113211013030"];
        [self returnMaxTaps:4];
        [self returnHints:42 h2:23 h3:13 h4:35 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 22) {
        [self returnLevelID:@"230301233321300212302202322110"];
        [self returnMaxTaps:3];
        [self returnHints:34 h2:44 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 23) {
        [self returnLevelID:@"201003021010001210331140322222"];
        [self returnMaxTaps:2];
        [self returnHints:43 h2:51 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 24) {
        [self returnLevelID:@"000213231333032322232221201311"];
        [self returnMaxTaps:4];
        [self returnHints:46 h2:15 h3:33 h4:33 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 25) {
        [self returnLevelID:@"032421410441032114303221043123"];
        [self returnMaxTaps:3];
        [self returnHints:34 h2:22 h3:44 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 26) {
        [self returnLevelID:@"202314112000110023021223111312"];
        [self returnMaxTaps:2];
        [self returnHints:36 h2:43 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 27) {
        [self returnLevelID:@"421313001102323230231201223223"];
        [self returnMaxTaps:2];
        [self returnHints:24 h2:34 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 28) {
        [self returnLevelID:@"003231012223220201002031320033"];
        [self returnMaxTaps:4];
        [self returnHints:45 h2:14 h3:24 h4:24 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 29) {
        [self returnLevelID:@"012032312002230123322001111000"];
        [self returnMaxTaps:2];
        [self returnHints:22 h2:23 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 30) {
        [self returnLevelID:@"000222132010240332001031130122"];
        [self returnMaxTaps:5];
        [self returnHints:25 h2:54 h3:35 h4:34 h5:34 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 31) {
        [self returnLevelID:@"211201101223301310403000002022"];
        [self returnMaxTaps:3];
        [self returnHints:31 h2:33 h3:41 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 32) {
        [self returnLevelID:@"242140202032001011113210200302"];
        [self returnMaxTaps:2];
        [self returnHints:25 h2:36 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 33) {
        [self returnLevelID:@"010022114221202201313330331100"];
        [self returnMaxTaps:3];
        [self returnHints:42 h2:43 h3:25 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 34) {
        [self returnLevelID:@"233221232310032222003120102310"];
        [self returnMaxTaps:3];
        [self returnHints:44 h2:34 h3:33 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 35) {
        [self returnLevelID:@"120002010000100220100210001111"];
        [self returnMaxTaps:2];
        [self returnHints:56 h2:16 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 36) {
        [self returnLevelID:@"021030122211132221232233031310"];
        [self returnMaxTaps:2];
        [self returnHints:25 h2:23 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 37) {
        [self returnLevelID:@"323133122421122213302230100302"];
        [self returnMaxTaps:3];
        [self returnHints:21 h2:34 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 38) {
        [self returnLevelID:@"043143233320022010300232032101"];
        [self returnMaxTaps:5];
        [self returnHints:14 h2:44 h3:44 h4:23 h5:23 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 39) {
        [self returnLevelID:@"200144213112240212313133222102"];
        [self returnMaxTaps:2];
        [self returnHints:44 h2:23 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 40) {
        [self returnLevelID:@"423422100310231203123103130213"];
        [self returnMaxTaps:3];
        [self returnHints:41 h2:33 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 41) {
        [self returnLevelID:@"332002430103202300133123240212"];
        [self returnMaxTaps:5];
        [self returnHints:55 h2:44 h3:33 h4:33 h5:22 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 42) {
        [self returnLevelID:@"113311001301323231021022221120"];
        [self returnMaxTaps:2];
        [self returnHints:43 h2:46 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 43) {
        [self returnLevelID:@"132132024010231023330202201211"];
        [self returnMaxTaps:2];
        [self returnHints:33 h2:25 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 44) {
        [self returnLevelID:@"232002321023322100131031400201"];
        [self returnMaxTaps:2];
        [self returnHints:43 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 45) {
        [self returnLevelID:@"323132342122222220322012110210"];
        [self returnMaxTaps:2];
        [self returnHints:24 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 46) {
        [self returnLevelID:@"332403302330231313132114103303"];
        [self returnMaxTaps:3];
        [self returnHints:44 h2:23 h3:36 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 47) {
        [self returnLevelID:@"121202103312230131210301113133"];
        [self returnMaxTaps:2];
        [self returnHints:36 h2:42 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 48) {
        [self returnLevelID:@"032133211022003023213132213111"];
        [self returnMaxTaps:1];
        [self returnHints:54 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 49) {
        [self returnLevelID:@"222352121310423213221232000234"];
        [self returnMaxTaps:3];
        [self returnHints:25 h2:44 h3:44 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 50) {
        [self returnLevelID:@"210251102320230310113213132030"];
        [self returnMaxTaps:3];
        [self returnHints:42 h2:35 h3:44 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 51) {
        [self returnLevelID:@"222212321410033332022112103313"];
        [self returnMaxTaps:3];
        [self returnHints:44 h2:15 h3:11 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 52) {
        [self returnLevelID:@"112021010224310322043302102322"];
        [self returnMaxTaps:4];
        [self returnHints:26 h2:34 h3:34 h4:34 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 53) {
        [self returnLevelID:@"000332130030232203340113132101"];
        [self returnMaxTaps:5];
        [self returnHints:51 h2:36 h3:34 h4:34 h5:32 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 54) {
        [self returnLevelID:@"131202200412302311101232230221"];
        [self returnMaxTaps:3];
        [self returnHints:25 h2:43 h3:12 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 55) {
        [self returnLevelID:@"202211132220233030103113123000"];
        [self returnMaxTaps:3];
        [self returnHints:41 h2:15 h3:45 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 56) {
        [self returnLevelID:@"022312302213210003033232212301"];
        [self returnMaxTaps:3];
        [self returnHints:25 h2:24 h3:16 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 57) {
        [self returnLevelID:@"423001223332030312112003100032"];
        [self returnMaxTaps:6];
        [self returnHints:35 h2:46 h3:34 h4:34 h5:32 h6:12 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 58) {
        [self returnLevelID:@"431021212133000030103020302003"];
        [self returnMaxTaps:4];
        [self returnHints:24 h2:23 h3:53 h4:35 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 59) {
        [self returnLevelID:@"003022111323122200103220220123"];
        [self returnMaxTaps:2];
        [self returnHints:33 h2:23 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 60) {
        [self returnLevelID:@"220212323224210230302420321230"];
        [self returnMaxTaps:4];
        [self returnHints:32 h2:24 h3:24 h4:55 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 61) {
        [self returnLevelID:@"000212221002220233213231011120"];
        [self returnMaxTaps:2];
        [self returnHints:42 h2:34 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 62) {
        [self returnLevelID:@"002222311322101023010000302231"];
        [self returnMaxTaps:2];
        [self returnHints:42 h2:36 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 63) {
        [self returnLevelID:@"221230123103331030112134320303"];
        [self returnMaxTaps:2];
        [self returnHints:44 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 64) {
        [self returnLevelID:@"222120003101330013231033300013"];
        [self returnMaxTaps:4];
        [self returnHints:14 h2:35 h3:12 h4:32 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 65) {
        [self returnLevelID:@"231100230322130321331200123302"];
        [self returnMaxTaps:4];
        [self returnHints:43 h2:35 h3:35 h4:34 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 66) {
        [self returnLevelID:@"334121131222001233120301031030"];
        [self returnMaxTaps:2];
        [self returnHints:33 h2:34 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 67) {
        [self returnLevelID:@"311024233031241123103131222012"];
        [self returnMaxTaps:2];
        [self returnHints:34 h2:46 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 68) {
        [self returnLevelID:@"051202200312213032332221230311"];
        [self returnMaxTaps:3];
        [self returnHints:44 h2:44 h3:43 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 69) {
        [self returnLevelID:@"205022043330232100222124410221"];
        [self returnMaxTaps:5];
        [self returnHints:33 h2:33 h3:15 h4:11 h5:13 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 70) {
        [self returnLevelID:@"002343321221131223332003110200"];
        [self returnMaxTaps:2];
        [self returnHints:33 h2:24 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 71) {
        [self returnLevelID:@"113323020310111333303003423334"];
        [self returnMaxTaps:5];
        [self returnHints:33 h2:25 h3:35 h4:14 h5:46 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 72) {
        [self returnLevelID:@"231312211221001121033200300103"];
        [self returnMaxTaps:1];
        [self returnHints:33 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 73) {
        [self returnLevelID:@"332421221030120003102210202102"];
        [self returnMaxTaps:2];
        [self returnHints:23 h2:13 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 74) {
        [self returnLevelID:@"221011410013332313113202203101"];
        [self returnMaxTaps:2];
        [self returnHints:15 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 75) {
        [self returnLevelID:@"130234101413002121112131202230"];
        [self returnMaxTaps:1];
        [self returnHints:42 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 76) {
        [self returnLevelID:@"111032232121212032232223023230"];
        [self returnMaxTaps:3];
        [self returnHints:11 h2:44 h3:44 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 77) {
        [self returnLevelID:@"323221132300033211000110221221"];
        [self returnMaxTaps:3];
        [self returnHints:45 h2:23 h3:22 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 78) {
        [self returnLevelID:@"310242000111302202002011221132"];
        [self returnMaxTaps:2];
        [self returnHints:45 h2:11 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 79) {
        [self returnLevelID:@"212222332110322320213032313133"];
        [self returnMaxTaps:2];
        [self returnHints:24 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 80) {
        [self returnLevelID:@"232402143400130102210232331110"];
        [self returnMaxTaps:5];
        [self returnHints:21 h2:24 h3:24 h4:24 h5:24 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 81) {
        [self returnLevelID:@"001110213010102321342020222300"];
        [self returnMaxTaps:4];
        [self returnHints:25 h2:33 h3:42 h4:53 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 82) {
        [self returnLevelID:@"310013123320332131123102210213"];
        [self returnMaxTaps:2];
        [self returnHints:44 h2:24 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 83) {
        [self returnLevelID:@"010020013031230020300022223002"];
        [self returnMaxTaps:6];
        [self returnHints:22 h2:15 h3:32 h4:35 h5:25 h6:52 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 84) {
        [self returnLevelID:@"223320232210320023022112020322"];
        [self returnMaxTaps:2];
        [self returnHints:44 h2:24 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 85) {
        [self returnLevelID:@"122203322213242031410133310230"];
        [self returnMaxTaps:2];
        [self returnHints:44 h2:13 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 86) {
        [self returnLevelID:@"031132032013201100300332220212"];
        [self returnMaxTaps:2];
        [self returnHints:33 h2:44 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 87) {
        [self returnLevelID:@"102003310033141001101203314202"];
        [self returnMaxTaps:3];
        [self returnHints:33 h2:22 h3:46 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 88) {
        [self returnLevelID:@"304303211234333232012030201303"];
        [self returnMaxTaps:5];
        [self returnHints:23 h2:34 h3:14 h4:53 h5:33 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 89) {
        [self returnLevelID:@"401310102302013333121124120201"];
        [self returnMaxTaps:3];
        [self returnHints:43 h2:15 h3:35 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 90) {
        [self returnLevelID:@"011120021101223212013303321230"];
        [self returnMaxTaps:2];
        [self returnHints:35 h2:36 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 91) {
        [self returnLevelID:@"034221232323301232002233322210"];
        [self returnMaxTaps:3];
        [self returnHints:33 h2:43 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 92) {
        [self returnLevelID:@"211023010012321301032322001320"];
        [self returnMaxTaps:3];
        [self returnHints:33 h2:55 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 93) {
        [self returnLevelID:@"022322303323214132031200122120"];
        [self returnMaxTaps:3];
        [self returnHints:34 h2:43 h3:15 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 94) {
        [self returnLevelID:@"212101222301012203100000313120"];
        [self returnMaxTaps:2];
        [self returnHints:33 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 95) {
        [self returnLevelID:@"203000203220021212112100001200"];
        [self returnMaxTaps:3];
        [self returnHints:42 h2:11 h3:13 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 96) {
        [self returnLevelID:@"001010122212003130003303311003"];
        [self returnMaxTaps:3];
        [self returnHints:25 h2:34 h3:44 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 97) {
        [self returnLevelID:@"330421221323321000032000331021"];
        [self returnMaxTaps:3];
        [self returnHints:33 h2:32 h3:24 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 98) {
        [self returnLevelID:@"111202022024331300041012012002"];
        [self returnMaxTaps:1];
        [self returnHints:33 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 99) {
        [self returnLevelID:@"121304123310231220113232203213"];
        [self returnMaxTaps:3];
        [self returnHints:55 h2:34 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 100) {
        [self returnLevelID:@"221333110330322231111222022023"];
        [self returnMaxTaps:2];
        [self returnHints:43 h2:34 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 101) {
        [self returnLevelID:@"215212230310222023131312223422"];
        [self returnMaxTaps:3];
        [self returnHints:25 h2:33 h3:36 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 102) {
        [self returnLevelID:@"023232131052313220212000222233"];
        [self returnMaxTaps:4];
        [self returnHints:32 h2:35 h3:34 h4:34 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 103) {
        [self returnLevelID:@"211013112300111304002220112013"];
        [self returnMaxTaps:4];
        [self returnHints:32 h2:36 h3:36 h4:36 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 104) {
        [self returnLevelID:@"303433432320223231021003132303"];
        [self returnMaxTaps:6];
        [self returnHints:23 h2:23 h3:33 h4:32 h5:33 h6:15 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 105) {
        [self returnLevelID:@"002202233210031132202000210312"];
        [self returnMaxTaps:3];
        [self returnHints:34 h2:25 h3:22 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
}

+(void) loadPack5:(int)pack level:(int)level {
    if (level == 1) {
        [self returnLevelID:@"322223131102212331220020030001"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 2) {
        [self returnLevelID:@"010103301033000000211232333211"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 3) {
        [self returnLevelID:@"231321232021230201020303301011"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 4) {
        [self returnLevelID:@"002200302012211033112310200210"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 5) {
        [self returnLevelID:@"012033113202033310220301301320"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 6) {
        [self returnLevelID:@"222313020231133023121012010113"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 7) {
        [self returnLevelID:@"301222200001220213031231303123"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 8) {
        [self returnLevelID:@"421010013210120221021323011010"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 9) {
        [self returnLevelID:@"320321004130003203301103211200"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 10) {
        [self returnLevelID:@"022313010210122320223030010202"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 11) {
        [self returnLevelID:@"001331010133110220032202210221"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 12) {
        [self returnLevelID:@"224012121210221030030022353324"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 13) {
        [self returnLevelID:@"110221310221012322001202221300"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 14) {
        [self returnLevelID:@"232300021231231314113220012222"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 15) {
        [self returnLevelID:@"031133112213203333121232212113"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 16) {
        [self returnLevelID:@"113332303103301120012122001311"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 17) {
        [self returnLevelID:@"210100020213123220213230310112"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 18) {
        [self returnLevelID:@"312101211203010314221103333020"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 19) {
        [self returnLevelID:@"103003010323330222111001303311"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 20) {
        [self returnLevelID:@"022101210202303222231112320323"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 21) {
        [self returnLevelID:@"011313230000123000210322031313"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 22) {
        [self returnLevelID:@"230232232021302310203020113220"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 23) {
        [self returnLevelID:@"131203003332103012321312222312"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 24) {
        [self returnLevelID:@"040243012402322002020301021311"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 25) {
        [self returnLevelID:@"032232202113402323332011212232"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 26) {
        [self returnLevelID:@"001013300021111011232211133330"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 27) {
        [self returnLevelID:@"323230210333221321110332313332"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 28) {
        [self returnLevelID:@"120031021302000103302003230303"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 29) {
        [self returnLevelID:@"033504310021111202023122033220"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 30) {
        [self returnLevelID:@"103132311101201120101333221023"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 31) {
        [self returnLevelID:@"100212211030222010002301212311"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 32) {
        [self returnLevelID:@"030310212310213120300230303102"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 33) {
        [self returnLevelID:@"313321233332123320110211111333"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 34) {
        [self returnLevelID:@"310201233021031123332001310231"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 35) {
        [self returnLevelID:@"322321201211002010110301303200"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 36) {
        [self returnLevelID:@"203312332312313110000203310122"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 37) {
        [self returnLevelID:@"211311331320223321003010303121"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 38) {
        [self returnLevelID:@"013120112302102032211202133232"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 39) {
        [self returnLevelID:@"040123141232221500331100323330"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 40) {
        [self returnLevelID:@"204033103310102041022032220020"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 41) {
        [self returnLevelID:@"133343020012221223211132101123"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 42) {
        [self returnLevelID:@"020102332010110231300230322013"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 43) {
        [self returnLevelID:@"203023010310100310211333031202"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 44) {
        [self returnLevelID:@"101101230210022231000121310232"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 45) {
        [self returnLevelID:@"311210120000230102231302212221"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 46) {
        [self returnLevelID:@"001300302200122232021330303102"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 47) {
        [self returnLevelID:@"041420314020212103201101012103"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 48) {
        [self returnLevelID:@"014004014113032032230330212200"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 49) {
        [self returnLevelID:@"032023310010302002111223012212"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 50) {
        [self returnLevelID:@"312231313203111002221012033300"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 51) {
        [self returnLevelID:@"120210222210123021000131032313"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 52) {
        [self returnLevelID:@"230130212131000231102011211312"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 53) {
        [self returnLevelID:@"011101131023212031002120103233"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 54) {
        [self returnLevelID:@"300302210300310113110002423123"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 55) {
        [self returnLevelID:@"231311112210032423021202203031"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 56) {
        [self returnLevelID:@"211112130123421332111000231133"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 57) {
        [self returnLevelID:@"203253133233220333423021030010"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 58) {
        [self returnLevelID:@"400031022242312121210213301101"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 59) {
        [self returnLevelID:@"003212021300200312103131323001"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 60) {
        [self returnLevelID:@"211201032110113223223320332130"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 61) {
        [self returnLevelID:@"032021321202020211021320012222"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 62) {
        [self returnLevelID:@"222210220201212202112133312001"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 63) {
        [self returnLevelID:@"242400322212103132331202101200"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 64) {
        [self returnLevelID:@"101321113022311101322132130002"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 65) {
        [self returnLevelID:@"141220321212232112303121310123"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 66) {
        [self returnLevelID:@"023221300301100312110130120133"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 67) {
        [self returnLevelID:@"001132010020311303221034310011"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 68) {
        [self returnLevelID:@"122042143010223201002212022331"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 69) {
        [self returnLevelID:@"133300322321202221212032200133"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 70) {
        [self returnLevelID:@"331110001010233221131200012312"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 71) {
        [self returnLevelID:@"000114430333302031202301011303"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 72) {
        [self returnLevelID:@"022105101200220132101333021311"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 73) {
        [self returnLevelID:@"052322130012302330310410242320"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 74) {
        [self returnLevelID:@"321030222011030111020002020302"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 75) {
        [self returnLevelID:@"312110100120333231221322220000"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 76) {
        [self returnLevelID:@"322424012232232000112212312120"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 77) {
        [self returnLevelID:@"032140111203223402031320322212"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 78) {
        [self returnLevelID:@"121113043111101001313030203202"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 79) {
        [self returnLevelID:@"202001012203012330213122120232"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 80) {
        [self returnLevelID:@"211310023321202300113032031203"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 81) {
        [self returnLevelID:@"211103321301112310302022111013"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 82) {
        [self returnLevelID:@"051220124310230033433121332210"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 83) {
        [self returnLevelID:@"101223230231042010110233231200"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 84) {
        [self returnLevelID:@"122012223120214311130303312312"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 85) {
        [self returnLevelID:@"120001222024212012123333132310"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 86) {
        [self returnLevelID:@"123030010122203103321322113220"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 87) {
        [self returnLevelID:@"001131211323210121232231223023"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 88) {
        [self returnLevelID:@"122310201011032211211132210311"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 89) {
        [self returnLevelID:@"032411121020001213001321321323"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 90) {
        [self returnLevelID:@"310212123314322100201201012112"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 91) {
        [self returnLevelID:@"331001030322213302231211110011"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 92) {
        [self returnLevelID:@"200031020020123221331232313130"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 93) {
        [self returnLevelID:@"131200213101312021213220121122"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 94) {
        [self returnLevelID:@"231030022300302210213120133210"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 95) {
        [self returnLevelID:@"004230121433203120232312220012"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 96) {
        [self returnLevelID:@"111102120220002212012221303210"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 97) {
        [self returnLevelID:@"023103001320102011111301021301"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 98) {
        [self returnLevelID:@"111111132220203301122122020033"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 99) {
        [self returnLevelID:@"031023233230002130121112023300"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 100) {
        [self returnLevelID:@"222010202130221031410021111101"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 101) {
        [self returnLevelID:@"201220032002012103330223030320"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 102) {
        [self returnLevelID:@"053332331321131242233100110212"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 103) {
        [self returnLevelID:@"050124222121102002031102223032"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 104) {
        [self returnLevelID:@"030133000210121210020312311203"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 105) {
        [self returnLevelID:@"121100300313010121223100301222"];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
}

+(void) loadPack6:(int)pack level:(int)level {
    
}

+(void) loadPack7:(int)pack level:(int)level {
    if (level == 1) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 2) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 3) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 4) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 5) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 6) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 7) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 8) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 9) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 10) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 11) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 12) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 13) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 14) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 15) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 16) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 17) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 18) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 19) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 20) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 21) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 22) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 23) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 24) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 25) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 26) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 27) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 28) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 29) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 30) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 31) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 32) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 33) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 34) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 35) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 36) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 37) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 38) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 39) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 40) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 41) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 42) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 43) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 44) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 45) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 46) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 47) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 48) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 49) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 50) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 51) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 52) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 53) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 54) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 55) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 56) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 57) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 58) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 59) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 60) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 61) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 62) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 63) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 64) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 65) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 66) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 67) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 68) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 69) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 70) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 71) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 72) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 73) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 74) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 75) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 76) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 77) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 78) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 79) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 80) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 81) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 82) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 83) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 84) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 85) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 86) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 87) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 88) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 89) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 90) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 91) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 92) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 93) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 94) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 95) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 96) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 97) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 98) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 99) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 100) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 101) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 102) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 103) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 104) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 105) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
}

+(void) loadPack8:(int)pack level:(int)level {
    if (level == 1) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 2) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 3) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 4) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 5) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 6) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 7) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 8) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 9) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 10) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 11) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 12) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 13) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 14) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 15) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 16) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 17) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 18) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 19) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 20) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 21) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 22) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 23) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 24) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 25) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 26) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 27) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 28) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 29) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 30) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 31) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 32) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 33) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 34) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 35) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 36) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 37) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 38) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 39) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 40) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 41) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 42) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 43) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 44) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 45) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 46) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 47) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 48) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 49) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 50) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 51) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 52) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 53) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 54) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 55) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 56) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 57) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 58) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 59) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 60) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 61) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 62) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 63) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 64) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 65) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 66) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 67) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 68) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 69) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 70) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 71) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 72) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 73) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 74) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 75) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 76) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 77) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 78) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 79) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 80) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 81) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 82) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 83) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 84) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 85) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 86) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 87) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 88) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 89) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 90) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 91) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 92) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 93) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 94) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 95) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 96) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 97) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 98) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 99) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 100) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 101) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 102) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 103) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 104) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 105) {
        [self returnLevelID:@" "];
        [self returnMaxTaps:20];
        [self returnHints:0 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
}

+(void) loadPack11:(int)pack level:(int)level {
    
    // Copied from Popper Pack #1
    if (level == 1) {
        [self returnLevelID:@"111000000111111000222020003000"];
        [self returnMaxTaps:2];
        [self returnHints:43 h2:43 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 2) {
        [self returnLevelID:@"020200211030001103022022301202"];
        [self returnMaxTaps:1];
        [self returnHints:34 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 3) {
        [self returnLevelID:@"120012002100123312002100120012"];
        [self returnMaxTaps:3];
        [self returnHints:34 h2:36 h3:35 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 4) {
        [self returnLevelID:@"011032202232031121212123222022"];
        [self returnMaxTaps:1];
        [self returnHints:34 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 5) {
        [self returnLevelID:@"302322200032010111010010210013"];
        [self returnMaxTaps:3];
        [self returnHints:36 h2:13 h3:13 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 6) {
        [self returnLevelID:@"333330022200100010111110332330"];
        [self returnMaxTaps:2];
        [self returnHints:35 h2:24 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 7) {
        [self returnLevelID:@"103301112301101311322313203113"];
        [self returnMaxTaps:2];
        [self returnHints:16 h2:11 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 8) {
        [self returnLevelID:@"310000003002323101100131031321"];
        [self returnMaxTaps:4];
        [self returnHints:34 h2:12 h3:32 h4:11 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 9) {
        [self returnLevelID:@"222130333012212233202200301033"];
        [self returnMaxTaps:3];
        [self returnHints:53 h2:34 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 10) {
        [self returnLevelID:@"230012000300012202330213003322"];
        [self returnMaxTaps:4];
        [self returnHints:24 h2:44 h3:33 h4:33 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 11) {
        [self returnLevelID:@"102232221022132241422222101012"];
        [self returnMaxTaps:2];
        [self returnHints:23 h2:25 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 12) {
        [self returnLevelID:@"103221111102201002200312301200"];
        [self returnMaxTaps:1];
        [self returnHints:23 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 13) {
        [self returnLevelID:@"031322320211323203223230132222"];
        [self returnMaxTaps:4];
        [self returnHints:25 h2:13 h3:32 h4:32 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 14) {
        [self returnLevelID:@"233210002321030233122103021311"];
        [self returnMaxTaps:4];
        [self returnHints:56 h2:24 h3:34 h4:34 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 15) {
        [self returnLevelID:@"131320022302430321221220323120"];
        [self returnMaxTaps:3];
        [self returnHints:54 h2:22 h3:43 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 16) {
        [self returnLevelID:@"312310030323022233221103102012"];
        [self returnMaxTaps:2];
        [self returnHints:43 h2:34 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 17) {
        [self returnLevelID:@"303322103301121200313010012312"];
        [self returnMaxTaps:1];
        [self returnHints:42 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 18) {
        [self returnLevelID:@"211202332132311332200231322320"];
        [self returnMaxTaps:2];
        [self returnHints:13 h2:45 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 19) {
        [self returnLevelID:@"303101123223224133043222221003"];
        [self returnMaxTaps:5];
        [self returnHints:16 h2:34 h3:25 h4:23 h5:32 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 20) {
        [self returnLevelID:@"002311010123020203000131322333"];
        [self returnMaxTaps:3];
        [self returnHints:24 h2:13 h3:53 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 21) {
        [self returnLevelID:@"201123222222323302033323310202"];
        [self returnMaxTaps:4];
        [self returnHints:24 h2:34 h3:34 h4:34 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 22) {
        [self returnLevelID:@"124223340001330120213322331301"];
        [self returnMaxTaps:5];
        [self returnHints:26 h2:34 h3:14 h4:32 h5:32 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 23) {
        [self returnLevelID:@"033414021132101001003202022020"];
        [self returnMaxTaps:2];
        [self returnHints:44 h2:24 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 24) {
        [self returnLevelID:@"423020134302213302322013021410"];
        [self returnMaxTaps:4];
        [self returnHints:45 h2:43 h3:33 h4:12 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 25) {
        [self returnMaxTaps:4];    
        [self returnLevelID:@"214412033132100330330120111322"];
        [self returnHints:53 h2:42 h3:24 h4:15 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 26) {
        [self returnMaxTaps:2];    
        [self returnLevelID:@"223213220121323033132112100131"];
        [self returnHints:51 h2:36 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 27) {
        [self returnMaxTaps:2];    
        [self returnLevelID:@"003310000201331212113300202300"];
        [self returnHints:33 h2:15 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 28) {
        [self returnMaxTaps:6];    
        [self returnLevelID:@"140041323031313301033202133233"];
        [self returnHints:32 h2:34 h3:34 h4:44 h5:44 h6:23 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 29) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"123202003131223220100220303231"];
        [self returnHints:11 h2:34 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 30) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"302021100111221111240430020233"];
        [self returnHints:35 h2:44 h3:54 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 31) {
        [self returnMaxTaps:5];    
        [self returnLevelID:@"002010223302323220213200102301"];
        [self returnHints:56 h2:42 h3:41 h4:43 h5:33 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 32) {
        [self returnMaxTaps:5];    
        [self returnLevelID:@"102123331221334333322323012043"];
        [self returnHints:46 h2:33 h3:33 h4:33 h5:33 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 33) {
        [self returnMaxTaps:6];    
        [self returnLevelID:@"403032024202022231312033121231"];
        [self returnHints:36 h2:26 h3:24 h4:34 h5:13 h6:33 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 34) {
        [self returnMaxTaps:1];    
        [self returnLevelID:@"243334200120030100210122323232"];
        [self returnHints:24 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 35) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"321104013221143332231122331003"];
        [self returnHints:44 h2:13 h3:24 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 36) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"002113012303111034011403024113"];
        [self returnHints:14 h2:55 h3:35 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 37) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"232000133001012313131133200022"];
        [self returnHints:44 h2:33 h3:13 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 38) {
        [self returnMaxTaps:4];    
        [self returnLevelID:@"122230103010323330002131200211"];
        [self returnHints:25 h2:44 h3:34 h4:34 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 39) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"113300100021022002034201111111"];
        [self returnHints:44 h2:44 h3:33 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 40) {
        [self returnMaxTaps:4];    
        [self returnLevelID:@"231140223202110321400040233022"];
        [self returnHints:32 h2:22 h3:23 h4:26 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 41) {
        [self returnMaxTaps:1];    
        [self returnLevelID:@"211021331232031012032132010212"];
        [self returnHints:23 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 42) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"130412204312222201212321102010"];
        [self returnHints:36 h2:33 h3:33 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 43) {
        [self returnMaxTaps:4];    
        [self returnLevelID:@"011023300303320122320233101002"];
        [self returnHints:13 h2:34 h3:41 h4:24 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 44) {
        [self returnMaxTaps:6];    
        [self returnLevelID:@"122221104303123023031013343303"];
        [self returnHints:31 h2:43 h3:35 h4:33 h5:15 h6:24 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 45) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"121320100002002103212001233002"];
        [self returnHints:46 h2:43 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 46) {
        [self returnMaxTaps:2];    
        [self returnLevelID:@"040123221311000000113020302323"];
        [self returnHints:42 h2:23 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 47) {
        [self returnMaxTaps:4];    
        [self returnLevelID:@"100142200112221341033301300332"];
        [self returnHints:33 h2:32 h3:34 h4:42 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 48) {
        [self returnMaxTaps:1];    
        [self returnLevelID:@"010013020300011103210231331001"];
        [self returnHints:34 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 49) {
        [self returnMaxTaps:5];    
        [self returnLevelID:@"233312021311303004220210134010"];
        [self returnHints:15 h2:23 h3:12 h4:52 h5:33 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 50) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"332023303032012200031230113111"];
        [self returnHints:26 h2:33 h3:33 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 51) {
        [self returnMaxTaps:5];    
        [self returnLevelID:@"043310232332132200123021033230"];
        [self returnHints:31 h2:23 h3:33 h4:33 h5:43 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 52) {
        [self returnMaxTaps:1];    
        [self returnLevelID:@"323400321130013211041201102000"];
        [self returnHints:35 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 53) {
        [self returnMaxTaps:4];    
        [self returnLevelID:@"003343203203131203312012003113"];
        [self returnHints:45 h2:14 h3:24 h4:24 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 54) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"011122200033201203130001130232"];
        [self returnHints:14 h2:36 h3:55 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 55) {
        [self returnMaxTaps:2];    
        [self returnLevelID:@"320220012200103020020211110122"];
        [self returnHints:45 h2:14 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 56) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"114202403020204122213001312222"];
        [self returnHints:34 h2:14 h3:35 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 57) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"220022033320031100313010013113"];
        [self returnHints:45 h2:42 h3:15 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 58) {
        [self returnMaxTaps:2];    
        [self returnLevelID:@"210103312003030210320311311203"];
        [self returnHints:35 h2:34 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 59) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"022220022023022022000000103210"];
        [self returnHints:36 h2:35 h3:35 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 60) {
        [self returnMaxTaps:2];    
        [self returnLevelID:@"312000100312110001000203233311"];
        [self returnHints:36 h2:25 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 61) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"001200242043122213123200131130"];
        [self returnHints:51 h2:44 h3:44 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 62) {
        [self returnMaxTaps:6];    
        [self returnLevelID:@"320030030230302012113001030202"];
        [self returnHints:42 h2:46 h3:25 h4:25 h5:24 h6:24 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 63) {
        [self returnMaxTaps:2];    
        [self returnLevelID:@"234232223010131043331111000211"];
        [self returnHints:33 h2:25 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 64) {
        [self returnMaxTaps:1];    
        [self returnLevelID:@"131203202021102113213002100220"];
        [self returnHints:34 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 65) {
        [self returnMaxTaps:2];    
        [self returnLevelID:@"212103012000133223230121321011"];
        [self returnHints:44 h2:45 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 66) {
        [self returnMaxTaps:2];    
        [self returnLevelID:@"331111023221321232223331020001"];
        [self returnHints:24 h2:24 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 67) {
        [self returnMaxTaps:2];    
        [self returnLevelID:@"022223001331312121332003333113"];
        [self returnHints:55 h2:41 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 68) {
        [self returnMaxTaps:2];    
        [self returnLevelID:@"200330202421130212112221110222"];
        [self returnHints:35 h2:25 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 69) {
        [self returnMaxTaps:4];    
        [self returnLevelID:@"023301032010320010330222312110"];
        [self returnHints:23 h2:23 h3:22 h4:54 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 70) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"231222123321023103122300102311"];
        [self returnHints:24 h2:24 h3:24 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 71) {
        [self returnMaxTaps:4];    
        [self returnLevelID:@"303302020131321020014310101313"];
        [self returnHints:45 h2:32 h3:44 h4:43 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 72) {
        [self returnMaxTaps:2];    
        [self returnLevelID:@"200232302202113010112201314022"];
        [self returnHints:52 h2:24 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 73) {
        [self returnMaxTaps:2];    
        [self returnLevelID:@"220322233331321030031010323111"];
        [self returnHints:51 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 74) {
        [self returnMaxTaps:2];    
        [self returnLevelID:@"231020223332011210113233331133"];
        [self returnHints:44 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 75) {
        [self returnMaxTaps:1];    
        [self returnLevelID:@"330303322132303133311031331110"];
        [self returnHints:24 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 76) {
        [self returnMaxTaps:2];    
        [self returnLevelID:@"102221112100400212111021221111"];
        [self returnHints:34 h2:34 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 77) {
        [self returnMaxTaps:4];    
        [self returnLevelID:@"224100201004413103022233020101"];
        [self returnHints:34 h2:43 h3:12 h4:21 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 78) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"211313100412313031020032020013"];
        [self returnHints:45 h2:35 h3:25 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 79) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"431313102210001302200200002121"];
        [self returnHints:25 h2:24 h3:11 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 80) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"440100310312112132122321202132"];
        [self returnHints:11 h2:22 h3:45 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 81) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"302101122220233103012203320001"];
        [self returnHints:14 h2:34 h3:36 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 82) {
        [self returnMaxTaps:4];    
        [self returnLevelID:@"013001032121233300223031032213"];
        [self returnHints:24 h2:23 h3:33 h4:54 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 83) {
        [self returnMaxTaps:2];    
        [self returnLevelID:@"212134312321114102232221022011"];
        [self returnHints:36 h2:32 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 84) {
        [self returnMaxTaps:2];    
        [self returnLevelID:@"213113010331122123332321302003"];
        [self returnHints:22 h2:51 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 85) {
        [self returnMaxTaps:2];    
        [self returnLevelID:@"112221232223313113010020123212"];
        [self returnHints:32 h2:35 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 86) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"222103123310013131100021231301"];
        [self returnHints:36 h2:45 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 87) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"010021332201220213322323202320"];
        [self returnHints:16 h2:34 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 88) {
        [self returnMaxTaps:2];    
        [self returnLevelID:@"220002123232120110023010302032"];
        [self returnHints:34 h2:25 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 89) {
        [self returnMaxTaps:4];    
        [self returnLevelID:@"212223310123333322221311303220"];
        [self returnHints:24 h2:35 h3:51 h4:51 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 90) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"122230010223330322231221112021"];
        [self returnHints:52 h2:44 h3:25 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 91) {
        [self returnMaxTaps:2];    
        [self returnLevelID:@"232233433323102311231122132000"];
        [self returnHints:33 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 92) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"213320223103301022222310133123"];
        [self returnHints:45 h2:35 h3:24 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 93) {
        [self returnMaxTaps:1];    
        [self returnLevelID:@"000001312220002102113010321311"];
        [self returnHints:42 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 94) {
        [self returnMaxTaps:4];    
        [self returnLevelID:@"220313122303102134002100121033"];
        [self returnHints:51 h2:35 h3:35 h4:35 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 95) {
        [self returnMaxTaps:1];    
        [self returnLevelID:@"023334310211021121100332211000"];
        [self returnHints:25 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 96) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"012221312113231032011233012333"];
        [self returnHints:45 h2:45 h3:24 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 97) {
        [self returnMaxTaps:3];    
        [self returnLevelID:@"432112232120233102332230232000"];
        [self returnHints:23 h2:23 h3:53 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 98) {
        [self returnMaxTaps:2];    
        [self returnLevelID:@"511332030212033402122102021213"];
        [self returnHints:43 h2:43 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 99) {
        [self returnLevelID:@"223010011100030200130320020200"];
        [self returnMaxTaps:4];
        [self returnHints:42 h2:32 h3:32 h4:32 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 100) {
        [self returnLevelID:@"120000103203111110010132223021"];
        [self returnMaxTaps:1];
        [self returnHints:31 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 101) {
        [self returnLevelID:@"131002103220232210003132322323"];
        [self returnMaxTaps:2];
        [self returnHints:34 h2:34 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 102) {
        [self returnLevelID:@"203033120212032103210200300332"];
        [self returnMaxTaps:4];
        [self returnHints:21 h2:42 h3:54 h4:32 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 103) {
        [self returnLevelID:@"101222020331302000322313210031"];
        [self returnMaxTaps:4];
        [self returnHints:52 h2:33 h3:33 h4:44 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 104) {
        [self returnLevelID:@"101030023220220022022101023023"];
        [self returnMaxTaps:3];
        [self returnHints:44 h2:24 h3:23 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
    else if (level == 105) {
        [self returnLevelID:@"021313213232012322133033212102"];
        [self returnMaxTaps:3];
        [self returnHints:22 h2:24 h3:24 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    }
}

+(id) requestLevelID:(int)pack level:(int)level {

    if (pack == 2) {
        [self loadPack2:pack level:level];
    }
    else if (pack == 3) {
        [self loadPack3:pack level:level];
    }
    else if (pack == 4) {
        [self loadPack4:pack level:level];
    }
    else if (pack == 5) {
        [self loadPack5:pack level:level];
    }
    else if (pack == 6) {
        [self loadPack6:pack level:level];
    }
    else if (pack == 7) {
        [self loadPack7:pack level:level];
    }
    else if (pack == 8) {
        [self loadPack8:pack level:level];
    }
    else if (pack == 11) {
         [self loadPack11:pack level:level];
    }
    else if (pack == 12) {
        
        // Use Popper Pack #2,3,4
        if (level <= 105) {
            [self loadPack2:pack level:level];
        }
        else if ((level > 105) && (level <= 210)) {
            level = level - 105;
            [self loadPack3:pack level:level];
        }
        else if (level > 210) {
            level = level - 210;
            [self loadPack4:pack level:level];
        }
    }

    return nil;
}
 
-(void) dealloc
{	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
