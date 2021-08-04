function [ cue , stimForCue ] = StimMatrixDecode( nCues , nMappedStimPerCue , code )

[stimForCue,cue] = ind2sub([nMappedStimPerCue nCues],code);
