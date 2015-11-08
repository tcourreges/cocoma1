// specific plans for cars

!run.

+!run
<-
    .print("waiting for job");
.

+!stop
<-
    !skip_forever;
.

+charge(C) : C < 150 & not .desire(charge) <- !charge.

