module Syntax

layout Layout = WhitespaceAndComment* !>> [\ \t\n\r#];
lexical WhitespaceAndComment = [\ \t\n\r] | @category="Comment" "#" ![\n]* $;

start syntax Planning 
    = planning: PersonTasks+ personList
;
syntax PersonTasks 
    = personTasks: 'Person' ID name Task+ tasks
;
syntax Task 
     = task:
    'Task' Action action
    'person' ID name
    'priority:' INT prio
    Duration? duration
;
syntax Role
     = manager: 'Manager'
     | employee: 'Employee' 
;
syntax Duration 
    = duration: 'duration' ':' INT dl TimeUnit unit
;
syntax Action 
    = lunch: LunchAction lunchAction 
    | meeting: MeetingAction meetingAction
    | paper: PaperAction paperAction
    | payment: PaymentAction paymentAction
;
syntax LunchAction 
    = lunchAction: 'Lunch' ID location
;
syntax MeetingAction 
    = meetingAction: 'Meeting' STRING topic
;
syntax PaperAction 
    = paperAction: 'Report' ID report
;
syntax PaymentAction 
    = paymentAction: 'Pay' INT amount 'euro'
;
syntax TimeUnit 
    = minute: Minute minute 
    | hour: Hour hour 
    | day: Day day 
    | week: Week week
;
syntax Minute 
    = minute: 'min'
;
syntax Hour 
    = hour: 'hour'
;
syntax Day 
    = day: 'day'
;
syntax Week 
    = week:'week'
;
lexical INT = ([\-0-9][0-9]* !>> [0-9]); 
lexical STRING = "\"" ![\"\n]* "\"";
lexical ID = ([a-zA-Z/.\-][a-zA-Z0-9_/.]* !>> [a-zA-Z0-9_/.]) \ Reserved;
keyword Reserved = "Person" | "Task" | "priority" | "duration" | "Lunch" | "Meeting" 
                    | "Report"  | "Pay" | "euro" | "min" | "hour" | "day" | "week" | ":";
