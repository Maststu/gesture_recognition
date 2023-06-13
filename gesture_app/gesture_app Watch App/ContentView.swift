import SwiftUI
import CoreML
import CoreMotion
//main関数の呼び出す回数と，センサのサンプリング周波数は同じであるが，処理の重さなどの外的要因により，インクリメントがずれる
struct ContentView: View {
    //IMU sensor
    @ObservedObject var sensor = MotionSensor()
    
    
    
    //timer(100 Hz)
    let timer = Timer.publish(every: 1/100, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            //Button (ON:ジェスチャ認識開始 OFF:ジェスチャ認識停止)
            Button(action:{
                if sensor.isStarted {
                    sensor.stop()
                }else{
                    sensor.start()
                    sensor.print_result()
                }
//
            }){
                sensor.isStarted ? Text("predicted..."):Text("START")
            }
            
            
        }
        .onReceive(timer){_ in
            if sensor.isStarted {
                sensor.print_result()

            }

        }
        
    }
    
    
}

class GesturesClassifier{
    //Create arrays for aggregating inputs
    struct ModelConstants{
        static let predictionWindowSize = 100
        static let sensorsUpdateInterval = 1.0/100.0
        static let stateInLength = 400
    }
    
    //acceleration
    let accelDataX = try! MLMultiArray(shape:[ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let accelDataY = try! MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let accelDataZ = try! MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    //gyro sensor
    let gyroDataX = try! MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let gyroDataY = try! MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let gyroDataZ = try! MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    
    var stateOutput = try! MLMultiArray(shape: [ModelConstants.stateInLength as NSNumber], dataType: MLMultiArrayDataType.double)
    
    var currentIndexInPredictionWindow: Int = 0
    
    var t_stamp = 0.0
    
    //gesture pose
    @Published var gesture_pose: String = ""
    
    var model:Gestures_Classifier_t
    
    init(){
        model = Gestures_Classifier_t()
        
    }
    
    func addSampleToDataArray(Sample: MotionSensor){
        
        currentIndexInPredictionWindow = Sample.cnt
        accelDataX[[currentIndexInPredictionWindow] as [NSNumber]] = Sample.acceX as NSNumber
        accelDataY[[currentIndexInPredictionWindow] as [NSNumber]] = Sample.acceY as NSNumber
        accelDataZ[[currentIndexInPredictionWindow] as [NSNumber]] = Sample.acceZ as NSNumber
        gyroDataX[[currentIndexInPredictionWindow] as [NSNumber]] = Sample.rotX as NSNumber
        gyroDataY[[currentIndexInPredictionWindow] as [NSNumber]] = Sample.rotY as NSNumber
        gyroDataZ[[currentIndexInPredictionWindow] as [NSNumber]] = Sample.rotZ as NSNumber
       
        
//        print("time:\(Sample.timestamp)-\(t_stamp)\n")
//        print("currentIndexInPredictionWindow:\(currentIndexInPredictionWindow)\n")
//        
//        if(currentIndexInPredictionWindow % ModelConstants.predictionWindowSize == 0){
//            if let predictedActivity = perfomModelPrediction(model:self.model){
//                //初期化
//                
//                Sample.cnt = 0
//                
//                //
//                if predictedActivity == "pinch_3"{
//                    gesture_pose = "pinch"
//                }else if predictedActivity == "neutral_3"{
//                    gesture_pose = "neutral"
//                }
//                
//                print(Sample.cnt)
//                
//                
//            }
//        }
        
        
    }
    
    func perfomModelPrediction(model:Gestures_Classifier_t) -> String?{
        
        let modelPrediction = try! model.prediction(accex: accelDataX, accey: accelDataY, accez: accelDataZ, gyrox: gyroDataX, gyroy: gyroDataY, gyroz: gyroDataZ, stateIn: stateOutput)
        
        stateOutput = modelPrediction.stateOut
        
        return modelPrediction.label
    }
    
    
}


class MotionSensor: NSObject, ObservableObject{
    let motionManager = CMMotionManager()
    // Load the CoreML model
    let model = GesturesClassifier()
    
    @Published var isStarted = false
    
    @Published var acceX = 0.0
    @Published var acceY = 0.0
    @Published var acceZ = 0.0
    
    @Published var rotX = 0.0
    @Published var rotY = 0.0
    @Published var rotZ = 0.0
    
    @Published var timestamp = 0.0
    
    @Published var cnt: Int = 0
    func start(){
        if motionManager.isDeviceMotionAvailable{
            motionManager.deviceMotionUpdateInterval = 1/100
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {(motion:CMDeviceMotion?, error:Error?) in self.updateMotionData(deviceMotion: motion!)})
            
        }
        
        isStarted = true
    }
    
    func stop(){
        isStarted = false
        motionManager.stopDeviceMotionUpdates()
    }
    
    func print_result(){
        print(model.gesture_pose)
    }
    
    private func updateMotionData(deviceMotion:CMDeviceMotion){
        
        cnt += 1
        model.addSampleToDataArray(Sample: self)
        
        
        
    }
    
}
