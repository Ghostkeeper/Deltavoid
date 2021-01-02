//Ominous bass background drone sound.
//This is a slow, dark sound that fills the bass register in slower tracks.
//It has a very slow onset and features multiple harmonics.

SynthDef.new("drone", {
	/*
	Arguments:
	- base_frequency: Lowest tone of the sound.
	- amplitude: Overall loudness of the sound.
	- duration: How long the sound goes on. It'll have faded to 0 by the end.
	*/
	arg base_frequency=110, amplitude=0.05, duration=5;

	//Some hard-coded "parameters" or pre-calculation that you don't necessarily want to change.
	var attack = min(1, duration / 2); //Attack duration in seconds. If the duration is 2 seconds or less, there is no sustain.
	var decay = min(1, duration / 2); //Decay duration in seconds.
	var sustain = duration - attack - decay;

	//Define an envelope for the main attack and decay.
	var attack_decay = EnvGen.ar(
		Env.linen(attack, sustain, decay)
	, timeScale: 1, doneAction: Done.freeSelf);

	//The base note, low and loud.
	var base_note = SinOsc.ar(base_frequency, 0, amplitude);
	var wobble = SinOsc.ar(1, mul: 0.05, add: 0.95); //Wobble the volume slowly and subtly.
	base_note = base_note * wobble;

	Out.ar(0, base_note * attack_decay);
}).add;

var test = Synth("drone", ["base_frequency", 110, "duration", 10]);