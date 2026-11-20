# Lab 2A TS60 report - Group A

**Students:** Diego Marzá Fuertes; Mario López Honrubia; Ismael Bentaleb Ezuitni; Antonio Jose Sandoval Hurtado.

## Tasks

- [x] L3 version demonstrated on the real robot.
- [ ] L1/L2 code simplification
- [ ] L1/L2 code additional review + check if works in simulation + record results + add to report?
- [ ] Add real-execution video to report

- [ ] Lab Report
    1. Task Description – e.g., “Pick part from A, place in B.”
    2. Program Breakdown – Motion sequence (MoveJ, MoveL, etc.), I/O 
    operations, waits + Flow diagram or pseudocode
    3. Parameters Used – Speeds, tool frames, payload.
    4. Safety Considerations – Collisions avoided, safe home position.
    5. Execution Results – Did the sequence complete? Cycle time?
    6. Improvements – how would you improve or optimize the task.

- [ ] Review Lab Report. Add full code?? Check links, layouts...

## Report Compilation

Run `./compile.ps1` from this folder. Output: `main.pdf`, alongside `main.tex`. Code sections contain placeholders until the applications are finished.

## Sources and requirements

- `../../Lab 1 Introduction/Robotics manipulation-class1.pdf`, PDF pp. 9-10: simulation video, real-execution video, report and code. Report sections: task, program/flowchart, parameters, safety, results and improvements.
- `../lesson2a.pdf`, PDF pp. 9-11: Level 1 = one part per ramp; Level 2 = four per ramp; Level 3 = automatic feeding and material classification. Assessment covers performance, tools/frames, MCP messages, code structure and report presentation. Videos are requested for each developed performance.
- Previously supplied Moodle instructions: include all names, video links with students visible, program listings and detailed variable explanations in the PDF. GitHub alone does not replace these. One student may submit for the group; check video access. Current Moodle wording remains to be checked.

## Code and videos

Applications: `../sim_ts60/Entorn_TS60/Controller-TS60/usr/usrapp/`.

- **L1 (`Lab2A_L1`):** two destinations indexed 0 and 1; original physical poses preserved.
- **L2 (`Lab2A_L2`):** four parts per material, alternating ramps, to slots 0-3 and 4-7.
- **L3 (`Lab2A_L3`):** Ismael's separate automatic-classification version.
- **Previous L3 (`Lab2A_new`):** our earlier version.

[Simulation video](https://ugirona-my.sharepoint.com/:v:/g/personal/u6120632_udg_edu/IQCCHUXZbpDZQJx1GxVThgnPAUpKyrIblhpKYQN-_18FjhU?e=oOMlbG); level 3.
