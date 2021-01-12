//Bright electronic bleep, but with a slightly slow onset.
//The title of this synthdef is not a typo. It's spelled "blleep" on purpose to describe that slightly delayed onset.

SynthDef.new("blleep", {
	/*
	Arguments:
	- base_frequency: Lowest tone of the sound.
	- amplitude: Overall loudness of the sound.
	*/
	arg frequency=440, amplitude=0.05;

	//Some hard-coded "parameters" or pre-calculation that you don't necessarily want to change.
	var attack = 0.005; //Very swift actual attack.
	var second_delay = 0.03; //This is the audible "delay".
	var initial_amplitude = 0.2; //As fraction of the main amplitude.
	var duration = 0.1;

	//Main waveform determining the type of sound this bleep creates.
	var wave = SinOsc.ar(frequency / 2, 0, 2/10)
	+ SinOsc.ar(frequency, 0.5, 5/10)
	+ SinOsc.ar(frequency * 0.6, 0, 1/10)
	+ SinOsc.ar(frequency * 1.2, 0, 1/10)
	+ Blip.ar(frequency, 100, 1/10);
	var overtone = SinOsc.ar(frequency * 2, 0, 0.5);

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
			curve: \sin
		)
	, timeScale: 1, doneAction: Done.freeSelf);

	var attack_decay_overtone = EnvGen.ar(
		Env.new(
			levels: [0.01, 0.01, 1, 0.01, 0.01],
			times: [second_delay, attack, duration / 2 - attack, duration /2],
			curve: 20
		)
	, timeScale: 1, doneAction: Done.freeSelf);

	Out.ar(0,
		(wave * initial_amplitude * attack_decay_initial)
		+ (wave * attack_decay_main)
		+ (overtone * attack_decay_overtone)
		* amplitude);
}).add;

//Example:
Synth("blleep", ["frequency", 1760, "duration", 8]);