classdef gca_fast < handle

    properties
        
        % Handles
        h_figure;
        h_axes;
        h_plot;
        
        % Original data
        x;
        y;
        y_to_x_map;
        
        % Extrema
        x_min;
        x_max;
        
        % Status
        busy            = false; % Set when we're working so we don't 
                                 % trigger new callbacks.
        calls_to_ignore = 0;     % Sometimes we ignore callbacks when 
                                 % triggered by callbacks from outside of
                                 % LinePlotReducer.
        
        % Last updated state
        last_width = 0;          % We only update when the width and
        last_lims  = [0 0];      % limits change.
        
        % We need to keep track of the figure listener so that we can
        % delete it later.
        figure_listener;
        
        % We'll delete the figure listener once all of the plots we manage
        % have been deleted (cleared from axes, closed figure, etc.).
        deleted_plots;
        
    end
    
    methods
        
        % Create a ReductiveViewer for the x and y variables.
        function o = gca_fast(varargin)
            
            o.h_figure = gcf;
            o.h_axes = gca;
            o.x_min = -Inf;
            o.x_max = Inf;
            
            idx = 1;
            line_handles = [];
            for a = 1:numel(o.h_axes.Children)
                if strcmp(o.h_axes.Children(a).Type, 'line')
                    if length(o.h_axes.Children(a).XData) > 1e3 % only do this for large lines
                        line_handles(idx) = a;
                        o.x{1,idx} = o.h_axes.Children(a).XData;
                        o.y{1,idx} = o.h_axes.Children(a).YData;
                        o.y_to_x_map(1,idx) = idx;
                        idx = idx + 1;
                    end
                end
            end
            o.h_plot = o.h_axes.Children(line_handles);
            
            % Listen for changes to the x limits of the axes.
            if verLessThan('matlab', '8.4')
                size_cb = {'Position', 'PostSet'};
            else
                size_cb = {'SizeChanged'};
            end
            
            % Listen for changes on the axes.
            linkaxes(o.h_axes, 'x');
            for k = 1:length(o.h_axes)
                addlistener(o.h_axes(k), 'Units', 'PreSet', ...
                            @(~,~) o.UnitsPreSet);
                addlistener(o.h_axes(k), 'XLim',  'PostSet', ...
                            @(~,~) o.RefreshData);
                addlistener(o.h_axes(k), size_cb{:}, ...
                            @(~,~) o.RefreshData);
            end
            
            % Listen for changes on the figure itself.
            o.figure_listener = addlistener(o.h_figure, size_cb{:}, ...
                @(~,~) o.RefreshData);
            
            % Define DeletePlot as Nested Function, so the figure can be deleted 
            % even if LinePlotReducer.m is not on Matlab's search path anymore.
            function DeletePlot(o,k)
                o.deleted_plots(k) = true;
                if all(o.deleted_plots)
                    delete(o.figure_listener);
                end
            end
            
            % When all of our managed plots are deleted, we need to erase
            % ourselves, so we'll keep track when each is deleted.
            for k = 1:length(o.h_plot)
                set(o.h_plot(k), 'DeleteFcn', @(~,~) DeletePlot(o,k));
            end
            o.deleted_plots = false(1, length(o.h_plot));
            
            % Force the drawing to happen now.
            drawnow();

            % No longer busy.
            o.busy = false;
            LinePlotExplorer(o.h_figure);
        end
       
    end
    
    methods
        
        % Redraw all of the data.
        function RefreshData(o)

            % When we set the axes units to 'pixels' and back, it will
            % trigger a callback each time for *both* 'Position' and
            % 'Units' (and in that order). Since we've set up callbacks to
            % trigger after the value is set, we can therefore set up a
            % PreSet callback for 'Units' to tell us to ignore a call.
            if o.calls_to_ignore > 0
                o.calls_to_ignore = o.calls_to_ignore - 1;
                return;
            end
            
            % We can do many things here that trigger additional callbacks,
            % so ignore them until we're done.
            if o.busy || ~all(ishandle(o.h_plot))
                return;
            end

            % We're busy now.
            o.busy = true;
            
            % Get the new limits. Sometimes there are multiple axes stacked
            % on top of each other. Just grab the first. This is really
            % just for plotyy.
            lims = get(o.h_axes(1), 'XLim');

            % Get axes width in pixels.
            width = get_axes_width(o.h_axes(1));
            
            % Just in case...
            if width < 0
                error(['The axes object reported a negative width. ' ...
                       'This is unexpected.']);
            end
            
            % Return if there's nothing to do.
            if width == o.last_width && all(lims == o.last_lims)
                o.busy = false;
                return;
            end
            
            % Record the last values for which we resized the data so we
            % can skip inconsequential updates later.
            o.last_width = width;
            o.last_lims  = lims;
            
            % For all data we manage...
            for k = 1:length(o.h_plot)
                
                % Reduce the data.
                [x_r, y_r] = reduce_to_width(o.x{o.y_to_x_map(k)}(:), ...
                                             o.y{k}(:), ...
                                             width, lims);
                
                % Update the plot.
                set(o.h_plot(k), 'XData', x_r, 'YData', y_r);
                
            end

            % We're no longer busy.
            o.busy = false;
            
        end

        % Setting the units (which we do to change them to 'pixels' and
        % back when getting the axes width) also triggers callbacks for
        % both 'Position' and 'Units' (in that order). We'll want to make
        % sure we ignore 1 request to refresh per call to 'Units'.
        function UnitsPreSet(o, ~, ~)
            
            % Note: In MATLAB 2014b, changing units won't trigger a change
            % in size, so we don't need to do this.
            if verLessThan('matlab', '8.4')
                o.calls_to_ignore = o.calls_to_ignore + 1;
            end
            
        end
                
    end
    
end