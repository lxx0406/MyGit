//
//  JMShowBigPictureView.h
//  点击cell查看大图
//
//  Created by LiuQingying on 2017/8/1.
//  Copyright © 2017年 LiuQingying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMShowBigPictureView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate>
/** 
 图片url数组
 */
@property (strong, nonatomic) NSArray *iconArray;
/**
 图片缩略图
 */
@property (strong, nonatomic) NSArray <UIImage *>*thumbIconArray;
/**
 index 当前显示图片的序号
 */
@property (assign, nonatomic) NSInteger index;
/** 
 图片位置rectArray
 */
@property (strong, nonatomic) NSArray<NSString *> *rectArray;
/**
 点击图片的位置
 */
@property (nonatomic, assign) CGRect currentRect;

/**
 是否是付费表情
 */
@property (nonatomic, assign) BOOL is_pay;

@end
