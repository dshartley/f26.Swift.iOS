//
//  ProtocolGalleryControlManagerBaseDelegate.swift
//  f26Controller
//
//  Created by David on 07/04/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

/// Defines a delegate for a GalleryControlManagerBase class
public protocol ProtocolGalleryControlManagerBaseDelegate: class {
	
	// MARK: - Methods
	
	func galleryControlManagerBase(signInFailed sender: GalleryControlManagerBase)
	
}
