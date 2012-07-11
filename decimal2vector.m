function output = decimal2vector(decimal_vector, len)
% convert a decimal row vector to a vector row vector.
% For example: 1 to [1 0 0]' ;  2 to [0 1 0]' ; 3 to [0 0 1]
% if max(decimal_vector )~= len
%         
%         error('vector length is not match with max decimal !') ;
% end
% 
% if (len == 1) && (max(decimal_vector) == 1)
% %         disp('Only one out put number. ') ;
%         output_bin = decimal_vector ;
% elseif len > 1 && (max(decimal_vector) == len) && ( min(decimal_vector)==1)
%         output_bin = zeros(len, length(decimal_vector)) ;
%         for i = 1:length(decimal_vector)
%                 output_bin(decimal_vector(i), i)= 1 ;
%         end
% else 
%         error('class type must start from 1 !!') ;
% end
% output = output_bin ;


output_bin = zeros(len, length(decimal_vector)) ;
for i = 1:length(decimal_vector)
    output_bin(decimal_vector(i), i)= 1 ;
    for j  = 1:len
        if output_bin(j,i)== 0
            output_bin(j,i) = -1;
        end
    end
end

output = output_bin ;