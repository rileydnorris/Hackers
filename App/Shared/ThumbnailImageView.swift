//
//  ThumbnailImageView.swift
//  Hackers
//
//  Created by Weiran Zhang on 16/06/2019.
//  Copyright © 2019 Weiran Zhang. All rights reserved.
//

import UIKit
import Kingfisher

class ThumbnailImageView: UIImageView {
    func setImageWithPlaceholder(url: URL?) -> DownloadTask? {
        setPlaceholder()

        // TODO improve this URL construction
        guard let url = url,
            let thumbnailURL = URL(string: "https://thumbnail-extractor.herokuapp.com/?url=\(url.absoluteString)") else {
                return nil
        }

        let newSize = 60
        let thumbnailSize = CGFloat(newSize) * UIScreen.main.scale
        let thumbnailCGSize = CGSize(width: thumbnailSize, height: thumbnailSize)
        let imageSizeProcessor = ResizingImageProcessor(referenceSize: thumbnailCGSize,
                                                        mode: .aspectFill)
        let options: KingfisherOptionsInfo = [
            .processor(imageSizeProcessor)
        ]

        let resource = ImageResource(downloadURL: thumbnailURL)

        let task = KingfisherManager.shared.retrieveImage(with: resource, options: options) { result in
            switch result {
            case .success(let imageResult):
                DispatchQueue.main.async {
                    self.contentMode = .scaleAspectFill
                    self.image = imageResult.image
                }
            default: break
            }
        }

        return task
    }

    private func setPlaceholder() {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .large)
        let placeholderImage = UIImage(systemName: "safari", withConfiguration: symbolConfiguration)!
        DispatchQueue.main.async {
            self.contentMode = .center
            self.image = placeholderImage
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 60, height: 60)
    }
}
