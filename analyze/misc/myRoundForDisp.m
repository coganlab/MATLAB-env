function outstr=myRoundForDisp(val,lastdig,maxstrlen,inczero)
%
% function outstr=myRoundForDisp(val,lastdig,maxstrlen,inczero)
%
%   Outputs a string outstr that is the input number val
%   rounded accordingly for display depending on your inputs.
%   lastdig is the value of the digit to round the number to
%   (i.e. 0 for ones digit, -1 for tenths, -2 for hundredths, 
%   etc.) The output string is also limited by maxstrlen, and
%   outputs the number in 5.24e5 form if it must. inczero 
%   indicates whether or not you want to include the first 
%   initial zero in the output for numbers less than one.
%
%   lastdig defaults to -2
%   maxstrlen defualts to 6
%   inczero defaults to 1

if nargin<2|isempty(lastdig)    lastdig=-2; end
if nargin<3|isempty(maxstrlen)    maxstrlen=6; end
if nargin<4|isempty(inczero)    inczero=1; end

ex=10^-lastdig;
val=round(val*ex)/ex;
tstr=num2str(val);
if val==0
    outstr='0';
else
    if abs(val)<1
        if ~inczero
            tstr=tstr(2:end);
        end
    end
    if length(tstr)>maxstrlen        
        firstdig=floor(log10(abs(val)));
        numexpdigs=1+floor(log10(abs(firstdig))+1); % 1 is for e
        if firstdig<0
            numexpdigs=numexpdigs+1; %if neg sign is required in exp
        end
        negdig=val<0;
        digsleft=maxstrlen-negdig-numexpdigs;
        if digsleft<1
            warning(['Could not fit ' num2str(val) ' into ' num2str(maxstrlen) ' digits or less.'])
            outstr=tstr;
        end
        if digsleft<3
            outstr=[num2str(round(val*10^-firstdig)) 'e' num2str(firstdig)];
        else
            extradigs=digsleft-2;
            outstr=[num2str(round(val*10^-(firstdig-extradigs))/(10^extradigs)) 'e' num2str(firstdig)];
        end
    else
        outstr=tstr;
    end
end