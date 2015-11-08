// specific plans for drones

!run.

+!run
<-
    .print("waiting for job");
    !skip_forever;
.

+charge(C) : C < 100 & not .desire(charge) <- !charge.
