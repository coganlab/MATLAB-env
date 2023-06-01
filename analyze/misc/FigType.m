function [Fig,Tit]=FigType(number,Fig,Tit,iFig,SpecFig)
%
% function Fig=FigType(number,Fig,Tit,iFig)
% 
% Returns certain value about a Fig based on it's type that are typically 
% different for each different type of fig. This only adds what should be 
% new values to the Fig structure, and opens up the figure. So far valid 
% values for number are:
%   
%   1: tall figure, typically PSTH Fig for Vertical Intervening Saccades
%   2: wide figure, typically PSTH Fig for Horizontal Intervening Saccades
%   3: square figure, typically PSTH fig for 3x3 center-out tasks
%   4-6 are the same but for Printable PSTH Figs
%   7: wide figure for RFPSTH's
%   8: wide figure for Printable RFPSTH's
%   9: RFColorsquares
%   10: PrintableRFColorsquares
%   11: Small overall SVDanalysis figure
%   12: SVDanalysis figure for series of 4x4 SVD's
%   13: Small overall Print SVDanalysis figure
%   14: SVDanalysis figure for Printing series of 4x4 SVD's
%   15: Plot Gradient Analysis Fig in RF Colorsquares
%   16: Print Gradient Analysis Fig in RF Colorsquares
%   17: Plot World Tuning Fig
%   18: Print World Tuning Fig

if number == 1      % 1: tall figure, typically PSTH Fig for Vertical Intervening Saccades
    
    Fig(iFig).FigHandle             = figure('Position', [50 70 1400 1000]);        
    Fig(iFig).HorzBetweenDirSpace   = 0.04; %Fraction of the total figure's Width and Height Between EACH direction's set of graphsGraph
    Fig(iFig).VertBetweenDirSpace   = 0.02;
    Fig(iFig).HorzBorderSpace       = 0.03; %Fraction of figure set aside for space around vertical and horizontal edges
    Fig(iFig).VertBorderSpace       = 0.03;
    Fig(iFig).BetweenGraphSpace1    = 0.02; %Fraction of total figure's height between neural and behavioral graphs within a direction
    Fig(iFig).BetweenGraphSpace2    = 0;    %Fraction of total figure's height between Eye and Hand Pos graphs within a direction
    Fig(iFig).HistSpaceFrac         = 0.75; %Fraction of the Direction's area in figure devoted to the histogram and rasters
    Fig(iFig).TB.Height             = 0.04;
    Tit.Height                      = 0.05;
    Fig(iFig).LabelSpace            = 0.035;
    Fig(iFig).DirTitleFontSize      = .1; %Fraction of the histgram axes' space for EACH LINE of the title to take up
    Fig(iFig).InitDirTitleOffset    = .02;
    
    %Intervening Saccade Graphic Info
    Fig(iFig).IntSaccGraphicSpace   = 0.06; %Fraction of the figure for the E-H-E Graphic to take up, for either horizontal or vertical Int Saccades
    Fig(iFig).IntSaccGraphicFlag    = 1;    %1/0 if you do or don't wnat the E-H-E graphic added to any figures that include any intervenging saccades
    Fig(iFig).NoIntSaccAxisGraphs   = 1;    %1/0 if you don't want to include graphs for directions along an intervening saccade axis for any figure containing that intervening saccade
    Fig(iFig).IntSaccBorderSpace    = 0.05; 
    Fig(iFig).ArrowWidth            = 5;
    
elseif number == 2    % 2: wide figure, typically PSTH Fig for Horizontal Intervening Saccades
    
    Fig(iFig).FigHandle             = figure('Position', [50 70 1400 1000]);
    Fig(iFig).HorzBetweenDirSpace   = 0.04; %Fraction of the total figure's Width and Height Between EACH direction's set of graphsGraph
    Fig(iFig).VertBetweenDirSpace   = 0.02;
    Fig(iFig).HorzBorderSpace       = 0.02; %Fraction of figure set aside for space around vertical and horizontal edges
    Fig(iFig).VertBorderSpace       = 0.03;
    Fig(iFig).BetweenGraphSpace1    = 0.02; %Fraction of total figure's height between neural and behavioral graphs within a direction
    Fig(iFig).BetweenGraphSpace2    = 0;    %Fraction of total figure's height between Eye and Hand Pos graphs within a direction
    Fig(iFig).HistSpaceFrac         = 0.75; %Fraction of the Direction's area in figure devoted to the histogram and rasters
    Fig(iFig).LabelSpace            = 0.035;
    Fig(iFig).DirTitleFontSize      = .1; %Fraction of the histgram axes' space for EACH LINE of the title to take up
    Fig(iFig).InitDirTitleOffset    = .02;
    
    %Intervening Saccade Graphic Info
    Fig(iFig).IntSaccGraphicSpace   = 0.1;  %Fraction of the figure for the E-H-E Graphic to take up, for either horizontal or vertical Int Saccades
    Fig(iFig).IntSaccGraphicFlag    = 1;    %1/0 if you do or don't wnat the E-H-E graphic added to any figures that include any intervenging saccades
    Fig(iFig).NoIntSaccAxisGraphs   = 1;    %1/0 if you don't want to include graphs for directions along an intervening saccade axis for any figure containing that intervening saccade
    Fig(iFig).IntSaccBorderSpace    = 0.05;
    Fig(iFig).ArrowWidth            = 5;
    
