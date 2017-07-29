---
title: What might the future of 3D printing software look like?
tags: 3d-printing
date: 2014-07-03
---
*I guest-wrote this post for my friends at [3Dagogo](http://blog.3dagogo.com/the-3d-printing-market/might-future-3d-printing-software-look-like/). A hearty congratulations on their successful [Kickstarter](https://www.kickstarter.com/projects/306530051/astroprinttm-wireless-3d-printing-software)!*

Eight years after the launch of RepRap and Fab@Home, 3D printing has reached the crescendo of hype. If declining stock prices of the 3D printing “bluechips”–namely Stratasys and 3D Systems–are any indication, January 2014 was the peak of inflated expectations; the industry now heads toward the trough of disillusionment. Only progress in software can drive the industry to the plateau of productivity.

Several of the promises, or laws, of 3D printing are idyllic in nature. For example, take efficiency: “3D printers use the precise amount of material necessary to make a part and no more.” Proponents contrast this to subtractive manufacturing, where a block of material cut away and wasted. Yet many printing technologies require support material, giving you a block of material that must be cut away and wasted. Yet even this waste pales to 3D printing’s dirty little secret: prints frequently fail.

Prints fail for all kinds of reasons: high humidity, bubbles in filament, uneven powder spread, lens occlusion, lens misalignment, clogged nozzle, xy drift, bed misalignment, filament grinding, insufficient material, dull razors, curling, over/under extrusion/exposure/depostion, drooping…. Of course, parts with improper designs may also fail post-print, but that’s the whole point of rapid prototyping!

Fortunately, many of these failures can be mitigated with smart software. Many consumer printers and most industrial printers already detect when material runs low, and pause for a change in material. This is only a rudimentary beginning: in the future, printers will automatically mitigate a wide range of partial failures.

How might this look on a desktop FDM printer? After auto calibrating the bed, the printer begins to lay down the first layer. By processing optical data, a computer recognizes that the machine is under-extruding. The extrusion rate is dynamically changed, and the computer directs the printer to deposit extra material at sites affected by the under-extrusion. Later in the print, an air bubble reaches the extruder from the filament. The computer detects that filament is still moving, ruling out grinding or clogging, and slows nozzle velocity until extrusion returns.

Later, the nozzle slips a few steps in the x-direction due to a loose belt and a particularly violent jerk (sadly this printer is not using a zero jerk board like the Tiny-G.) The computer recognizes this drift and corrects it, compensating dynamically if need be. When plastic builds up around the nozzle, the head moves towards a brush on the edge of the print bed, and scrapes off the goo. Finally, near the top of the part, the printer is stringing between two columns. The computer cools the nozzle by 5 degrees and adjusts the retraction rate, and fixes the issue for subsequent layers.

Software that streams static gcode is just the beginning. Software can enable these flexible manufacturing devices to adjust print parameters on-the-fly and self-correct under-extrusion for superior near-net-shape. Put technically, rather than generating gcode per-object, software will enable computers to generate gcode per-layer or even in real-time.  The future of 3D printing software will make producing an object as easy as downloading a file. Only then can the technology match expectations.
