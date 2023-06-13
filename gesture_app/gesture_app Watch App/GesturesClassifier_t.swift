//
// GesturesClassifier_t.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class GesturesClassifier_tInput : MLFeatureProvider {

    /// accex window input as 100 element vector of doubles
    var accex: MLMultiArray

    /// accey window input as 100 element vector of doubles
    var accey: MLMultiArray

    /// accez window input as 100 element vector of doubles
    var accez: MLMultiArray

    /// gyrox window input as 100 element vector of doubles
    var gyrox: MLMultiArray

    /// gyroy window input as 100 element vector of doubles
    var gyroy: MLMultiArray

    /// gyroz window input as 100 element vector of doubles
    var gyroz: MLMultiArray

    /// LSTM state input as 400 element vector of doubles
    var stateIn: MLMultiArray

    var featureNames: Set<String> {
        get {
            return ["accex", "accey", "accez", "gyrox", "gyroy", "gyroz", "stateIn"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "accex") {
            return MLFeatureValue(multiArray: accex)
        }
        if (featureName == "accey") {
            return MLFeatureValue(multiArray: accey)
        }
        if (featureName == "accez") {
            return MLFeatureValue(multiArray: accez)
        }
        if (featureName == "gyrox") {
            return MLFeatureValue(multiArray: gyrox)
        }
        if (featureName == "gyroy") {
            return MLFeatureValue(multiArray: gyroy)
        }
        if (featureName == "gyroz") {
            return MLFeatureValue(multiArray: gyroz)
        }
        if (featureName == "stateIn") {
            return MLFeatureValue(multiArray: stateIn)
        }
        return nil
    }
    
    init(accex: MLMultiArray, accey: MLMultiArray, accez: MLMultiArray, gyrox: MLMultiArray, gyroy: MLMultiArray, gyroz: MLMultiArray, stateIn: MLMultiArray) {
        self.accex = accex
        self.accey = accey
        self.accez = accez
        self.gyrox = gyrox
        self.gyroy = gyroy
        self.gyroz = gyroz
        self.stateIn = stateIn
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    convenience init(accex: MLShapedArray<Double>, accey: MLShapedArray<Double>, accez: MLShapedArray<Double>, gyrox: MLShapedArray<Double>, gyroy: MLShapedArray<Double>, gyroz: MLShapedArray<Double>, stateIn: MLShapedArray<Double>) {
        self.init(accex: MLMultiArray(accex), accey: MLMultiArray(accey), accez: MLMultiArray(accez), gyrox: MLMultiArray(gyrox), gyroy: MLMultiArray(gyroy), gyroz: MLMultiArray(gyroz), stateIn: MLMultiArray(stateIn))
    }

}


/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class GesturesClassifier_tOutput : MLFeatureProvider {

    /// Source provided by CoreML
    private let provider : MLFeatureProvider

    /// Activity prediction probabilities as dictionary of strings to doubles
    var labelProbability: [String : Double] {
        return self.provider.featureValue(for: "labelProbability")!.dictionaryValue as! [String : Double]
    }

    /// Class label of top prediction as string value
    var label: String {
        return self.provider.featureValue(for: "label")!.stringValue
    }

    /// LSTM state output as 400 element vector of doubles
    var stateOut: MLMultiArray {
        return self.provider.featureValue(for: "stateOut")!.multiArrayValue!
    }

    /// LSTM state output as 400 element vector of doubles
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    var stateOutShapedArray: MLShapedArray<Double> {
        return MLShapedArray<Double>(self.stateOut)
    }

    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(labelProbability: [String : Double], label: String, stateOut: MLMultiArray) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["labelProbability" : MLFeatureValue(dictionary: labelProbability as [AnyHashable : NSNumber]), "label" : MLFeatureValue(string: label), "stateOut" : MLFeatureValue(multiArray: stateOut)])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class GesturesClassifier_t {
    let model: MLModel

    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: self)
        return bundle.url(forResource: "GesturesClassifier_t", withExtension:"mlmodelc")!
    }

    /**
        Construct GesturesClassifier_t instance with an existing MLModel object.

        Usually the application does not use this initializer unless it makes a subclass of GesturesClassifier_t.
        Such application may want to use `MLModel(contentsOfURL:configuration:)` and `GesturesClassifier_t.urlOfModelInThisBundle` to create a MLModel object to pass-in.

        - parameters:
          - model: MLModel object
    */
    init(model: MLModel) {
        self.model = model
    }

    /**
        Construct GesturesClassifier_t instance by automatically loading the model from the app's bundle.
    */
    @available(*, deprecated, message: "Use init(configuration:) instead and handle errors appropriately.")
    convenience init() {
        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
    }

    /**
        Construct a model with configuration

        - parameters:
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    convenience init(configuration: MLModelConfiguration) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct GesturesClassifier_t instance with explicit path to mlmodelc file
        - parameters:
           - modelURL: the file url of the model

        - throws: an NSError object that describes the problem
    */
    convenience init(contentsOf modelURL: URL) throws {
        try self.init(model: MLModel(contentsOf: modelURL))
    }

    /**
        Construct a model with URL of the .mlmodelc directory and configuration

        - parameters:
           - modelURL: the file url of the model
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
        try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
    }

    /**
        Construct GesturesClassifier_t instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<GesturesClassifier_t, Error>) -> Void) {
        return self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
    }

    /**
        Construct GesturesClassifier_t instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
    */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> GesturesClassifier_t {
        return try await self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct GesturesClassifier_t instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<GesturesClassifier_t, Error>) -> Void) {
        MLModel.load(contentsOf: modelURL, configuration: configuration) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let model):
                handler(.success(GesturesClassifier_t(model: model)))
            }
        }
    }

    /**
        Construct GesturesClassifier_t instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
    */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> GesturesClassifier_t {
        let model = try await MLModel.load(contentsOf: modelURL, configuration: configuration)
        return GesturesClassifier_t(model: model)
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as GesturesClassifier_tInput

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as GesturesClassifier_tOutput
    */
    func prediction(input: GesturesClassifier_tInput) throws -> GesturesClassifier_tOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as GesturesClassifier_tInput
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as GesturesClassifier_tOutput
    */
    func prediction(input: GesturesClassifier_tInput, options: MLPredictionOptions) throws -> GesturesClassifier_tOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return GesturesClassifier_tOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface

        - parameters:
            - accex: accex window input as 100 element vector of doubles
            - accey: accey window input as 100 element vector of doubles
            - accez: accez window input as 100 element vector of doubles
            - gyrox: gyrox window input as 100 element vector of doubles
            - gyroy: gyroy window input as 100 element vector of doubles
            - gyroz: gyroz window input as 100 element vector of doubles
            - stateIn: LSTM state input as 400 element vector of doubles

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as GesturesClassifier_tOutput
    */
    func prediction(accex: MLMultiArray, accey: MLMultiArray, accez: MLMultiArray, gyrox: MLMultiArray, gyroy: MLMultiArray, gyroz: MLMultiArray, stateIn: MLMultiArray) throws -> GesturesClassifier_tOutput {
        let input_ = GesturesClassifier_tInput(accex: accex, accey: accey, accez: accez, gyrox: gyrox, gyroy: gyroy, gyroz: gyroz, stateIn: stateIn)
        return try self.prediction(input: input_)
    }

    /**
        Make a prediction using the convenience interface

        - parameters:
            - accex: accex window input as 100 element vector of doubles
            - accey: accey window input as 100 element vector of doubles
            - accez: accez window input as 100 element vector of doubles
            - gyrox: gyrox window input as 100 element vector of doubles
            - gyroy: gyroy window input as 100 element vector of doubles
            - gyroz: gyroz window input as 100 element vector of doubles
            - stateIn: LSTM state input as 400 element vector of doubles

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as GesturesClassifier_tOutput
    */

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func prediction(accex: MLShapedArray<Double>, accey: MLShapedArray<Double>, accez: MLShapedArray<Double>, gyrox: MLShapedArray<Double>, gyroy: MLShapedArray<Double>, gyroz: MLShapedArray<Double>, stateIn: MLShapedArray<Double>) throws -> GesturesClassifier_tOutput {
        let input_ = GesturesClassifier_tInput(accex: accex, accey: accey, accez: accez, gyrox: gyrox, gyroy: gyroy, gyroz: gyroz, stateIn: stateIn)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface

        - parameters:
           - inputs: the inputs to the prediction as [GesturesClassifier_tInput]
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as [GesturesClassifier_tOutput]
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    func predictions(inputs: [GesturesClassifier_tInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [GesturesClassifier_tOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [GesturesClassifier_tOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  GesturesClassifier_tOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
