function [pks, ix] = extract_detections(y_in, fs, varargin)
%EXTRACT_DETECTIONS Extract detections from the WDS index
%
% SYNTAX:
%   [pks, loc] = detect(y_in, fs)
%   [pks, loc] = detect(y_in, fs, 'ArgumentName', Value, ...)
%
% INPUTS:
%   y_in    - Data vector (column, double precision).
%   fs      - Sample rate in Hz.
%
% OPTIONAL INPUT ARGUMENT-VALUE PAIRS:
%   'threshold' - Threshold. Default=0.4
%   'deadtime'  - Dead time of the detector in seconds. Default=1
%
% OUTPUTS:
%   pks     - Peak values.
%   ix      - Detection times as indices of y_in.

% Check input:
narginchk(2,Inf)
validateattributes(y_in, 'double', {'column'})
validateattributes(fs, 'numeric', {'scalar' 'positive'})

% Default values:
threshold = 0.4;
deadtime = 1;

% Optional input:
if mod(length(varargin),2) % Check if the optional inputs come in pairs.
    error('Incomplete property-value pairs!');
else
    for i = 1:2:length(varargin) % Loop over pairs...
        switch lower(varargin{i})
            % Detection threshold
            case 'threshold'
                threshold = varargin{i+1};
            % Detector dead time
            case 'deadtime'
                deadtime = varargin{i+1};
        end
    end
end

% Find peaks:
[pks, ix] = findpeaks(y_in, 'MinPeakHeight', threshold, ...
    'MinPeakDistance', deadtime*fs);