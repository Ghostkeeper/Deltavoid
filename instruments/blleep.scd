//Bright bleep, but with a slightly slow onset.
//The title of this synthdef is not a typo. It's spelled "blleep" on purpose to describe that slightly delayed onset.

SynthDef.new("blleep", {
	/*
	Arguments:
	- base_frequency: Lowest tone of the sound.
	- amplitude: Overall loudness of the sound.
	*/
	arg base_frequency=440, amplitude=0.05;

	//Some hard-coded "parameters" or pre-calculation that you don't necessarily want to change.
	var attack = 0.005; //Very swift actual attack.
	var second_delay = 0.05; //This is the audible "delay".
	var initial_amplitude = 0.5; //As fraction of the main amplitude.
	var duration = 0.2;

	//Main waveform determining the type of sound this bleep creates.
	var wave = LFTri.ar(base_frequency, 0, 1/2) + SinOsc.ar(base_frequency * 2, 0.5, 1/3) + Blip.ar(base_frequency, 200, 1/6);

	var attack_decay_initial = EnvGen.ar(
		Env.new(
			levels: [0.01, 1, 0.01, 0.01],
			times: [attack, duration - attack, second_delay],
			curve: \exp
		)
	, timeScale: 1, doneAction: Done.freeSelf);

	var attack_decay_main = EnvGen.ar(
		Env.new(
			levels: [0.01, 0.01, 1, 0.01],
			times: [second_delay, attack, duration - attack],
			curve: \exp
		)
	, timeScale: 1, doneAction: Done.freeSelf);

	Out.ar(0, wave * initial_amplitude * attack_decay_initial + wave * attack_decay_main * amplitude);
}).add;

//Example:
Synth("blleep", ["base_frequency", 1760, "duration", 8]);