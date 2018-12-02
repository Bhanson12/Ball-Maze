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
    

    let categoryEndLevel = 8
    
    var scnView: SCNView!
    var scnScene: SCNScene!
    
    var cameraNode: SCNNode!
    var ballNode: SCNNode!
    var levelNode: SCNNode!
    var endLevelNode: SCNNode!
    
    var motion = MotionHelper()
    var motionForce = SCNVector3(0, 0, 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController!.navigationBar.isTranslucent = true
        
        setupWorld()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    // MARK: Private Methods
    
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
    
    func setupCameraAndLighting() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        let lightNodeDirectional = SCNNode()
        lightNodeDirectional.light = SCNLight()
        lightNodeDirectional.light?.type = SCNLight.LightType.ambient
        lightNodeDirectional.position = SCNVector3(0, 10, 5)
        
        let ambiLightNode = SCNNode()
        ambiLightNode.light = SCNLight()
        ambiLightNode.light?.type = SCNLight.LightType.ambient
        ambiLightNode.light?.color = UIColor.gray
        
        let center = SCNNode()
        lightNodeDirectional.constraints = [SCNLookAtConstraint(target: center)]
        cameraNode.constraints = [SCNLookAtConstraint(target: center)]
        
        scnScene.rootNode.addChildNode(cameraNode)
        scnScene.rootNode.addChildNode(lightNodeDirectional)
        scnScene.rootNode.addChildNode(ambiLightNode)
    }
    
    func setupNodes() {
        ballNode = scnScene.rootNode.childNode(withName: "ball", recursively: true)!
        ballNode.physicsBody?.contactTestBitMask = categoryEndLevel
        
    }

    func setupLevel() {
        let levelScene = SCNScene(named: "BallMaze.scnassets/level1.scn")
        scnScene.rootNode.addChildNode((levelScene?.rootNode.childNode(withName: "level1", recursively: true))!)
        
        levelNode = scnScene.rootNode.childNode(withName: "level1", recursively: true)!
        levelNode.position = SCNVector3(0, 0, 0)
        
        endLevelNode = scnScene.rootNode.childNode(withName: "endBox", recursively: true)!
    }
    
    func setupWorld(){
        setupView()
        setupScene()
        setupCameraAndLighting()
        setupNodes()
        setupLevel()
    }
    
    func setupUI() {
        let mainMenuButton = UIButton()
        
        
    }
    
    // MARK: Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        /*
        // Configure the destination view controller only when the pause button is pressed.
        guard let button = sender as? UIBarButtonItem, button === pauseButton else {
            return
        }*/
        
        scnScene.isPaused = true
    }
    
    @IBAction func unwindToGame(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PauseViewController{
            let option = sourceViewController.option
            print(option)
            
            switch option {
            case 0:
                scnScene.isPaused = false
            case 1:
                setupWorld()
                scnScene.isPaused = false
            case 2:
                self.navigationController?.popToRootViewController(animated: false)
            default:
                scnScene.isPaused = false
            }
        }
    }
    
  
    
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
            
            let alert = UIAlertController(title: "Level Completed", message: "Continue to next Level", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Main Menu", style: .default, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Next Level", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}


