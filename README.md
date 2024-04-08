The backlit Macintosh Portable models (both M5126 and M5120 with the upgrade installed) added backlight hardware without changing the ROM, so the backlight functionality had to be added by the operating system.

This was done with version 1.3 of the Portable cdev/Control Panel.

This also included a patch to the SndWatch function to always keep sound power turned on, though in the method this was implemented it clears the sound latch every 10 seconds regardless of whether the sound was already on or not.

## Build Instructions

Use an assembler such as vasm to generate the machine code:
```
vasmm68k_mot -Fbin -o SndWatchPatchOriginal.ptch -nosym SndWatchPatchOriginal.s -sc -showopt
vasmm68k_mot -Fbin -o SndWatchPatchFixed.ptch -nosym SndWatchPatchFixed.s -sc -showopt
```

Replace the machine code in PTCH ID 3 of the Portable Control Panel 1.3 using ResEdit or Resourcer.
