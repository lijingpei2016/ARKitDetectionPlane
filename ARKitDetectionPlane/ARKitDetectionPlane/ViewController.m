//
//  ViewController.m
//  ARKitDetectionPlane
//
//  Created by LJP on 2018/4/2.
//  Copyright © 2018年 LJP. All rights reserved.
//

#import "ViewController.h"
#import "Plane.h"

@interface ViewController () <ARSCNViewDelegate>

@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;

//装平面的数组
@property (nonatomic, strong) NSMutableDictionary * planes;

//视图
@property (nonatomic, strong) ARSCNView * jpARSCNView;

//会话
@property (nonatomic, strong) ARSession * jpARSession;

//跟踪会话
@property (nonatomic, strong) ARWorldTrackingConfiguration * jpARWTkConfiguration;

@end

    
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化数组
    self.planes = [[NSMutableDictionary alloc]init];

    
    // Set the view's delegate
    self.sceneView.delegate = self;
    
    // Show statistics such as fps and timing information
    self.sceneView.showsStatistics = YES;
    
    // Create a new scene
    SCNScene *scene = [SCNScene new];
    
    // Set the scene to the view
    self.sceneView.scene = scene;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Create a session configuration
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];

    configuration.planeDetection = ARPlaneDetectionHorizontal | ARPlaneDetectionVertical;
    
    configuration.lightEstimationEnabled = YES;

    // Run the view's session
    [self.sceneView.session runWithConfiguration:configuration];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Pause the view's session
    [self.sceneView.session pause];
}

#pragma mark ============================== 代理方法 ==============================

- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    
    NSLog(@"检测到了");
    
    ARPlaneAnchor * planeAnchor = (ARPlaneAnchor *)anchor;
    
    Plane * jpPlane = [[Plane alloc]initWithAnchor:planeAnchor];
    
    NSUUID * uuid = anchor.identifier;
    NSString * str = [uuid UUIDString];
    
    [self.planes setObject:jpPlane forKey:str];
    
    [node addChildNode:jpPlane];
    
}

-(void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    
    // anchor 更新后也需要更新 3D 几何体。例如平面检测的高度和宽度可能会改变，所以需要更新 SceneKit 几何体以匹配
    //uuid用于区别是那一个几何图形  但是他是anchor里的信息
    
    NSUUID * uuid = anchor.identifier;
    
    NSString * str = [uuid UUIDString];
    
    Plane * jpPlane = self.planes[str];
    
    ARPlaneAnchor * planeAnchor = (ARPlaneAnchor *)anchor;
    
    [jpPlane update:planeAnchor];
    
}

-(void)renderer:(id<SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    
    NSUUID * uuid = anchor.identifier;
    
    NSString * str = [uuid UUIDString];
    
    [self.planes removeObjectForKey:str];
}


@end
