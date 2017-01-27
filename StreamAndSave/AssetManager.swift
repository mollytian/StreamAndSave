//
//  AssetManager.swift
//  streamAndSave
//
//  Created by Molly Tian on 1/26/17.
//  Copyright © 2016 Molly Tian. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class AssetManager: NSObject, CanSaveAVAsset {
    
    //MARK: - singleton
    static let sharedInstance = AssetManager()
    
    //MARK: - Properties
    var assetCache: PWCache!
    
    //MARK: - Init
    override init() {
        super.init()
        self.assetCache = PWCache(name: "com.MollyTian.StreamAndSave.PWAssetManager")
    }
    
    //MARK: - Cache Operation
    func containsObject(forKey key: String) -> Bool {
        return assetCache.diskCache.containsObject(forKey: key)
    }
    
    func path(forKey key: String) -> String? {
        return assetCache.diskCache.path(forKey: key)
    }
    
    func cache(object: Data?, forKey key: String) {
        return self.assetCache.diskCache.setData(object, forKey: key)
    }
    
    func clearCache() {
        AssetManager.sharedInstance.assetCache.diskCache.trim(toCount: 0)
        printCacheSize()
        
    }
    
    func printCacheSize() {
        print("Cache size = \(assetCache.diskCache.totalCost())")
    }
    
    //MARK: - Delegate Method
    
    func saveAVAsset(asset: CustomAVURLAsset) {
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
        
        let filename = "temp.mp4"
        let documentsDirectory = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last!
        let outputURL = documentsDirectory.appendingPathComponent(filename)
        
        checkAndRemoveFile(atPath: outputURL.absoluteString)
       
        exporter?.outputURL = outputURL
        exporter?.outputFileType = AVFileTypeMPEG4
        
        exporter?.exportAsynchronously(completionHandler: {
            if let data = FileManager.default.contents(atPath: (exporter?.outputURL?.path)! ) {
                self.cache(object: data, forKey: asset.originalURLString!)
                AssetManager.sharedInstance.printCacheSize()
                self.checkAndRemoveFile(atPath: outputURL.absoluteString)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FinishedCachingVideo"), object: nil)
            }
        })
    }
    
    func checkAndRemoveFile(atPath path: String) {
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch let error{
                print(error)
            }
        }
    }
    
    
}

protocol CanSaveAVAsset{
    func saveAVAsset(asset: CustomAVURLAsset)
}
