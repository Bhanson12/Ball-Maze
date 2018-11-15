//
//  GameViewController.swift
//  Ball Maze
//
//  Created by Braydon Hanson on 2018-11-14.
//  Copyright © 2018 Braydon Hanson. All rights reserved.
//

import UIKit
import SceneKit
import CoreMotion

class GameViewController: UIViewController {
    
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    var ball: SCNNode!
    var motionManager: CMMotionManager!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupScene()
        setupCamera()
        setupBall()
        setupMotion()
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupView() {
        scnView = self.view as! SCNView
        scnView.allowsCameraControl = true
    }
    
    func setupScene() {
        scnScene = SCNScene(named: "BallMaze.scnassets/MainScene.scn")
        scnView.scene = scnScene
    }
    
    func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 200) //Position camera
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func setupBall() {
        ball = scnScene.rootNode.childNode(withName: "ball reference", recursively: true)
        //ball!.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
    }
    
    // NEED TO TEST WITH PHONE
    func setupMotion(){
        motionManager = CMMotionManager()
        
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 1.0 / 60.0
            motionManager.startGyroUpdates()
            
            let data = motionManager.gyroData
            let x = data?.rotationRate.x
            let y = data?.rotationRate.y
            let z = data?.rotationRate.z
            print(x!, y!, z!)
            
            // Need to update ball position after checking values
        }
        
        // Just testing moving the ball
        else{
            if(ball.position.x >= 0){
                ball.runAction(SCNAction.moveBy(x: -0.5, y: 0, z: 0, duration: 5))
            } else {
                ball.runAction(SCNAction.moveBy(x: 0.5, y: 0, z: 0, duration: 5))
            }
        }
    }
    
  
}

