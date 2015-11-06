package env;

import jason.asSyntax.Atom;

import cartago.*;

public class CoordArtifact extends Artifact {

	String chosenAgent = "no_agent";

	@OPERATION
	public void init() {
		// observable properties
		defineObsProperty("running", false);
		defineObsProperty("task", "no_task");
		defineObsProperty("best_bid", Double.MAX_VALUE);
		defineObsProperty("winner", new Atom(chosenAgent));
	}

	@OPERATION
	public void start(String task) {
		if (getObsProperty("running").booleanValue())
			failed("protocol already running");
		getObsProperty("running").updateValue(true);
		getObsProperty("task").updateValue(task);
	}

	@OPERATION
	public void stop() {
		if (!getObsProperty("running").booleanValue())
			failed("protocol not running");
		getObsProperty("running").updateValue(false);
		getObsProperty("winner").updateValue(new Atom(chosenAgent));
	}

	@OPERATION
	public void bid(double bidValue) {
		if (!getObsProperty("running").booleanValue())
			failed("auction not started");

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
}
