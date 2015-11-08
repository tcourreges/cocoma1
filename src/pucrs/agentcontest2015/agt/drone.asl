// specific plans for drones

//!start("a2","flight_ticket(athens,paris,18/12/2015)").
!run.

+!run
<-
    .print("waiting for job");
    !skip_forever;
.

+charge(C) : C < 100 & not .desire(charge) <- !charge.
