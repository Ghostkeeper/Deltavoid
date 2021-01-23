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
	var noise_resonators = 6; //How often the noise profile is resonating.
	var resonant_cutoff = 2000; //Waveform collapses in flute above this frequency due to width of the tube not being able to sustain those frequencies.
	var num_undertones = 0; //The salient frequency is the highest of the constant-amplitude waves, and will be set to frequency. Add a number of octaves below it with equal amplitude.
	var num_overtones = 3; //Overtones decay in amplitude.

	//Variables we'll need later.
	var tone;

	//Start with the noise profile as baseline.
	var wind = LFNoise0.ar(SampleRate.ir);
	noise_resonators.do {
		//Repeat the same noise pattern with reverberation.
		//The delay in reverberation is precisely the duration of the frequency so that it produces the base note.
		//Has a distinct saw-wave like effect due to the sharp part of the noise being more prominent.
		var reverberation = DelayL.ar(wind, 1 / frequency / 32, 1 / frequency / 32, 0.5);
		reverberation = LPF.ar(reverberation, resonant_cutoff); //Dampen with maximum standing waveform.
		reverberation = HPF.ar(reverberation, frequency);

		wind = wind + reverberation;
	};
	//Resonant filter on the reverb noise produce a brass-like effect.
	wind = Resonz.ar(wind, frequency, 0.75);

	//Combine the brass sound with a frequency-modulated base tone that makes the basic "dry" sound of the flute.
	tone = SinOsc.ar(frequency + LFTri.ar(SinOsc.kr(6, 0, 1, frequency), 0, frequency))
	     + SinOsc.ar(frequency * 1.5 + LFTri.ar(SinOsc.kr(6.5, 0, 1, frequency), 1/4, frequency))
	     / 2;

	Out.ar(0,
		wind * 0.1
		+ tone
		* amplitude);

}).add;
)

Synth("flute", ["frequency", 72.midicps, "amplitude", 0.1])