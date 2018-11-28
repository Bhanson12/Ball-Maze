//
//  GameViewController.swift
//  Ball Maze
//
//  Created by Braydon Hanson on 2018-11-14.
//  Copyright © 2018 Braydon Hanson. All rights reserved.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {
    
    let categoryEndLevel = 8;
    
    var scnView: SCNView!
    var scnScene: SCNScene!
    
    var cameraNode: SCNNode!
    var ballNode: SCNNode!
    var levelNode: SCNNode!
    var endLevelNode: SCNNode!
    
    var motion = MotionHelper()
    var motionForce = SCNVector3(0, 0, 0)
    //var motionManager: CMMotionManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupScene()
        setupCamera()
        setupNodes()
        setupLevel()
        //setupMotion()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupView() {
        scnView = self.view as! SCNView
        scnView.delegate = self
        scnView.allowsCameraControl = true
    }
    
    func setupScene() {
        scnScene = SCNScene(named: "BallMaze.scnassets/MainScene.scn")
        scnView.scene = scnScene
        
        scnScene.physicsWorld.contactDelegate = self
    }
    
    func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10) //Position camera
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func setupNodes() {
        ballNode = scnScene.rootNode.childNode(withName: "ball", recursively: true)!
        ballNode.physicsBody?.contactTestBitMask = categoryEndLevel
        //ball!.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
    }
    
    func setupLevel() {
        let levelScene = SCNScene(named: "BallMaze.scnassets/level1.scn")
        scnScene.rootNode.addChildNode((levelScene?.rootNode.childNode(withName: "level1", recursively: true))!)
        
        levelNode = scnScene.rootNode.childNode(withName: "level1", recursively: true)!
        //levelNode.position = SCNVector3(x: 0, y: 0.01, z: 0)
        
        endLevelNode = scnScene.rootNode.childNode(withName: "endBox", recursively: true)!
        //endLevelNode.position = SCNVector3(x: 0, y: 0, z: 2.5)
    }
    
    // NEED TO TEST WITH PHONE
/*    func setupMotion(){
        motionManager = CMMotionManager()
        
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 1.0 / 60.0
            motionManager.startGyroUpdates()
            
            let data = motionManager.gyroData
            let x = data?.rotationRate.x
            let y = data?.rotationRate.y
            let z = data?.rotationRate.z
            print(x, y, z)
            
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
    } */
    
    

}

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        motion.getAccelerometerData {(x, y, z) in
            self.motionForce = SCNVector3(x: x * 0.05, y: 0, z: (y + 0.8) * -0.05)
        }
        ballNode.physicsBody?.velocity += motionForce
    }
}

extension GameViewController: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        var contactNode: SCNNode!
        
        if contact.nodeA.name == "ball" {
            contactNode = contact.nodeB
        }else {
            contactNode = contact.nodeA
        }
        
        if contactNode.physicsBody?.categoryBitMask == categoryEndLevel {
            print("next level")
            
            let actionSheet = UIAlertController(title: "Level Completed", message: "Continue to next Level", preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Main Menu", style: .default, handler: nil))
            
            actionSheet.addAction(UIAlertAction(title: "Next Level", style: .default, handler: nil))
            
        }
    }
}
