//
//  ProtocolDashboardMenuViewDelegate.swift
//  f26
//
//  Created by David on 29/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import f26Core

/// Defines a delegate for a DashboardMenuView class
public protocol ProtocolDashboardMenuViewDelegate {

	// MARK: - Methods
	
	func dashboardMenuView(didDismiss sender: DashboardMenuView)
	
	func dashboardMenuView(sender: DashboardMenuView, didSelectDaughter daughter: Daughters)
	
	func dashboardMenuView(sender: DashboardMenuView, didSelectYear year: Int)
}
