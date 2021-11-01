//
//  EntryFieldView.swift
//  CoolBrakes
//
//  Created by James Ford on 11/1/21.
//

import SwiftUI

struct EntryFieldView: View {
    var label: String
    @Binding var field: Double
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
                
            }
            Text(prompt)
                .font(.caption)

            
        }
    }
}

struct EntryFieldView_Previews: PreviewProvider {
    static var previews: some View {
        EntryFieldView(label: "S&H", field: .constant(46), placeHolder: 47, prompt: "Poopy Pants")
    }
}
