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

+charge(C) : C < 100 & not .desire(charge) <- !charge.
