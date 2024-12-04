function [XYZ] = wrldmagm(height, lat, lon, dyear, filename )
%WRLDMAGM calculates the Earth's magnetic field at a specific location and
%time using the World Magnetic Model (WMM).

% [XYZ] = WRLDMAGM(HEIGHT, LAT, LON, DYEAR, 'Custom', FILE)
% calculates the Earth's magnetic field using the World Magnetic Model
% defined in the WMM.cof file, FILE. WMM.COF files must be in their original
% form as provided by NOAA (http://www.ngdc.noaa.gov/geomag/WMM/DoDWMM.shtml).

%   Inputs to wrldmagm are:
%   HEIGHT :Scalar value in meters. 
%   LAT    :Scalar geodetic latitude in degrees where north latitude is 
%           positive and south latitude is negative.
%   LON    :Scalar geodetic longitude in degrees where east longitude 
%           is positive and west is negative.
%   DYEAR  :Scalar decimal year.  Decimal year is the desired year in 
%           a decimal format to include any fraction of the year that has 
%           already passed.
%   FILE  :String specifying the WMM coefficient file to use. WMM.COF
%          files must be in their original form as provided by NOAA
%          (http://www.ngdc.noaa.gov/geomag/WMM/DoDWMM.shtml). FILE is
%          available when MODEL is 'Custom'.
%
%   Output calculated by wrldmagm are:
%   XYZ    :Magnetic field vector in nanotesla (nT). 
%
%   Calculate the magnetic model 1000 meters over Natick, Massachusetts on
%   July 4, 2020, using downloaded WMM.COF file:
%      [XYZ, H, D, I, F] = wrldmagm(1000, 42.283, -71.35,...
%          decyear(2020,7,4), 'Custom', 'WMM.COF')

persistent c dc fm fn k maxdef;

[c,dc,epoch,fm,fn,k,maxdef,~] = readWMMCoeff(filename);

% Calculate the time difference from the epoch
dt = dyear - epoch;

maxord = maxdef + 1;

zeroMaxordM = zeros(maxord,maxord);
zeroMaxordA = zeros(1,maxord);
snorm = zeroMaxordM;
dp = zeroMaxordM;
pp = ones(maxord,1);
sp = zeroMaxordA; 
cp = zeroMaxordA;

% convert to kilometers
height = height*0.001;

%WGS84
re = 6371.2;
a = 6378.137;
b = 6356.7523142;

a2 = a*a;
b2 = b*b;
c2 = a2-b2;
a4 = a2*a2;
b4 = b2*b2;
c4 = a4 - b4;

rlon = deg2rad(lon);
rlat = deg2rad(lat);
srlon = sin(rlon);
srlat = sin(rlat);
crlon = cos(rlon);
crlat = cos(rlat);
srlat2 = srlat*srlat;
crlat2 = crlat*crlat;

% convert from geodetic coordinates to spherical coordinates
q = sqrt(a2-c2*srlat2);
q1 = height*q;
q2 = ((q1+a2)/(q1+b2))*((q1+a2)/(q1+b2));
ct = srlat/sqrt(q2*crlat2+srlat2);
st = sqrt(1.0-(ct*ct));
r2 = (height*height)+2.0*q1+(a4-c4*srlat2)/(q*q);
r = sqrt(r2);
d = sqrt(a2*crlat2+b2*srlat2);
ca = (height+d)/r;
sa = c2*crlat*srlat/(r*d);

% Time adjust the Gauss coefficients
tc = c+dt*dc;

cp(1) = 1.0; 
pp(1) = 1.0;
sp(2) = srlon;
cp(2) = crlon;

for m = 3:maxord
    sp(m) = sp(2)*cp(m-1)+cp(2)*sp(m-1);
    cp(m) = cp(2)*cp(m-1)-sp(2)*sp(m-1);
end

% Initial legendre polynomials and derivatives
snorm(1,1) = 1.0; 
snorm(2,1) = ct;
dp(1,1) = 0.0;
dp(1,2) = -st;

aor = re/r;
ar = aor*aor;
br = 0.0; bt = 0.0; bp = 0.0; bpp = 0.0;
for n = 1:maxord-1
    ar = ar*aor;
    for m = 0:n
        %     Compute unnormalized associated legendre polynomials
        %     and derivatives via recursion relations
        if (n == m)
            snorm(n+1, m+1) = st*snorm(n, m);
            dp(m+1, n+1) = st*dp(m, n)+ct*snorm(n, m);
        elseif (n > 1)
            snorm(n+1, m+1) = ct*snorm(n, m+1)-k(m+1, n+1)*snorm(n-1, m+1);
            dp(m+1, n+1) = ct*dp(m+1, n) - st*snorm(n, m+1)-k(m+1, n+1)*dp(m+1, n-1);
        end

        %    Accumulate terms of the spherical harmonic expansions
        par = ar*snorm(n+1, m+1);
        if (m == 0)
            temp1 = tc(m+1, n+1)*cp(m+1);
            temp2 = tc(m+1, n+1)*sp(m+1);
        else
            temp1 = tc(m+1, n+1)*cp(m+1)+tc(n+1, m)*sp(m+1);
            temp2 = tc(m+1, n+1)*sp(m+1)-tc(n+1, m)*cp(m+1);
        end

        bt = bt-ar*temp1*dp(m+1, n+1);
        bp = bp+(fm(m+1)*temp2*par);
        br = br+(fn(n+1)*temp1*par);

        %   Special Case:  North/South geographic poles
        if (st == 0.0 && m == 1)
            if (n == 1)
                pp(n+1) = pp(n);
            else
                pp(n+1) = ct*pp(n)-k(m+1,n+1)*pp(n-1);
            end
            parp = ar*pp(n+1);
            bpp = bpp + (fm(m+1)*temp2*parp);
        end

    end
end
if (st == 0.0)
    bp = bpp;
else
    bp = bp/st;
end

%    Rotate magnetic vector components from spherical to geodetic
%    coordinates

bx = -bt*ca-br*sa;
by = bp;
bz = bt*sa-br*ca;

%   Compute declination (D), inclination (I) & total intensity (F)

bh = sqrt((bx*bx)+(by*by));
F = sqrt((bh*bh)+(bz*bz));
D = atan2(by,bx);
I = atan2(bz,bh);
%   Compute XYZ & H components of the magnetic field

X = F*cos(D)*cos(I);
Y = F*cos(I)*sin(D);
Z = F*sin(I);
XYZ = [X; Y; Z];

end

