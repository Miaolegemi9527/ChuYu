//
//  HomeCVFlowLayout.m
//  Mine
//
//  Created by lanou on 16/1/13.
//  Copyright © 2016年 9527. All rights reserved.
//

#import "HomeCVFlowLayout.h"

@implementation HomeCVFlowLayout

-(id)init{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = 30.0*SCALE_X;//item间距
        //self.sectionInset = UIEdgeInsetsMake(64, 15, 0, 15);//item距离屏幕上、左、下、右高度
        
        [self bigOrSmall];
    }
    return self;
}
-(void)bigOrSmall
{
    int xxx = (int)XX;
    int xxx2 = (int)(15*SCALE_X);
    if (xxx == xxx2) {
        [UIView animateWithDuration:1.0 animations:^{
            self.sectionInset = UIEdgeInsetsMake(48*SCALE_Y, 15*SCALE_X, 0, 15*SCALE_X);//item距离屏幕上、左、下、右高度
        }];
    }
    else if (xxx == 0)
    {
        [UIView animateWithDuration:1.0 animations:^{
            self.sectionInset = UIEdgeInsetsMake(48*SCALE_Y, 0, 0, 0);//item距离屏幕上、左、下、右高度
        }];
    }
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);//collectionView落在屏幕中点的x坐标
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
    
}

static CGFloat const ActiveDistance = 350;
static CGFloat const ScaleFactor = 0.05;

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    //NSLog(@"x=%f",self.collectionView.contentOffset.x);
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
        //NSLog(@"distance=%f",distance);
        CGFloat normalizedDistance = distance / ActiveDistance;
        CGFloat zoom = 1 + ScaleFactor*(1 - ABS(normalizedDistance));
        attributes.transform3D = CATransform3DMakeScale(1.0, zoom, 1.0);
        attributes.zIndex = 1;
    }
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


@end
