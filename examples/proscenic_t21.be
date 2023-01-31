# To use this code, add it to your `autoexec.be` - or upload this script to your device and add `load("/proscenic_t21.be")`.

#First we import this library.

import pcmr

log("Setting up Proscenic T21 Power Configuration...")

# Now we write a callback to determine when the fryer is drawing high power (i.e. cooking).

def is_cooking(pc)
    var powers=tasmota.get_power()
    return powers[1] && !powers[3] # Cooking is running and Delayed Start is not enabled.
end

pc=pcmr.PowerConfigurator(4.0*1000, 960.0, is_cooking)