//
//  TableViewCell.swift
//  theCrag
//
//  Created by Adam Debono on 30/03/2016.
//  Copyright © 2016 Adam Debono. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

private struct _Section : AnimatableSectionModelType {
	typealias Item = _Cell
	typealias Identity = String
	
	var identity: Identity
	var items: [Item]
	
	init(original: _Section, items: [Item]) {
		self = original
		self.items = items
	}
	init(identity: Identity, items: [Item]) {
		self.identity = identity
		self.items = items
	}
}
private struct _Cell : IdentifiableType, Equatable {
	typealias Identity = String
	
	var identity: Identity
	
	init(identity: Identity) {
		self.identity = identity
	}
}
private func == (lhs: _Cell, rhs: _Cell) -> Bool {
	return lhs.identity == rhs.identity
}


public class ModeledDataSource: NSObject, UITableViewDelegate {
	
	public var sectionModels = [TableViewSectionModel]()
	let disposeBag = DisposeBag()
	private var sectionDisposables = [String:(Disposable, Disposable)]()
	
	
	private var reloadWatcher = PublishSubject<[_Section]>()
	private func onReload() {
		let element = self.sectionModels.map { (section) in
			return _Section(identity: section.identity, items: section.cells.map { (cell) in
				return _Cell(identity: cell.identity)
				})
		}
		self.reloadWatcher.onNext(element)
	}
	
	private var sectionReloadWatcher = PublishSubject<AnyObject?>()
	private func onSectionReload() {
		self.sectionReloadWatcher.onNext(nil)
	}
	
	private var heightReloadWatcher = PublishSubject<AnyObject?>()
	private func onHeightReload() {
		self.heightReloadWatcher.onNext(nil)
	}
	
	
	private func sectionAtIndex(section: Int) -> TableViewSectionModel {
		return self.sectionModels[section]
	}
	private func cellModelAtIndexPath(indexPath: NSIndexPath) -> TableViewCellModel {
		return self.sectionAtIndex(indexPath.section).cells[indexPath.row]
	}
	
	public func bindToTableView(tableView: UITableView) {
		tableView.dataSource = nil
		tableView.delegate = nil
		
		tableView.rowHeight = UITableViewAutomaticDimension
		
		let dataSource = RxTableViewSectionedAnimatedDataSource<_Section>()
		dataSource.configureCell = { (dataSource, tableView, indexPath, item) -> UITableViewCell in
			return self.cellModelAtIndexPath(indexPath).configureCell(tableView: tableView, indexPath: indexPath)
		}
		
		tableView.rx_itemSelected
			.subscribeNext { (indexPath) in
				self.cellModelAtIndexPath(indexPath).selectionAction?()
			}.addDisposableTo(self.disposeBag)
		
		self.reloadWatcher.asObserver()
			.bindTo(tableView.rx_itemsAnimatedWithDataSource(dataSource))
			.addDisposableTo(self.disposeBag)
		
		self.sectionReloadWatcher.asObserver()
			.subscribeNext { _ in
				tableView.reloadData()
			}.addDisposableTo(self.disposeBag)
		
		self.heightReloadWatcher.asObserver()
			.subscribeNext { _ in
				tableView.beginUpdates()
				tableView.endUpdates()
			}.addDisposableTo(self.disposeBag)
		
		tableView.rx_setDelegate(self)
	}
	
	// MARK: - Reloading
	
	public func reloadData() {
		self.onReload()
	}
	
	public func reloadSectionViews() {
		self.onSectionReload()
	}
	
	public func recalculateHeights() {
		self.onHeightReload()
	}
	
	// MARK: - Table View
	
	public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return self.cellModelAtIndexPath(indexPath).estimatedHeight
	}
	
	public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	public func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
		return self.sectionAtIndex(section).headerView?.estimatedHeight ?? UITableViewAutomaticDimension
	}
	
	public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return self.sectionAtIndex(section).headerView?.configureView(tableView: tableView, section: section)
	}
	
	public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	public func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
		return self.sectionAtIndex(section).footerView?.estimatedHeight ?? UITableViewAutomaticDimension
	}

	public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return self.sectionAtIndex(section).footerView?.configureView(tableView: tableView, section: section)
	}
}
