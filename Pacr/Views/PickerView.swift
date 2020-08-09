//
//  TargetPacePickerView.swift
//  Time Keeper
//
//  Created by Erik Fisher on 8/6/20.
//  Copyright © 2020 Erik Fisher. All rights reserved.
//

import SwiftUI
import UIKit

// Notes to look through
// Credit to protasm from Nov 1 2019: https://stackoverflow.com/questions/56567539/multi-component-picker-uipickerview-in-swiftui
// Apple notes on topic: https://developer.apple.com/tutorials/swiftui/interfacing-with-uikit

struct PickerView: UIViewRepresentable {
    var data: [[Int]]
    @Binding var selections: [Int]

    //makeCoordinator()
    func makeCoordinator() -> PickerView.Coordinator {
        Coordinator(self)
    }

    //makeUIView(context:)
    func makeUIView(context: UIViewRepresentableContext<PickerView>) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)

        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator

        return picker
    }

    //updateUIView(_:context:)
    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<PickerView>) {
        for i in 0..<(self.selections.count) {
            view.selectRow(self.selections[i], inComponent: i, animated: false)
        }
    }

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: PickerView

        //init(_:)
        init(_ pickerView: PickerView) {
            self.parent = pickerView
        }

        //numberOfComponents(in:)
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return self.parent.data.count
        }

        //pickerView(_:numberOfRowsInComponent:)
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.parent.data[component].count
        }

        //pickerView(_:titleForRow:forComponent:)
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return String(self.parent.data[component][row])
        }

        //pickerView(_:didSelectRow:inComponent:)
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.selections[component] = row
        }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return CGFloat(100.0)
        }
    }
}
