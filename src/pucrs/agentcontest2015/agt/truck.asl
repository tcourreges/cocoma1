// specific plans for trucks

!run.

+!run
<-
    .print("waiting for job");
    !skip_forever;
.
   
+pricedJob(JobId, Storage, A,B,C, List)
<- 
    .print("received job ", JobId," : ",List);
    bid(50);
.
