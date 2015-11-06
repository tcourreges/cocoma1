// specific plans for drones

!run.

+!run
<-
    .print("waiting for job");
    !skip_forever;
.
   
+pricedJob(JobId, Storage, A,B,C, List)
<- 
    .print("received job ", JobId," : ",List)
.

+charge(C) : C < 100 & not .desire(charge) <- !charge.
