// specific plans for motorcycles

!run.

+!run
<-
    .print("waiting for job");
.

+!stop
<-
    !skip_forever;
.

+charge(C) : C < 100 & not .desire(charge) <- !charge.