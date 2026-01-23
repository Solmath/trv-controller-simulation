# Simulation model for TRV controllers

Requires Matlab R2025b.

Run `run_simulation.m` to get step responses for multiple controller parameters.

## Controllers

Use the manual switches in the mode `heating.slx` to switch between an implementation with the Simulink `PID controller` block and a manual implementation. Both implementations use the same parameters `Kp` and `Ki` from the workspace.

There is a dead zone of +-1K to prevent valve operations and thus conserver energy while the temperature is close to the target.

In the manual controller it's possible to activate the integral part only if the temperature error is below a threshold.
