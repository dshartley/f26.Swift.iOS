//
//  GallerySlideshowItemView.swift
//  f26
//
//  Created by David on 05/09/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import f26Core

/// A view class for a GallerySlideshowItemView
public class GallerySlideshowItemView: UIView {

	// MARK: - Private Stored Properties
	
	fileprivate var widthConstraint:					NSLayoutConstraint?
	fileprivate var isConnectedYN: 						Bool = false
	
	
	// MARK: - Public Stored Properties
	
	public var delegate:								ProtocolGallerySlideshowItemViewDelegate?
	public var deck:									GallerySlideshowDeck?
	public var leadingConstraint:						NSLayoutConstraint?
	public fileprivate(set) var dataItem:				ArtworkWrapper? = nil
	public var slideshowIndex:							Int = 0
	
	@IBOutlet var contentView:							UIView!
	@IBOutlet weak var itemImageView:					UIImageView!
	@IBOutlet weak var imageLoadingActivityIndicator:	UIActivityIndicatorView!
	@IBOutlet weak var watermarkContainerView: 			UIView!
	@IBOutlet weak var watermarkView: 					UIView!
	
	
	// MARK: - Initializers
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setup()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.setup()
	}
	
	
	// MARK: - Public Methods
	
	public func clear() {
	
		self.dataItem				= nil
		
		self.itemImageView.image	= nil
		self.doAfterImageSet(imageIsNilYN: true)
	}
	
	public func setup() {
		
		self.setupContentView()
		self.setupActivityIndicator()
		self.setupWatermarkContainerView()
	}
	
	public func set(dataItem: ArtworkWrapper) {
		
		// Get isConnectedYN to determine whether to display watermark or activity indicator
		self.isConnectedYN = self.delegate!.checkIsConnected()
		
		// item
		self.dataItem = dataItem
		
		// itemImageView
		if let largeImageData = dataItem.largeImageData {
			
			self.set(largeImage: UIImage(data: largeImageData)!)
			
		} else {
			
			self.set(largeImage: nil)
			
		}
		
	}
	
	public func set(largeImage: UIImage?) {
		
		DispatchQueue.main.async {
				
			self.doAfterImageSet(imageIsNilYN: (largeImage == nil))
			
			self.itemImageView.image = largeImage
			
		}
	}
	
	public func set(leadingConstant: CGFloat) {
		
		self.leadingConstraint?.constant = leadingConstant
	}
	
	public func set(widthConstraint: NSLayoutConstraint) {
		
		self.widthConstraint = widthConstraint
	}

	public func getWidthConstraint() -> NSLayoutConstraint {
		
		return self.widthConstraint!
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setupContentView() {
		
		// Load xib
		Bundle.main.loadNibNamed("GallerySlideshowItemView", owner: self, options: nil)

		addSubview(contentView)
		
		self.layoutIfNeeded()
		
		// Position the contentView to fill the view
		contentView.frame				= self.bounds
		contentView.autoresizingMask	= [.flexibleHeight, .flexibleWidth]
		
	}

	fileprivate func setupActivityIndicator() {
		
		self.imageLoadingActivityIndicator.activityIndicatorViewStyle = .whiteLarge
		self.imageLoadingActivityIndicator.startAnimating()
	}
	
	fileprivate func doAfterImageSet(imageIsNilYN: Bool) {
		
		if (imageIsNilYN) {
			
			if (self.isConnectedYN) {
				
				self.imageLoadingActivityIndicator.startAnimating()
				self.hideWatermarkContainerView()
				
			} else {
				
				self.imageLoadingActivityIndicator.stopAnimating()
				self.presentWatermarkContainerView()
				
			}
			
		} else {
			
			self.imageLoadingActivityIndicator.stopAnimating()
			self.hideWatermarkContainerView()
			
		}
	}
	
	fileprivate func setupWatermarkContainerView() {
		
		self.watermarkView.layer.cornerRadius 	= 10.0;
		self.watermarkView.layer.borderWidth 	= 10.0;
		self.watermarkView.layer.borderColor 	= UIColor.white.cgColor
		self.watermarkContainerView.isHidden 	= true
		
	}
	
	fileprivate func presentWatermarkContainerView() {
		
		self.watermarkContainerView.isHidden = false
	}
	
	fileprivate func hideWatermarkContainerView() {
		
		self.watermarkContainerView.isHidden = true
	}
	
}
