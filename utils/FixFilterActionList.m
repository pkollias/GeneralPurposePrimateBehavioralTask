function filteredlist = FixFilterActionList( actionlist , filter )

fixlist = {'FixAcq' 'FixHold'};

if filter,
    filteredlist = {actionlist{find(cellfun(@(x) ~any(strcmpi(x,fixlist)),actionlist))}};
else,
    filteredlist = actionlist;
end