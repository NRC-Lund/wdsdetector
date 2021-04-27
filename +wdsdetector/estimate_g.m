function g = estimate_g(y_in)
%ESTIMATE_G Estimate Earth gravity
%
% SYNTAX:
%   g = estimate_g(y_in)
%
% INPUTS:
%   y_in  - Data vector (column, double precision).
%
% OUTPUTS:
%   g     - Earth gravity in accelerometer units.

% Check input:
narginchk(1,1)
validateattributes(y_in, 'double', {'column'})

% Estimate g:
g = norm(nanmedian(y_in));