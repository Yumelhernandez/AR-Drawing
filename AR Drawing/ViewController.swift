//
//  ViewController.swift
//  AR Drawing
//
//  Created by Yumel Hernandez on 4/15/18.
//  Copyright © 2018 Yumel Hernandez. All rights reserved.
//

import UIKit
import ARKit
class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var draw: UIButton!
    let configuration = ARWorldTrackingConfiguration() // position and orientaiton of device at all time
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = true 
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointnOfView = sceneView.pointOfView else{return} // contains current location and orientation of the camera view however encoded in transform matrix 
        let transform = pointnOfView.transform     //put it ina  transform matrix to take it out
        let orientation = SCNVector3(-transform.m31,-transform.m32, -transform.m33) //
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        let currentPositionOfCamera = orientation + location
        DispatchQueue.main.async {
            if self.draw.isHighlighted {
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.position = currentPositionOfCamera
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.black
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
            } else {
                let pointer = SCNNode(geometry: SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0.01/2))
                pointer.position = currentPositionOfCamera
                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                    if node.geometry is SCNBox {
                    node.removeFromParentNode() // removing every node form its parent node such that we are only adding the newest pointer the scene after
                       }
                })
                
                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                self.sceneView.scene.rootNode.addChildNode(pointer)
            }
            
        } // happen on the main thread not background
    }
}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.y)
}


//orientation and location = position


//override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    guard let touch = touches.first else{return}
//    let result = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
//    guard let hitResult = result.last else {return}
//    let hitTransform = SCNMatrix4(hitResult.worldTransform)
//    let hitVector = SCNVector3(hitTransform.m41, hitTransform.m42, hitTransform.m43)
//    createBall(position: hitVector)
//
//}
//
//func createBall(position : SCNVector3) {
//    let ballNode = SCNNode(geometry:SCNSphere(radius:0.07))
//    ballNode.position = position
//    sceneView.scene.rootNode.addChildNode(ballNode)
//
//
//}
