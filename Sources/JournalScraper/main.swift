import Foundation
import FoundationNetworking
import SwiftSoup


print(CommandLine.arguments)
let name = "Mukul Agarwal"
let helpReceived = CommandLine.arguments[2]
let helpGiven = CommandLine.arguments[3]

let internalSeparator = String(repeating: ".", count: 85)
let externalSeparator = String(repeating: "-", count: 85)

guard let url = URL(string: CommandLine.arguments[1]) else {
    fatalError("Bad URL :(")
}

let contents = try! String(contentsOf: url)

let doc: Document = try! SwiftSoup.parse(contents)
let tables = try! doc.select("table")

let journals = tables
  .filter{ try! $0.text().contains("Ponder") }
  .compactMap { try? $0.select("li").compactMap{ try? $0.text() } }

let journalName = try! doc.select(".contentHeader")
  .compactMap{ try? $0.text()}.first!
  .components(
    separatedBy: CharacterSet(charactersIn: " W")
  ).filter { !$0.isEmpty }.first!


print("Name: \(name)")
print("Journal: J\(journalName)")
print()
print("I received assistance from: \(helpReceived)")
print("I assisted: \(helpGiven)")
print()
print(externalSeparator)

var numberedJournals : [[String]]  = []

for i in 0..<journals.count {
    let sectionNumber = i + 1
    var section = [String]()
    for j in 0..<journals[i].count {
        let questionNumber = j + 1
        section.append("\(sectionNumber).\(questionNumber): \(journals[i][j])\n\n")
    }
    numberedJournals.append(section)
}



let questionText = numberedJournals.map { $0.joined(separator: internalSeparator + "\n") }.joined(separator: externalSeparator + "\n")

print(questionText)

let reflectionQuestions = [
  "What did I learn? What is the big idea?",
  "What challenges did I encounter?",
  "How could this experience be improved?",
  "Free Reflection: How has what I've learned impacted my thinking?"
]

reflectionQuestions.forEach {
    print(externalSeparator)
    print($0)
    print()
}


