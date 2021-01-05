//
//  AwardWrapper.swift
//  f26Core
//
//  Created by David on 08/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// A wrapper for a Award model item
public class AwardWrapper {
	
	// MARK: - Public Stored Properties
	
	public var id:					Int = 0
	public var category:			ArtworkCategoryTypes = .elena
	public var year:				Int = 0
	public var text:				String = ""
	public var imageFileName:		String = ""
	public var imageData:			Data? = nil
	public var competitionName:		String = ""
	public var quote:				String = ""
	public var url: 				String = ""
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
}
