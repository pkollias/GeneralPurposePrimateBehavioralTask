function funcOpts = InitFuncOpts( opts )

%%% Task - specific

%%
global specs

%% Initialize
funcOpts = [];



%% Display
funcOpts.Display.DVAToCM = @(a) tan(a)*opts.Display.ScreenDist;
funcOpts.Display.CMToDVA = @(x) atan(x/opts.Display.ScreenDist);
funcOpts.Display.DVAToPIX = @(a,res) tan(a)*opts.Display.ScreenDist*res;
funcOpts.Display.PIXToDVA = @(x,res) atan(x/opts.Display.ScreenDist/res);

funcOpts.Display.Rect.Temp = @(radius) [[specs.Display.ScreenCenter(:); specs.Display.ScreenCenter(:)] + [-specs.Display.ScreenHorizRes; -specs.Display.ScreenVertRes; specs.Display.ScreenHorizRes; specs.Display.ScreenVertRes]*funcOpts.Display.DVAToCM(radius)]';
funcOpts.Display.Rect.Rect = @(temprect,loc) CenterRectOnPoint(temprect, specs.Display.ScreenCenter(1) + specs.Display.ScreenHorizRes.*funcOpts.Display.DVAToCM(loc(1)+opts.Display.DisplayOffset(1)), specs.Display.ScreenCenter(2) + specs.Display.ScreenVertRes.*funcOpts.Display.DVAToCM(loc(2)+opts.Display.DisplayOffset(2)));
funcOpts.Display.Rect.Rect_x = @(temprect,loc) round(sum(funcOpts.Display.Rect.Rect(temprect,loc) .* [1 0 1 0]))/2;
funcOpts.Display.Rect.Rect_y = @(temprect,loc) round(sum(funcOpts.Display.Rect.Rect(temprect,loc) .* [0 1 0 1]))/2;

funcOpts.Display.FixRect.Temp = funcOpts.Display.Rect.Temp(opts.Display.FixRadius);
funcOpts.Display.CueRect.Temp = funcOpts.Display.Rect.Temp(opts.Display.CueEdge/2);
funcOpts.Display.StimRect.Temp = funcOpts.Display.Rect.Temp(opts.Display.StimEdge/2);
funcOpts.Display.FrameRect.Temp = funcOpts.Display.Rect.Temp(opts.Display.FrameEdge/2);
funcOpts.Display.PeripheralRect.Temp = funcOpts.Display.Rect.Temp(opts.Display.PeripheralEdge/2);

funcOpts.Display.FixRect.Rect = funcOpts.Display.Rect.Rect(funcOpts.Display.FixRect.Temp,opts.Display.FixLocation);
funcOpts.Display.FixRect.Rect_x = funcOpts.Display.Rect.Rect_x(funcOpts.Display.FixRect.Temp,opts.Display.FixLocation);
funcOpts.Display.FixRect.Rect_y = funcOpts.Display.Rect.Rect_y(funcOpts.Display.FixRect.Temp,opts.Display.FixLocation);
funcOpts.Display.CueRect.Rect = funcOpts.Display.Rect.Rect(funcOpts.Display.CueRect.Temp,opts.Display.CueLocation);
funcOpts.Display.CueRect.Rect_x = funcOpts.Display.Rect.Rect_x(funcOpts.Display.CueRect.Temp,opts.Display.CueLocation);
funcOpts.Display.CueRect.Rect_y = funcOpts.Display.Rect.Rect_y(funcOpts.Display.CueRect.Temp,opts.Display.CueLocation);
funcOpts.Display.StimRect.Rect = funcOpts.Display.Rect.Rect(funcOpts.Display.StimRect.Temp,opts.Display.StimLocation);
funcOpts.Display.StimRect.Rect_x = funcOpts.Display.Rect.Rect_x(funcOpts.Display.StimRect.Temp,opts.Display.StimLocation);
funcOpts.Display.StimRect.Rect_y = funcOpts.Display.Rect.Rect_y(funcOpts.Display.StimRect.Temp,opts.Display.StimLocation);
funcOpts.Display.FrameRect.Rect = funcOpts.Display.Rect.Rect(funcOpts.Display.FrameRect.Temp,opts.Display.StimLocation);
funcOpts.Display.FrameRect.Rect_x = funcOpts.Display.Rect.Rect_x(funcOpts.Display.FrameRect.Temp,opts.Display.StimLocation);
funcOpts.Display.FrameRect.Rect_y = funcOpts.Display.Rect.Rect_y(funcOpts.Display.FrameRect.Temp,opts.Display.StimLocation);
funcOpts.Display.PeripheralRect.Rect = funcOpts.Display.Rect.Rect(funcOpts.Display.PeripheralRect.Temp,opts.Display.StimLocation);
funcOpts.Display.PeripheralRect.Rect_x = funcOpts.Display.Rect.Rect_x(funcOpts.Display.PeripheralRect.Temp,opts.Display.StimLocation);
funcOpts.Display.PeripheralRect.Rect_y = funcOpts.Display.Rect.Rect_y(funcOpts.Display.PeripheralRect.Temp,opts.Display.StimLocation);

funcOpts.Display.RadiusToPixels = @(radius) [specs.Display.ScreenHorizRes; specs.Display.ScreenVertRes].*funcOpts.Display.DVAToCM(radius);

photonx = (specs.Display.ScreenRect(3)-opts.Display.Photon.Edge(1))*opts.Display.Photon.RectPerc(1);
photony = (specs.Display.ScreenRect(4)-opts.Display.Photon.Edge(2))*opts.Display.Photon.RectPerc(2);
funcOpts.Display.Photon.Rect = [photonx photony photonx+opts.Display.Photon.Edge(1) photony+opts.Display.Photon.Edge(2)];