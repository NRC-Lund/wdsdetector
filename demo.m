% Load accelerometer data:
L = load('accelerometer_data.mat');
y = L.y;    % Column1=AP, Colum2=DV, Column3=ML
fs = L.fs;  % Sample rate in Hz.

% Normalize to Earth gravity:
g = wdsdetector.estimate_g(L.y); % Estimate g.
y = y/g;                         % Now y is expressed in units of g. This 
                                 % makes it easier to set the threshold for
                                 % the detector.

% Find wet dog shakes:
threshold = 0.3;
y_bp = wdsdetector.bandpass(y(:,3), fs);        % Bandpass the mediolateral dimension with default values.
y_wds = wdsdetector.calculate_index(y_bp, fs);  % Calculate WDS index with default values.
[pks, ix] = wdsdetector.extract_detections(y_wds, fs, 'threshold', threshold); % Get WDS timestamps.

% Plot:
figure(1)
clf
h_ax(1) = subplot(3,1,1);
plot(y(:,3))
ylabel('Acceleration [g]')
title('Raw mediolateral acceleration')
h_ax(2) = subplot(3,1,2);
plot(y_bp)
ylabel('Acceleration [g]')
title('Bandpassed mediolateral acceleration')
h_ax(3) = subplot(3,1,3);
plot(y_wds)
hold on
plot([1 numel(y_wds)], [threshold threshold], '--k')
plot(ix, pks, 'd')
hold off
ylabel('WDS index')
title('WDS detections')
linkaxes(h_ax, 'x')