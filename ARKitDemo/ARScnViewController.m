//
//  ARScnViewController.m
//  ARKitDemo
//
//  Created by zhangxiaoguang on 2019/4/2.
//  Copyright © 2019 zhangxiaoguang. All rights reserved.
//

#import "ARScnViewController.h"
#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>

@interface ARScnViewController ()

@property (nonatomic, strong) ARSCNView *scnView;
@property (nonatomic, strong) ARSession *arSession;
@property (nonatomic, strong) ARWorldTrackingConfiguration *sessionConfig;
@property (nonatomic, strong) SCNNode *node;

@end

@implementation ARScnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configView];
}

#pragma mark - Property

- (ARWorldTrackingConfiguration *)sessionConfig
{
    if (!_sessionConfig) {
        _sessionConfig = [ARWorldTrackingConfiguration new];
        _sessionConfig.planeDetection = ARPlaneDetectionHorizontal;
        _sessionConfig.lightEstimationEnabled = YES;
    }
    
    return _sessionConfig;
}

- (ARSession *)arSession
{
    if (!_arSession) {
        _arSession = [ARSession new];
    }
    
    return _arSession;
}

- (ARSCNView *)scnView
{
    if (!_scnView) {
        _scnView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
        _scnView.session = self.arSession;
        _scnView.automaticallyUpdatesLighting = YES;
    }
    
    return _scnView;
}

#pragma mark - Function

- (void)configView
{
    [self.view addSubview:self.scnView];
    [self.arSession runWithConfiguration:self.sessionConfig];
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
    SCNNode *shipNode = scene.rootNode.childNodes[0];
    shipNode.position = SCNVector3Make(0, -1, -1);
    
    [self.scnView.scene.rootNode addChildNode:shipNode];
}


@end
