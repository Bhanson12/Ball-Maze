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
    
    var totalScore: Int!
    var levelScore: Int!
    var levelTimer: Timer!
    let categoryEndLevel = 8
    
    var scnView: SCNView!
    var scnScene: SCNScene!
    
    var cameraNode: SCNNode!
    var ballNode: SCNNode!
    var levelNode: SCNNode!
    var endLevelNode: SCNNode!
    var currentLevel = level()
    
    var motion = MotionHelper()
    var motionForce = SCNVector3(0, 0, 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalScore = 0
        setupGame()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    // MARK: Setup Methods
    
    func setupView() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController!.navigationBar.isTranslucent = true
        
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
        let levelScene = SCNScene(named: "BallMaze.scnassets/" + String(currentLevel.num) + ".scn")
        scnScene.rootNode.addChildNode((levelScene?.rootNode.childNode(withName: String(currentLevel.num), recursively: true))!)
        
        levelNode = scnScene.rootNode.childNode(withName: String(currentLevel.num), recursively: true)!
        
        endLevelNode = scnScene.rootNode.childNode(withName: "endBox", recursively: true)!
    }
    
    func setupWorld() {
        setupView()
        setupScene()
        setupCameraAndLighting()
        setupNodes()
        setupLevel()
    }
    
    func setupTimer() {
        levelTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(calcScore), userInfo: nil, repeats: true)
    }
    
    func setupScore() {
        levelScore = 1000
    }
    
    func setupGame() {
        setupWorld()
        setupTimer()
        setupScore()
    }
    
    // MARK: Helper Functions
    
    @objc func calcScore() {
        if(levelScore >= 0) {
            levelScore = levelScore - 1
            print(levelScore)
        }/*
        if(levelScore == 998) {
            levelTimer.invalidate()
            scnScene.isPaused = true
            self.performSegue(withIdentifier: "LevelComplete", sender: nil)
        }*/
    }
    
    func getScore() -> Int {
        return totalScore
    }
    
    func unPause() {
        scnScene.isPaused = false
        setupTimer()
    }
    
    func restartLevel() {
        setupGame()
        scnScene.isPaused = false
    }
    
    
    // MARK: Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller for pausing only when the pause button is pressed.
        // else the level is completed
        if let button = sender as? UIBarButtonItem, button === self.navigationItem.rightBarButtonItem {
            levelTimer.invalidate()
            scnScene.isPaused = true
            SFXController.sharedSFX.playButtonSound()
        } else {
            totalScore = totalScore + levelScore
            if segue.identifier == "LevelComplete" {
                if let destVC = segue.destination as? LevelCompleteViewController {
                    destVC.scoreIn = totalScore
                }
            }
            totalScore = totalScore + levelScore
            levelTimer.invalidate()
            
        }
        
    }
    
    @IBAction func unwindToGame(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PauseViewController {
            let option = sourceViewController.option
            
            switch option {
            case 0:
                unPause()
            case 1:
                restartLevel()
            case 2:
                self.navigationController?.popToRootViewController(animated: false)
            default:
                self.navigationController?.popToRootViewController(animated: false)
            }
        } else if let sourceViewController = sender.source as? LevelCompleteViewController {
            let option = sourceViewController.option
            
            switch option {
            case 0:
                // next level
                currentLevel.incrementLevel()
                setupGame()
            case 1:
                self.navigationController?.popToRootViewController(animated: false)
            default:
                self.navigationController?.popToRootViewController(animated: false)
            }
        }
    }
}

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        motion.getAccelerometerData {(x, y, z) in
            self.motionForce = SCNVector3(x: x * 0.05, y: 0, z: (y + 0.8) * -0.05)
        }
        
        // for pc level completion
        self.motionForce = SCNVector3(x: 0, y: 0, z: -0.08)
        
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
            levelTimer.invalidate()
            scnScene.isPaused = true
            OperationQueue.main.addOperation {
                [weak self] in
                self?.performSegue(withIdentifier: "LevelComplete", sender: nil)
            }
            
        }
    }
    
    
}


