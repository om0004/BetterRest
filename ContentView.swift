//
//  ContentView.swift
//  BetterRest
//
//  Created by om on 04/04/21.
//

import SwiftUI

struct ContentView: View
{
    @State private var wakeUp = defualtWakeTime
    @State private var sleepHours=8.25
    @State private var coffeeAmount=1
    @State private var alertTitle:String=""
    @State private var alertMessage:String=""
    @State private var alertStatus=false
    static var defualtWakeTime:Date
    {
        var comp=DateComponents()
        comp.hour=7
        comp.minute=0
        return Calendar.current.date(from:comp) ?? Date()
        
    }
    var body: some View
    {
        NavigationView()
        {
            Form()
            {
                VStack(alignment:.leading, spacing:0)
                {
                    Text("When do u want to wakeup?")
                        .font(.headline)
                    DatePicker("Please enter a time",selection:$wakeUp,displayedComponents:.hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                VStack(alignment:.leading, spacing:0)
                {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper(value:$sleepHours,in:3...12,step:0.25)
                    {
                        Text("\(sleepHours,specifier:"%.3g") Hours")
                    }
                }
                VStack(alignment:.leading, spacing:0)
                {
                    Text("Daily coffee intake")
                        .font(.headline)
                    Stepper(value:$coffeeAmount,in:1...20,step:1)
                    {
                        if coffeeAmount==1
                        {
                            Text("1 cup")
                        }
                        else
                        {
                            Text("\(coffeeAmount) cups")
                        }
                    }
                }
            }
            .alert(isPresented:$alertStatus)
            {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle("BetterRest")
            .navigationBarItems(trailing:
            Button(action:calculateBedTime)
            {
                Text("Calculate")
            }

            )
        }
    }
    func calculateBedTime()
    {
        let model=SleepCalculator()
        let components=Calendar.current.dateComponents([.hour,.minute], from:wakeUp)
        let hour=(components.hour ?? 0)*60*60
        let minute=(components.minute ?? 0)*60
        do
        {
            let prediction = try model.prediction(wake:Double(hour+minute), estimatedSleep:sleepHours, coffee:Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter=DateFormatter()
            formatter.timeStyle = .short
            alertTitle="Your ideal bedtime is"
            alertMessage=formatter.string(from:sleepTime)
            alertStatus=true
        }
        catch
        {
            alertTitle="Error"
            alertMessage="sorry there was a error calculating your bedtime"
            alertStatus=true
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
