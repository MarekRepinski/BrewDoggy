//
//  NotificationsView.swift
//  BrewDoggy
//
//  Created by Marek Repinski on 2021-03-05.
//

import SwiftUI
import UserNotifications

struct NotificationsView: View {
    @State private var permission = false           // Activate view if permission is set
    @State private var msg = ""                     // Container for private message
    @State private var date = Date()                // Container trigger date
    
    var brew: Brew
    
    var body: some View {
        VStack{
            if !permission {
                Text("No Permission! Please allow Notifications in Settings")
                    .font(.title3)
                    .bold()
                    .padding()
            } else {
                HStack {
                    Text("Your message:")
                        .bold()
                    TextField("msg", text: $msg)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                .padding(.vertical, 5)
                .padding(.top, 50)

                HStack {
                    DatePicker(selection: $date, in: Date()..., displayedComponents: .date, label: { Text("ETA:").bold() })
                        .datePickerStyle(CompactDatePickerStyle())
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                .padding(.vertical, 5)
                .padding(.bottom, 50)

                Button(action: { scheduleNotification() }){
                    Text("Schedule Notification")
                        .font(.title2)
                        .bold()
                }
                                
                Spacer()

                Text("* Only one notification per Brew")
                    .padding()
            }
        }
        .padding(.horizontal, 15)
        .onAppear() {
            checkPermission()
            getPending()
        }
    }
    
    // Check if permission is set
    private func checkPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { ns in
            if ns.authorizationStatus == .notDetermined {
                permission = askForAuthorization()
            } else if ns.authorizationStatus == .authorized {
                permission = true
            }
        }
    }
    
    // Ask for permission to send notifications
    private func askForAuthorization() -> Bool {
        var rc = false
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                rc = true
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        return rc
    }
    
    // Schedule a notification
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "BrewDoggy!"
        content.subtitle = brew.name!
        content.body = msg
        content.sound = UNNotificationSound.default
        content.userInfo = ["date": date]

        // Set trigger in seconds between
        let interval = daysBetween(start: Date(), end: date) * 24 * 60 * 60 + evenOutTheSeconds()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval), repeats: false)

        let request = UNNotificationRequest(identifier: brew.id!.uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }

    // Calculate number of days between dates
    private func daysBetween(start: Date, end: Date) -> Int {
       Calendar.current.dateComponents([.day], from: start, to: end).day! + 1
    }
    
    // Calculate so it will be triggered at 9 am the chosen day
    private func evenOutTheSeconds() -> Int {
        var secondsToAdd = 9 * 60 * 60 - Calendar.current.component(.hour, from: Date()) * 60 * 60
        secondsToAdd -= Calendar.current.component(.minute, from: Date()) * 60
        
        return secondsToAdd
    }
    
    // Find pending notifications
    private func getPending() {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { reqs in
            for req in reqs {
                if req.identifier == brew.id?.uuidString {
                    msg = req.content.body
                    date = req.content.userInfo["date"] as! Date
                }
            }
        })
    }
}

//struct NotificationsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotificationsView()
//    }
//}
