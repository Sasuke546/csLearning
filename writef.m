function writef( x , ac)
%WRITEF Summary of this function goes here
%   Detailed explanation goes here..

fid = fopen('y.txt','a');
fprintf(fid,'%f %f\n',x,ac);
fclose(fid);


end

