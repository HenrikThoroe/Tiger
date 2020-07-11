//
//  ImageProcessor.swift
//  Tiger
//
//  Created by Henrik Thoroe on 01.07.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import Vision

class ImageProcessor {
    
    let target: RecognitionTarget
    
    private var resultHandler: (Result) -> Void = {_ in}
    
    private var viewArea: CGRect?
    
    init(target: RecognitionTarget = .weblink) {
        self.target = target
    }
    
}

// MARK: - API
extension ImageProcessor {
    
    enum Error: Swift.Error {
        case bufferTranslation
    }
    
    enum RecognitionTarget {
        case weblink
    }
    
    struct Result: Identifiable, Hashable {
        var value: String
        let confidence: Double
        let location: CGRect
        let id = UUID()
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(value)
            hasher.combine(confidence)
            hasher.combine(id)
        }
    }
    
    func process(image data: CMSampleBuffer, in viewArea: CGRect?, resultHandler: @escaping (Result) -> Void) throws {
        let cgImage = try cast(buffer: data)
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest(completionHandler: handleTextRecognition)
        
        self.resultHandler = resultHandler
        self.viewArea = viewArea
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = false
        
        try requestHandler.perform([request])
    }
    
}

// MARK: - Private Helper Methods
private extension ImageProcessor {
    
    func cast(buffer: CMSampleBuffer) throws -> CGImage {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(buffer) else {
            throw Error.bufferTranslation
        }
        
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        let context = CIContext(options: nil)
        
        if let image = context.createCGImage(ciImage, from: ciImage.extent) {
            return image
        }
        
        throw Error.bufferTranslation
    }
    
    func handleTextRecognition(request: VNRequest, error: Swift.Error?) {
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            return
        }
        
        let recognizedText = observations
            .compactMap { (observation) -> (String, VNConfidence, CGRect)? in
                guard let text = observation.topCandidates(1).first?.string,
                    let range = text.range(of: text),
                    let rect = try? observation.topCandidates(1).first?.boundingBox(for: range) else {
                        
                    return nil
                }
                
                var textRect: CGRect?
                
                if let viewArea = self.viewArea {
                    let transform = CGAffineTransform.identity
                        .scaledBy(x: 1, y: -1)
                        .translatedBy(x: 0, y: -viewArea.size.height)
                        .scaledBy(x: viewArea.size.width, y: viewArea.size.height)

                    let convertedTopLeft = rect.topLeft.applying(transform)
                    let convertedTopRight = rect.topRight.applying(transform)
                    let convertedBottomLeft = rect.bottomLeft.applying(transform)
                    let convertedBottomRight = rect.bottomRight.applying(transform)
                    
                    textRect = CGRect(x: convertedTopLeft.x,
                                      y: convertedTopLeft.y,
                                      width: convertedTopRight.x - convertedTopLeft.x,
                                      height: convertedBottomLeft.y - convertedTopLeft.y)
                    
//                    print(textRect)
                }
                
                return (text, observation.confidence, textRect ?? CGRect(x: rect.topLeft.x, y: rect.topLeft.y,
                                                                         width: abs(rect.topRight.x - rect.topLeft.x),
                                                                         height: abs(rect.bottomLeft.y - rect.topLeft.y)))
            }
            .map {
                (fixWeblink($0.0), $0.1, $0.2)
            }
            .filter {
                isWeblink($0.0)
            }
        
        if !recognizedText.isEmpty {
            print(recognizedText)
        }
        
        for res in recognizedText {
            resultHandler(Result(value: res.0, confidence: Double(res.1), location: res.2))
        }
    }
    
    func fixWeblink(_ text: String) -> String {
        var href = text.replacingOccurrences(of: " ", with: "")
        
        if href ~= #".+:\/\/.*"# {
            let firstBackslash = href.firstIndex(of: "/")!
            let secondBackslash = href.index(after: firstBackslash)
            href.replaceSubrange(href.startIndex...secondBackslash, with: "https://")
        } else {
            href = "https://\(href)"
        }
        
        return href
    }
    
    func isWeblink(_ text: String) -> Bool {
        guard text ~= #"https:\/\/[a-zA-Z]+.*\.[a-zA-Z]+[a-zA-Z0-9]*\/*.*"#, let url = URL(string: text) else {
            return false
        }
        
        return DispatchQueue.main.sync {
            UIApplication.shared.canOpenURL(url)
        }
    }
    
}
