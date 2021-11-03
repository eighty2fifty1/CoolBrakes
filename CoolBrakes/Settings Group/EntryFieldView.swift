//
//  EntryFieldView.swift
//  CoolBrakes
//
//  Created by James Ford on 11/1/21.
//

import SwiftUI
import Introspect

struct EntryFieldView: View {
    var label: String
    @Binding var field: Double?
    var placeHolder: Double
    var placeHolderString: String {
        return numFormatter.string(from: NSNumber(value: placeHolder)) ?? ""
    }
    var prompt: String
    
    private var numFormatter: NumberFormatter {
        let form = NumberFormatter()
        //form.alwaysShowsDecimalSeparator = false
        form.numberStyle = .none
        return form
    }
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label)
                TextField(placeHolderString, value: $field, formatter: numFormatter)
                    .frame(width: 100.0)
                    //.keyboardType(.numberPad)
                    // won't work properly with number pad...problem for the future
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .introspectTextField(customize: addToolbar)
                    
                
            }
            
            Text(prompt)
                .font(.caption)
                .foregroundColor(Color.red)

            
        }
    }
    func addToolbar(to textField: UITextField) {
        let toolbar = UIToolbar(
            frame: CGRect(origin: .zero, size: CGSize(
                            width: textField.frame.size.width, height: 44)))
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(
        title: "Done",
            style: .done,
            target: self,
            action: #selector(textField.textFieldShouldReturn(_:)))
        toolbar.setItems([flexButton, doneButton], animated: true)
        textField.inputAccessoryView = toolbar
    }

}
extension UITextField: UITextFieldDelegate {
    @objc func didTapDoneButton(_ button: UIBarButtonItem) -> Void {
        
        resignFirstResponder()
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("done button pressed")
        resignFirstResponder()
        return true
    }
}

struct EntryFieldView_Previews: PreviewProvider {
    static var previews: some View {
        EntryFieldView(label: "S&H", field: .constant(46), placeHolder: 47, prompt: "Poopy Pants")
    }
}
