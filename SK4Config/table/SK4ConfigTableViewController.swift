//
//  SK4ConfigTableViewController.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Library

/// ユーザー設定用テーブル表示ViewControllerクラス
open class SK4ConfigTableViewController: SK4TableViewController {

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	/// ユーザー設定管理クラス
	public var configAdmin: SK4ConfigAdmin?

	/// 初期化（設定以外はお任せ）
	open func setup(configAdmin: SK4ConfigAdmin) {
		let tv = makeTableView(style: .grouped)
		SK4AutoLayout.overlay(target: tv, parent: self)

		setup(tableView: tv, configAdmin: configAdmin)
	}

	/// 初期化（TableViewも用意）
	open func setup(tableView: UITableView, configAdmin: SK4ConfigAdmin) {
		self.tableView = tableView
		self.configAdmin = configAdmin
		self.tableModel = SK4ConfigTableAdmin(tableView: tableView, parent: self, configAdmin: configAdmin)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for UIViewController

	override open func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if let configAdmin = configAdmin {
			navigationItem.title = configAdmin.title
		}
	}

}

// eof
