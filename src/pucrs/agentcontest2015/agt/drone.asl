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
	?todoList(Temp1); .abolish(todoList(_));
	
	.concat(Temp1, [node(X,Y,explore)], Temp2);
	+todoList(Temp2);

	//.print(Temp2);
    }

    +again(true);
    while(again(AAA) & AAA=true) {
    	    ?todoList(Step); .abolish(todoList(_)); +todoList([]);

            .abolish(again(_)); +again(false);
	    
	    for( .member( node(X,Y,Z), Step )) {
		//.print(Z);
		if( Z==explore ) {
			.abolish(again(_)); +again(true);
			//.print(X);
			?product(X, N, List2);

			+assemble(false);

			for( .member( consumed(XX,YY), List2 ) ) {
				.abolish(assemble(_)); +assemble(true);
				//.print(XX);
				?todoList(Temp1); .abolish(todoList(_));
				.concat(Temp1, [node(XX,YY,explore)], Temp2);
				+todoList(Temp2);
			}

			for( .member( tools(XXX,YYY), List2 ) ) {
				//.print(XXX);
				?todoList(Temp1); .abolish(todoList(_));
				.concat(Temp1, [node(XXX,YYY,explore)], Temp2);
				+todoList(Temp2);
			}

			?todoList(Temp1); .abolish(todoList(_));

			?assemble(Assemble); //.print(Toto);
			if(Assemble==true) {.concat(Temp1, [node(X,Y,assemble)], Temp2); +todoList(Temp2);}
			else {.concat(Temp1, [node(X,Y,buy)], Temp2); +todoList(Temp2);}
			.abolish(assemble(_));
		}
		else {
			?todoList(Temp1); .abolish(todoList(_));
			.concat(Temp1, [node(X,Y,Z)], Temp2);
			+todoList(Temp2);
		}
	    }

    }
    //?todoList(Display); .print(Display);
.   

+charge(C) : C < 100 & not .desire(charge) <- !charge.
