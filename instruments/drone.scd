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
	var num_overtones = 2;

	//Define an envelope for the main attack and decay.
	var attack_decay = EnvGen.ar(
		Env.linen(attack, sustain, decay)
	, timeScale: 1, doneAction: Done.freeSelf);

	//The base note, low and loud.
	var base_note = LFCub.ar(base_frequency, 0, 2 / 3);
	var wobble = SinOsc.ar(2, mul: 0.1, add: 0.9); //Wobble the volume slowly and subtly.
	var timbre = VarSaw.ar(base_frequency / 2, 0, 0.5, 1 / 6);
	timbre = timbre + VarSaw.ar(base_frequency / 2, 0.2, 0.5, 1 / 6);
	base_note = base_note + timbre * wobble;

	//Several overtones at octaves.
	num_overtones.do {
		arg octave;
		var frequency_multiplier = 2 ** (octave + 1);
		base_note = base_note + LFPar.ar(base_frequency * frequency_multiplier, 1 / frequency_multiplier, 0.1 / frequency_multiplier);
		base_note = base_note + LFPar.ar(base_frequency * frequency_multiplier * 1.5, 0, 0.05 / frequency_multiplier); //Add a perfect fifth.
	};

	Out.ar(0, base_note * attack_decay * amplitude);
}).add;

var test = Synth("drone", ["base_frequency", 110, "duration", 3]);