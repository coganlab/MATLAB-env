function test = skf_eval(skf, flags, Y,S,X)
%SKF_EVAL Evaluate an SKF using the specified flags and true variables

    str = '';
    if flags.eval_lhood 
	test.lhood = gpb2_lhood(skf,Y);	
	str = [str sprintf('\tlhood = %g\n',test.lhood)];
    end
    [test.serr, test.spct] = skf_eval_state(S,skf.M);
    str = [str sprintf('\tserr  = %g\n\tspct  = %g',test.serr, test.spct)];

    if flags.eval_traj
	test.CC = skf_eval_traj(X,skf.X);

	str = [str sprintf('\n\tCC = [ ')];
	for i=1:size(X,1)
	    str = [str sprintf('%g ', test.CC(i))];
	end
	str = [str ']'];
	
	test.rmse = sqrt(sum((X(1:2,:)-skf.X(1:2,:)).^2,2)/length(S));
	str = [str sprintf('\n\tRMSE: (%g, %g)', test.rmse(1),test.rmse(2))];

    end
    disp(str);

