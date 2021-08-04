mnkname = 'bun';
d = dir(sprintf('%s*',mnkname));
d = d([d.isdir]);

%%
dnum = zeros(1,length(d));
for i=1:length(d),
    dname = d(i).name(length(mnkname)+1:end);
    dnum(i) = datenum(dname,'mmddyy');
end

[~,inds] = sort(dnum);
d = d(inds);

%%
%for every day
T = zeros(1,length(d));
for i=1:length(d),
    cd(d(i).name);
    dd = dir(sprintf('%s*',mnkname));
    dd = dd([dd.isdir]);
    %for every session
    trials = 0;
    for j=1:length(dd),
        cd(dd(j).name);
        ds = dir(sprintf('%s*_*_0*.mat',mnkname));
        trials = trials+length(ds);
        cd('..');
    end
    T(i) = trials;
    cd('..');
end
