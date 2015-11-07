// specific plans for drones

//!start("a2","flight_ticket(athens,paris,18/12/2015)").
!run.

+!run
<-
    .print("waiting for job");
    !skip_forever;
.

+pricedJob(JobId, Storage, A,B,C, List)
<- 
    .print("received job ", JobId," : ", List);
    .nth(0, List, Item1);
    !start(JobId,Item1);
.

//bidding
+!start(Id,P) 
   <- makeArtifact(Id, "env.CoordArtifact", [], ArtId);
      focus(ArtId);
      .broadcast(achieve,focus(Id));
      start(P)[artifact_id(ArtId)];
      //.at("now + 5 seconds", {+!decide(Id)})
.
      
+!decide(Id)
   <- .print("stopping");
stop[artifact_name(Id)].

+task(D)[artifact_id(AId)] : running(true)[artifact_id(AId)] 
   <- bid(math.random * 100 + 10)[artifact_id(AId)].

+winner(W)[artifact_id(AId)] : W \== no_winner
   <- ?task(S)[artifact_id(AId)];
      ?best_bid(V)[artifact_id(AId)];
      .print("Winner for ", S, " is ",W," with ", V).         

+charge(C) : C < 100 & not .desire(charge) <- !charge.
