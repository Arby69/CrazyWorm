# Crazy Worm
Amstrad CPC Game "Crazy Worm" created in 1989 and slightly modified in 1994

It was fully written in Z80 Assembler and was comiled with the BASIC written "Kio Fox Assembler" from a german CPC magazine.
The binaries were originally loaded afterwards into memory and then the whole bunch was saved to disk. With the help of WinApe I was able to save all those binaries from an available DSK file and modify the assembler source so that the project will compile and run(!) with the WinApe Assembler.

For assembling convenience, just load "start.asm" into the WinApe Assembler and the hit Ctrl+F9 (to compile) or F9 (to compile and run!).

The run command has set a break point directly at the entry point (decimal 25000, hex #61A8).
