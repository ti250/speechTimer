//
//  InterfaceController.swift
//  SpeechTimer WatchKit Extension
//
//  Created by Taketomo Isazawa on 1/3/17.
//  Copyright © 2017 Taketomo Isazawa. All rights reserved.
//

import WatchKit
import Foundation

class Section{
    let length: TimeInterval
    let name: String
    var done = false
    
    init(name: String, length: TimeInterval){
        self.name = name
        self.length = length
    }
    
    init(name: String, lengthInMinutes: Float){
        self.name = name
        self.length = TimeInterval(lengthInMinutes*60.0)
    }
}

class Speech{
    var totalLength: TimeInterval{
        var total = TimeInterval(0)
        for section in self.sections{
            total += section.length
        }
        return total
    }
    var timeLeft: TimeInterval{
        var total = TimeInterval(0)
        for section in self.sections{
            if section.done == false{ total += section.length}
        }
        return total
    }
    var timeToEnd: TimeInterval{
        return endTime.timeIntervalSinceNow
    }
    var endTime: NSDate
    var sections: [Section]
    init(sections: [Section], endTime: NSDate){
        self.sections = sections
        self.endTime = endTime
    }
}


class InterfaceController: WKInterfaceController {

    let speeches = ["Y9", "Y13B", "Y13A"]
    @IBOutlet var speechesTable: WKInterfaceTable!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        let Y9Speech = Speech(sections: [Section(name: "Intro, recap w/eg", lengthInMinutes: 10.0),
                                         Section(name: "RTank demo&vote", lengthInMinutes: 10.0),
                                         Section(name: "Qs start", lengthInMinutes: 5.0),
                                         Section(name: "Laser&exit", lengthInMinutes: 10.0)],
                              endTime: NSDate(timeInterval: TimeInterval(35*60), since: Date()))
        //    let Y9Speech = Speech(sections: [Section(name: "Intro, recap w/eg", lengthInMinutes: 0.25),
        //                                     Section(name: "RTank demo&vote", lengthInMinutes: 0.25),
        //                                     Section(name: "Qs start", lengthInMinutes: 0.25),
        //                                     Section(name: "Laser&exit", lengthInMinutes: 0.25)],
        //                          endTime: NSDate(timeInterval: TimeInterval(60), since: Date()))
        let Y13ASpeech = Speech(sections: [Section(name: "Intro, recap diffrac", lengthInMinutes: 5.0),
                                           Section(name: "Qual.diff+letter patterns", lengthInMinutes: 10.0),
                                           Section(name: "Python demo", lengthInMinutes: 5.0),
                                           Section(name: "SSlit deriv.", lengthInMinutes: 5.0),
                                           Section(name: "Qsheet", lengthInMinutes: 10.0)],
                                endTime: NSDate(timeInterval: TimeInterval(35*60), since: Date()))
        let Y13BSpeech = Speech(sections: [Section(name: "Intro, recap diffrac", lengthInMinutes: 5.0),
                                           Section(name: "prac.+letter patterns", lengthInMinutes: 10.0),
                                           Section(name: "SSlit deriv.", lengthInMinutes: 10.0),
                                           Section(name: "Qsheet", lengthInMinutes: 15.0)],
                                endTime: NSDate(timeInterval: TimeInterval(40*60), since: Date()))
        let speechesData = [Y9Speech, Y13BSpeech, Y13ASpeech]
        print(rowIndex)
        let speech = speechesData[rowIndex]
        
        return speech
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.speechesTable.setNumberOfRows(self.speeches.count, withRowType: "default")
        for (index,speech) in speeches.enumerated(){
            if let cell = self.speechesTable.rowController(at: index) as? RowController{
                cell.textLabel.setText(speech)
            }
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
