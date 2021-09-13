# GeneralPurposePrimateBehavioralTask

Code for running cognitive behavioral experiments (specialized for non-human primate neurophysiology)
You can create a single session specialized to a specific task by running the command
> function [ varargout ] = RunSession ( task , animal )

on command terminal. This will return the animal performance, task cache and output files, when the session is completed.

Debugging mode is enabled at the end of every trial. You can correct the variables and resume running allowing smooth animal training.

The task files are set for the 'Gating' task.
The main task structure assumes a series of trials format. In every trial there is a sequence of events defined as screen changes and a series of behavioral events (motor output, eye tracking, voice commands etc). Every trial yields a stop condition code and optionally triggers a reward.

![Uploading MrPiggy_180528_00_bhv_ERROR.jpeg…]()

TO BE DOCUMENTED:
Robust reward scheduling
Probabilistic vs deterministic programming of condition sequencing
Slack/email alerts for session behavioral progress or events
Behavioral performance GUI, options for stop, pause, resume, manual reward
Cache/output/Blackrock interface/...

![MrPiggy_180528_00_bhv_ERROR](https://user-images.githubusercontent.com/4206199/132777918-da7381f7-e1d5-4430-bad2-aed57cda008c.jpeg)
