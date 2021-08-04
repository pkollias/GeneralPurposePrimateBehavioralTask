if specs.Eyelink.UseEyelink,
%     red_green_el_calib_nobar(devs.el);
    WaitSecs(0.1);
    Eyelink('StartRecording');
    WaitSecs(0.3);
end