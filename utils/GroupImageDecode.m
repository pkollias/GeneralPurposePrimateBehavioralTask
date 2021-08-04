function [ group , image ] = GroupImageDecode( nGroups , nImages , code )

[group,image] = ind2sub([nGroups nImages],code);