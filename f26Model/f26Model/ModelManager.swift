//
//  ModelManager.swift
//  f26Model
//
//  Created by David on 09/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel

/// Manages the model layer and provides access to the model administrators
public class ModelManager: ModelManagerBase {

	// MARK: - Initializers
	
	fileprivate override init() {
		super.init()
	}
	
	public override init(storageDateFormatter: DateFormatter) {
		super.init(storageDateFormatter: storageDateFormatter)
	}
	
	
	// MARK: - Public Methods
	
	// MARK: - Artwork
	
	fileprivate var _artworkModelAdministrator: ArtworkModelAdministrator?
	
	public func setupArtworkModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("artwork")) { self.modelAdministrators.removeValue(forKey: "artwork") }
		
		self._artworkModelAdministrator = ArtworkModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["artwork"] = self._artworkModelAdministrator
	}
	
	public var getArtworkModelAdministrator: ArtworkModelAdministrator? {
		get {
			return self._artworkModelAdministrator
		}
	}
	
	
	// MARK: - ArtworkComment
	
	fileprivate var _artworkCommentModelAdministrator: ArtworkCommentModelAdministrator?
	
	public func setupArtworkCommentModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("artworkComment")) { self.modelAdministrators.removeValue(forKey: "artworkComment") }
		
		self._artworkCommentModelAdministrator = ArtworkCommentModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["artworkComment"] = self._artworkCommentModelAdministrator
	}
	
	public var getArtworkCommentModelAdministrator: ArtworkCommentModelAdministrator? {
		get {
			return self._artworkCommentModelAdministrator
		}
	}
	
	
	// MARK: - Award
	
	fileprivate var _awardModelAdministrator: AwardModelAdministrator?
	
	public func setupAwardModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("award")) { self.modelAdministrators.removeValue(forKey: "award") }
		
		self._awardModelAdministrator = AwardModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["award"] = self._awardModelAdministrator
	}
	
	public var getAwardModelAdministrator: AwardModelAdministrator? {
		get {
			return self._awardModelAdministrator
		}
	}
	
	
	// MARK: - NewsSnippet
	
	fileprivate var _newsSnippetModelAdministrator: NewsSnippetModelAdministrator?
	
	public func setupNewsSnippetModelAdministrator(modelAccessStrategy: ProtocolModelAccessStrategy) {
		
		if (self.modelAdministrators.keys.contains("newsSnippet")) { self.modelAdministrators.removeValue(forKey: "newsSnippet") }
		
		self._newsSnippetModelAdministrator = NewsSnippetModelAdministrator(modelAccessStrategy: modelAccessStrategy, modelAdministratorProvider: self, storageDateFormatter: self.storageDateFormatter!)
		
		self.modelAdministrators["newsSnippet"] = self._newsSnippetModelAdministrator
	}
	
	public var getNewsSnippetModelAdministrator: NewsSnippetModelAdministrator? {
		get {
			return self._newsSnippetModelAdministrator
		}
	}
	
}
