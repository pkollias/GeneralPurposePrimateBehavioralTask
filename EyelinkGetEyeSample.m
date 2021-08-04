function [mx, my, varargout] = EyelinkGetEyeSample(el, eye_used)

mx = NaN; my = NaN; Tms = NaN; pup = NaN;

evt = Eyelink('NewestFloatSample');
if eye_used ~= -1,

    x = evt.gx(eye_used+1);
    y = evt.gy(eye_used+1);
    Tms = evt.time;
    pup = evt.pa(eye_used+1);

    if x~=el.MISSING_DATA && y~=el.MISSING_DATA && pup>0
        mx=x;
        my=y;
    end
end
if nargout >= 3,
    varargout{1} = Tms;
end
if nargout >= 4,
    varargout{2} = pup;
end