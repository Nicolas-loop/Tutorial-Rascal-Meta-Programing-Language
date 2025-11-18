module Checker

import Syntax;
 
extend analysis::typepal::TypePal;
import ParseTree;
import String;

data IdRole = personId();

data AType = personType();

data DefInfo(list[Person] person = []);

data Person = person(str role = "Employee", int age = 0);

public TModel modulesTModelFromTree(Tree pt) {
    if (pt has top) pt = pt.top;
    TypePalConfig a = getModulesConfig();
    c = newCollector("collectAndSolve", pt, a);
    collect(pt, c);
    return newSolver(pt, c.run()).run();
}

private TypePalConfig getModulesConfig() = tconfig(
      verbose=true,
      isSubType = subtype
);

void collect(current: (Person) `<ID name> { <Role role> , age <INT age> }`,  Collector c) {
     dt = defType(personType());
     dt.person = [person(role="<role>", age=toInt("<age>"))];
     c.define("<name>", personId(), name, dt);
}

void collect(current: (Task) `Task <Action action>
                        'person <ID name> 
                        'priority: <INT prio>
                        '<Duration? duration>`,  Collector c) {
     c.use(name, {personId()});
}

