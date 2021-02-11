//Bright flute, good for melody and solos.
(
SynthDef.new("flute", {
	/*
	Arguments:
	frequency: Base note frequency.
	amplitude: Loudness of the output signal.
	*/
	arg frequency=440, amplitude=0.05;

	//Less important parameters to tune the sound to actually make it sound like a flute.
	var resonant_cutoff = 2000; //Waveform collapses in flute above this frequency due to width of the tube not being able to sustain those frequencies.
	var num_overtones = 2;

	//Variables we'll need later.
	var tone;

	//Start with the noise profile as baseline.
	var wind = LFClipNoise.ar(SampleRate.ir);
	//Resonant filter on the noise produce a brass-like effect.
	wind = Resonz.ar(wind, frequency, 0.75);

	//Combine the brass sound with a frequency-modulated base tone that makes the basic "dry" sound of the flute.
	tone = SinOsc.ar(frequency + LFTri.ar(SinOsc.kr(6, 0, 1, frequency * 4), 0, frequency / 2));
	num_overtones.do {
		arg overtone_index;
		var overtone_multiplier = 2 ** overtone_index;

		tone = tone + SinOsc.ar(frequency * overtone_multiplier + LFTri.ar(SinOsc.kr(6.5, 0, 1, frequency * 4), 1 / overtone_multiplier, frequency / 2));
	};
	tone = tone / (1 + num_overtones);

	Out.ar(0,
		wind * 0.1
		+ tone
		* amplitude);

}).add;
)

Synth("flute", ["frequency", 72.midicps, "amplitude", 0.1])