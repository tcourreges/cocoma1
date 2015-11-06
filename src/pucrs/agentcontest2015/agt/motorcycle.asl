// specific plans for motorcycles

!run.

+!run
<-
    .print("waiting for job");
    !skip_forever;
.
   
+pricedJob(JobId, Storage, A,B,C, List)
<- 
    .print("received job ", JobId," : ",List);
.

+!focus(A) 
   <- lookupArtifact(A,ToolId); 
      focus(ToolId).

+task(D)[artifact_id(AId)] : running(true)[artifact_id(AId)] 
   <- bid(math.random * 100 + 10)[artifact_id(AId)].
