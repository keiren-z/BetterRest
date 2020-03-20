//
//  ContentView.swift
//  BetterRest
//
//  Created by keiren on 3/19/20.
//  Copyright © 2020 keiren. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessaage = ""
    @State private var showingAlert = false
    
    var body: some View {
        
        NavigationView {
            Form {
                
                Section(header: Text("when do you want yo wake up?")
                    .font(.headline)) {
                                   
                    DatePicker("Please enter a time",
                              selection: $wakeUp,
                              displayedComponents:
                       .hourAndMinute)
                       .labelsHidden()
                       //old style
                       .datePickerStyle(WheelDatePickerStyle())
                }
               
                Section(header: Text("Desired amount of sleep")
                    .font(.headline)) {
                                  
                    Stepper(value: $sleepAmount, in:
                      4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section(header: Text("Daily coffee intake")
                    .font(.headline)) {
                              
                    Stepper(value: $coffeeAmount, in: 1...20) {
                        if coffeeAmount == 1 {
                            Text("1 cup")
                        } else {
                            Text("\(coffeeAmount) cups")
                        }
                    }
                }
            }
            .navigationBarTitle("BetterRest")
            .navigationBarItems(trailing:
                Button(action: calculateBedTime){
                    Text("Calculate")
                }
            )
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessaage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    
   static  var defaultWakeTime: Date {
       var components = DateComponents()
       components.hour = 7
       components.minute = 0
       return Calendar.current.date(from: components)  ?? Date()
   }
    
    func calculateBedTime(){
        
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60 * 60
        
        do {
            let prediciton = try
            model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            // you can substract a value in seconds directly  from a Date, and you get back a new Date
            let sleepTime = wakeUp - prediciton.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle  = .short
            
            alertMessaage = formatter.string(from: sleepTime)
            alertTitle =  "Your ideal bedtime is..."
        } catch {
            alertTitle = "Error"
            alertMessaage = "Sorry, there wasas a  prroblem calculating your bedtimme."
        }
        
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
