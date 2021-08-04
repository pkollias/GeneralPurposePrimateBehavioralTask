function TerminateMail

global specs stats

%% mail
mailbody = strcat(sprintf('Working Time: \t\t%d\n', stats.RunningTime-stats.IdleTime),'\n', ...
                    sprintf('Total Time: \t\t%d\n', stats.RunningTime),'\n', ...
                    sprintf('Correct Trials: \t%d\n', stats.CorrectTrials),'\n', ...
                    sprintf('Attempted Trials: \t%d\n', stats.AttemptedTrials),'\n', ...
                    sprintf('Broken Trials: \t%d\n', stats.BreakFixTrials),'\n', ...
                    sprintf('Total Trials: \t\t%d\n', stats.TrialNo),'\n', ...
                    sprintf('Accuracy: \t\t%.2f\n', stats.Accuracy),'\n', ...
                    sprintf('Break Rate: \t\t%.2f\n', stats.BreakFixRate));
                
MailAdd(sprintf(mailbody),{strcat(specs.Version.SaveFileName(1:end-4),'.jpg')},'*');


%% slack %%%tb
fn = strcat(specs.Version.SaveFileName(1:end-4),'.jpg');
chan_str = specs.Slack.ChannelString;
token_str = specs.Slack.TokenString;

%Get list of channels
data = webread('https://slack.com/api/channels.list', 'token', token_str, 'exclude_archived', 'true', 'exclude_members', 'false', 'pretty', '1');
%Convert human readable channel name to its ID
cur_chan_str = data.channels(find(strcmpi({data.channels(:).name}, chan_str), 1, 'first')).id;

%Read image, convert to uint8
fid = fopen(fn, 'rb');
data = fread(fid, Inf, '*uint8');
fclose(fid);

%Post image
str = urlreadpost('https://slack.com/api/files.upload', ...
    {'file',data, 'token',token_str, 'channels',cur_chan_str, ...
    'title', sprintf('%s %s %s', specs.Version.ScriptRun, specs.Version.Monkey, specs.Version.DateString)});
% urlreadpost('https://slack.com/api/chat.postMessage', ...
%     {'token',token_str, 'channel',cur_chan_str, ...
%     'text', mailbody});
resp_tok = regexpi(str, '"ok":(\w+),', 'tokens');
if ~strcmpi(resp_tok{1}{1}, 'true'), error('Couldn''t upload image'); end