elseif number == 3    % 3: square figure, typically PSTH fig for 3x3 center-out tasks
    Fig(iFig).FigHandle             = figure('Position', [50 70 1400 1000]);
    Fig(iFig).HorzBetweenDirSpace   = 0.05; %Fraction of the total figure's Width and Height Between EACH direction's set of graphsGraph
    Fig(iFig).VertBetweenDirSpace   = 0.02;
    Fig(iFig).HorzBorderSpace       = 0.03; %Fraction of figure set aside for space around vertical and horizontal edges
    Fig(iFig).VertBorderSpace       = 0.03;  
    Fig(iFig).BetweenGraphSpace1    = 0.02; %Fraction of total figure's height between neural and behavioral graphs within a direction
    Fig(iFig).BetweenGraphSpace2    = 0;    %Fraction of total figure's height between Eye and Hand Pos graphs within a direction
    Fig(iFig).HistSpaceFrac         = 0.75; %Fraction of the Direction's area in figure devoted to the histogram and rasters
    Fig(iFig).LabelSpace            = 0.035;
    Fig(iFig).DirTitleFontSize      = .1; %Fraction of the histgram axes' space for EACH LINE of the title to take up
    Fig(iFig).InitDirTitleOffset    = .02;
    
    %Intervening Saccade Graphic Info
    Fig(iFig).IntSaccGraphicSpace   = 0.2;  %Fraction of the figure for the E-H-E Graphic to take up, for either horizontal or vertical Int Saccades
    Fig(iFig).IntSaccGraphicFlag    = 1;    %1/0 if you do or don't wnat the E-H-E graphic added to any figures that include any intervenging saccades
    Fig(iFig).NoIntSaccAxisGraphs   = 1;    %1/0 if you don't want to include graphs for directions along an intervening saccade axis for any figure containing that intervening saccade
    Fig(iFig).IntSaccBorderSpace    = 0.05;
    Fig(iFig).ArrowWidth            = 5;
    
elseif number == 4    % 4: printable tall figure, typically PSTH Fig for Vertical Intervening Saccades
    Fig(iFig).FigHandle             = figure('Position',[50 70 1400 1000]);
    set(Fig(iFig).FigHandle,'Units', 'inches', 'Position', [.25 .25 8 10.5]);       
    Fig(iFig).HorzBetweenDirSpace   = 0.04;     %Fraction of the total figure's Width and Height Between EACH direction's set of graphsGraph
    Fig(iFig).VertBetweenDirSpace   = 0.02;
    Fig(iFig).HorzBorderSpace       = 0.045;    %Fraction of figure set aside for space around vertical and horizontal edges
    Fig(iFig).VertBorderSpace       = 0.01;
    Fig(iFig).BetweenGraphSpace1    = 0.005;    %Fraction of total figure's height between neural and behavioral graphs within a direction
    Fig(iFig).BetweenGraphSpace2    = 0;        %Fraction of total figure's height between Eye and Hand Pos graphs within a direction
    Fig(iFig).HistSpaceFrac         = 0.82;     %Fraction of the Direction's area in figure devoted to the histogram and rasters
    Fig(iFig).TB.Height             = 0.03;
    Fig(iFig).LabelSpace            = 0;
    Tit.Height                      = 0.05;
    Fig(iFig).DirTitleFontSize      = .03; %Fraction of the histgram axes' space for EACH LINE of the title to take up
    Fig(iFig).InitDirTitleOffset    = .02;
    
    %Intervening Saccade Graphic Info
    Fig(iFig).IntSaccGraphicSpace   = 0.06; %Fraction of the figure for the E-H-E Graphic to take up, for either horizontal or vertical Int Saccades
    Fig(iFig).IntSaccGraphicFlag    = 1;    %1/0 if you do or don't wnat the E-H-E graphic added to any figures that include any intervenging saccades
    Fig(iFig).NoIntSaccAxisGraphs   = 1;    %1/0 if you don't want to include graphs for directions along an intervening saccade axis for any figure containing that intervening saccade
    Fig(iFig).IntSaccBorderSpace    = 0.05; 
    Fig(iFig).ArrowWidth            = 3;
    
