//
//  TableViewModels.swift
//  theCrag
//
//  Created by Adam Debono on 4/04/2016.
//  Copyright © 2016 Adam Debono. All rights reserved.
//

import UIKit
import RxSwift

public class TableViewSectionModel: Equatable {
	internal var rx_events = PublishSubject<String>()
	private var disposeBag = DisposeBag()
	
	public let identity: String
	public var cells: [TableViewCellModel]
	
	public var headerText: String? {
		didSet {
			self.rx_events.onNext("headerText")
		}
	}
	public var headerView: TableViewHeaderFooterViewModel? {
		didSet {
			self.rx_events.onNext("headerView")
		}
	}
	public var footerText: String? {
		didSet {
			self.rx_events.onNext("footerText")
		}
	}
	public var footerView: TableViewHeaderFooterViewModel? {
		didSet {
			self.rx_events.onNext("footerView")
		}
	}
	
	public init(identity: String, cells: [TableViewCellModel] = [], headerText: String? = nil, footerText: String? = nil, headerView: TableViewHeaderFooterViewModel? = nil, footerView: TableViewHeaderFooterViewModel? = nil) {
		if identity.isEmpty {
			fatalError("Must provide a unique identity for the section")
		}
		self.identity = identity
		self.cells = cells
		self.headerText = headerText
		self.footerText = footerText
		self.headerView = headerView
		self.footerView = footerView
	}
}

public func == (lhs: TableViewSectionModel, rhs: TableViewSectionModel) -> Bool {
	return lhs.identity == rhs.identity
}

public class TableViewHeaderFooterViewModel {
	public var estimatedHeight: CGFloat = 44
	
	public init() {}
	
	public func createView(tableView tableView: UITableView, section: Int) -> UITableViewHeaderFooterView {
		fatalError("Must be overridden in a subclass")
	}
	
	public func configureView(tableView tableView: UITableView, section: Int) -> UITableViewHeaderFooterView {
		let view = self.createView(tableView: tableView, section: section)
		return view
	}
}

public class TableViewCellModel: Equatable {
	public let identity: String
	
	public var estimatedHeight: CGFloat = 44
	public var selectionAction: (() -> ())?
	public var accessoryType: UITableViewCellAccessoryType = .None
	
	public init(identity: String, selectionAction: (() -> ())? = nil) {
		self.identity = identity
		self.selectionAction = selectionAction
		
		if let _ = self.selectionAction {
			self.accessoryType = .DisclosureIndicator
		}
	}
	
	public func createCell(tableView tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
		fatalError("Must be overridden in a subclass")
	}
	
	public func configureCell(tableView tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
		let cell = self.createCell(tableView: tableView, indexPath: indexPath)
		
		if let _ = self.selectionAction {
			cell.selectionStyle = .Default
		} else {
			cell.selectionStyle = .None
		}
		
		cell.accessoryType = self.accessoryType
		
		return cell
	}
}

public func == (lhs: TableViewCellModel, rhs: TableViewCellModel) -> Bool {
	return lhs.identity == rhs.identity
}
