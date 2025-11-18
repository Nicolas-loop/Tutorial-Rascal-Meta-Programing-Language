module Generator

import IO;
import Set;
import List;
import String;

import Syntax;
import Parser;
import Checker;

void main() {
    
    inFile = |project://tutorial-rascal-meta-programing-language/src/main/rascal/instance/spec2.tdsl|;
    cst = parsePlanning(inFile);
    rVal = generator(cst);
    println(rVal);
}

str generator(cst) {
    tm = modulesTModelFromTree(cst);
    rVal = 
        "Info of the planning DepartmentABC
        'All Persons:
	    '       <for (person <- {name | /(Person) `<ID name> { <Role role> , age <INT age> }` := cst }) {><person>
        '       <}>
        'All actions of tasks:
        '======
        '        <printTaskWithDuration(cst)>
        '=====
        'Other way of listing all tasks:
        '        <printTaskWithoutDuration(cst, tm)>
        '";
    return rVal;
}

str printTaskWithDuration(ast) {
    rVal = [];
    for (<a, p, d> <- [ <action, prio, duration> | /(Task) `Task <Action action> person <ID name> priority: <INT prio> <Duration? duration>` := ast ]) {
        rVal += "<printAction(a)> <p> <printDuration(d)>";
    }
    return intercalate(" &\n", rVal);
}

str printTaskWithoutDuration(ast, tm) {
    rVal = [];
    for (<a, p, m> <- { <action, prio, name> | /(Task) `Task <Action action> person <ID name> priority: <INT prio> <Duration? duration>` := ast }) {
        rVal += "<printOrganizer(m, tm)> <p> <printAction(a)>";
    }
    return intercalate(" ,\n", rVal);
}

str printAction(action) {
    if (/(LunchAction) `Lunch <ID location>`      := action)  return "Lunch at location <location>";
    if (/(MeetingAction) `Meeting <STRING topic>` := action)  return "Meeting with topic <replaceAll("<topic>", "\"", "")>";
    if (/(PaperAction) `Report <ID report>`       := action)  return "Paper for journal <report>";
    if (/(PaymentAction) `Pay <INT amount> euro`  := action)  return "Pay <amount> Euro";
    return "Unknown action!";
}

str printDuration(duration) {
    rVal = "";
    if (/(Duration) `duration: <INT dl> <TimeUnit unit>` := duration) {
        u = "";
        if (/(Minute) `min` := duration) u = "m";
        if (/(Hour) `hour`  := duration) u = "h";
        if (/(Day) `day`    := duration) u = "d";
        if (/(Week) `week`  := duration) u = "w";
        return "with duration: <dl> <u>";
    } else {
        ; // duration is optional
    }
    return rVal;
}

str printOrganizer(name, tm) {
    DefInfo defInfo = findReference(tm, name);
    println(defInfo);
    if (p <- defInfo.person) {
        return "Organizer is: <name>, role: <p.role>, age: <p.age> -\>";
    }
    return "Organizer is: <name> (no person information available)";
}

DefInfo findReference(tm, use) {
    defs = getUseDef(tm);
    if (def <- defs[use.src]) { 
        return tm.definitions[def].defInfo;
    }
    throw "Fix references in language instance";   
}
