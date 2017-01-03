//
//  LivePhotoCollectionViewController.swift
//  LivePreview
//
//  Created by David Rothschild on 1/1/17.
//  Copyright © 2017 Dave Rothschild. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class LivePhotoCollectionViewController: UIViewController {

    var photoView:PHLivePhotoView!
    var livePhotoAsset:PHAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoView = PHLivePhotoView(frame: self.view.bounds)
        photoView.contentMode = .scaleAspectFill
        self.view.addSubview(photoView)
        
        
        if self.traitCollection.forceTouchCapability == .unavailable {
            let playBarButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(LivePhotoCollectionViewController.playAnimation))
            self.navigationItem.rightBarButtonItem = playBarButton
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    func playAnimation() {
        photoView.startPlayback(with: .full)
    }
    
    func configureView() {
        if let photoAsset = livePhotoAsset {
            PHImageManager.default().requestLivePhoto(for: photoAsset, targetSize: photoView.frame.size, contentMode: .aspectFill, options: nil, resultHandler: { (photo:PHLivePhoto?, info:[AnyHashable : Any]?) in
                
                if let livePhoto = photo {
                    self.photoView.livePhoto = livePhoto
                    self.photoView.startPlayback(with: .hint)
                    
                    let geoCoder = CLGeocoder()
                    geoCoder.reverseGeocodeLocation(photoAsset.location!, completionHandler: { (placemark:[CLPlacemark]?, error:Error?) in
                        if error == nil {
                            self.navigationItem.title = placemark?.first?.locality
                        }
                    })
                }
            })
        }
    }

}
