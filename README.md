# GeneralPurposePrimateBehavioralTask

Run a single session by running:
>>> function [ varargout ] = RunSession ( task , animal )
on command terminal. This will run an experimental session and will return the animal performance, task cache and output files.
Debugging mode is enabled at the end of every trial. You can correct the variables and resume running allowing smooth animal training.

The task is toggled here to be 'Gating'.
The main task structure assumes a series of trials format. In every trial there is a sequence of events defined as screen changes and a series of behavioral events (motor output, eye tracking, voice commands etc). Every trial yields a stop condition code and optionally triggers a reward.

TO BE DOCUMENTED:
Robust reward scheduling
Probabilistic vs deterministic programming of condition sequencing
Slack/email alerts for session behavioral progress or events
Behavioral performance GUI, options for stop, pause, resume, manual reward
Cache/output/Blackrock interface/...
