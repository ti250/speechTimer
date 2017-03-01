//
//  TimerInterfaceController.swift
//  SpeechTimer
//
//  Created by Taketomo Isazawa on 1/3/17.
//  Copyright © 2017 Taketomo Isazawa. All rights reserved.
//

import WatchKit
import Foundation


class TimerInterfaceController: WKInterfaceController {

    @IBOutlet var totalTimer: WKInterfaceTimer!
    @IBOutlet var timer: WKInterfaceTimer!
    @IBOutlet var Button: WKInterfaceButton!
    @IBOutlet var titleLabel: WKInterfaceLabel!
    var speech: Speech!
    var currentSection: Section? = nil
    var currentSectionIndex:Int = 0
    var nextBuzzTimer:Timer?
    
    
    @IBAction func nextSection() {
        self.totalTimer.setDate(speech.endTime as Date)
        self.totalTimer.start()
        if let thisTimer = self.nextBuzzTimer{
            thisTimer.invalidate()
        }
        if self.currentSection != nil{
            self.currentSection?.done = true
        }
        if self.currentSection == nil{
            print(currentSection?.length)
            self.currentSection = speech.sections[currentSectionIndex]
            self.titleLabel.setText(currentSection?.name)
            self.Button.setTitle("Next")
            let timeRemainingToDo = self.speech.timeLeft
            let timeRemainingForSpeech = self.speech.timeToEnd
            if timeRemainingToDo > timeRemainingForSpeech{
                self.timer.setTextColor(UIColor.red)
            }
            else{
                self.timer.setTextColor(UIColor.green)
            }
            let timeForSection = (currentSection!.length/timeRemainingToDo) * timeRemainingForSpeech
            let timerEndTime = NSDate(timeInterval: timeForSection, since: NSDate() as Date)
            self.timer.setDate(timerEndTime as Date)
            self.nextBuzzTimer = Timer(fire: timerEndTime as Date, interval: 0.0, repeats: false){_ in 
                WKInterfaceDevice.current().play(.failure)
                let newTimerEndTime = NSDate(timeInterval: 60.0, since: NSDate() as Date)
                self.nextBuzzTimer = Timer(fire: newTimerEndTime as Date, interval: 60.0, repeats: true){_ in
                    WKInterfaceDevice.current().play(.failure)
                }
                RunLoop.current.add(self.nextBuzzTimer!, forMode: .defaultRunLoopMode)
            }
            self.timer.start()
        }
        else if self.currentSectionIndex <= self.speech.sections.count - 2{
            print(currentSection?.length)
            self.currentSection = speech.sections[currentSectionIndex + 1]
            self.currentSectionIndex += 1
            self.titleLabel.setText(currentSection?.name)
            self.Button.setTitle("Next")
            let timeRemainingToDo = self.speech.timeLeft
            let timeRemainingForSpeech = self.speech.timeToEnd
            if timeRemainingToDo > timeRemainingForSpeech{
                self.timer.setTextColor(UIColor.red)
            }
            else{
                self.timer.setTextColor(UIColor.green)
            }
            let timeForSection = (currentSection!.length/timeRemainingToDo) * timeRemainingForSpeech
            let timerEndTime = NSDate(timeInterval: timeForSection, since: NSDate() as Date)
            self.timer.setDate(timerEndTime as Date)
            self.nextBuzzTimer = Timer(fire: timerEndTime as Date, interval: 0.0, repeats: false){_ in
                WKInterfaceDevice.current().play(.failure)
                let newTimerEndTime = NSDate(timeInterval: 60.0, since: NSDate() as Date)
                self.nextBuzzTimer = Timer(fire: newTimerEndTime as Date, interval: 60.0, repeats: true){_ in
                    WKInterfaceDevice.current().play(.failure)
                }
                RunLoop.current.add(self.nextBuzzTimer!, forMode: .defaultRunLoopMode)
            }
            self.timer.start()
        }
        else if self.currentSectionIndex <= self.speech.sections.count - 2{
            self.currentSection = speech.sections[currentSectionIndex + 1]
            self.currentSectionIndex += 1
            self.titleLabel.setText(currentSection?.name)
            self.Button.setTitle("Finish")
            let timeRemainingToDo = self.speech.timeLeft
            let timeRemainingForSpeech = self.speech.timeToEnd
            if timeRemainingToDo > timeRemainingForSpeech{
                self.timer.setTextColor(UIColor.red)
            }
            else{
                self.timer.setTextColor(UIColor.green)
            }
            let timeForSection = (currentSection!.length/timeRemainingToDo) * timeRemainingForSpeech
            let timerEndTime = NSDate(timeInterval: timeForSection, since: NSDate() as Date)
            self.timer.setDate(timerEndTime as Date)
            self.nextBuzzTimer = Timer(fire: timerEndTime as Date, interval: 0.0, repeats: false){_ in
                WKInterfaceDevice.current().play(.failure)
                self.timer.setTextColor(UIColor.red)
                let newTimerEndTime = NSDate(timeInterval: 60.0, since: NSDate() as Date)
                self.nextBuzzTimer = Timer(fire: newTimerEndTime as Date, interval: 60.0, repeats: true){_ in
                    WKInterfaceDevice.current().play(.failure)
                }
                RunLoop.current.add(self.nextBuzzTimer!, forMode: .defaultRunLoopMode)
            }
            self.timer.start()
        }
        else{
            self.Button.setHidden(true)
            self.timer.setDate(Date())
            self.totalTimer.setDate(Date())
            self.timer.stop()
            self.totalTimer.stop()
        }
        RunLoop.current.add(nextBuzzTimer!, forMode: .defaultRunLoopMode)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let thisSpeech = context as? Speech{
            self.speech = thisSpeech
        }
        self.currentSectionIndex = 0
        self.Button.setTitle("Start")
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
