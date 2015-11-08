// specific plans for trucks

!run.

+!run
<-
    .print("waiting for job");
    !skip_forever;
.
+charge(C) : C < 150 & not .desire(charge) <- !charge.