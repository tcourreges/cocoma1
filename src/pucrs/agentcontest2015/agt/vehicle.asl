{ include("common-rules.asl") }
{ include("common-plans.asl") }
{ include("actions.asl") }


+!doBid : task(D) & running(true)
<-
	//bid
	.print("Currently bid ");
	?role(Type, Speed, Charge, Load, Items);
	if (idling) {
		bid(Speed);
	} 
	else {
		bid(0);
	}
.


+idling : running(false)
<-
	.print("asking permission for auction start");
	ask_permission;
	!start_auction;
.

+!start_auction : king(K) & .my_name(K)
<-
	?index(I);
	.print("Starting for job number ", I+1);
	start(I+1);
	+idling;
	!doBid;
.
	
+!start_auction : true
<-
	+idling;
.

+answer_count(4) : king(K) & .my_name(K)
<- 
	stop;
	release_permission;
.

+winner(W) : .my_name(W)
<-
	?index(I);
	.print("Doing job with index ", I, "!");
	.broadcast(untell, idling);
	.broadcast(tell, idling);
	-idling;
	.nth(I,todoList,Node);
.

+!needToAssemble(material,assist,master)
<- 
	//cannot assemble more than one item at once
	!goto(workshop1,0);
	if (assist){
		!assist_assemble(master);
		.print("I assisted ", master ,"to build ", material, ".");
	}
	else{
		.my_name(Name);
		!broadcast(achieve,needToAssemble(material, true, Name));
		!assemble(material);
		.print("I assembled ", material, ".");
	}
	//once done, idle
	+idling;
.

+!needToBuy(item, quantity)
<-
	.print("Going to buy ", quantity, " ", item);
	!buy_item(item,quantity);
	//once done, idle
	+idling;
.

+!get_permission
<-
	askPermission;
.

+pricedJob(JobId, Storage, A,B,C, List)
<- 
	askPermission;
	
	!build_todo_list;
.   

+!build_todo_list : king(K) & .my_name(K)
<-
	?pricedJob(JobId, Storage, A,B,C, List);
	.print("Processing TodoList");
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
   	.print("Built the following todolist : ",Bcast);
   	.broadcast(tell,todoList);
   	releasePermission;
    .broadcast(tell,idling);		    
	+idling;
.

+!build_todo_list : true
<-
	.print("Didnt get permissions to write the list");
.
/* //////////////////////////////////////// DO NOT REMOVE //////////////// */

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
	
