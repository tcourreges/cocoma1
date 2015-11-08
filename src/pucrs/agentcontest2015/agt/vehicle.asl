{ include("common-rules.asl") }
{ include("common-plans.asl") }
{ include("actions.asl") }

+!focus(A) 
   <- lookupArtifact(A,ToolId); 
      focus(ToolId).

+idling : todoList(List)
<-
 	?index(Id);
	.print("currently idling -> trying to create id ", Id);
	if(doingAuction(_)) {
		.print("auction running");
	} else {
		.broadcast(tell, doingAuction);
		+doingAuction;
		.print("starting auction ", Id2);
		//.nth(0, List, CurrentAction); // need to change 0 to index

		.term2string(Id,Id2);
		!startArtifact(Id2, Id2);
		
	}
.

+winner(W) : .my_name(W)
<-
	.print("I Won!");
	.broadcast(untell,doingAuction);

	-idling(_);

	?index(I);
	-index(_); +index(I+1);
	.broadcast(untell, index(_));
	.broadcast(tell, index(I+1));

	.print(I+1);

	-doingAuction;
	.broadcast(untell,idling);
	.broadcast(tell,idling);
.

+task(D)[artifact_id(AId)] : running(true)[artifact_id(AId)] 
<- 
	?role(Type, Speed, Charge, Load, Items);
	if (idling) {
		bid(Speed)[artifact_id(AId)];
	} else {
		bid(0)[artifact_id(AId)];
	}
.


+!startArtifact(Id, P)
<-
	makeArtifact(Id, "env.CoordArtifact", [], ArtId);
	focus(ArtId);
	.broadcast(achieve, focus(Id));
	start(P)[artifact_id(ArtId)];
.

+needToAssemble(material,assist,master)
<- 
	//cannot assemble more than one item at once
	!goto(workshop1,0);
	if (assist){
		!assist_assemble(master);
		.print("I assisted ", master ,"to build ", material, ".");
	}
	else{
		!assemble(material);
		.print("I assembled ", material, ".");
		?index(I);
		.broadcast(untell,index(_));
		.broadcast(tell,index(I+1));
	}
	//once done, idle
	+idling;
.

+needToBuy(item, quantity)
<-
	.print("Going to buy ", quantity, " ", item);
	?index(I);
	.broadcast(untell, index(_));
	.broadcast(tell, index(I+1));
	!buy_item(item,quantity);
	//once done, idle
	+idling;
.

+todoList(_)
<- -processingTodo(_).

+pricedJob(JobId, Storage, A,B,C, List)
<- 
	if(processingTodo(_)) {
		.print("someone already processing TodoList");
	}
	else {
		.print("first to process TodoList");
		.broadcast(tell, processingTodo(true));
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
		    ?todoList(Bcast); 
		    .print(Bcast);
		    .broadcast(tell,todoList(Bcast));

		    .broadcast(tell, doingAuction);
		    +doingAuction;

		    +index(1);
		    .broadcast(tell,index(1));	
		    +idling;
		    .broadcast(tell,idling);

		    .broadcast(untell,doingAuction(_));
		    -doingAuction(_);
		}
.   

	// register this agent into the MAPC server (simulator) using a personal interface artifact
+!register_EIS(E)
<-  
    .my_name(Me);
    .concat("perso_art_",Me,AName);
    makeArtifact(AName,"pucrs.agentcontest2015.env.EISArtifact",[],AId);
    focus(AId);
    registerEISEntity(E);
. 

+!register_freeconn
<-	
    .print("Registering...");
	registerFreeconn;
.

// plan to react to the signal role/5 (from EISArtifact)
// it loads the source code for the agent's role in the simulation
+role(Role, Speed, LoadCap, BatteryCap, Tools)
<-
	.print("Got role: ", Role);
	!new_round;
	.lower_case(Role, File);
	.concat(File, ".asl", FileExt);
	.include(FileExt);
.
	
