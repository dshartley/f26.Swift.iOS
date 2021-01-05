//
//  ArtworkCollectionViewCell.swift
//  f26
//
//  Created by David on 12/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFView
import f26Core

/// A class for an ArtworkCollectionViewCell
public class ArtworkCollectionViewCell: UICollectionViewCell {
	
	// MARK: - Public Stored Properties
	
	public var delegate:												ProtocolArtworkCollectionViewCellDelegate?
	public fileprivate(set) var item:									ArtworkWrapper? = nil

	@IBOutlet weak var thumbnailImageView:								UIImageView!
	@IBOutlet weak var thumbnailImageViewHeightConstraint:				NSLayoutConstraint!
	@IBOutlet weak var nameLabel:										UILabel!
	@IBOutlet weak var numberofLikesLabel: 								UILabel!
	@IBOutlet weak var watermarkContainerView: 							UIView!
	@IBOutlet weak var watermarkView: 									UIView!
	@IBOutlet weak var itemDetailView: 									UIView!
	@IBOutlet weak var itemDetailViewHeightConstraint: 					NSLayoutConstraint!
	@IBOutlet weak var itemLatestArtworkCommentView: 					UIView!
	@IBOutlet weak var itemLatestArtworkCommentViewHeightConstraint: 	NSLayoutConstraint!
	@IBOutlet weak var latestArtworkCommentTextLabel: 					UILabel!
	@IBOutlet weak var latestArtworkCommentPostedByNameLabel: 			UILabel!
	@IBOutlet weak var latestArtworkCommentDatePostedLabel: 			UILabel!
	@IBOutlet weak var seeAllArtworkCommentsButton: 					UIButton!
	
	
	// MARK: - Private Stored Properties
	
	fileprivate let recognizer											= UITapGestureRecognizer()

	
	// MARK: - Public Methods
	
	public func set(item: ArtworkWrapper) {
		
		self.thumbnailImageView.image = nil
		
		self.item = item
		
		self.displayItem()
		
		self.setHeights()
		
		self.layoutIfNeeded()
		self.setupShadow()
	}
	
	public func set(thumbnailImage: UIImage?) {
		
		if (thumbnailImage != nil) {
			
			self.hideWatermarkContainerView()
			
		} else {
			
			self.presentWatermarkContainerView()
			
		}
		
		self.thumbnailImageView.image = thumbnailImage

	}

	
	// MARK: - Override Methods
	
	public override func awakeFromNib() {
		
		self.setup()
	}
	
	public override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
		super.apply(layoutAttributes)
		
		self.contentView.frame = self.bounds
		
		self.layoutIfNeeded()
		
		self.setupShadow()
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setup() {
		
		self.setupContentView()
		self.setupItemDetailView()
		self.setupThumbnailImageView()
		self.setupWatermarkContainerView()
	}
	
	fileprivate func setupContentView() {
		
	}
	
