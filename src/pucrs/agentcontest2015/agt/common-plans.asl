+idling(true)
<-
	//trouver un job
	?id(i);
	.broadcast(tell,id(i+1));
	-idling(_);
	+idling(false);
.

+needToAssemble(item, workshop, assist)
<-
	//todo
	-idling(_);
	+idling(true);
.

+needToBuy(item,n)
<-
	//buy_item(foo)
	-idling(_);
	+idling(true);
.
/*
 * +task(D)[artifact_id(AId)] : running(true)[artifact_id(AId)] 
   <- bid(math.random * 100 + 10)[artifact_id(AId)].

+winner(W) : .my_name(W) <- .print("I Won!").
 
 */
+pricedJob(JobId, Storage, A,B,C, List)
<- 
    +todoList([]);

    .print("received job ", JobId," : ",List);
    for ( .member(item(X,Y), List) ) {
		?todoList(Temp1); -todoList(_);
		
		.concat(Temp1, [node(X,Y,explore)], Temp2);
		+todoList(Temp2);
	
		//.print(Temp2);
    }

    +again(true);
    while(again(AAA) & AAA=true) {
	    ?todoList(Step); -todoList(_); +todoList([]);

        -again(_); +again(false);
    
	    for( .member( node(X,Y,Z), Step )) {
	    	
			if( Z==explore ) {
				-again(_); +again(true);
				+loopvar(0);
				while(loopvar(Var) & Var < Y) {
					
					?product(X, N, List2);
					
					+assemble(false);
		
					for( .member( consumed(XX,YY), List2 ) ) {
						-assemble(_); +assemble(true);
						?todoList(Temp1); -todoList(_);
						.concat(Temp1, [node(XX,YY,explore)], Temp2);
						+todoList(Temp2);
					}
		
					for( .member( tools(XXX,YYY), List2 ) ) {
						?todoList(Temp1); -todoList(_);
						.concat(Temp1, [node(XXX,YYY,explore)], Temp2);
						+todoList(Temp2);
					}
		
					?todoList(Temp1); -todoList(_);
		
					?assemble(Assemble);
					if(Assemble==true) {
						?loopvar(Count); -loopvar(_); +loopvar(Count+1);
						.concat(Temp1, [node(X,1,assemble)], Temp2); +todoList(Temp2);
					}
					else {
						-loopvar(_); +loopvar(Y);
						.concat(Temp1, [node(X,Y,buy)], Temp2); +todoList(Temp2);
					}
					-assemble(_);
				}
				-loopvar(_);
			}
			else {
				?todoList(Temp1); -todoList(_);
				.concat(Temp1, [node(X,Y,Z)], Temp2);
				+todoList(Temp2);
			}
	    }

    }
    ?todoList(Display); .print(Display);
.   

+simEnd
<-
	!end_round;
	!new_round;
.

+!new_round
<-  .print("-------------------- BEGIN OF NEW ROUND ----------------");
	.
	
+!end_round
<-
	.print("-------------------- END OF THE ROUND ----------------");
	.abolish(_[source(self)]);
	.abolish(_[source(X)]);
    .drop_all_intentions;
    .drop_all_desires;	
.


+lastActionResult(R) : R \== none & R \== successful <- .print("last action result: ",R).

+inFacility(FacilityId)
<-  .my_name(Me);
    .broadcast(achieve,update_location(Me,FacilityId));
. 

+!update_location(Ag,L)
<-   -ag_loc(Ag,_);
     +ag_loc(Ag,L);
.

+!all_at(Ags,Loc) : .count(.member(A,Ags) & ag_loc(A,Loc)) == .length(Ags).
+!all_at(Ags,Loc) 
<-  .findall(A, .member(A,Ags) & ag_loc(A,Loc),LAt);
    .difference(Ags,LAt,RAgs);
    ?step(S);
    .print("waiting ",RAgs," to arrive at ",Loc," -- step ",S);
    !skip;
    !all_at(Ags,Loc);
.


// waits for some belief, skip otherwise
+!wait_skip(B) : B.
+!wait_skip(B) <- !skip; !wait_skip(B).


+!skip_forever
<- !skip;
   !skip_forever;
.

+!buy_item(Item,Amount) : item(Item,A) & A >= Amount.
+!buy_item(Item,Amount) : step(_)
<-  ?find_shop(Item,S);
    !goto(S, 0);
    .print("ok, at ",S);
    !buy(Item,Amount);
    !buy_item(Item,Amount).
+!buy_item(Item,Amount) 
<-  .wait({+step(_)});
    !buy_item(Item,Amount).

    
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }