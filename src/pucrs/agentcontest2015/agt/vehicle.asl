{ include("common-rules.asl") }
{ include("common-plans.asl") }
{ include("actions.asl") }


+!idle : task(D) & running(true)
<-
	//bid
	?role(Type, Speed, Charge, Load, Items);
	if (idling) {
		bid(Speed);
	} 
	else {
		bid(0);
	}
.

+!idle : running(false) & king(K) & .my_name(K)
<-
	?index(I);
	.print("Currently idling with no auction in progress, starting it for job number ", I+1);
	start(I+1);
	
	//bid
	?role(Type, Speed, Charge, Load, Items);
	if (idling) {
		bid(Speed);
	} 
	else {
		bid(0);
	}
.
	
+answer_count(4)
<- 
	stop
.

+winner(W) : .my_name(W)
<-
	?index(I);
	.print("I Won job with id ", I, "!");
	.broadcast(achieve, idle);
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
	!idle;
.

+needToBuy(item, quantity)
<-
	.print("Going to buy ", quantity, " ", item);
	?index(I);
	.broadcast(untell, index(_));
	.broadcast(tell, index(I+1));
	!buy_item(item,quantity);
	//once done, idle
	!idle;
.

+todoList(_)
<- -processingTodo(_).

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
    //.broadcast(achieve,idle);		    
	//!idle;
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
	