	fileprivate func setupThumbnailImageView() {
		
		self.thumbnailImageView.clipsToBounds				= true
		self.thumbnailImageView.isUserInteractionEnabled	= true
		
		self.recognizer.addTarget(self, action: #selector(ArtworkCollectionViewCell.thumbnailImageTapped))
		self.thumbnailImageView.addGestureRecognizer(recognizer)
	}
	
	fileprivate func setupItemDetailView() {

		self.itemDetailView.layer.cornerRadius = 4.0;
		self.itemDetailView.layer.borderWidth = 1.0;
		self.itemDetailView.layer.borderColor = UIColor.clear.cgColor
		self.itemDetailView.layer.masksToBounds = true;
	}
	
	fileprivate func setupShadow() {
		
		self.layer.shadowColor 		= UIColor.darkGray.cgColor
		self.layer.shadowOffset 	= CGSize(width: 0, height: 2.0)
		self.layer.shadowRadius 	= 4.0;
		self.layer.shadowOpacity 	= 0.5;
		self.layer.masksToBounds 	= false;
		self.layer.shadowPath 		= UIBezierPath(roundedRect:self.itemDetailView.bounds, cornerRadius:self.itemDetailView.layer.cornerRadius).cgPath;

	}
	
	fileprivate func setupThumbnailImageViewHeightConstraint() {
		
		guard (self.item != nil) else { return }
		
		self.thumbnailImageViewHeightConstraint.constant = self.item!.thumbnailImageDisplayHeight
	}

	fileprivate func setupWatermarkContainerView() {
		
		self.watermarkView.layer.cornerRadius 	= 10.0;
		self.watermarkView.layer.borderWidth 	= 10.0;
		self.watermarkView.layer.borderColor 	= UIColor.white.cgColor
	
	}
	
	fileprivate func presentWatermarkContainerView() {
		
		self.watermarkContainerView.isHidden = false
	}
	
	fileprivate func hideWatermarkContainerView() {
		
		self.watermarkContainerView.isHidden = true
	}

	fileprivate func setHeights() {
		
		// itemDetailViewHeightConstraint
		self.itemDetailViewHeightConstraint.constant = self.item!.itemDetailViewHeight
		
		if (self.item!.latestArtworkCommentText.count > 0) {
			
			// itemLatestArtworkCommentViewHeightConstraint
			self.itemLatestArtworkCommentViewHeightConstraint.constant = self.item!.itemLatestArtworkCommentViewHeight
		}
	}
	
	fileprivate func displayItem() {
		
		guard (self.item != nil) else { return }
		
		self.displayName()
		self.displayThumbnailImage()
		self.displayNumberofLikes()
		self.displayLatestArtworkComment()

	}
	
	fileprivate func displayName() {
		
		// nameLabel
		self.nameLabel.text		= self.item!.name
		
	}
	
	fileprivate func displayThumbnailImage() {
		
		// thumbnailImageViewHeightConstraint
		self.setupThumbnailImageViewHeightConstraint()
		
		// thumbnailImageView
		if let thumbnailImageData = self.item!.thumbnailImageData {
			
			self.set(thumbnailImage: UIImage(data: thumbnailImageData)!)
			
		} else {
			
			self.set(thumbnailImage: nil)
		}
	}
	
	fileprivate func displayNumberofLikes() {
	
		var localizedStringKey = "Like0"
		
		if (self.item!.numberofLikes == 1) {
			localizedStringKey = "Like1"
		} else if (self.item!.numberofLikes > 1) {
			localizedStringKey = "LikeN"
		}
		
		// Get numberofLikesText from localized string
		let numberofLikesTextLocalized 	= NSLocalizedString(localizedStringKey, comment: "")
		let numberofLikesText			= String(format: numberofLikesTextLocalized, String(self.item!.numberofLikes))
		
		// numberofLikesLabel
		self.numberofLikesLabel.text 	= numberofLikesText
	}
	
	fileprivate func displayLatestArtworkComment() {
		
		// Check latestArtworkCommentText
		if (self.item!.latestArtworkCommentText.count > 0) {
			
			// itemLatestArtworkCommentView
			self.itemLatestArtworkCommentView.isHidden = false
			
			self.latestArtworkCommentTextLabel.text 			= "\"" + self.item!.latestArtworkCommentText + "\""
			self.latestArtworkCommentPostedByNameLabel.text 	= self.item!.latestArtworkCommentPostedByName
			
			// Get latestArtworkCommentDatePostedString from dateFormatter
			let dateFormatter									= DateFormatter()
			dateFormatter.dateFormat							= "MMM d, yyyy"
			dateFormatter.timeZone 								= TimeZone(secondsFromGMT: 0)
			
			let latestArtworkCommentDatePostedString 			= dateFormatter.string(from: self.item!.latestArtworkCommentDatePosted)
			
			// latestArtworkCommentDatePostedLabel
			self.latestArtworkCommentDatePostedLabel.text 		= ", " + latestArtworkCommentDatePostedString
			
			// Get seeAllArtworkCommentsText from localized string
			let seeAllArtworkCommentsTextLocalized 				= NSLocalizedString("SeeAllArtworkComments", comment: "")
			
			let numberofArtworkCommentsString					= String(self.item!.numberofArtworkComments)
			let seeAllArtworkCommentsText						= String(format: seeAllArtworkCommentsTextLocalized, numberofArtworkCommentsString)
			
			// seeAllArtworkCommentsButton
			self.seeAllArtworkCommentsButton.setTitle(seeAllArtworkCommentsText, for: .normal)
			
		} else {
			
			// itemLatestArtworkCommentView
			self.itemLatestArtworkCommentView.isHidden = true
		}
		
	}
	
	
	// MARK: - thumbnailImage Methods
	
	@objc fileprivate func thumbnailImageTapped() {
		
		// Notify the delegate
		self.delegate!.artworkCollectionViewCell(cell: self, didTapThumbnailImage: self.thumbnailImageView)
	}
	
	
	// MARK: - likeButton Methods
	
	@IBAction func likeButtonTapped(_ sender: Any) {
		
		// Create completion handler
		let didTapThumbnailImageCompletionHandler: (() -> Void) =
		{
			() -> Void in
			
			self.displayNumberofLikes()
		}
		
		// Notify the delegate
		self.delegate!.artworkCollectionViewCell(cell: self, didTapLikeButton: self.item!, oncomplete: didTapThumbnailImageCompletionHandler)
	}
	
	
	// MARK: - artworkCommentsButton Methods
	
	@IBAction func artworkCommentsButtonTapped(_ sender: Any) {
		
		// Notify the delegate
		self.delegate!.artworkCollectionViewCell(cell: self, didTapCommentsButton: self.item!)
	}
	
	
	// MARK: - seeAllArtworkCommentsButton Methods
	
	@IBAction func seeAllArtworkCommentsButtonTapped(_ sender: Any) {
		
		// Notify the delegate
		self.delegate!.artworkCollectionViewCell(cell: self, didTapCommentsButton: self.item!)
	}
	
}
