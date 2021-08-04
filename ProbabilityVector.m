function normd = ProbabilityVector( arbit )

normd = arbit./repmat(sum(arbit,2),1,size(arbit,2));