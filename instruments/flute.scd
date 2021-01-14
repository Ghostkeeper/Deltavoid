//Bright flute, good for melody and solos.

SynthDef.new("flute", {
	/*
	Arguments:
	frequency: Base note frequency.
	amplitude: Loudness of the output signal.
	*/
	arg frequency=440, amplitude=0.05;

	var signal = LFNoise0.ar(SampleRate.ir);
	signal = LPF.ar(signal, frequency * 1.1);
	signal = HPF.ar(signal, frequency * 0.9);

	Out.ar(0,
		signal
		* amplitude);

}).add;
z
Synth("flute", ["frequency", 440, "amplitude", 0.01])