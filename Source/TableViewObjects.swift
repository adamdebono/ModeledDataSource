//
//  TableViewObjects.swift
//  ModeledDataSource
//
//  Created by Adam Debono on 17/04/2016.
//  Copyright © 2016 Adam Debono. All rights reserved.
//

import UIKit

public class TitleHeaderFooterViewModel: TableViewHeaderFooterViewModel {
	private enum Type: String {
		case Header = "header"
		case Footer = "footer"
		case Custom = "custom"
	}
	
	private static let reuseIdentifier = "title"
	
	private var type: Type
	
	public var title: String
	public var font: UIFont
	public var textAlignment: NSTextAlignment
	
	private let padding: UIEdgeInsets
	
	public init(title: String, font: UIFont, textAlignment: NSTextAlignment, padding: UIEdgeInsets) {
		self.title = title
		self.font = font
		self.textAlignment = textAlignment
		self.padding = padding
		self.type = .Custom
		
		super.init()
		
		self.estimatedHeight = 22
	}
	
	public init(headerViewForTitle title: String) {
		self.title = title
		self.type = .Header
		
		self.font = UIFont()
		self.textAlignment = .Left
		self.padding = UIEdgeInsets()
		
		super.init()
		
		self.estimatedHeight = 22
	}
	
	public init(footerViewForTitle title: String) {
		self.title = title
		self.type = .Footer
		
		self.font = UIFont()
		self.textAlignment = .Left
		self.padding = UIEdgeInsets()
		
		super.init()
		
		self.estimatedHeight = 22
	}
	
	public override func createView(tableView tableView: UITableView, section: Int) -> UITableViewHeaderFooterView {
		let reuseIdentifier = TitleHeaderFooterViewModel.reuseIdentifier.stringByAppendingString(self.type.rawValue)
		if let view = tableView.dequeueReusableHeaderFooterViewWithIdentifier(reuseIdentifier) {
			return view
		}
		
		switch self.type {
		case .Header:
			var padding: UIEdgeInsets
			var font: UIFont
			switch tableView.style {
				case .Grouped:
					padding = UIEdgeInsets(top: 15, left: 15, bottom: 5, right: 15)
					font = UIFont.systemFontOfSize(13)
				case .Plain:
					padding = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
					font = UIFont.systemFontOfSize(17)
			}
			
			let view = TitleHeaderFooterView(reuseIdentifier: reuseIdentifier, labelPadding: padding)
			view.label.font = font
			view.label.textAlignment = .Left
			return view
		case .Footer:
			var font: UIFont
			switch tableView.style {
			case .Grouped:
				font = UIFont.systemFontOfSize(13)
			case .Plain:
				font = UIFont.systemFontOfSize(17)
			}
			
			let view = TitleHeaderFooterView(reuseIdentifier: reuseIdentifier, labelPadding: UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15))
			view.label.font = font
			view.label.textAlignment = .Left
			return view
		case .Custom:
			return tableView.dequeueReusableHeaderFooterViewWithIdentifier(TitleHeaderFooterViewModel.reuseIdentifier) ?? TitleHeaderFooterView(reuseIdentifier: TitleHeaderFooterViewModel.reuseIdentifier, labelPadding: self.padding)
		}
	}
	
	public override func configureView(tableView tableView: UITableView, section: Int) -> UITableViewHeaderFooterView {
		guard let view = super.configureView(tableView: tableView, section: section) as? TitleHeaderFooterView else {
			fatalError("Created view should be a TitleHeaderFooterView")
		}
		
		if self.type == .Header && tableView.style == .Grouped {
			view.label.text = self.title.uppercaseString
		} else {
			view.label.text = self.title
		}
		
		if self.type == .Custom {
			view.label.font = self.font
			view.label.textAlignment = self.textAlignment
		}
		
		return view
	}
}

class TitleHeaderFooterView: UITableViewHeaderFooterView {
	var label = UILabel()
	var labelPadding: UIEdgeInsets
	
	init(reuseIdentifier: String?, labelPadding: UIEdgeInsets) {
		self.labelPadding = labelPadding
		
		super.init(reuseIdentifier: reuseIdentifier)
		
		self.label.textColor = UIColor.darkGrayColor()
		self.label.numberOfLines = 0
		
		self.label.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.addSubview(self.label)
		self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(leftpadding)-[label]-(rightpadding)-|", options: NSLayoutFormatOptions(), metrics: ["leftpadding": labelPadding.left, "rightpadding": labelPadding.right], views: ["label": self.label]))
		self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(toppadding)-[label]-(bottompadding)-|", options: NSLayoutFormatOptions(), metrics: ["toppadding": labelPadding.top,"bottompadding": labelPadding.bottom], views: ["label": self.label]))
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}