function RGBout = Mattscolordefs(colornumber,printflag)
% Outputs the RGB values in a 1x3 row vector associated with the 
% custom set color designed by Matt given an input number. These 
% numbers are based on but are not identical to the colors 
% that matlab uses when adding multiple new plots to an axis at once, 
% and are different than the 'rgbmcyk' colors set as plotting 
% options for color in matlab.
%
% If printflag is set to one, the colrnumbers are rearranged as 
% appropriate for things to be printed out
%
% See matlabcolordefs for the RGB values associated with 'rgbmcyk' 
% strings in plots.

if nargin<2 printflag=0; end
%if printflag
%    printconvert=[1 5 6 12 15 2 3 4 7 8 9 10 11 13 14];
%    colornumber=printconvert(colornumber);
%end

numcolors=15;
if mod(colornumber-1,numcolors)+1==1
    RGBout = [0 0 0]; %Black
elseif mod(colornumber-1,numcolors)+1==2
    RGBout = [0 0 1]; %Blue
elseif mod(colornumber-1,numcolors)+1==3
    RGBout = [0 .5 0]; %Medium Green, much sexier than the bright green for plot option 'g' which is RGB value [0 1 0]
elseif mod(colornumber-1,numcolors)+1==4
    RGBout = [1 0 0]; %Red
elseif mod(colornumber-1,numcolors)+1==5
    RGBout = [0 .75 .75]; %Teal, a hell of lot better than cyan    
elseif mod(colornumber-1,numcolors)+1==6
    RGBout = [.75 0 .75]; %Purple
elseif mod(colornumber-1,numcolors)+1==7
    RGBout = [.75 .75 0]; %Marigold
elseif mod(colornumber-1,numcolors)+1==8
    RGBout = [.5 .5 .5]; %Grey
elseif mod(colornumber-1,numcolors)+1==9
    RGBout = [1 0 1]; %magenta
elseif mod(colornumber-1,numcolors)+1==10
    RGBout = [1 .6 .6]; %pink    
elseif mod(colornumber-1,numcolors)+1==11
    RGBout = [.75 0 0]; %dark red    
elseif mod(colornumber-1,numcolors)+1==12
    RGBout = [1 .5 0]; %orange
elseif mod(colornumber-1,numcolors)+1==13
    RGBout = [0 1 0]; %bright green as a last resort    
elseif mod(colornumber-1,numcolors)+1==14
    RGBout = [0 1 1]; %cyan as a last resort
elseif mod(colornumber-1,numcolors)+1==15
    RGBout = [1 1 0]; %yellow
end
