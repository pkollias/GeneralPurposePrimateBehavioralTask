function ObjectListDisplay

%%% Task - general

%%
global specs devs opts funcOpts cache

[~,order] = sort([cache.display.Object.List(:).Priority]);

%% Display items
for i=order,
    
    params = cache.display.Object.List(i).Parameters;
    if strcmpi(cache.display.Object.List(i).Type,'Back'),
        Screen('FillRect', devs.wPtr,params{1});
    elseif strcmpi(cache.display.Object.List(i).Type,'Rect'),
        Screen('FillRect', devs.wPtr,params{1},params{2});
    elseif strcmpi(cache.display.Object.List(i).Type,'Oval'),
        Screen('FillOval', devs.wPtr,params{1},params{2});
    elseif strcmpi(cache.display.Object.List(i).Type,'Texture'),
        Screen('DrawTexture',devs.wPtr,params{1},[],params{2});
	elseif strcmpi(cache.display.Object.List(i).Type,'FillArc'),
        Screen('FillArc',devs.wPtr,params{1},params{2},params{3},params{4});
    end
    
end

% cache.Photon = ~cache.Photon;
if specs.Display.UsePhoton & cache.Photon,
    Screen('FillRect', devs.wPtr,floor(opts.Display.Photon.Color*specs.Display.White),funcOpts.Display.Photon.Rect);
end




%% Flip screen
stage = cache.trial.Behavior.StageNo;
[cache.trial.Timing.StageTime(stage).VBL,cache.trial.Timing.StageTime(stage).Onset] = Screen('Flip',devs.wPtr);
    


%% Display trigger
stagename = cache.trial.Behavior.BehStruct(end).StageName;
DisplayTrigger(specs.Eyelink.UseEyelink,specs.Display.ScreenDelay,specs.Encodes.(stagename),stagename);



%% Display eyelink
if specs.Eyelink.UseEyelink,
    Eyelink('command','clear_screen 0');
    for i=order,

        params = cache.display.Object.List(i).Parameters;
        if any(strcmpi(cache.display.Object.List(i).Type,{'Oval' 'Rect' 'Texture' 'EyeOval' 'EyeRect' 'EyeTexture'})),
            Eyelink('command',sprintf('draw_box %.0f %.0f %.0f %.0f 15',params{end}));
		elseif any(strcmpi(cache.display.Object.List(i).Type,{'FillArc' 'EyeFillArc'})),
            Eyelink('command',sprintf('draw_box %.0f %.0f %.0f %.0f 15',params{2}));
			c_x = (params{2}(3) + params{2}(1))/2; c_y = (params{2}(4) + params{2}(2))/2;
			a = (params{2}(3) - params{2}(1))/2; b = (params{2}(4) - params{2}(2))/2;
			x_s = c_x + a*sin(params{3}/180*pi); y_s = c_y + b*cos(params{3}/180*pi);
			x_e = c_x + a*sin((params{3}+params{4})/180*pi); y_e = c_y + b*cos((params{3}+params{4})/180*pi);
			Eyelink('command',sprintf('draw_line %.0f %.0f %.0f %.0f 15', c_x, c_y, x_s, y_s));			
			Eyelink('command',sprintf('draw_line %.0f %.0f %.0f %.0f 15', c_x, c_y, x_e, y_e));
			Eyelink('command',sprintf('draw_line %.0f %.0f %.0f %.0f 15', x_s, y_s, x_e, y_e));			
        elseif strcmpi(cache.display.Object.List(i).Type,'EyeText'),
            Eyelink('command',sprintf('draw_text %.0f %.0f 15 %.1f',params{1},params{2}));
        elseif strcmpi(cache.display.Object.List(i).Type,'EyePoint'),
            Eyelink('command',sprintf('draw_cross %.0f %.0f',params{1}));
        end

    end
end