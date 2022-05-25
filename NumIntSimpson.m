% Numerical Integration
% compares Simpson's Rule to the Trapezoidal Rule

%% default parameters
lowerLim = 903.5;
upperLim = 919.5;
dirData = strcat(pwd, '\test data');    % start in current folder, add subfolder

%% read data, display details 
msg = 'Input Data File ...';
[inpPathname, inpFilename, header, xRaw, dx, yRaw] = readTxtFile(dirData, msg);
xMin = min(xRaw); xMax = max(xRaw);
Npt = length(xRaw);
fprintf('\tData: %s\n\tHeader: %s\n\t# data points: %d\n\tx range: %.2f - %.2f, with spacing %0.2f\n', ...
    fullfile(inpPathname, inpFilename), header, Npt, xMin, xMax, dx);
fprintf('\n');

%% specify integration limits
dummy = input(sprintf('Enter the lower integration limit (default %0.2f): ', lowerLim));
if ~isempty(dummy) 
    if ( dummy >= xMin ) && ( dummy < xMax ) 
        lowerLim = dummy;
    elseif ( lowerLim >= xMin ) && ( lowerLim < xMax ) 
        fprintf('\tUsing default value\n');
    else
        lowerLim = xMin;
        fprintf('\tOut of range - using minimum value\n');
    end
else
    if ( lowerLim >= xMin ) && ( lowerLim < xMax ) 
        fprintf('\tUsing default value\n');
    else
        lowerLim = xMin;
        fprintf('\tOut of range - using minimum value\n');
    end
end

dummy = input(sprintf('Enter the upper integration limit (default %0.2f): ', upperLim));
if ~isempty(dummy)
    if ( dummy > lowerLim ) && ( dummy <= xMax )
        upperLim = dummy; 
    elseif ( upperLim > lowerLim ) && ( upperLim <= xMax )
        fprintf('\tUsing default value\n');
    else
        upperLim = xMax;
        fprintf('\tOut of range - using maximum value\n');
    end
else
    if ( upperLim > lowerLim ) && ( upperLim <= xMax )
        fprintf('\tUsing default value\n');
    else
        upperLim = xMax;
        fprintf('\tOut of range - using maximum value\n');
    end
end

%% truncate data and calculate integral
xInt = xRaw(xRaw >= lowerLim & xRaw <= upperLim);
yInt = yRaw(xRaw >= lowerLim & xRaw <= upperLim);

trap = trapz(xInt, yInt);        % MATLAB function, corrects for non-unit spacing
[method, simp] = Simpson(xInt, yInt);

%% print results
fprintf('\n')
fprintf('Integrate from %0.2f - %0.2f:\n', min(xInt), max(xInt))
fprintf('(%d segments, %d data pts)\n', length(xInt)-1, length(xInt))
fprintf('\tTrapezoidal Rule: %0.6f\n', trap)   
fprintf('\t%s: %0.6f\n', method, simp)
fprintf('\tDelta = %f ppm\n', (trap-simp)/trap*1E6)

%% plot results
figure(399); clf; set(399,'Name','Numerical Integration');
ax = gca;
plot(xRaw,yRaw)
ylim auto
hold on
hh = plot([lowerLim,lowerLim],[ax.YLim(1),ax.YLim(2)],[upperLim,upperLim],[ax.YLim(1),ax.YLim(2)]); 
hh(1).LineStyle = '--';  hh(1).LineWidth = 1.0;  hh(1).Color = 'r';
hh(2).LineStyle = '--';  hh(2).LineWidth = 1.0;  hh(2).Color = 'r';
title(sprintf('limits: %0.2f - %0.2f, dx = %0.2f, Trapz = %.6G, %s = %.6G', lowerLim, upperLim, dx, trap, method, simp))
plotbrowser 'on'
