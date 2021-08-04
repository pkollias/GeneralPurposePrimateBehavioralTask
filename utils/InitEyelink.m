function InitEyelink

%%% Task - general

%%
global specs devs

%%
devs.el = [];
if specs.Eyelink.UseEyelink,
    
    temp.BackgroundColor = [0.2 0.2 0.2];;
    temp.FixColor = [1 1 1];
    temp.EyeCalibTargetSize = 0.5;
    temp.EyeCalibNoBarColor = 255*[.9 .9 .9]; 
    temp.EyeCalibHoldColor = 255*[.8 0 0];
	temp.EyeCalibReleaseColor = 255*[1 .95 .05];
    temp.EyeCalibHoldTime = [.5 2]; %in seconds

    
    devs.el=EyelinkInitDefaults(devs.wPtr);

    devs.el.backgroundcolour = round(255*temp.BackgroundColor);
    devs.el.msgfontcolour = round(255*temp.FixColor);
    devs.el.imgtitlecolour = round(255*temp.FixColor);
    devs.el.calibrationtargetcolour= round(255*temp.FixColor);

    devs.el.calibrationtargetsize = temp.EyeCalibTargetSize;
    devs.el.calibrationtargetwidth = temp.EyeCalibTargetSize/2;

    EyelinkUpdateDefaults(devs.el);

    if ~EyelinkInit(specs.Eyelink.DummyEyelink,1),
        sca;
        Eyelink('Shutdown');
        error(sprintf('\nError(InitDevs): Couldn''t initialize Eyelink\n'));
    end

    [~,vs] = Eyelink('GetTrackerVersion');
    fprintf('Running experiment on a ''%s'' tracker\n', vs);

    Eyelink('openfile', specs.Version.EdfFilename);
    Eyelink('add_file_preamble_text', 'CapLim_PTB_Eyetracker');

    Eyelink('Command', 'screen_pixel_coords = %ld %ld %ld %ld', 0, 0, specs.Display.ScreenRect(3)-1, specs.Display.ScreenRect(4)-1);
    Eyelink('Message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, specs.Display.ScreenRect(3)-1, specs.Display.ScreenRect(4)-1);

    Eyelink('Command', 'calibration_type = HV9');
    Eyelink('Command', 'enable_automatic_calibration = NO'); 
    Eyelink('Command', 'automatic_calibration_pacing = 1000');

    Eyelink('Command', 'recording_parse_type = GAZE');
    Eyelink('Command', 'sample_rate = 2000');
    if specs.Eyelink.EyelinkUseEllipse,
        Eyelink('command', 'use_ellipse_fitter = YES');
    else
        Eyelink('command', 'use_ellipse_fitter = NO');
    end
    Eyelink('command', 'elcl_tt_power = 3');
    Eyelink('Command', 'heuristic_filter = 2');
    Eyelink('Command', 'corneal_mode = YES');
    Eyelink('Command', 'binocular_enabled = NO');
    Eyelink('Command', 'active_eye = RIGHT');
    Eyelink('Command', 'saccade_velocity_threshold = 30');
    Eyelink('Command', 'saccade_acceleration_threshold = 9500');
    Eyelink('Command', 'pupil_size_diameter = YES');

    Eyelink('Command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,FIXUPDATE');
    Eyelink('Command', 'file_sample_data  = GAZE,GAZERES,AREA,STATUS');

    Eyelink('Command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,FIXUPDATE');
    Eyelink('Command', 'link_sample_data  = GAZE,GAZERES,AREA,STATUS');
    Eyelink('Command', 'driftcorrect_cr_disable = OFF');
    Eyelink('Command', 'normal_click_dcorr = ON');

    if specs.Eyelink.RequireFixation,
        result = 0;
        while ~result,
            if strcmpi(specs.Eyelink.CalibrationMode,'nobar'),
                result = red_green_el_calib_nobar(devs.el, devs.ioObj,'ParallelPort_Address',specs.ParallelPort.Address,'HoldColor',temp.EyeCalibNoBarColor,'ReleaseColor',temp.EyeCalibNoBarColor,'HoldTime',temp.EyeCalibHoldTime);
            elseif strcmpi(specs.Eyelink.CalibrationMode,'bar'),
                result = red_green_el_calib(devs.el, devs.ioObj,'ParallelPort_Address',specs.ParallelPort.Address,'HoldColor',temp.EyeCalibHoldColor,'ReleaseColor',temp.EyeCalibReleaseColor,'HoldTime',temp.EyeCalibHoldTime);
            end
        end
        % EyelinkDoDriftCorrection(devs.el);
    end
    
    WaitSecs(0.1);
    Eyelink('StartRecording');
    specs.Eyelink.EyeUsed = Eyelink('EyeAvailable');
    if specs.Eyelink.EyeUsed == devs.el.BINOCULAR;
        specs.Eyelink.EyeUsed = devs.el.LEFT_EYE;
    end
    
end