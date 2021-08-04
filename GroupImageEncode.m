function code = GroupImageEncode( nGroups , nImages , group , image )

code = sub2ind([nGroups nImages],group,image);