function y_out = calculate_index(y_in, fs, varargin)
%CALCULATE_INDEX Calculate wet dog shake index
%
% SYNTAX:
%   y_out = calculate_wds_index(y_in, fs)
%   y_out = calculate_wds_index(y_in, fs, 'ArgumentName', Value, ...)
%
% INPUTS:
%   y_in    - Data vector (column, double precision).
%   fs      - Sample rate in Hz.
%
% OPTIONAL INPUT ARGUMENT-VALUE PAIRS:
%   'winlength' - Window length for smoothing. Default=fs/4.
%
% OUTPUTS:
%   y_out   - Filtered data vector.

% Check input:
narginchk(2,Inf)
validateattributes(y_in, 'double', {'column'})
validateattributes(fs, 'numeric', {'scalar' 'positive'})

% Default values:
winlength = round(fs/4);     % Convolution window length.

% Optional input:
if mod(length(varargin),2) % Check if the optional inputs come in pairs.
    error('Incomplete property-value pairs!');
else
    for i = 1:2:length(varargin) % Loop over pairs...
        switch lower(varargin{i})
            % Window length
            case 'winlength'
                winlength = varargin{i+1};
        end
    end
end

% Create Gaussian window:
win = gausswin(winlength);

% Convolute:
y_out = conv(abs(y_in), win, 'same') / sum(win);