//
//  ImageManager.swift
//  AccesoryDetection
//
//  Created by Akash Tala on 17/04/25.
//

import Vision
import UIKit

final class ImageManager {
    static let shared = ImageManager()
    private init() { }
    
    func detectAccesories(in image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let cgImage = image.cgImage else {
            print("Failed to convert UIImage to CIImage")
            return
        }
        let faceDetectionRequest = VNDetectFaceRectanglesRequest { request, error in
            DispatchQueue.main.async {
                if let error = error {
                    debugPrint("Error: \(error.localizedDescription)")
                    completion(false)
                } else if let faces = request.results as? [VNFaceObservation] {
                    if faces.count == 1, let face = faces.first, let faceAreaImg = self.getCropedImage(from: cgImage, area: face.boundingBox) {
                        completion(self.checkAccesories(in: faceAreaImg))
                    } else if faces.count > 1 {
                        debugPrint("Multiple Face found")
                        completion(false)
                    } else {
                        debugPrint("No valid Face found")
                        completion(false)
                    }
                } else {
                    debugPrint("No face found")
                    completion(false)
                }
            }
        }
        // MARK: check it in device by removing it
        faceDetectionRequest.usesCPUOnly = true
        let imageResultHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try imageResultHandler.perform([faceDetectionRequest])
        } catch let error {
            debugPrint("Something went wrong: \(error)")
            completion(false)
        }
    }
}

// MARK: Private Methods
extension ImageManager {
//    // MARK: MobileVi
//    private func checkAccesories(in img: CGImage) -> Bool {
//        do {
//            let input = try MobileViInput(inputWith: img)
//            let model = try MobileVi()
//            let prediction = try model.prediction(input: input)
//            let label = prediction.classLabel.lowercased()
//            let perecentage: Int = Int((prediction.var_1216[label] ?? 0) * 100.0)
//            debugPrint("Label: \(prediction.classLabel), Confidence: \(perecentage)")
//            if label.contains("mask") && perecentage > 17 {
//                return false
//            }
//            if label.contains("glass") && perecentage > 20 {
//                return false
//            }
//            if (label.contains("cap") || label.contains("hat") || label.contains("bucket") || label.contains("brace")) {
//                return false
//            }
//            return true
//        } catch {
//            debugPrint("Error: \(error.localizedDescription)")
//        }
//        return false
//    }
    
//    // MARK: Codeformer
//    private func checkAccesories(in img: CGImage) -> Bool {
//        do {
//            let input = try ConformerInput(x_1With: img)
//            let model = try Conformer()
//            let prediction = try model.prediction(input: input)
//            let label = prediction.classLabel.lowercased()
//            let perecentage: Int = Int((prediction.var_2736[label] ?? 0) * 100.0)
//            debugPrint("Label: \(prediction.classLabel), Confidence: \(perecentage)%")
//            if label.contains("mask") || label.contains("glass") || label.contains("cap") || label.contains("hat") || label.contains("bucket") || label.contains("brace") {
//                return false
//            }
//            return true
//        } catch {
//            debugPrint("Error: \(error.localizedDescription)")
//        }
//        return false
//    }
    
//    // MARK: Efficientnet
//    private func checkAccesories(in img: CGImage) -> Bool {
//        do {
//            let input = try efficientnetInput(keras_layer_1_inputWith: img)
//            let model = try efficientnet(configuration: MLModelConfiguration())
//            let prediction = try model.prediction(input: input)
//            let label = prediction.classLabel.lowercased()
//            let perecentage: Int = Int((prediction.Identity[label] ?? 0) * 100.0)
//            debugPrint("Label: \(prediction.classLabel), Confidence: \(perecentage)%")
//            if label.contains("mask") || label.contains("glass") || label.contains("cap") || label.contains("hat") || label.contains("bucket") || label.contains("brace") {
//                return false
//            }
//            return true
//        } catch {
//            debugPrint("Error: \(error.localizedDescription)")
//        }
//        return false
//    }
    
//    // MARK: MobileViT
//    private func checkAccesories(in img: CGImage) -> Bool {
//        do {
//            let input = try MobileViTInput(imageWith: img)
//            let model = try MobileViT(configuration: MLModelConfiguration())
//            let prediction = try model.prediction(input: input)
//            let label = prediction.classLabel.lowercased()
//            let perecentage: Int = Int((prediction.probabilities[label] ?? 0) * 100.0)
//            debugPrint("Label: \(prediction.classLabel), Confidence: \(perecentage)%")
//            if label.contains("mask") || label.contains("glass") || label.contains("cap") || label.contains("hat") || label.contains("bucket") || label.contains("brace") {
//                return false
//            }
//            return true
//        } catch {
//            debugPrint("Error: \(error.localizedDescription)")
//        }
//        return false
//    }
    
    // MARK: Resnet50
    private func checkAccesories(in img: CGImage) -> Bool {
        do {
            let input = try Resnet50Input(imageWith: img)
            let model = try Resnet50(configuration: MLModelConfiguration())
            let prediction = try model.prediction(input: input)
            let label = prediction.classLabel.lowercased()
            let perecentage: Int = Int((prediction.classLabelProbs[label] ?? 0) * 100.0)
            debugPrint("Label: \(prediction.classLabel), Confidence: \(perecentage)%")
            if label.contains("mask") || label.contains("glass") || label.contains("cap") || label.contains("hat") || label.contains("bucket") || label.contains("brace") || label.contains("shades") {
                return false
            }
            return true
        } catch {
            debugPrint("Error: \(error.localizedDescription)")
        }
        return false
    }
    
    private func getCropedImage(from image: CGImage, area: CGRect) -> CGImage? {
        let width = CGFloat(image.width)
        let height = CGFloat(image.height)
        
        let rect = CGRect(
            x: area.origin.x * width,
            y: (1 - area.origin.y - area.height) * height,
            width: area.width * width,
            height: area.height * height
        )
        
        return image.cropping(to: rect)
    }
}
