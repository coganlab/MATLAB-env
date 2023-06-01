function [texthand,fontsize]=AddFittedText(textstr,startxpos,ypos,endxpos,fontunits,fontsize,alignment,fontweight,nofitflag,axhandle)
%
% function texthand=AddFittedText(textstr, startxpos, ypos, endxpos, fontunits, fontsize, alignment, fontweight, nofitflag, axhandle)
%
% Adds text and fits it into the specified limits of endxpos.
%
% Inputs: textstr = The string of text you want to add
%       startxpos = The starting x position of your text
%       ypos = The y position of the text
%       endxpos = The ending xposition of your text. the function
%           goes into a while loop and checks the end position of 
%           your added text, and shrinks the fontsize each time 
%           until it fits into the specified ending position
%       fontunits = The units of fontsize for your text. Defaults to normalized
%       fontsize = The initial fontsize for your text
%       alignment = Horizontal Alignment of your text. Defaults to left
%       fontweight = The weight of the font. Defaults to normal
%       nofitflag = If you wnat to skip the while loop fitting of the string by its horz length
%       axhand= The axis you want to add the text to. Adds text to current axis as default.
%
% Outputs:  texthand = The handle of the text you just added.
%           fontsize = FontSize after optionally shrinking the font, 
%               in the same units as the input fontunits

if endxpos<startxpos
    error(['endxpos is: ' num2str(endxpos) ' and is less than startxpos: ' num2str(startxpos)])
end

if nargin==10
    axes(axhand)
end
if nargin<9
    nofitflag=0;
end
if nargin<8
    fontweight='normal';
end
if nargin<7
    alignment='left';
end
if nargin<6
    fontsize=[];
end
if nargin<5
    fontunits='normalized';
end
if nargin<4
    endxpos=Inf;
end

if isempty(fontweight)
    fontweight='normal';
end
if isempty(alignment)
    alignment='left';
end
if isempty(fontunits)
    fontunits='normalized';
end
if isempty(endxpos)
    endxpos=Inf;
end

% function texthand=AddFittedText(textstr,startxpos,ypos,endxpos,fontunits,fontsize,alignment,fontweight,axhandle)
%disp(['Plotting text ' textstr ' from xpos ' num2str(startxpos) ' to ' num2str(endxpos) ' at ypos ' num2str(ypos)])
texthand=text(startxpos,ypos,textstr);
if strcmp(class(textstr),'cell')
    temp='';
    for i=1:length(textstr)
        temp=[temp textstr{i}];
    end
    textstr=temp;
end
%disp('Displaying properties for text handle before changing fontsize')
%get(texthand)

set(texthand,'FontUnits',fontunits,'FontWeight',fontweight,...
    'HorizontalAlignment',alignment);
if ~isempty(fontsize)
%    disp(['Setting fontsize to: ' num2str(fontsize)])
    set(texthand,'FontSize',fontsize)
else
    fontsize=get(texthand,'FontSize')
end

%disp('Displaying properties for text handle after changing fontsize')
%get(texthand)

if ~nofitflag
    
    Ext=get(texthand,'Extent');
    % disp(['New Fontsize is ' num2str(get(texthand,'FontSize'))])
    % disp(['Inside AddFittedText, After changing fontsize Extent is: ' num2str(Ext)])
    % 
    numloops=0;
    while Ext(3)+Ext(1)>endxpos & numloops<100
%         if length(textstr)>4
%             if strcmp(textstr(1:5),'pvals')
%                 disp(['Fontsize is ' num2str(get(texthand,'FontSize'))])
%                 disp(['Inside AddFittedText while loop, Extent is: ' num2str(Ext)])
%                 pause(1)
%             end
%         end
        numloops=numloops+1;
        disp(['Shrinking font for: ' textstr]);
        fontsize=.9*fontsize;
        %disp(['Want fontsize to be ' num2str(fontsize)])
        set(texthand,'FontSize',fontsize);
        %disp(['Fontsize is ' num2str(get(texthand,'FontSize'))])
        Ext=get(texthand,'Extent');
    end
    
    if numloops==100
        warning(['More than 100 loops of shrinking font reached for ' textstr])
    end
end