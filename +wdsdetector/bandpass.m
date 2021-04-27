function y_out = bandpass(y_in, fs, varargin)
%BANDPASS Filter data with a bandpass FIR filter
%
% SYNTAX:
%   y_out = bandpass(y_in, fs)
%   y_out = bandpass(y_in, fs, 'ArgumentName', Value, ...)
%
% INPUTS:
%   y_in    - Data vector (column, double precision).
%   fs      - Sample rate in Hz.
%
% OPTIONAL INPUT ARGUMENT-VALUE PAIRS:
%   'passband'    - Passband frequencies [low high] in Hz. Default=[8 32].
%   'filterorder' - Filter order. Default=fs/2.
%
% OUTPUTS:
%   y_out   - Filtered data vector.

% Check input:
narginchk(2,Inf)
validateattributes(y_in, 'double', {'column'})
validateattributes(fs, 'numeric', {'scalar' 'positive'})

% Default values:
if fs/2<32
    passband = [8 fs/2.01]; % Has to be less than the Nyquist frequency.
else
    passband = [8 32];
end
filterorder = round(fs/2);

% Optional input:
if mod(length(varargin),2) % Check if the optional inputs come in pairs.
    error('Incomplete property-value pairs!');
else
    for i = 1:2:length(varargin) % Loop over pairs...
        switch lower(varargin{i})
            % Passband
            case 'passband'
                passband = varargin{i+1};
            % Filter order
            case 'filterorder'
                filterorder = varargin{i+1};
        end
    end
end

% Check filter frequency:
if passband(2)*2>fs
    error('The upper limit of the passband must be less than half the sample rate.')
end

% Calculate the filter coefficients:
b = fir1(filterorder,[passband(1)*2/fs passband(2)*2/fs]);

% Handle NaNs (but not dealing with edge effects):
bNan = isnan(y_in);
if any(bNan(:))
    warning('NaNs treated like zeros.')
    y_in(bNan) = 0;
end

% Filter the signal (forward & backward):
y_out = filtfilt(b,1,y_in);

% Put back NaNs:
y_out(bNan) = NaN;
