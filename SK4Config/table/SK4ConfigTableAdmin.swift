//
//  SK4ConfigTableAdmin.swift
//  SK4Config
//
//  Created by See.Ku on 2016/12/24.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Library

/// ユーザー設定でをUITableViewで表示するための管理クラス
open class SK4ConfigTableAdmin: SK4TableViewAdmin, SK4KeyboardObserver {

	/// ViewControllerのキャッシュ
	lazy var dateViewController: SK4ConfigDateViewController = SK4ConfigDateViewController()
	lazy var choiceViewController: SK4ConfigChoiceViewController = SK4ConfigChoiceViewController()
	lazy var colorViewController: SK4ConfigColorViewController = SK4ConfigColorViewController()
	lazy var dirViewController: SK4ConfigViewController = SK4ConfigViewController()
	lazy var pickerViewController: SK4ConfigPickerViewController = SK4ConfigPickerViewController()

	/// ユーザー設定管理クラス
	public weak var configAdmin: SK4ConfigAdmin!

	/// 初期化
	public convenience init(tableView: UITableView, parent: UIViewController, configAdmin: SK4ConfigAdmin) {
		self.init()

		setup(tableView: tableView, parent: parent, configAdmin: configAdmin)
	}

	/// 初期化
	open func setup(tableView: UITableView, parent: UIViewController, configAdmin: SK4ConfigAdmin) {
		super.setup(tableView: tableView, parent: parent)

		self.configAdmin = configAdmin
		configAdmin.configTable = self

		syncSection()
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - セクション関係

	/// 設定とテーブルでセクションを同期させる
	open func syncSection() {
		sectionArray.removeAll()

		for sec in configAdmin.userSection {
			let ts = SK4ConfigTableSection(configSection: sec)
			sectionArray.append(ts)
		}
	}

	/// テーブルにセクションを挿入
	open func insertSection(at: Int) {
		let config = configAdmin.userSection[at]
		let table = SK4ConfigTableSection(configSection: config)
		sectionArray.insert(table, at: at)
	}

	/// テーブルのセクションを削除
	open func removeSection(at: Int) {
		sectionArray.remove(at: at)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - キーボードの開閉に対応

	/// キーボードの開閉に合わせて位置を調整するCell
	public var displayOffsetCell: IndexPath?

	/// スクロール位置を調整するCellを設定
	public func setDisplayOffset(config: SK4ConfigValue?) {
		displayOffsetCell = config?.indexPath
	}

	// /////////////////////////////////////////////////////////////

	/// キーボードが開かれるときの処理
	open func onKeyboardWillShow(_ notify: NSNotification) {
		if let index = displayOffsetCell {
			let info = SK4KeyboardUserInfo(notify: notify)
			adjustDisplayOffset(index: index, rect: info.frameEnd)
		}
	}

	/// キーボードが閉じられるときの処理
	open func onKeyboardWillHide(_ notify: NSNotification) {
		resetDisplayOffset()
	}

	// /////////////////////////////////////////////////////////////

	/// スクロール位置を調整
	public func adjustDisplayOffset(index: IndexPath, rect: CGRect) {

		// キーボードとTableViewとの間のマージン
		let margin: CGFloat = 48

		var table_re = tableView.bounds
		if let sv = tableView.window {
			table_re = sv.convert(table_re, from: tableView)
		}

		let offset = max(0, table_re.maxY - rect.minY + margin)
		tableView.contentInset.bottom = offset
		tableView.scrollIndicatorInsets.bottom = offset
		tableView.scrollToRow(at: index, at: .bottom, animated: false)
	}

	/// スクロール位置をリセット
	public func resetDisplayOffset() {
		var offset: CGFloat = 0
		if let tab = parent.tabBarController {
			offset += tab.tabBar.frame.height
		}

		tableView.contentInset.bottom = offset
		tableView.scrollIndicatorInsets.bottom = offset
	}
	
	// /////////////////////////////////////////////////////////////
	// MARK: - for override

	override open func viewWillAppear() {
		super.viewWillAppear()

		registerKeyboardObserver()
		configAdmin.viewWillAppear()
	}

	override open func viewWillDisappear() {
		super.viewWillDisappear()

		configAdmin.viewWillDisappear()
		removeKeyboardObserver()
	}

}

// eof