elseif number == 5  % 5: printable wide figure, typically PSTH Fig for Horizontal Intervening Saccades
    Fig(iFig).FigHandle             = figure('Position',[50 70 1400 1000]);
    set(Fig(iFig).FigHandle,'Units','inches','Position',[.25 .25 8 10.5]);
    Fig(iFig).HorzBetweenDirSpace   = 0.04; %Fraction of the total figure's Width and Height Between EACH direction's set of graphsGraph
    Fig(iFig).VertBetweenDirSpace   = 0.02;
    Fig(iFig).HorzBorderSpace       = 0.025; %Fraction of figure set aside for space around vertical and horizontal edges
    Fig(iFig).VertBorderSpace       = 0.01;
    Fig(iFig).BetweenGraphSpace1    = 0.005; %Fraction of total figure's height between neural and behavioral graphs within a direction
    Fig(iFig).BetweenGraphSpace2    = 0;    %Fraction of total figure's height between Eye and Hand Pos graphs within a direction
    Fig(iFig).HistSpaceFrac         = 0.9;  %Fraction of the Direction's area in figure devoted to the histogram and rasters
    Fig(iFig).LabelSpace            = 0;
    Tit.Height                      = 0.05;
    Fig(iFig).TB.Height             = 0.03;
    Fig(iFig).DirTitleFontSize      = .03; %Fraction of the histgram axes' space for EACH LINE of the title to take up
    Fig(iFig).InitDirTitleOffset    = .02;
    
    %Intervening Saccade Graphic Info
    Fig(iFig).IntSaccGraphicSpace   = 0.03; %Fraction of the figure for the E-H-E Graphic to take up, for either horizontal or vertical Int Saccades
    Fig(iFig).IntSaccGraphicFlag    = 1;    %1/0 if you do or don't wnat the E-H-E graphic added to any figures that include any intervenging saccades
    Fig(iFig).NoIntSaccAxisGraphs   = 1;    %1/0 if you don't want to include graphs for directions along an intervening saccade axis for any figure containing that intervening saccade
    Fig(iFig).IntSaccBorderSpace    = 0.05;
    Fig(iFig).ArrowWidth            = 3;

elseif number == 6  % 6: printable square figure, typically PSTH fig for 3x3 center-out tasks
    Fig(iFig).FigHandle             = figure('Position',[700 70 1400 1000]);
    set(Fig(iFig).FigHandle,'Units','inches','Position',[.25 .25 8 10.5]); 
    Fig(iFig).HorzBetweenDirSpace   = 0.04;  %Fraction of the total figure's Width and Height Between EACH direction's set of graphsGraph
    Fig(iFig).VertBetweenDirSpace   = 0.02;
    Fig(iFig).HorzBorderSpace       = 0.03;  %Fraction of figure set aside for space around vertical and horizontal edges
    Fig(iFig).VertBorderSpace       = 0.01;  
    Fig(iFig).BetweenGraphSpace1    = 0.005; %Fraction of total figure's height between neural and behavioral graphs within a direction
    Fig(iFig).BetweenGraphSpace2    = 0;     %Fraction of total figure's height between Eye and Hand Pos graphs within a direction
    Fig(iFig).HistSpaceFrac         = 0.93;  %Fraction of the Direction's area in figure devoted to the histogram and rasters
    Fig(iFig).LabelSpace            = 0.035;
    Tit.Height                      = 0.05;
    Fig(iFig).TB.Height             = 0.03;
    Fig(iFig).DirTitleFontSize      = .03; %Fraction of the histgram axes' space for EACH LINE of the title to take up
    Fig(iFig).InitDirTitleOffset    = .02;
    
    %Intervening Saccade Graphic Info
    Fig(iFig).IntSaccGraphicSpace   = 0.05; %Fraction of the figure for the E-H-E Graphic to take up, for either horizontal or vertical Int Saccades
    Fig(iFig).IntSaccGraphicFlag    = 1;    %1/0 if you do or don't want the E-H-E graphic added to any figures that include any intervenging saccades
    Fig(iFig).NoIntSaccAxisGraphs   = 1;    %1/0 if you don't want to include graphs for directions along an intervening saccade axis for any figure containing that intervening saccade
    Fig(iFig).IntSaccBorderSpace    = 0.05;
    Fig(iFig).ArrowWidth            = 5;
    
