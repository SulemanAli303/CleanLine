//
//  ImageAnimator.swift
//  Image To Video
//
//  Created by TuyenLX on 05/10/2021.
//

import Foundation
import UIKit
import Photos

public class ImageAnimator1 {
    
    // Apple suggests a timescale of 600 because it's a multiple of standard video rates 24, 25, 30, 60 fps etc.
    static let kTimescale: Int32 = 600
    
    public let settings: RenderSettings1
    public let videoWriter: VideoWriter1
    public var images: [UIImage]!
    
    var frameNum = 0
    
    public class func saveToLibrary(videoURL: URL) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
            }) { success, error in
                if !success {
                    print("Could not save video to photo library: \(String(describing: error))")
                }
            }
        }
    }
    
    public class func removeFileAtURL(fileURL: URL) {
        do {
            try FileManager.default.removeItem(atPath: fileURL.path)
        }
        catch {
                
        }
    }

    public init(renderSettings: RenderSettings1) {
        settings = renderSettings
        videoWriter = VideoWriter1(renderSettings: settings)
    }

    public func render(completion: (()->Void)?) {

        // The VideoWriter will fail if a file exists at the URL, so clear it out first.
        ImageAnimator1.removeFileAtURL(fileURL: settings.outputURL)

        videoWriter.start()
        videoWriter.render(appendPixelBuffers: appendPixelBuffers) { [weak self] in
            guard let self = self else {return}
            if self.settings.saveToLibrary {
                ImageAnimator1.saveToLibrary(videoURL: self.settings.outputURL)
            }
            completion?()
        }
    }

    // This is the callback function for VideoWriter.render()
    func appendPixelBuffers(writer: VideoWriter1) -> Bool {

        let frameDuration = CMTimeMake(value: Int64(ImageAnimator1.kTimescale / settings.fps), timescale: ImageAnimator1.kTimescale)
        var pixelBuffer: CVPixelBuffer!
        while !images.isEmpty {
            if writer.isReadyForData == false {
                // Inform writer we have more buffers to write.
                return false
            }
            let diff = frameNum % settings.imageloop
            if diff == 0 || pixelBuffer == nil {
                let image = images.first
                pixelBuffer = writer.getFrameBuffer(image: image!)
            }
            print("difff \(diff) \(frameNum)")
            
            let presentationTime = CMTimeMultiply(frameDuration, multiplier: Int32(frameNum))
            let success = writer.addBuffer(pixelBuffer: pixelBuffer, withPresentationTime: presentationTime)
            if success == false {
                print("fale to add image")
            } else {
                if diff == 0, frameNum != 0 {
                    images.removeFirst()
                }
                frameNum += 1
            }
        }
        return true
    }
}
