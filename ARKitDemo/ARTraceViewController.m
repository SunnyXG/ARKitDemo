//
//  ARTraceViewController.m
//  ARKitDemo
//
//  Created by zhangxiaoguang on 2019/4/2.
//  Copyright © 2019 zhangxiaoguang. All rights reserved.
//

#import "ARTraceViewController.h"
#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>

@interface ARTraceViewController () <ARSCNViewDelegate, ARSessionDelegate>

@property (nonatomic, strong) ARSCNView *scnView;
@property (nonatomic, strong) ARSession *arSession;
@property (nonatomic, strong) ARWorldTrackingConfiguration *sessionConfig;
@property (nonatomic, strong) SCNNode *node;
@property(nonatomic,strong)SCNNode *planeNode;

@end

@implementation ARTraceViewController

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
        _arSession.delegate = self;
    }
    
    return _arSession;
}

- (ARSCNView *)scnView
{
    if (!_scnView) {
        _scnView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
        _scnView.delegate = self;
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

#pragma mark -

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    /*
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
    //2.获取飞机节点（一个场景会有多个节点，此处我们只写，飞机节点则默认是场景子节点的第一个）
    //所有的场景有且只有一个根节点，其他所有节点都是根节点的子节点
    
    SCNNode *shipNode = scene.rootNode.childNodes[0];
    
    self.planeNode = shipNode;
    
    //飞机比较大，释放缩放一下并且调整位置让其在屏幕中间
    shipNode.scale = SCNVector3Make(0.5, 0.5, 0.5);
    shipNode.position = SCNVector3Make(0, -15,-15);
    ;
    //一个飞机的3D建模不是一气呵成的，可能会有很多个子节点拼接，所以里面的子节点也要一起改，否则上面的修改会无效
    for (SCNNode *node in shipNode.childNodes) {
        node.scale = SCNVector3Make(0.5, 0.5, 0.5);
        node.position = SCNVector3Make(0, -15,-15);
        
    }
    
    //3.将飞机节点添加到当前屏幕中
    [self.scnView.scene.rootNode addChildNode:shipNode];
     */
}

#pragma mark - ScnViewDelegate

- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    if ([anchor isMemberOfClass:[ARPlaneAnchor class]]) {
        NSLog(@"捕捉到平地");
        
        ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
        
        SCNBox *plane = [SCNBox boxWithWidth:planeAnchor.extent.x *0.3 height:0 length:planeAnchor.extent.x*0.3 chamferRadius:0];
        plane.firstMaterial.diffuse.contents = [UIColor redColor];
        SCNNode *planenode = [SCNNode nodeWithGeometry:plane];
        planenode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
        [node addChildNode:planenode];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
            SCNNode *sNode = scene.rootNode.childNodes[0];;
            sNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
            [node addChildNode:sNode];
        });
    }
}


//刷新时调用
- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"刷新中");
}

//更新节点时调用
- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"节点更新");
    
}

//移除节点时调用
- (void)renderer:(id <SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"节点移除");
}

#pragma mark -ARSessionDelegate

//会话位置更新（监听相机的移动），此代理方法会调用非常频繁，只要相机移动就会调用，如果相机移动过快，会有一定的误差，具体的需要强大的算法去优化，笔者这里就不深入了
- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
    /*
    if (self.planeNode) {
        
        //捕捉相机的位置，让节点随着相机移动而移动
        //根据官方文档记录，相机的位置参数在4X4矩阵的第三列
        self.planeNode.position =SCNVector3Make(frame.camera.transform.columns[3].x,frame.camera.transform.columns[3].y,frame.camera.transform.columns[3].z);
    }
     */
}
- (void)session:(ARSession *)session didAddAnchors:(NSArray<ARAnchor*>*)anchors
{
    NSLog(@"添加锚点");
    
}


- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<ARAnchor*>*)anchors
{
    NSLog(@"刷新锚点");
    
}


- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<ARAnchor*>*)anchors
{
    NSLog(@"移除锚点");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
