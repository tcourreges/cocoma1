package env;

import jason.asSyntax.Atom;

import cartago.*;

public class CoordArtifact extends Artifact {

	String chosenAgent = "no_agent";
	String king = "no_agent";

	@OPERATION
	public void init() {
		// observable properties
		defineObsProperty("running", false);
		defineObsProperty("task", "no_task");
		defineObsProperty("best_bid", Double.MAX_VALUE);
		defineObsProperty("index", 0);
		defineObsProperty("answer_count", 0);
		defineObsProperty("winner", new Atom(chosenAgent));
		defineObsProperty("king", new Atom(king));
	}

	@OPERATION
	public void start(String task, int ind) {
		if (getObsProperty("running").booleanValue())
			failed("protocol already running");
		getObsProperty("index").updateValue(ind+1);
		getObsProperty("running").updateValue(true);
		getObsProperty("task").updateValue(task);
		getObsProperty("answer_count").updateValue(0);
	}

	@OPERATION
	public void stop() {
		if (!getObsProperty("running").booleanValue())
			failed("protocol not running");
		getObsProperty("running").updateValue(false);
		getObsProperty("winner").updateValue(new Atom(chosenAgent));
	}

	@OPERATION
	public void bid(double bidValue, int count) {
		if (!getObsProperty("running").booleanValue())
			failed("auction not started");

		getObsProperty("answer_count").updateValue(count+1);
		
		ObsProperty opCurrentValue = getObsProperty("best_bid");
		if (bidValue < opCurrentValue.doubleValue()) { // the bid is better than
														// the previous
			opCurrentValue.updateValue(bidValue);
			chosenAgent = getOpUserName(); // the name of the agent doing this
											// operation
		}
		System.out.println("Received bid " + bidValue + " from "
				+ getOpUserName());
		
	}
	
	@OPERATION
	public void transmitInformation(String string) {
		System.out.println(string);
	}
	
	@OPERATION
	public void askPermission(){
		if (king.equals("no_agent")){
			king = getOpUserName();
		}
		getObsProperty("king").updateValue(new Atom(king));
	}
	
	@OPERATION
	public void releasePermission(){
		king = "no_agent";
	}
}
