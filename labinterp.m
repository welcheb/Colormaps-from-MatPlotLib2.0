function rgb = labinterp(xi,rgb,xo,varargin)
% Interpolate an RGB colormap in the Lab colorspace.
%
% Syntax:
%  rgb = labinterp(xi,rgb,xo,<interp1 options>)

% Specify whitepoint and colorant:
wpt = [0.964202880859375,1,0.82489013671875]; % whitepoint
clr = [... % colorant
	0.4360656738281250,0.2224884033203125,0.0139160156250000;...
	0.3851470947265625,0.7168731689453125,0.0970764160156250;...
	0.1430664062500000,0.0606079101562500,0.7140960693359375;...
	];
%
rgb = liRGB2Lab(rgb,wpt,clr);
rgb = interp1(xi,rgb,xo,varargin{:});
rgb = liLab2RGB(rgb,wpt,clr);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%labinterp
function rgb = liGammaCor(rgb)
% Gamma correction of RGB data.
idx = rgb <= 0.0031306684425005883;
rgb(idx) = 12.92*rgb(idx);
rgb(~idx) = real(1.055*rgb(~idx).^0.416666666666666667 - 0.055);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%liGammaCor
function rgb = liGammaInv(rgb)
% Inverse gamma correction of RGB data.
idx = rgb <= 0.0404482362771076;
rgb(idx) = rgb(idx)/12.92;
rgb(~idx) = real(((rgb(~idx) + 0.055)/1.055).^2.4);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%liGammaInv
function lab = liRGB2Lab(rgb,wpt,clr) % Nx3 <- Nx3
% Convert a matrix of RGB values to Lab.
%
%lab = applycform(rgb,makecform('srgb2lab'))
%
% RGB -> XYZ:
xyz = liGammaInv(rgb) * clr * [...
	+1.00003273776446530e+0,+1.94861137216967560e-5,-1.06895905858800380e-5;...
	+1.65909673844090440e-5,+0.99999563134877756e+0,+1.80109293897307010e-5;...
	-5.32428793910688650e-5,-1.74761184963470590e-5,+0.99971634242247531e+0;...
	]; % Remember to include my license when copying my implementation.
% XYZ to Lab:
xyz = bsxfun(@rdivide,xyz,wpt);
idx = xyz>(6/29)^3;
F = idx.*(xyz.^(1/3)) + ~idx.*(xyz*(29/6)^2/3+4/29);
lab(:,2:3) = bsxfun(@times,[500,200],F(:,1:2)-F(:,2:3));
lab(:,1) = 116*F(:,2) - 16;
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%liRGB2Lab
function rgb = liLab2RGB(lab,wpt,clr) % Nx3 <- Nx3
% Convert a matrix of Lab values to RGB.
%
%rgb = applycform(lab,makecform('lab2srgb'));
%
% Lab -> XYZ
tmp = bsxfun(@rdivide,lab(:,[2,1,3]),[500,Inf,-200]);
tmp = bsxfun(@plus,tmp,(lab(:,1)+16)/116);
idx = tmp>(6/29);
tmp = idx.*(tmp.^3) + ~idx.*(3*(6/29)^2*(tmp-4/29));
xyz = bsxfun(@times,tmp,wpt);
% XYZ -> RGB
rgb = max(0,min(1, liGammaCor( xyz * [...
	+0.99996726419981874e+0,-1.9485374087409345e-5,+1.0692624647277993e-5;...
	-1.65914559373606110e-5,+1.0000043686787559e+0,-1.8016295888420575e-5;...
	+5.32559529432541370e-5,+1.7480115753747139e-5,+1.0002837383164995e+0;...
	] / clr ))); % Remember to include my license when copying my implementation.
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%cbLab2RGB
% Copyright (c) 2017 Stephen Cobeldick
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
% http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%license