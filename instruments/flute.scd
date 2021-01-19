//Bright flute, good for melody and solos.

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

	//Start with the noise profile as baseline.
	var wind = LFNoise0.ar(SampleRate.ir);
	noise_resonators.do {
		//Repeat the same noise pattern with reverberation.
		//The delay in reverberation is precisely the duration of the frequency so that it produces the base note.
		//Has a distinct saw-wave like effect due to the sharp part of the noise being more prominent.
		var reverberation = DelayL.ar(signal, 1.0 / frequency, 1.0 / frequency, 0.5);
		reverberation = LPF.ar(reverberation, resonant_cutoff); //Dampen with maximum standing waveform.

		wind = wind + reverberation;
	};
	//Resonant filter on the reverb noise produce a brass-like effect.
	wind = Resonz.ar(wind, frequency, 0.75);

	//Combine the brass sound with an organ-like sum of sine waves to produce the flute sound.


	Out.ar(0,
		wind
		* amplitude);

}).add;

Synth("flute", ["frequency", 440, "amplitude", 0.01])