//
//  SK4ConfigUserDefaults.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// UserDefaultsに対応したユーザー設定管理クラス
open class SK4ConfigUserDefaults: SK4ConfigAdmin {

	// /////////////////////////////////////////////////////////////
	// MARK: - for override

	/// コンフィグを復元
	override open func onLoad() {
		defaultUserDefaults()
		readUserDefaults()
	}

	/// コンフィグを保存
	override open func onSave() {
		writeUserDefaults()
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - UserDefaultsの初期化／保存／再生

	/// NSUserDefaultsの初期値を設定
	func defaultUserDefaults() {
		var dic = [String : Any]()
		forAllConfig { (path, cv) in
			if let key = makeKey(path: path, config: cv) {
				dic[key] = cv.string
			}
		}
		let ud = UserDefaults.standard
		ud.register(defaults: dic)
	}

	/// NSUserDefaultsから読み込み
	func readUserDefaults() {
		let ud = UserDefaults.standard
		forAllConfig { (path, cv) in
			if let key = makeKey(path: path, config: cv) {
				if let str = ud.string(forKey: key) {
					cv.string = str
				}
			}
		}
	}

	/// NSUserDefaultsに保存
	func writeUserDefaults() {
		let ud = UserDefaults.standard
		forAllConfig { (path, cv) in
			if let key = makeKey(path: path, config: cv) {
				ud.set(cv.string, forKey: key)
			}
		}
	}

	/// NSUserDefaultsで使用するキーを作成　※ReadOnlyの設定は保存しない
	func makeKey(path: String, config: SK4ConfigValue) -> String? {
		if config.readOnly == true {
			return nil
		} else {
			return "\(path)/\(config.identifier)"
		}
	}

}

// eof
