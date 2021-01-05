//
//  ProtocolArtworkCollectionViewCellDelegate.swift
//  f26
//
//  Created by David on 12/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import f26Core

/// Defines a delegate for a ArtworkCollectionViewCell class
public protocol ProtocolArtworkCollectionViewCellDelegate {
	
	// MARK: - Methods
	
	func artworkCollectionViewCell(cell:ArtworkCollectionViewCell, didTapThumbnailImage image: UIImageView)
	
	func artworkCollectionViewCell(cell:ArtworkCollectionViewCell, didTapLikeButton item: ArtworkWrapper, oncomplete completionHandler:@escaping () -> Void)

	func artworkCollectionViewCell(cell:ArtworkCollectionViewCell, didTapCommentsButton item: ArtworkWrapper)
	
}
