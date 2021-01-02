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

	//Define an envelope for the main attack and decay.
	var attack_decay = EnvGen.ar(
		Env.linen(1, 1, 1)
	, timeScale:duration / 3, doneAction: Done.freeSelf);

	var base_note;
	base_note = SinOsc.ar(base_frequency, 0, amplitude);
	Out.ar(0, base_note * attack_decay);
}).add;

var test = Synth("drone", ["base_frequency", 110, "duration", 3]);