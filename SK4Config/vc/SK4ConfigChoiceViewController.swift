//
//  SK4ConfigChoiceViewController.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Library

// /////////////////////////////////////////////////////////////
// MARK: - SK4ConfigChoiceViewController

/// 複数の選択肢から1つを選ぶViewController
public class SK4ConfigChoiceViewController: SK4TableViewController {

	public var configValue: SK4ConfigValue!

	var tableAdmin: SK4ConfigChoiceViewControllerAdmin!

	override public func viewDidLoad() {
		super.viewDidLoad()

		let tv = makeTableView(style: .plain)
		tv.clearSeparator()
		SK4AutoLayout.overlay(target: tv, parent: self)

		tableAdmin = SK4ConfigChoiceViewControllerAdmin(tableView: tv, parent: self)
		setup(tableModel: tableAdmin)
	}

	override public func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		assert(configValue is SK4ConfigIndex, "Wrong config type.")

		let cv = configValue as! SK4ConfigIndex
		tableAdmin.setup(configIndex: cv)
		tableView.reloadData()

		if cv.value >= 0 {
			let index = IndexPath(row: cv.value, section: 0)
			tableView.scrollToRowAsync(at: index)
		}

		navigationItem.title = configValue.title
	}
}


// /////////////////////////////////////////////////////////////
// MARK: - SK4ConfigChoiceViewControllerAdmin

/// SK4ConfigChoiceViewController専用の管理クラス
class SK4ConfigChoiceViewControllerAdmin: SK4TableViewModel {

	var configIndex: SK4ConfigIndex!
	var cellStyle = UITableViewCellStyle.default

	func setup(configIndex: SK4ConfigIndex) {
		self.configIndex = configIndex

		cellStyle = .default

		//　SK4ConfigCellChoiceの場合、詳細があるかないかでスタイルを変更
		if let cc = configIndex.cell as? SK4ConfigCellChoice {
			if cc.cellStyle == .default && configIndex.detailArray != nil {
				cellStyle = .subtitle
			} else {
				cellStyle = cc.cellStyle
			}
		}

		// SK4ConfigCellColorIndexはスタイル固定
		if configIndex.cell is SK4ConfigCellColorIndex {
			cellStyle = .subtitle
		}

		cellId = "Cell\(cellStyle.rawValue)"
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for override

	override func numberOfRows(inSection section: Int) -> Int {
		return configIndex.textArray.count
	}

	override func cellForRow(at indexPath: IndexPath) -> UITableViewCell {
		let cell = dequeueOrMakeCell(style: cellStyle)

		if configIndex.cell is SK4ConfigCellColorIndex {
			cell.textLabel?.text = "　　　　　　　　　　　　"
		} else {
			cell.textLabel?.text = configIndex.textArray[indexPath.row]
		}

		if let details = configIndex.detailArray {
			cell.detailTextLabel?.text = details.safe(indexPath.row)
		} else {
			cell.detailTextLabel?.text = nil
		}

		if configIndex.value == indexPath.row {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}

		return cell
	}

	override func didSelectRow(at indexPath: IndexPath) {
		if configIndex.selectText != nil {
			let index = IndexPath(row: configIndex.value, section: 0)
			if let old = tableView.cellForRow(at: index) {
				old.accessoryType = .none
			}
		}

		if let now = tableView.cellForRow(at: indexPath) {
			now.accessoryType = .checkmark
		}

		tableView.deselectRow(at: indexPath, animated: true)
		configIndex.value = indexPath.row

		_ = parent.navigationController?.popViewController(animated: true)
	}

	override func willDisplayCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
		if configIndex.cell is SK4ConfigCellColorIndex {
			let str = configIndex.textArray[indexPath.row]
			cell.textLabel?.backgroundColor = UIColor.fromString(str)
		}
	}

}

// eof
