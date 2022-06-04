//
//  EmojPageView.h
//  mingZhong
//
//  Created by apple on 2021/3/29.
//

#import <UIKit/UIKit.h>
#import "EmojHelp.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^EmojPageViewClickBlock)(EmojModel * model);


@interface EmojPageView : UIView

@property (nonatomic, copy) EmojPageViewClickBlock clickBlock;

- (void)reloadData;

@end


@interface EmojListView : UIView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, copy) EmojPageViewClickBlock clickBlock;

@end


@interface EmojCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * emojImgView;

@end

NS_ASSUME_NONNULL_END
