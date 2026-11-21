# Lab 2A - Level 2

Open `Lab2A_L2.pjx` from this folder. Load four parts in each ramp and empty the destinations before starting.

- `simulation=true`: manual sensor simulation. Set `partOnTool=true` at step 60 and `false` at step 70 for each part.
- `simulation=false`: real suction sensor and outputs (`bIn0`, `bOut0`, `bOut1`). The saved mode remains physical; choose the mode before starting.
- Placement uses eight destinations indexed 0-7, generated from taught references 0 and 4. Taught joint values, TCP and motion settings are preserved.
- `start` selects the ramp and destination; `pickAndPlace` performs the movement. `physicalIO` handles the suction tool; `stop` preserves suction and turns off blow-off.

No conveyor, barrier, material detector or diverter control is included. Configure the station for ramp loading before running. Sensor waits have no timeout.

Pending: reload the whole application, run Check Syntax and check trajectories and grip/release in SRS before physical trials.
