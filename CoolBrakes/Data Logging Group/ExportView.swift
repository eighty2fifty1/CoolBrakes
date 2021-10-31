//
//  ExportView.swift
//  CoolBrakes
//
//  Created by James Ford on 10/31/21.
//

import SwiftUI
import SwiftUIMailView

struct ExportView: View {
    //@State private var mailData = ComposeMailData(subject: "CoolBrakes Trip Data", recipients: ["huskernavy70@gmail.com"], message: "Attached is your data", attachments: [AttachmentData(data: "some text".data(using: .utf8)!, mimeType: "text/plain", fileName: "file.txt")])
    
    @State private var showMailView = false
    
    private var mailData: ComposeMailData {
        let subject = "CoolBrakes \(trip.name ?? "Trip") Data"
        let recipients = [""]
        let message = "Here is your trip data from \(trip.name ?? "Trip").  \nTrip Date: \(trip.formattedStartDate ) \n\nThank you for using CoolBrakes!"
        let attachments = AttachmentData(data: generateCSV(withManagedObjects: trip).data(using: .utf8)!, mimeType: "text/csv", fileName: trip.name!)
        
        return ComposeMailData(subject: subject, recipients: recipients, message: message, attachments: [attachments])
    }
    
    var trip: Trip
    
    
    var body: some View {
        Button(action: {
            showMailView.toggle()
        }) {
            Image(systemName: "square.and.arrow.up")
        }
        
        .disabled(!MailView.canSendMail)
        .sheet(isPresented: $showMailView) {
            MailView(data: .constant(mailData)) { result in
                print(result)
            }
        }
    }
    
    func generateCSV(withManagedObjects arrManagedObjects: Trip) -> String{
        var CSVString = "Date,Position,Temp,Speed,Elevation\n"
        arrManagedObjects.snapArray.forEach { (eachObject) in
            let entityContent = "\(String(describing: eachObject.timestamp)),\(String(describing: eachObject.posit)),\(String(describing: eachObject.sensorTemp)),\(String(describing: eachObject.speed)),\(String(describing: eachObject.altitude))\n"
            CSVString.append(entityContent)
        }
        
        return CSVString
        /*
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = directory.appendingPathComponent("\(String(describing: arrManagedObjects.name))-\(arrManagedObjects.formattedStartDate)").appendingPathExtension("csv")
        if !fileManager.fileExists(atPath: path.path) {
            fileManager.createFile(atPath: path.path, contents: nil, attributes: nil)
        }
        do {
            try CSVString.write(to: path, atomically: true, encoding: .utf8)
        } catch let error {
            print("Error creating CSV \(error.localizedDescription)")
        }
 */
    }
}

struct ExportView_Previews: PreviewProvider {
    static var trip = Trip()
    
    static var previews: some View {
        ExportView(trip: trip)
    }
}