elseif number == 7  % 7: wide figure for RFPSTH's
    Fig(iFig).FigHandle             = figure('Position',[200 700 1400 1000]);
    Fig(iFig).HorzBetweenDirSpace   = 0.04; %Fraction of the total figure's Width and Height Between EACH direction's set of graphsGraph
    Fig(iFig).VertBetweenDirSpace   = 0.02;
    Fig(iFig).HorzBorderSpace       = 0.02; %Fraction of figure set aside for space around vertical and horizontal edges
    Fig(iFig).VertBorderSpace       = 0.02;
    Fig(iFig).BetweenGraphSpace1    = 0; %Fraction of total figure's height between neural and behavioral graphs within a direction
    Fig(iFig).BetweenGraphSpace2    = 0;    %Fraction of total figure's height between Eye and Hand Pos graphs within a direction
    Fig(iFig).HistSpaceFrac         = 1; %Fraction of the Direction's area in figure devoted to the histogram and rasters
    Fig(iFig).LabelSpace            = 0.0; %For Epos, HPos labels
    Fig(iFig).DirTitleFontSize      = 0;%.1; %Fraction of the histgram axes' space for EACH LINE of the title to take up
    Fig(iFig).InitDirTitleOffset    = .02;
    
    %RF/IntSacc Graphic Info
    Fig(iFig).IntSaccGraphicFrac    = 0.1;  %Fraction of Each Direction for the E-H-E Graphic to take up.
    Fig(iFig).IntSaccGraphicFlag    = 1;    %1/0 if you do or don't wnat the E-H-E graphic added to figures
    Fig(iFig).IntSaccBorderSpace    = 0.05;
    Fig(iFig).DivLineFlag           = 1;
    Fig(iFig).DivLineWidth          = 2;
    
    %Figure Axes Labels
    Fig(iFig).FigXaxLabelFlag    = 1;
    Fig(iFig).FigYaxLabelFlag    = 1;
    Fig(iFig).FigXaxLabelHeight    = .02;  %Fraction of the Figure Height
    Fig(iFig).FigXaxLabelLineWidth    = 2;  %Width of the line
    Fig(iFig).FigYaxLabelWidth    = .03;  %Fraction of the Figure Width
    Fig(iFig).FigYaxLabelLineWidth    = 2;  %Width of the line
    
elseif number == 8  % 8: wide figure for PrintRFPSTH's
    Fig(iFig).FigHandle             = figure('Position',[200 700 1400 1000]);
    set(Fig(iFig).FigHandle,'Units','inches','Position',[.25 .25 8 10.5]);
    Fig(iFig).HorzBetweenDirSpace   = 0.04; %Fraction of the total figure's Width and Height Between EACH direction's set of graphsGraph
    Fig(iFig).VertBetweenDirSpace   = 0.02;
    Fig(iFig).HorzBorderSpace       = 0.02; %Fraction of figure set aside for space around vertical and horizontal edges
    Fig(iFig).VertBorderSpace       = 0.02;
    Fig(iFig).BetweenGraphSpace1    = 0; %Fraction of total figure's height between neural and behavioral graphs within a direction
    Fig(iFig).BetweenGraphSpace2    = 0;    %Fraction of total figure's height between Eye and Hand Pos graphs within a direction
    Fig(iFig).HistSpaceFrac         = 1; %Fraction of the Direction's area in figure devoted to the histogram and rasters
    Fig(iFig).LabelSpace            = 0.0; %For Epos, HPos labels
    Fig(iFig).DirTitleFontSize      = 0;%.1; %Fraction of the histgram axes' space for EACH LINE of the title to take up
    Fig(iFig).InitDirTitleOffset    = .02;
    
    %RF/IntSacc Graphic Info
    Fig(iFig).IntSaccGraphicFrac    = 0.1;  %Fraction of Each Direction for the E-H-E Graphic to take up.
    Fig(iFig).IntSaccGraphicFlag    = 1;    %1/0 if you do or don't want the E-H-E graphic added to figures
    Fig(iFig).IntSaccBorderSpace    = 0.05;
    Fig(iFig).DivLineFlag           = 1;
    Fig(iFig).DivLineWidth          = 2;
    
    %Figure Axes Labels
    Fig(iFig).FigXaxLabelFlag    = 1;
    Fig(iFig).FigYaxLabelFlag    = 1;
    Fig(iFig).FigXaxLabelHeight    = .02;  %Fraction of the Figure Height
    Fig(iFig).FigXaxLabelLineWidth    = 2;  %Width of the line
    Fig(iFig).FigYaxLabelWidth    = .03;  %Fraction of the Figure Width
    Fig(iFig).FigYaxLabelLineWidth    = 2;  %Width of the line
    
