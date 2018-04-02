//
//  Plane.m
//  第二个铺抓平面
//
//  Created by LJP on 6/12/17.
//  Copyright © 2017年 poco. All rights reserved.
//

#import "Plane.h"
#import "math.h"


@implementation Plane


-(instancetype)initWithAnchor:(ARPlaneAnchor *)anchor {
    
    self = [super init];
    
    if (self) {
        
        self.anchor = anchor;
        
        _planeGeometry = [SCNPlane planeWithWidth:anchor.extent.x height:anchor.extent.z];
        SCNNode * planeNode = [SCNNode nodeWithGeometry:_planeGeometry];
        planeNode.simdPosition = SCNVector3ToFloat3(SCNVector3Make(anchor.center.x, 0, anchor.center.z));
        planeNode.eulerAngles = SCNVector3Make(-M_PI/2.0, 0, 0);
        planeNode.opacity = 0.25;//透明度
        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);

        [self setTextureScale];

        [self addChildNode:planeNode];
        
    }
    
    return self;
}

- (void)setTextureScale {
    
    CGFloat w = self.planeGeometry.width;
    CGFloat h = self.planeGeometry.height;
    
    SCNMaterial * material = self.planeGeometry.materials[0];
    
    material.diffuse.contentsTransform = SCNMatrix4MakeScale(w, h, 1);
    
    material.diffuse.wrapS = SCNWrapModeRepeat;
    
    material.diffuse.wrapT = SCNWrapModeRepeat;
        
}

- (void)update:(ARPlaneAnchor* )anchor {
    
    // 随着用户移动，平面 plane 的 范围 extend 和 位置 location 可能会更新。
    // 需要更新 3D 几何体来匹配 plane 的新参数。
    CGFloat w = anchor.extent.x;
    CGFloat h = anchor.extent.z;
    
    self.planeGeometry.width  = w;
    self.planeGeometry.height = h;

    // plane 刚创建时中心点 center 为 0,0,0，node transform 包含了变换参数。
    // plane 更新后变换没变但 center 更新了，所以需要更新 3D 几何体的位置
    self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
    
    [self setTextureScale];
    
}

@end
