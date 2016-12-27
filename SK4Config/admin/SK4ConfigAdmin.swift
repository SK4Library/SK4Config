//
//  SK4ConfigAdmin.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Library

/// ユーザー設定をまとめて管理するためのクラス
open class SK4ConfigAdmin: SK4ConfigValue {

	struct Const {

		/// 管理クラスのデフォルト名称
		static let adminDefaultName = "Admin"

		/// 内部用セクションのヘッダー・ID
		static let hideSectionName = "###hide###"
	}
	
	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	/// 実際の値
	public var value = ""

	/// 値と文字列を変換
	override open var string: String {
		get {
			return value
		}

		set {
			value = newValue
		}
	}

	/// true: まとまった編集をキャンセル可能にする
	public var cancellation  = true

	/// true: 設定が変更された時、自動で保存する
	public var autoSave = SK4PauseFlag(enable: true, pause: false)

	/// 表示に使用するTableAdmin
	public var configTable: SK4ConfigTableAdmin? {
		get {
			return cell.configTable
		}

		set {
			cell.configTable = newValue
		}
	}

	/// 初期化
	override public init(title: String, identifier: String? = nil) {
		super.init(title: title, identifier: identifier)

		self.cell = SK4ConfigCellDirectory()

		// フックを設定
		userSection.onRegisterHook = { [weak self] (config, at) in
			config.onRegister(configAdmin: self, at: at)
		}

		userSection.onRemoveHook = { [weak self] (config, at) in
			config.onRemove(configAdmin: self, at: at)
		}

		hideSection.configAdmin = self
	}

	/// デフォルトの名前で初期化
	public convenience init() {
		self.init(title: Const.adminDefaultName)
	}

	/// コンフィグを準備する
	open func setup() {
		autoSave.pause()
		onSetup()
		onLoad()
		autoSave.resume()
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - セクション操作

	/// ユーザーが操作可能な設定
	public var userSection = SK4ArrayWithHook<SK4ConfigSection>()

	/// ユーザーが操作しない部分の設定
	public let hideSection = SK4ConfigSection(header: Const.hideSectionName)
	
	/// セクションを生成・追加
	public func addSection(header: String, footer: String? = nil, identifier: String? = nil) -> SK4ConfigSection {
		let sec = SK4ConfigSection(header: header, footer: footer, identifier: identifier)
		userSection.append(sec)
		return sec
	}

	/// 設定に対応するIndexPathを取得
	public func indexPath(for config: SK4ConfigValue) -> IndexPath? {
		for (i, sec) in userSection.enumerated() {
			if let row = sec.configArray.index(of: config) {
				return IndexPath(row: row, section: i)
			}
		}
		return nil
	}

	/// IndexPathに対応する設定を取得
	public func config(for indexPath: IndexPath) -> SK4ConfigValue? {
		let sec = userSection.safe(indexPath.section)
		return sec?.configArray.safe(indexPath.row)
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - 手動で復元／保存

	/// コンフィグを復元
	open func loadConfig() {
		autoSave.pause()
		onLoad()
		autoSave.resume()
	}

	/// コンフィグを保存
	open func saveConfig() {
		autoSave.pause()
		onSave()
		autoSave.resume()
	}

	/// コンフィグの自動保存を実行
	open func autoSaveConfig() {
		if autoSave.flag == true {
			saveConfig()
		}
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for override

	/// コンフィグを準備する
	open func onSetup() {
	}

	/// コンフィグを復元
	open func onLoad() {
	}

	/// コンフィグを保存
	open func onSave() {
	}

	/// 値が変更された
	open func onChange(_ config: SK4ConfigValue) {
		autoSaveConfig()
	}

	// /////////////////////////////////////////////////////////////

	/// まとめて編集開始
	open func onEditStart() {
		if cancellation {
			autoSave.pause()
		}

		push()
	}

	/// まとめて編集終了
	open func onEditEnd(_ cancel: Bool) {
		if cancel == true {
			pop()
		}

		if cancellation {
			autoSave.resume()
		}

		if cancel == false {
			autoSaveConfig()
		}
	}

	// /////////////////////////////////////////////////////////////

	/// ViewControllerが表示される
	open func viewWillAppear() {
	}

	/// ViewControllerが非表示になる
	open func viewWillDisappear() {
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - まとめて処理

	/// ユーザー向けの設定に対して、まとめて処理を行う
	public func forUserConfig(exec: (String, SK4ConfigValue) -> Void) {
		forEachConfig(all: false, path: "", exec: exec)
	}

	/// 全ての設定に対して、まとめて処理を行う
	public func forAllConfig(exec: (String, SK4ConfigValue) -> Void) {
		forEachConfig(all: true, path: "", exec: exec)
	}

	/// 全ての設定に対して、まとめて処理を行う
	func forEachConfig(all: Bool, path: String, exec: (String, SK4ConfigValue) -> Void) {
		let path = "\(path)/\(identifier)"
		for section in userSection {
			forEachSection(all: all, path: path, section: section, exec: exec)
		}

		if all == true {
			forEachSection(all: all, path: path, section: hideSection, exec: exec)
		}
	}

	/// 指定されたセクションにまとめて処理を行う
	func forEachSection(all: Bool, path: String, section: SK4ConfigSection, exec: (String, SK4ConfigValue) -> Void) {
		let path = "\(path)/\(section.identifier)"
		for cv in section.configArray {
			exec(path, cv)

			if let admin = cv as? SK4ConfigAdmin {
				admin.forEachConfig(all: all, path: path, exec: exec)
			}
		}
	}

	////////////////////////////////////////////////////////////////
	// MARK: - その他

	/// SK4ConfigViewControllerを開く
	@discardableResult
	public func openConfigViewController(parent: UIViewController, completion: ((Bool) -> Void)? = nil) -> SK4ConfigViewController {
		let vc = SK4ConfigViewController()
		vc.configAdmin = self
		vc.completion = completion
		vc.openConfig(parent: parent)
		return vc
	}

	/// 値を全て表示
	open func debugPrint() {
		forAllConfig { path, cv in
			print("\(path) -> \(cv)")
		}
	}

	////////////////////////////////////////////////////////////////
	// MARK: - for override

	/// 値を保存
	override open func push() {
		super.push()

		forUserConfig { path, cv in cv.push() }
	}

	/// 値を復元
	override open func pop() {
		super.pop()

		forUserConfig { path, cv in cv.pop() }
	}

	/// 初期値に戻す
	override open func reset() {
		super.reset()

		forUserConfig { path, cv in cv.reset() }
	}

	/// ランダムに変更
	override open func random() {
		super.random()

		forUserConfig { path, cv in cv.random() }
	}

}

// eof
