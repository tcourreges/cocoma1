// specific plans for drones

!run.

+!run
<-
    .print("waiting for job");
    start("flight_ticket(paris,athens,15/12/2015)");
    !skip_forever;
.

+pricedJob(JobId, Storage, A,B,C, List)
<- 
    .print("received job ", JobId," : ",List);
    bid(75);
.

+charge(C) : C < 100 & not .desire(charge) <- !charge.
