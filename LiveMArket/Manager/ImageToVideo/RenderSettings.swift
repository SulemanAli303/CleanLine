//
//  RenderSettings.swift
//  Image To Video
//
//  Created by TuyenLX on 05/10/2021.
//

import AVFoundation
import UIKit
import Photos

public struct RenderSettings1 {
    public var size : CGSize = .zero
    public var fps: Int32 = 6   // frames per second
    public var avCodecKey: AVVideoCodecType = AVVideoCodecType.h264
    public var videoFilename: String = "render"
    public var videoFilenameExt: String = "mp4"
    public var saveToLibrary: Bool = true
    public var imageloop: Int = 1

    public var outputURL: URL {
        let fileManager = FileManager.default
        if let tmpDirURL = try? fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) {
            return tmpDirURL.appendingPathComponent(videoFilename).appendingPathExtension(videoFilenameExt)
        }
        fatalError("URLForDirectory() failed")
    }
    
    public init(size: CGSize = .zero, fps: Int32 = 6, avCodecKey: AVVideoCodecType = .h264, videoFilename: String = "render", videoFilenameExt: String = "mp4", saveToLibrary: Bool = true, imageloop: Int = 1) {
        self.size = size
        self.fps = fps
        self.avCodecKey = avCodecKey
        self.videoFilename = videoFilename
        self.videoFilenameExt = videoFilenameExt
        self.saveToLibrary = saveToLibrary
        self.imageloop = imageloop
    }
}
