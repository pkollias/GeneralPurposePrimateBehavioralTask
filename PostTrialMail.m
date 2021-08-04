function PostTrialMail

global opts cache

if cache.TrialNo > opts.Behavior.IdleTrialsWindow+1 & ...
        all(ismember(cache.lists.StopCondition(end-opts.Behavior.IdleTrialsWindow+1:end),opts.Behavior.StopConditionIdle)) & ...
        ~ismember(cache.lists.StopCondition(end-opts.Behavior.IdleTrialsWindow),opts.Behavior.StopConditionIdle),
    MailAdd(sprintf('Idle for the last %d trials',opts.Behavior.IdleTrialsWindow),NaN,'h');
end

if cache.TrialNo > opts.Behavior.IdleTrialsWindow+1 & ...
        all(ismember(cache.lists.StopCondition(end-opts.Behavior.IdleTrialsWindow:end-1),opts.Behavior.StopConditionIdle)) & ...
        ~ismember(cache.lists.StopCondition(end),opts.Behavior.StopConditionIdle),
    MailAdd(sprintf('Restarted working'),NaN,'h');
end

temp.incorrThreshold = 25;
if cache.TrialNo > temp.incorrThreshold+1 & ...
        all(ismember(cache.lists.StopCondition(end-temp.incorrThreshold+1:end),opts.Behavior.StopConditionIncorrect)) & ...
        ~ismember(cache.lists.StopCondition(end-temp.incorrThreshold),opts.Behavior.StopConditionIncorrect),
    MailAdd(sprintf('%d consecutive incorrect trials',temp.incorrThreshold),NaN,'h');
end

MailSend;