elseif number == 9  % 9: Figure for PlotRFColorSquares
    Fig(iFig).FigHandle             = figure('Position',[200 700 1000 1000]);
    Fig(iFig).HorzBetweenDirSpace   = 0.04; %Fraction of the total figure's Width and Height Between EACH direction's set of graphsGraph
    Fig(iFig).VertBetweenDirSpace   = 0.02;
    Fig(iFig).HorzBorderSpace       = 0.02; %Fraction of figure set aside for space around vertical and horizontal edges
    Fig(iFig).VertBorderSpace       = 0.01;
    Fig(iFig).BetweenGraphSpace1    = 0; %Fraction of total figure's height between neural and behavioral graphs within a direction
    Fig(iFig).BetweenGraphSpace2    = 0;    %Fraction of total figure's height between Eye and Hand Pos graphs within a direction
    Fig(iFig).HistSpaceFrac         = 1; %Fraction of the Direction's area in figure devoted to the histogram and rasters
    Fig(iFig).LabelSpace            = 0.00;%8; %For Epos, HPos labels
    
    %RF/IntSacc Graphic Info
    Fig(iFig).XaxLabelSpace          = .03; %Fraction of the whole figue space for each row
    Fig(iFig).XaxLabelBorder          = .05; %Fraction of the axis label
    Fig(iFig).XaxLabelFlag           =  1;
    Fig(iFig).YaxLabelSpace          = .022; %Fraction of the whole figue space for each Column past the first
    Fig(iFig).YaxLabelBorder          = .05; %Fraction of the axis label
    Fig(iFig).YaxLabelFlag           =  1;
    Fig(iFig).IntSaccGraphicSpace    = 0.05;  %Fraction of the whole figue space for each row
    Fig(iFig).IntSaccGraphicBorder    = 0.01;  %Fraction of the IntSaccGraphic
    Fig(iFig).IntSaccGraphicFlag    = 1;    %1/0 if you do or don't want the E-H-E graphic added to figures
    Fig(iFig).DivLineFlag           = 1;
    Fig(iFig).DivLineWidth          = 2;
    Fig(iFig).CBWidth               = .01; %Fraction of the figure's width
    Fig(iFig).CBBorderSpace1         = .01; %Fraction of the figure's width between last CSgraph and CB
    Fig(iFig).CBBorderSpace2         = .01; %Fraction of the figure's width between CB and border
    
elseif number == 10  % 10: Printable figure for PrintRFColorSquares
    Fig(iFig).FigHandle             = figure('Position',[200 700 1400 1000]);
    set(Fig(iFig).FigHandle,'Units','inches','Position',[.25 .25 8 10.5]);
    Fig(iFig).HorzBetweenDirSpace   = 0.04; %Fraction of the total figure's Width and Height Between EACH direction's set of graphsGraph
    Fig(iFig).VertBetweenDirSpace   = 0.02;
    Fig(iFig).HorzBorderSpace       = 0.02; %Fraction of figure set aside for space around vertical and horizontal edges
    Fig(iFig).VertBorderSpace       = 0.01;
    Fig(iFig).BetweenGraphSpace1    = 0; %Fraction of total figure's height between neural and behavioral graphs within a direction
    Fig(iFig).BetweenGraphSpace2    = 0;    %Fraction of total figure's height between Eye and Hand Pos graphs within a direction
    Fig(iFig).HistSpaceFrac         = 1; %Fraction of the Direction's area in figure devoted to the histogram and rasters
    Fig(iFig).LabelSpace            = 0.012; %For Epos, HPos labels
    
    %RF/IntSacc Graphic Info
    Fig(iFig).XaxLabelSpace          = .03; %Fraction of the whole figue space for each row
    Fig(iFig).XaxLabelBorder         = .05; %Fraction of the axis label
    Fig(iFig).XaxLabelFlag           =  1;
    Fig(iFig).YaxLabelSpace          = .035; %Fraction of the whole figue space for each Column, I think
    Fig(iFig).YaxLabelBorder          = .04; %Fraction of the axis label
    Fig(iFig).YaxLabelFlag           =  1;
    Fig(iFig).IntSaccGraphicSpace    = 0.03;  %Fraction of the whole figue space for each row
    Fig(iFig).IntSaccGraphicBorder   = 0.01;  %Fraction of the IntSaccGraphic
    Fig(iFig).IntSaccGraphicFlag     = 1;    %1/0 if you do or don't want the E-H-E graphic added to figures
    Fig(iFig).DivLineFlag            = 1;
    Fig(iFig).DivLineWidth           = 2;
    Fig(iFig).CBWidth                = .018; %Fraction of the figure's width
    Fig(iFig).CBBorderSpace1         = .01; %Fraction of the figure's width between last CSgraph and CB
    Fig(iFig).CBBorderSpace2         = .03; %Fraction of the figure's width between CB and border
    
elseif number == 11  % 11: Small overall SVDanalysis figure
    Fig(iFig).SpecFig(SpecFig).FigHandle             = figure('Position',[200 200 1400 500]);
    Fig(iFig).HorzBetweenDirSpace   = 0.04; %Fraction of the total figure's Width and Height Between EACH direction's set of graphsGraph
    Fig(iFig).VertBetweenDirSpace   = 0.02;
    Fig(iFig).HorzBorderSpace       = 0.02; %Fraction of figure set aside for space around vertical and horizontal edges
    Fig(iFig).VertBorderSpace       = 0.02;
    Fig(iFig).LabelSpace            = 0.0; %For Epos, HPos labels
    Fig(iFig).ExtraTitSpace         = 0.08; %Fraction of the Figure's height
    
    %RF/IntSacc Graphic Info
    Fig(iFig).DirTitleSpace          = .04; %Fraction of the whole figue space for each row
    Fig(iFig).DirTitleBorder          = .05; %Fraction of the axis label
    Fig(iFig).DirTitleFlag           =  1;

    
