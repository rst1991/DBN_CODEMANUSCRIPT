function [rmse,AveErrNum,denoisedI] = CalcRmseTest( dbn, IN, OUT,Inp)
out = v2h( dbn, IN );

err = power( OUT - out, 2 );
rmse = sqrt( sum(err(:)) / numel(err) );
load dnn      %#ok<LOAD>
bout = out > 0.5;
BOUT = OUT > 0.5;

err = abs( BOUT - bout );
AveErrNum = mean( sum(err,2) );
denoisedI = denoiseImage(Inp,dnn);

end
