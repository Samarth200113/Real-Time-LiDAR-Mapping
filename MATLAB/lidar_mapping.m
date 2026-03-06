%% --- SETTINGS ---
comPort = "COM4"; % <-- change to your Arduino Due COM port
baudRate = 115200;
maxDist = 1000; % max range for display (mm)
%% --- OPEN SERIAL CONNECTION ---
s = serialport(comPort, baudRate);
configureTerminator(s, "LF");
flush(s);
disp("Connected. Starting full 360° RPLIDAR polar plot...");
%% --- SETUP PLOT ---
theta = nan(360,1);
rho = nan(360,1);
figure;
h = polarplot(theta,rho,'.');
rlim([0 maxDist]);
title("Full 360° RPLIDAR Scan");
%% --- READ + PLOT LOOP ---
while ishandle(h)
if s.NumBytesAvailable > 0
try
% Read one line of CSV: angle,distance,quality
line = readline(s);
vals = str2double(strsplit(strtrim(line), ","));
if numel(vals) == 3
ang = round(vals(1)); % nearest degree
dist = vals(2);
quality = vals(3);
% Accept valid distances
if ang >= 0 && ang <= 359 && dist > 0
theta(ang+1) = deg2rad(ang);
rho(ang+1) = dist;
end
end
catch ME
warning("Parse error: %s", ME.message);
end
end
% Once we collected a full circle -> update plot
if all(~isnan(rho))
set(h, 'ThetaData', theta, 'RData', rho);
rlim([0 max(rho)+100]); % auto-scale with margin
drawnow;
% Reset for next revolution
theta(:) = nan;
rho(:) = nan;
end
end
%% --- CLEANUP ---
clear s
disp("Serial closed.");
