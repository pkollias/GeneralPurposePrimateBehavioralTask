# GeneralPurposePrimateBehavioralTask

Code for running cognitive behavioral experiments (specialized for non-human primate neurophysiology)
You can create a single session specialized to a specific task by running the command
> function [ varargout ] = RunSession ( task , animal )

on command terminal. This will return the animal performance, task cache and output files, when the session is completed.

The following task structures are used throughout the code:
* specs: set of parameters that are meant to remain constant throughout the session
* devs: set of hardware and IO parameters (parallel port, keyboard, mouse, email interface, recording rig)
* opts: set of task design parameters, user can change those directly during task or can schedule adaptive changes
* funcOpts: set of parameters that are defined as functions of opts. Change in opts automatically re-evaluates all funcOpts parameters
* optsHistory: keeps track of every update in opts and funcOpts for reconstructing trial by trial parameters
* stats: aggregate statistics of task performance for easy visualization
* files: file information and content for files loaded and meant to be saved on hard disk (images, sounds)
* trials: trial vector where each entry contains full information for each trial. Session assumes that task consists of a sequence of trials
* eyes: high-precision eye tracking data following similar format as trials structure
* cache: cache consists of the tasks current sketchpad. It contains a collection of vectors of length t, where t is current trial, containing easy access to a single parameter's history. Second component of cache is the active memory of values that are important for moment to moment scheduling decisions
* figures: figure handles and parameters

An experimental session consists of an initialization of these structures and a loop of single trials following the following general format (loop begins at the end of previous, if it exists, trial):
1. Evaluate previous trial outcome
2. begin ITI interval timing
3. Evaluate reward
4. read/write files to hard drive
5. update cache and stats
7. append last trial and eye signal
8. [write single trial on hard disk for later retrieval in case of crush]
9. evaluate pause requests for pausing task
10. if task is not finished
11. update opts and funcopts
12. initialize stats, cache, files for next trial
13. wait rest of ITI interval
14. execute trial

Trials:
A trial is operationalized as a sequence of several stages, where each stage is defined as a single screen configuration. For example in gating task a trial is a sequence of variable length where a cue and then a random number of stimuli appear with delays in between. Each of these is defined as a separate stage. Stages can be associated with expected or required behavioral actions (for now coded, joystick hold/release, fixation hold/release, saccade acquire). TrialStagesExecute codes for that sequence of stages.

Generally each stage has a free form but the following is a good template
1. initilize relevant code params
2. load visual stimuli using ObjectListAdd and visualize using ObjectListDisplay
3. initiliaze behavioral action expectations and timings and wait for behavioral triggers
4. evaluate behavioral actions
5. housekeeping of relevant code params

TO BE DOCUMENTED:
Robust reward scheduling
Probabilistic vs deterministic programming of condition sequencing
Bias correcting options
Slack/email alerts for session behavioral progress or events
Behavioral performance GUI, options for stop, pause, resume, manual reward
Device [blackrock/eyelink] interfaces 

**GUI Example**
![MrPiggy_180528_00_bhv_ERROR](https://user-images.githubusercontent.com/4206199/132777918-da7381f7-e1d5-4430-bad2-aed57cda008c.jpeg)