elseif number == 12  % 12: SVDanalysis figure for series of 4x4 SVD's
    Fig(iFig).SpecFig(SpecFig).FigHandle             = figure('Position',[200 700 1400 1000]);
    Fig(iFig).HorzBetweenDirSpace   = 0.02; %Fraction of the total figure's Width and Height Between EACH direction's set of graphsGraph
    Fig(iFig).VertBetweenDirSpace   = 0.02;
    Fig(iFig).HorzBorderSpace       = 0.02; %Fraction of figure set aside for space around vertical and horizontal edges
    Fig(iFig).VertBorderSpace       = 0.02;
    Fig(iFig).YAxLabelSpace            = 0.009; %For Epos, HPos labels
    Fig(iFig).ExtraTitSpace         = 0.025; %Fraction of the Figure's height
    Fig(iFig).DirTitleFontSize      = .1;%.1; %Fraction of the histgram axes' space for EACH LINE of the title to take up
    Fig(iFig).InitDirTitleOffset    = .02;
    
    %RF/IntSacc Graphic Info
    Fig(iFig).XaxLabelSpace          = .03; %Fraction of the whole figue space for each row
    Fig(iFig).XaxLabelBorder          = .05; %Fraction of the axis label
    Fig(iFig).XaxLabelFlag           =  1;
    Fig(iFig).HorzVecSpace          = .03; %Fraction of the whole figue space for each row
    Fig(iFig).HorzVecBorder          = .12; %Fraction of the Horizontal Border
    Fig(iFig).HorzVecFlag           =  1;
    Fig(iFig).VertVecSpace          = .025; %Fraction of the whole figue space for each column
    Fig(iFig).VertVecBorder          = .2; %Fraction of the Horizontal Border
    Fig(iFig).VertVecFlag           =  1;
    Fig(iFig).DirTitleSpace          = .015; %Fraction of the whole figue space for each row
    Fig(iFig).DirTitleBorder          = .05; %Fraction of the axis label
    Fig(iFig).DirTitleFlag           =  1;
    Fig(iFig).YaxLabelSpace          = .022; %Fraction of the whole figue space for each Column past the first
    Fig(iFig).YaxLabelBorder          = .05; %Fraction of the axis label
    Fig(iFig).YaxLabelFlag           =  1;
    Fig(iFig).CB1Width               = .01; %Fraction of the figure's width
    Fig(iFig).CB1BorderSpace1         = .01; %Fraction of the figure's width between last CSgraph and CB
    Fig(iFig).CB1BorderSpace2         = .01; %Fraction of the figure's width between CB and border
    Fig(iFig).CB2Width               = .01; %Fraction of the figure's width
    Fig(iFig).CB2BorderSpace1         = .01; %Fraction of the figure's width between last CSgraph and CB
    Fig(iFig).CB2BorderSpace2         = .01; %Fraction of the figure's width between CB and border
    Fig(iFig).CB3Width               = .005; %Fraction of the figure's width
    Fig(iFig).CB3BorderSpace1         = .005; %Fraction of the figure's width between last CSgraph and CB
    Fig(iFig).CB3BorderSpace2         = .005; %Fraction of the figure's width between CB and border
    
    
elseif number == 13  % 13: Small overall Print SVDanalysis figure
    Fig(iFig).SpecFig(SpecFig).FigHandle             = figure('Position',[200 200 1400 500]);
    set(Fig(iFig).SpecFig(SpecFig).FigHandle,'Units','inches','Position',[.25 5.25 8 5.25]);
    Fig(iFig).HorzBetweenDirSpace   = 0.05; %Fraction of the total figure's Width and Height Between EACH direction's set of graphsGraph
    Fig(iFig).VertBetweenDirSpace   = 0.02;
    Fig(iFig).HorzBorderSpace       = 0.05; %Fraction of figure set aside for space around vertical and horizontal edges
    Fig(iFig).VertBorderSpace       = 0.02;
    Fig(iFig).LabelSpace            = 0.0; %For Epos, HPos labels
    Fig(iFig).ExtraTitSpace         = 0.08; %Fraction of the Figure's height
    
    %RF/IntSacc Graphic Info
    Fig(iFig).DirTitleSpace          = .04; %Fraction of the whole figue space for each row
    Fig(iFig).DirTitleBorder          = .05; %Fraction of the axis label
    Fig(iFig).DirTitleFlag           =  1;

    
