/********************************************************
 * @file    : TuMonsterDatasets.m
 * @project : TuSDKVideoDemo
 * @author  : Copyright © http://tutucloud.com/
 * @date    : 2020-08-01
 * @brief   : 哈哈镜
*********************************************************/
#import "TuMonsterDatasets.h"
#import <TuSDKPulseCore/TuSDKPulseCore.h>
#import "TTRenderDef.h"
/** TuMonsterData************************************************/
@implementation TuMonsterData
- (BOOL)online
{
    return NO;
}

- (void)loadThumb:(UIImageView *)thumbImageView completed:(void (^)(BOOL))hander
{
    if (!thumbImageView)
    {
        return;
    }
    
    thumbImageView.image = [UIImage imageNamed:self.thumbImageName];
    if (hander)
    {
        hander(YES);
    }
}

- (void)load
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryItemLoadCompleted:)])
    {
        [self.delegate categoryItemLoadCompleted:self];
    }
}

@end


/** TuMonsterDatasets************************************************/
@implementation TuMonsterDatasets
-(instancetype)init
{
    if (self = [super init])
    {
//        self.categoryType = TuSDKMediaEffectDataTypeMonsterFace;
    }
    return self;
}

+ (NSArray *)allCategories
{
    static NSArray<TuStickerBaseDatasets *> *categories;
    if (categories)
    {
        return categories;
    }
    
    NSMutableArray<TuStickerBaseDatasets *> *allCagegories = [NSMutableArray array];
    TuMonsterDatasets *monsterCategory = [[TuMonsterDatasets alloc] init];
    monsterCategory.name = NSLocalizedStringFromTable(@"tu_哈哈镜", @"VideoDemo", @"哈哈镜");
    [allCagegories addObject:monsterCategory];
    
    NSMutableArray<TuStickerBaseData *> *monsterPropItems = [NSMutableArray array];
    
    NSDictionary<NSNumber*,NSString*> *monsterFaceTypeDic =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    /** 图片缩略图 ： 哈哈镜类型  */
                    // 哈哈镜 - 大鼻子
                    @"bignose",@(TTMonsterStyleBigNose),
                    // 哈哈镜 - 木瓜脸
                    @"papaya",@(TTMonsterStylePapayaFace),
                    // 哈哈镜 - 大饼脸
                    @"pie",@(TTMonsterStylePieFace),
                    // 哈哈镜 - 眯眯眼
                    @"smalleyes",@(TTMonsterStyleSmallEyes),
                    // 哈哈镜 - 蛇精脸
                    @"snake",@(TTMonsterStyleSnakeFace),
                    // 哈哈镜 - 国字脸
                    @"square",@(TTMonsterStyleSquareFace),
                    // 哈哈镜 - 厚嘴唇
                    @"thicklips",@(TTMonsterStyleThickLips),
     nil];

    [monsterFaceTypeDic.allKeys enumerateObjectsUsingBlock:^(NSNumber* _Nonnull monsterFaceType, NSUInteger idx, BOOL * _Nonnull stop)
    {
        TuMonsterData *propsItem = [[TuMonsterData alloc] init];
        propsItem.item = monsterFaceType;
        propsItem.thumbImageName = [NSString stringWithFormat:@"face_monster_ic_%@",[monsterFaceTypeDic objectForKey:monsterFaceType]];
        [monsterPropItems addObject:propsItem];
    }];
    
    monsterCategory.propsItems = monsterPropItems;
    return categories = allCagegories;
}

- (BOOL)canRemovePropsItem:(TuStickerBaseData *)propsItem
{
    return NO;
}


@end
