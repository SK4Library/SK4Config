//
//  SK4ConfigSection.swift
//  SK4Config
//
//  Created by See.Ku on 2016/12/01.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Library

/// 設定を管理するためのセクションクラス
open class SK4ConfigSection: Equatable {

	/// ID（値の保管／復元で使用）
	public var identifier = ""

	/// 設定の管理クラス
	public weak var configAdmin: SK4ConfigAdmin!

	/// 表示用のセクション
	public weak var tableSection: SK4ConfigTableSection?

	/// true: 内部向けセクション（＝ユーザーが操作しない）
	public var isInternal: Bool {
		if let hide = configAdmin?.hideSection, hide === self {
			return true
		} else {
			return false
		}
	}

	/// セクションのヘッダー
	public var header: String?

	/// セクションのフッター
	public var footer: String?

	/// 設定
	public var configArray = SK4ArrayWithHook<SK4ConfigValue>()

	/// 初期化
	public init(header: String, footer: String? = nil, identifier: String? = nil) {
		self.header = header
		self.footer = footer
		self.identifier = identifier ?? header

		// フックを設定
		configArray.onRegisterHook = { [weak self] (item, at) in
			self?.setupConfig(config: item, at: at)
		}

		configArray.onRemoveHook = { [weak self] (item, at) in
			self?.cleanConfig(config: item, at: at)
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - セクション関係の情報・操作

	/// セクションが登録された
	open func onRegister(configAdmin: SK4ConfigAdmin?, at: Int) {
		self.configAdmin = configAdmin
		configAdmin?.configTable?.insertSection(at: at)
	}

	/// セクションが削除された
	open func onRemove(configAdmin: SK4ConfigAdmin?, at: Int) {
		configAdmin?.configTable?.removeSection(at: at)
		self.configAdmin = nil
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 設定の追加・削除

	/// 設定をセクションに追加
	open func addConfig(_ config: SK4ConfigValue) {
		configArray.append(config)
	}

	/// 設定が追加された後の処理
	open func setupConfig(config: SK4ConfigValue, at: Int) {
		config.configAdmin = configAdmin
		if isInternal {
			config.readOnly = false
		}
		tableSection?.insertRow(at)
	}

	/// 設定が削除された後の処理
	open func cleanConfig(config: SK4ConfigValue, at: Int) {
		if isInternal == false {
			tableSection?.removeRow(at)
		}
		config.configAdmin = nil
	}
	
	// /////////////////////////////////////////////////////////////
	// MARK: - for Equatable

	public static func ==(lhs: SK4ConfigSection, rhs: SK4ConfigSection) -> Bool {
		return lhs === rhs
	}

}

// eof
