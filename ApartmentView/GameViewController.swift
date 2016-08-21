//
//  GameViewController.swift
//  PBROrbs
//
//  Created by Avihay Assouline on 23/07/2016.
//  Copyright © 2016 MediumBlog. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene from our object file
        // MDL loader will load our material automatically because
        // we have an Apartment.obj.mtl file in our lib
        let scene = SCNScene(named: "Apartment.obj")!
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // Post processing effects setup
        
        // (1) Add Vignette
        cameraNode.camera?.vignettingPower = 0.6
        
        // (2) Add Bloom
        cameraNode.camera?.bloomIntensity = 1.4
        cameraNode.camera?.bloomBlurRadius = 1.0
        
        // (3) Depth-Of-Field Effect
        cameraNode.camera?.focalSize = 20.0
        cameraNode.camera?.focalBlurRadius = 5.0
        cameraNode.camera?.focalDistance = 1.0
        
        
        // Change the near field so items will not get occluded
        cameraNode.camera?.zNear = 0.1

        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: -9.0, z: 10)
        
        // Setup background - This will be the beautiful blurred background
        // that assist the user understand the 3D envirnoment
        let bg = UIImage(named: "sunsetBlurred.jpg")
        scene.background.contents = bg;

        // Setup Image Based Lighting (IBL) map
        let env = UIImage(named: "sunset.jpg")
        scene.lightingEnvironment.contents = env
        scene.lightingEnvironment.intensity = 2.0
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // Setup Antialiasing to best quality
        scnView.antialiasingMode = .multisampling4X
        
        // set the scene to the view
        scnView.scene = scene
        
        // disallow the user to manipulate the camera
        scnView.allowsCameraControl = true

        // Add some cool animations
        cameraNode.run(SCNAction.repeatForever(SCNAction.moveBy(x: -0.002, y: 0.002, z: -0.02, duration: 0.01)))
        cameraNode.run(SCNAction.repeatForever(SCNAction.rotate(byAngle: 0.001, aroundAxis: SCNVector3Make(0.0, 1, 0), duration: 0.01)))
    
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
