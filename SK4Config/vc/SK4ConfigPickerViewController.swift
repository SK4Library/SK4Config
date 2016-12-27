//
//  SK4ConfigPickerViewController.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Library

/// UIPickerViewを使用して、複数の値を選択するためのViewController
class SK4ConfigPickerViewController: UIViewController {

	var configValue: SK4ConfigValue!

	var annotationLabel: UILabel!
	var pickerView: UIPickerView!
	var pickerAdmin: SK4PickerViewAdmin!

	override func viewDidLoad() {
		super.viewDidLoad()

		// デフォルトのView
		view.backgroundColor = .white

		// annotationで使うUILabel
		annotationLabel = UILabel()
		annotationLabel.textAlignment = .center
		view.addSubview(annotationLabel)

		// 値を選択するUIPickerView
		let picker = UIPickerView()
		view.addSubview(picker)
		pickerView = picker

		// OKで使うUIButton
		let button = UIButton(type: .system)
		button.setTitle("OK", for: .normal)
		button.addTarget(self, action: #selector(SK4ConfigPickerViewController.onClose), for: .touchUpInside)
		view.addSubview(button)

		// AutoLayoutを設定
		let maker = SK4AutoLayout(viewController: self)
		maker.addDic(name: "annotation", view: annotationLabel)
		maker.addDic(name: "picker", view: picker)
		maker.addDic(name: "button", view: button)

		maker.addFormat("V:[topLayoutGuide]-12-[annotation]-4-[picker(>=162)]-16-[button]")
		maker.addFormat("H:|-[annotation]-|")
		maker.addFormat("H:|-[picker]-|")
		maker.addFormat("H:[button(==120)]")
		maker.addCenterEqualX(target: button, base: view)
		view.addConstraints(maker.constraints)

		// UIPickerViewの管理クラス
		pickerAdmin = SK4PickerViewAdmin(pickerView: pickerView, parent: self)

		pickerAdmin.didSelect = { [weak self] in
			self?.updateCell()
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationItem.title = configValue.title

		if let cv = configValue as? SK4ConfigMulti {
			pickerAdmin.unitArray = cv.unitArray
			pickerView.reloadAllComponents()
			annotationLabel.text = cv.annotation
		}

		pickerAdmin.selectToPicker()
	}
	
	func onClose() {
		_ = navigationController?.popViewController(animated: true)
	}

	func updateCell() {
		configValue.configAdmin?.onChange(configValue)
		configValue.cell.updateCell()
	}

}

// eof
