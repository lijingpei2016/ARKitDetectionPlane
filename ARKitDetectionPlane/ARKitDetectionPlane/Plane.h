//
//  Plane.h
//  第二个铺抓平面
//
//  Created by LJP on 6/12/17.
//  Copyright © 2017年 poco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>


//ARPlaneAnchor - 关于在AR会话中检测到的真实平面的位置和方向的信息。
//SCNPlane 创建一个平面几何形状
//用其对平面几何进行渲染 SCNMaterial

@interface Plane : SCNNode

@property (nonatomic, strong) ARPlaneAnchor * anchor;

@property (nonatomic, strong) SCNPlane * planeGeometry;


/**
 初始化方法

 @param anchor 检测到的平面信息
 @return 几何体模型
 */
-(instancetype)initWithAnchor:(ARPlaneAnchor *)anchor;

/**
 平面信息改变调整几何模型大小

 @param anchor 新的平面信息
 */
- (void)update:(ARPlaneAnchor* )anchor;

/**
 改变几何模型的纹理大小
 */
- (void)setTextureScale;

@end