elseif number == 14  % 14: SVDanalysis figure for Print series of 4x4 SVD's
    Fig(iFig).SpecFig(SpecFig).FigHandle             = figure('Position',[200 700 1400 1000]);
    set(Fig(iFig).SpecFig(SpecFig).FigHandle,'Units','inches','Position',[.25 .25 8 10.5]);
    Fig(iFig).HorzBetweenDirSpace   = 0.015; %Fraction of the total figure's Width and Height Between EACH direction's set of graphsGraph
    Fig(iFig).VertBetweenDirSpace   = 0.01;
    Fig(iFig).HorzBorderSpace       = 0.02; %Fraction of figure set aside for space around vertical and horizontal edges
    Fig(iFig).VertBorderSpace       = 0.02;
    Fig(iFig).ExtraTitSpace         = 0.025; %Fraction of the Figure's height
    Fig(iFig).DirTitleFontSize      = .1;%.1; %Fraction of the histgram axes' space for EACH LINE of the title to take up
    Fig(iFig).InitDirTitleOffset    = .02;
    
    %RF/IntSacc Graphic Info
    Fig(iFig).XaxLabelSpace          = .03; %Fraction of the whole figue space for each row
    Fig(iFig).XaxLabelBorder          = .05; %Fraction of the axis label
    Fig(iFig).XaxLabelFlag           =  1;
    Fig(iFig).HorzVecSpace          = .02; %Fraction of the whole figue space for each row
    Fig(iFig).HorzVecBorder          = .12; %Fraction of the Horizontal Border
    Fig(iFig).HorzVecFlag           =  1;
    Fig(iFig).VertVecSpace          = .035; %Fraction of the whole figue space for each column
    Fig(iFig).VertVecBorder          = .2; %Fraction of the Horizontal Border
    Fig(iFig).VertVecFlag           =  1;
    Fig(iFig).DirTitleSpace          = .01; %Fraction of the whole figue space for each row
    Fig(iFig).DirTitleBorder          = .01; %Fraction of the axis label
    Fig(iFig).DirTitleFlag           =  1;
    Fig(iFig).YaxLabelSpace          = .022; %Fraction of the whole figue space for each Column past the first
    Fig(iFig).YaxLabelBorder          = .05; %Fraction of the axis label
    Fig(iFig).YaxLabelFlag           =  1;
    Fig(iFig).CB1Width               = .01; %Fraction of the figure's width
    Fig(iFig).CB1BorderSpace1         = .021; %Fraction of the figure's width between last CSgraph and CB
    Fig(iFig).CB1BorderSpace2         = .003; %Fraction of the figure's width between CB and border
    Fig(iFig).CB2Width               = .01; %Fraction of the figure's width
    Fig(iFig).CB2BorderSpace1         = .017; %Fraction of the figure's width between last CSgraph and CB
    Fig(iFig).CB2BorderSpace2         = .00; %Fraction of the figure's width between CB and border
    Fig(iFig).CB3Width               = .005; %Fraction of the figure's width
    Fig(iFig).CB3BorderSpace1         = .005; %Fraction of the figure's width between last CSgraph and CB
    Fig(iFig).CB3BorderSpace2         = .005; %Fraction of the figure's width between CB and border
    
elseif number == 15  % 15: Figure for Gradient plots in PlotRFColorSquares
    Fig(iFig).FigHandle             = figure('Position',[200 700 1000 1000]);
    Fig(iFig).HorzBetweenDirSpace   = 0.04; %Fraction of the total figure's Width and Height Between EACH direction's set of graphsGraph
    Fig(iFig).VertBetweenDirSpace   = 0.005;
    Fig(iFig).HorzBorderSpace       = 0.02; %Fraction of figure set aside for space around vertical and horizontal edges
    Fig(iFig).VertBorderSpace       = 0.02;
    Fig(iFig).BetweenGraphSpace1    = 0; %Fraction of total figure's height between neural and behavioral graphs within a direction
    Fig(iFig).BetweenGraphSpace2    = 0;    %Fraction of total figure's height between Eye and Hand Pos graphs within a direction
    Fig(iFig).HistSpaceFrac         = 1; %Fraction of the Direction's area in figure devoted to the histogram and rasters
    Fig(iFig).LabelSpace            = 0.00;%8; %For Epos, HPos labels
    
    %RF/IntSacc Graphic Info
    Fig(iFig).XaxLabelSpace          = .012; %Fraction of the whole figue space for each row
    Fig(iFig).XaxLabelBorder          = .05; %Fraction of the axis label
    Fig(iFig).XaxLabelFlag           =  1;
    Fig(iFig).YaxLabelSpace          = .00; %Fraction of the whole figue space for each Column past the first
    Fig(iFig).YaxLabelBorder          = .05; %Fraction of the axis label
    Fig(iFig).YaxLabelFlag           =  0;
    Fig(iFig).IntSaccGraphicSpace    = 0.05;  %Fraction of the whole figue space for each row
    Fig(iFig).IntSaccGraphicBorder    = 0.01;  %Fraction of the IntSaccGraphic
    Fig(iFig).IntSaccGraphicFlag    = 0;    %1/0 if you do or don't want the E-H-E graphic added to figures
    Fig(iFig).DivLineFlag           = 1;
    Fig(iFig).DivLineWidth          = 2;
    Fig(iFig).CBWidth               = 0;%.02; %Fraction of the figure's width
    Fig(iFig).CBBorderSpace1         = 0;%.01; %Fraction of the figure's width between last CSgraph and CB
    Fig(iFig).CBBorderSpace2         = 0;%.01; %Fraction of the figure's width between CB and border
    
