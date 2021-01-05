//
//  ProtocolArtworkCommentsDisplayViewControllerDelegate.swift
//  f26
//
//  Created by David on 27/10/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// Defines a delegate for a ArtworkCommentsDisplayViewControllerDelegate class
public protocol ProtocolArtworkCommentsDisplayViewControllerDelegate {
	
	// MARK: - Methods
	
	func artworkCommentsDisplayViewController(didDismiss sender: ArtworkCommentsDisplayViewController)
	
	func artworkCommentsDisplayViewController(didPostComment sender: ArtworkCommentsDisplayViewController)
	
}
