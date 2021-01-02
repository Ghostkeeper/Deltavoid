//Set-up for my Ubuntu environment.
s.options.outDevice = "hw:Generic";
s.options.inDevice = "hw:Generic";
"SC_JACK_DEFAULT_OUTPUTS".setenv("system");
s.boot;
s.quit;