elseif number == 16  % 16: Printable Figure for Gradient plots in PrintRFColorSquares
    Fig(iFig).FigHandle             = figure('Position',[200 700 1400 1000]);
    set(Fig(iFig).FigHandle,'Units','inches','Position',[.25 .25 8 10.5]);
    Fig(iFig).HorzBetweenDirSpace   = 0.04; %Fraction of the total figure's Width and Height Between EACH direction's set of graphsGraph
    Fig(iFig).VertBetweenDirSpace   = 0.005;
    Fig(iFig).HorzBorderSpace       = 0.02; %Fraction of figure set aside for space around vertical and horizontal edges
    Fig(iFig).VertBorderSpace       = 0.02;
    Fig(iFig).BetweenGraphSpace1    = 0; %Fraction of total figure's height between neural and behavioral graphs within a direction
    Fig(iFig).BetweenGraphSpace2    = 0;    %Fraction of total figure's height between Eye and Hand Pos graphs within a direction
    Fig(iFig).HistSpaceFrac         = 1; %Fraction of the Direction's area in figure devoted to the histogram and rasters
    Fig(iFig).LabelSpace            = 0.00;%8; %For Epos, HPos labels
    
    %RF/IntSacc Graphic Info
    Fig(iFig).XaxLabelSpace          = .012; %Fraction of the whole figue space for each row
    Fig(iFig).XaxLabelBorder          = .05; %Fraction of the axis label
    Fig(iFig).XaxLabelFlag           =  1;
    Fig(iFig).YaxLabelSpace          = .01; %Fraction of the whole figue space for each Column past the first
    Fig(iFig).YaxLabelBorder          = .05; %Fraction of the axis label
    Fig(iFig).YaxLabelFlag           =  0;
    Fig(iFig).IntSaccGraphicSpace    = 0.05;  %Fraction of the whole figue space for each row
    Fig(iFig).IntSaccGraphicBorder    = 0.01;  %Fraction of the IntSaccGraphic
    Fig(iFig).IntSaccGraphicFlag    = 0;    %1/0 if you do or don't want the E-H-E graphic added to figures
    Fig(iFig).DivLineFlag           = 1;
    Fig(iFig).DivLineWidth          = 2;
    Fig(iFig).CBWidth               = 0;%.02; %Fraction of the figure's width
    Fig(iFig).CBBorderSpace1         = 0;%.01; %Fraction of the figure's width between last CSgraph and CB
    Fig(iFig).CBBorderSpace2         = 0;%.01; %Fraction of the figure's width between CB and border
    
elseif number == 17      % 17: tall figure for plot World Tune
    
    Fig(iFig).FigHandle             = figure('Position', [200 200 700 700]);        
    Fig(iFig).HorzBetweenDirSpace   = 0.04; %Fraction of the total figure's Width and Height Between EACH direction's set of graphsGraph
    Fig(iFig).VertBetweenDirSpace   = 0.005;
    Fig(iFig).HorzBorderSpace       = 0.03; %Fraction of figure set aside for space around vertical and horizontal edges
    Fig(iFig).VertBorderSpace       = 0.03;
    Fig(iFig).BetweenGraphSpace1    = 0.02; %Fraction of total figure's height between neural and behavioral graphs within a direction
    Fig(iFig).BetweenGraphSpace2    = 0;    %Fraction of total figure's height between Eye and Hand Pos graphs within a direction
    Fig(iFig).HistSpaceFrac         = 0.75; %Fraction of the Direction's area in figure devoted to the histogram and rasters
    Fig(iFig).TB.Height             = 0.04;
    Tit.Height                      = 0.05;
    Fig(iFig).LabelSpace            = 0.035;
    Fig(iFig).DirTitleFontSize      = .1; %Fraction of the histgram axes' space for EACH LINE of the title to take up
    Fig(iFig).InitDirTitleOffset    = .02;
    
else
    warning(['No Fig type yet for number: ' num2str(number) '. No changes made to Fig.'])
end