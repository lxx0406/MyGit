//
//  JMShowBigPictureView.m
//  点击cell查看大图
//
//  Created by LiuQingying on 2017/8/1.
//  Copyright © 2017年 LiuQingying. All rights reserved.
//

#import "JMShowBigPictureView.h"
#import "JMShowBigPictureCell.h"
#import "UIView+Extension.h"
@interface JMShowBigPictureView()
/** indexLabel 图片序号指示器 */
@property (nonatomic, strong) UILabel *indexLabel;
/**
 显示当前序号的window
 */
@property (nonatomic, strong) UIWindow *indexWindow;
/**
 动画效果
 */
@property (nonatomic, assign) BOOL needAnimate;
@end
static NSString *const showBigPictureCellID = @"showBigPictureCellID";
@implementation JMShowBigPictureView
- (UILabel *)indexLabel{
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.backgroundColor = rgba(0, 0, 0, 0.6);
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.font = [UIFont systemFontOfSize:15];
        self.indexLabel.text = [NSString stringWithFormat:@"%zd/%zd", self.index+1, _iconArray.count];
    }
    return _indexLabel;
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.needAnimate = YES;
    if (_index) [self setContentOffset:CGPointMake((self.frame.size.width) * _index, 0) animated:NO];
    if (!_indexLabel&&_iconArray.count>1) {
        self.indexWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [_indexWindow setBackgroundColor:[UIColor clearColor]];
        [_indexWindow setWindowLevel:UIWindowLevelAlert + 1];
        [_indexWindow makeKeyAndVisible];
        [_indexWindow addSubview:self.indexLabel];
        [self performSelector:@selector(hideIndex) withObject:nil afterDelay:1];
    }


}
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        UICollectionViewFlowLayout *layout1 = (UICollectionViewFlowLayout *)layout;
        layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout1.itemSize = CGSizeMake(SCREEN_WIDTH + 20, SCREEN_HEIGHT);
        layout1.minimumInteritemSpacing = 0;
        layout1.minimumLineSpacing = 0;
        [self registerClass:[JMShowBigPictureCell class] forCellWithReuseIdentifier:showBigPictureCellID];
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}
#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.iconArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JMShowBigPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:showBigPictureCellID forIndexPath:indexPath];
    cell.bigPictureView.currentRect = self.currentRect;
    cell.bigPictureView.is_pay = self.is_pay;
    if ([self.iconArray[indexPath.row] isKindOfClass:[NSString class]]) {
        [cell.bigPictureView setImageWithURL:self.iconArray[indexPath.row] placeholderImage:self.thumbIconArray[indexPath.row]];
    }else{
        cell.bigPictureView.imageView.image = self.iconArray[indexPath.row];
    }

    __weak __typeof(cell)weakCell = cell;
    __weak __typeof(self)weakSelf = self;
    cell.singleTapGestureBlock = ^(CGRect rect){
        
        [weakSelf.indexWindow resignKeyWindow];
        [weakSelf.window makeKeyAndVisible];
        weakSelf.indexWindow.hidden = YES;
        weakSelf.needAnimate = YES;
        weakSelf.indexWindow = nil;
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        weakSelf.backgroundColor = [UIColor clearColor];
        weakCell.backgroundColor = [UIColor clearColor];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        __strong typeof(weakCell) strongCell = weakCell;
        
        [UIView animateWithDuration:0.25 animations:^{

            strongCell.bigPictureView.imageContainerView.frame = strongSelf.currentRect;
            strongCell.bigPictureView.imageView.yy_width = strongSelf.currentRect.size.width;
            strongCell.bigPictureView.imageView.yy_height = strongSelf.currentRect.size.height;

        } completion:^(BOOL finished) {
            
            [strongSelf removeFromSuperview];
            
        }];
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[JMShowBigPictureCell class]]) {
        [(JMShowBigPictureCell *)cell recoverSubviews:_needAnimate];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[JMShowBigPictureCell class]]) {
        
        [(JMShowBigPictureCell *)cell recoverSubviews:_needAnimate];
    }
}

#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.indexWindow.hidden = NO;
    if (_indexLabel) {
        self.needAnimate = NO;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    JMShowBigPictureCell *cell = [self visibleCells][0];
    CGRect rect = [cell convertRect:[cell convertRect:cell.frame fromView:self] toView:[UIApplication sharedApplication].keyWindow];
    
    if (rect.origin.x == -10) {
        self.index = [self indexPathForCell:cell].row;
    }else if([self visibleCells].count>1){
        
        self.index = [self indexPathForCell:[self visibleCells][1]].row;
    }
    self.indexLabel.text = [NSString stringWithFormat:@"%zd/%zd", self.index+1, _iconArray.count];
    if (self.rectArray.count>self.index) {
        self.currentRect = CGRectFromString(self.rectArray[self.index]);
    }
    [self performSelector:@selector(hideIndex) withObject:nil afterDelay:1];
}
- (void)hideIndex{
    self.indexWindow.hidden = YES;
}
- (void)dealloc{

}
@end
