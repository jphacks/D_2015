//
//  DeepViewModel.swift
//  Daicon_watchos WatchKit Extension
//
//  Created by 立花巧樹 on 2020/11/04.
//

import Foundation
import AVFoundation

import CoreML
import CoreMotion

import Alamofire


struct ModelConstants{
    static let predictionWindowSize = 20
    static let sensorsUpdateInterval = 1.0 / 10.0
    static let stateInLength = 400
}

class DeepViewModel : NSObject, ObservableObject {

    let motionManager = CMMotionManager()
        
    @Published var activity_name:[String : Double] = ["label":0.0]
    @Published var label:String = ""
    @Published var muscle_count:Int = 0
    @Published var muscle_state:String = "Abs"
    @Published var muscle_states:[String] = ["Abs", "Spine", "Push-ups", "Squat"]
    @Published var muscle_states_jp:[String:String] = ["Abs" : "腹筋", "Spine" : "背筋", "Push-ups" : "腕立て", "Squat" : "スクワット"]
    
    
    @Published var start_muscle = false
    @Published var page_state = false
    
    let activityClassificationModel =  jphackclassifer_7()

    let accelDataX = try! MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let accelDataY = try! MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let accelDataZ = try! MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)

    let gyroDataX = try! MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let gyroDataY = try! MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let gyroDataZ = try! MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)

    var stateOutput = try! MLMultiArray(shape:[ModelConstants.stateInLength as NSNumber], dataType: MLMultiArrayDataType.double)
    
    private var one_state:Bool = false
    private var passlabel:[String] = ["","","","","","","","","","","","","","","","","","","",""]
    
    
    override init(){
        super.init()
        self.speech_ai_voice(word: "大根へようこそ")
    }

    func record_start(){
        
        self.passlabel = ["","","","","","","","","","","","","","","","","","","",""]
        
        motionManager.deviceMotionUpdateInterval = ModelConstants.sensorsUpdateInterval
        for i in 0..<ModelConstants.predictionWindowSize {
            self.accelDataX[i] = 0
            self.accelDataY[i] = 0
            self.accelDataZ[i] = 0
            self.gyroDataX[i]  = 0
            self.gyroDataY[i]  = 0
            self.gyroDataZ[i]  = 0
        }
        
        motionManager.startDeviceMotionUpdates( to: OperationQueue.current!, withHandler:{
            deviceManager, error in
            let gyr: CMRotationRate = deviceManager!.rotationRate
            let acc: CMAcceleration = deviceManager!.userAcceleration
            
            for i in 1..<ModelConstants.predictionWindowSize {
                self.accelDataX[i-1] = self.accelDataX[i]
                self.accelDataY[i-1] = self.accelDataY[i]
                self.accelDataZ[i-1] = self.accelDataZ[i]
                self.gyroDataX[i-1]  = self.gyroDataX[i]
                self.gyroDataY[i-1]  = self.gyroDataY[i]
                self.gyroDataZ[i-1]  = self.gyroDataZ[i]
            }
            
            self.accelDataX[[ModelConstants.predictionWindowSize - 1] as [NSNumber]] = NSNumber(value: acc.x)
            self.accelDataY[[ModelConstants.predictionWindowSize - 1] as [NSNumber]] = NSNumber(value: acc.y)
            self.accelDataZ[[ModelConstants.predictionWindowSize - 1] as [NSNumber]] = NSNumber(value: acc.z)
            self.gyroDataX[[ModelConstants.predictionWindowSize - 1]  as [NSNumber]] = NSNumber(value: gyr.x)
            self.gyroDataY[[ModelConstants.predictionWindowSize - 1]  as [NSNumber]] = NSNumber(value: gyr.y)
            self.gyroDataZ[[ModelConstants.predictionWindowSize - 1]  as [NSNumber]] = NSNumber(value: gyr.z)
            
            
            let modelPrediction = try! self.activityClassificationModel.prediction(acclX: self.accelDataX, acclY: self.accelDataY, acclZ: self.accelDataZ, gyroX: self.gyroDataX, gyroY: self.gyroDataY, gyroZ: self.gyroDataZ, stateIn: nil)
            
            self.label = modelPrediction.label
            self.activity_name = modelPrediction.labelProbability
            
            for i in 1..<20 {
                self.passlabel[i-1] = self.passlabel[i]
            }
            
            self.passlabel[19] = modelPrediction.label
            print(self.passlabel)
            
            if self.passlabel[16] == self.muscle_state && self.passlabel[17] == self.muscle_state && self.passlabel[18] == self.muscle_state && self.passlabel[19] == self.muscle_state && self.one_state == false{
                self.one_state = true
                if self.muscle_count == 0{
                    self.start_muscle = true
                }
                
            }else if !(self.passlabel.contains(self.muscle_state)) && self.one_state == false && self.start_muscle == true{
                self.record_end()
                
            }else if self.passlabel[18] != self.muscle_state && self.passlabel[19] != self.muscle_state && self.one_state == true{
                
                self.muscle_count += 1
                self.speech_ai_voice(word: String(self.muscle_count))
                self.one_state = false
                
            }
        })
    }
    
    func record_end(){
        self.speech_ai_voice(word: String("\(self.muscle_states_jp[self.muscle_state]!)を\(self.muscle_count)かいしました"))
        self.upload_rasp()
        self.start_muscle = false
        self.page_state = false
        self.muscle_count = 0
        motionManager.stopDeviceMotionUpdates()
    }
    
    func speech_ai_voice(word:String){
        let talker = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: String(word))
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        talker.speak(utterance)
    }
    
    func upload_rasp(){
        var url = "http://163.221.129.99:5000/controller"
        var parameters:[String: Any] = ["training" : self.muscle_states_jp[self.muscle_state]!, "count" : self.muscle_count]
        AF.request(url, method: .post, parameters: parameters).responseJSON {response in
            print(response)
        }
    }
}
