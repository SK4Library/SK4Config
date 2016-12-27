//
//  SK4ConfigTableSection.swift
//  SK4Config
//
//  Created by See.Ku on 2016/12/24.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Library

/// ユーザー設定をUITableViewで表示するためのセクションクラス
open class SK4ConfigTableSection: SK4TableViewSection {

	/// 対応する設定用セクション
	public weak var configSection: SK4ConfigSection!

	/// 初期化
	public init(configSection: SK4ConfigSection) {
		super.init()

		self.configSection = configSection
		configSection.tableSection = self

		self.header = configSection.header
		self.footer = configSection.footer
	}

	/// 行の数＝設定の数
	override open func numberOfRows() -> Int {
		return configSection.configArray.count
	}

	/// 対応する設定からCellを取得
	override open func cellForRow(at indexPath: IndexPath) -> UITableViewCell {
		let config = configSection.configArray[indexPath.row]
		let cell = config.cell.availableCell(for: tableView)
		config.cell.configTable = tableAdmin as? SK4ConfigTableAdmin
		config.cell.setupCell(cell)
		return cell
	}

	/// Cellが選択された
	override open func didSelectRow(at indexPath: IndexPath) {
		let config = configSection.configArray[indexPath.row]
		if let cell = tableView.cellForRow(at: indexPath) {
			config.cell.onSelectCell(cell)
		}

		if config.cell.readOnly == false {
			if let vc = config.cell.nextViewController() {
				parent.navigationController?.pushViewController(vc, animated: true)
			}
		}

		tableView.deselectRow(at: indexPath, animated: true)
	}

	/// Cellが表示される
	override open func willDisplayCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
		let config = configSection.configArray[indexPath.row]
		config.cell.willDisplayCell(cell)
	}

}

// eof
