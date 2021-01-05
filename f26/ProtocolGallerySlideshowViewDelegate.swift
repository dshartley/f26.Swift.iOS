//
//  ProtocolGallerySlideshowViewDelegate.swift
//  f26
//
//  Created by David on 05/09/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFView
import f26Core

/// Defines a delegate for a GallerySlideshowView class
public protocol ProtocolGallerySlideshowViewDelegate {

	// MARK: - Methods
	
	func gallerySlideshowView(dataItems sender: GallerySlideshowView) -> [ArtworkWrapper]
	
	func gallerySlideshowView(sender: GallerySlideshowView, itemChanged item: ArtworkWrapper)
	
	func gallerySlideshowView(sender: GallerySlideshowView, itemTapped item: ArtworkWrapper)
	
	func gallerySlideshowView(sender: GallerySlideshowView, largeImageDataForItem item: ArtworkWrapper, oncomplete completionHandler:@escaping (Data?, Error?) -> Void)
	
	func gallerySlideshowView(preloadPrevious sender: GallerySlideshowView)
	
	func gallerySlideshowView(preloadNext sender: GallerySlideshowView)
	
	func gallerySlideshowView(for gesture:UIPanGestureRecognizer, panningStartedWith attributes: PanGestureAttributes)
	
	func gallerySlideshowView(for gesture:UIPanGestureRecognizer, panningContinuedWith attributes: PanGestureAttributes)
	
	func gallerySlideshowView(for gesture:UIPanGestureRecognizer, panningStoppedAfterThresholdWith attributes: PanGestureAttributes)
	
	func gallerySlideshowView(for gesture:UIPanGestureRecognizer, panningStoppedBeforeThresholdWith attributes: PanGestureAttributes)
	
	func gallerySlideshowView(for gesture:UIPanGestureRecognizer, panningStoppedWith attributes: PanGestureAttributes)
	
	func checkIsConnected() -> Bool
	
}
