function RewardDeliver( ppa , pprb , ioObj , nr , rw , rd )

%%% Task - general

%%
if ~isnan(nr),
    for i=1:nr,

            data_in = io32(ioObj,ppa);
            base_data_out = bitset(data_in,pprb,0);
            rew_data_out = bitset(data_in,pprb,1);
            io32(ioObj,ppa,rew_data_out);
            WaitSecs(rw/1000);
            io32(ioObj,ppa,base_data_out);
            WaitSecs(rd/1000);

    end
end