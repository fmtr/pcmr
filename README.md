# Power Configuration for Multiple Relays

This is a Tasmota Berry Script library (so requires Tasmota32) for working around Tasmota lacking per-relay calibration
when using pseudo power monitoring (`OptionA 2`).

```be
import pcmr

...
```

## Pre-Release

:warning: This library is currently in a pre-release state. The configuration format (and perhaps even the library name)
is likely to change.

## Installing

Simply paste the following into your Tasmota Berry Script Console:

```be
tasmota.urlfetch('https://raw.githubusercontent.com/fmtr/pcmr/v0.0.3/pcmr.be','/pcmr.be')
```

Alternatively, manually download [pcmr.be](https://raw.githubusercontent.com/fmtr/pcmr/v0.0.3/pcmr.be) and upload it
onto
your device.
