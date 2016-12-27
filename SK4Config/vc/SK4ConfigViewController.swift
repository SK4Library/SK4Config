//
//  SK4ConfigViewController.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Library

/// ユーザー設定を行うためのViewControllerクラス
open class SK4ConfigViewController: SK4ConfigTableViewController {

	/// 画面を閉じる時の処理
	public var completion: ((Bool) -> Void)?

	/// true: キャンセルされた
	public var canceled = false

	/// true: サブディレクトリ
	public var subDir = false

	// /////////////////////////////////////////////////////////////
	// MARK: - 設定用画面の開閉

	/// 設定用の画面を開く
	open func openConfig(parent: UIViewController) {
		configAdmin?.onEditStart()

		let nav = UINavigationController(rootViewController: self)
		nav.modalPresentationStyle = .formSheet
		parent.present(nav, animated: true, completion: nil)
	}

	/// 設定用の画面を閉じる
	open func closeConfig(cancel: Bool) {
		canceled = cancel
		configAdmin?.onEditEnd(cancel)
		completion?(cancel)

		dismiss(animated: true, completion: nil)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 標準の処理

	override open func viewDidLoad() {
		super.viewDidLoad()

		// 必要であれば初期化
		if let admin = configAdmin, tableView == nil && tableModel == nil {
			setup(configAdmin: admin)
		}

		// UIBarButtonItemを作成
		makeBarButton()
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - BarButton関係

	/// UIBarButtonItemを作成
	open func makeBarButton() {
		if subDir {
			return
		}

		if configAdmin?.cancellation == true {
			let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(SK4ConfigViewController.onCancel(_:)))
			navigationItem.leftBarButtonItem = cancel
		}

		let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SK4ConfigViewController.onDone(_:)))
		navigationItem.rightBarButtonItem = done
	}

	/// 完了
	open func onDone(_ sender: AnyObject) {
		closeConfig(cancel: false)
	}

	/// キャンセル
	open func onCancel(_ sender: AnyObject) {
		closeConfig(cancel: true)
	}

}

// eof
