function code = StimMatrixEncode( nCues , nMappedStimPerCue , cue , stimForCue )

if ~cue,
    code = 0;
else,
    code = sub2ind([nMappedStimPerCue nCues],stimForCue,cue);
end