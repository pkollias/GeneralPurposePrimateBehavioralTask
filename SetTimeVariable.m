function VarTime = SetTimeVariable( varargin )

%%% Task - general

%%% more timing parameters

%%
if nargin == 1,
    
    OptTime = varargin{1};
    
elseif nargin > 1,
    
    tvar = varargin{1};
    if isfield(tvar,'Type'),
        if strcmpi(tvar.Type,'incrbound'),
            OptTime = SetIncrBoundVariable(sum(varargin{2}),tvar.InitTime,tvar.Increments,tvar.IncrStep,tvar.BoundTime);
        end
    else,
        OptTime = tvar;
    end

end


if length(OptTime) == 1,
    VarTime = OptTime;
elseif length(OptTime) == 2,
    VarTime = randi([OptTime(1) OptTime(2)], 1, 1);
elseif length(OptTime) == 4,
    VarTime = max(min(OptTime(3) + OptTime(4).*randn, OptTime(2)), OptTime(1));
end