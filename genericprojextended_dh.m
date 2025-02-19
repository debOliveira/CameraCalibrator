function m=genericprojextended_dh(X,p,R,t)
% m=genericprojextended(X,p,R,t)
%
% GENERICPROJEXTENDED projects points using the generic camera model
% with additional symmetric and asymmetric parameters
%
% input:
%   X = [X Y Z], world coordinates
%   p = internal camera parameters
%   R = rotation matrix
%   t = translation vector, Xc'=R*X'+t
%
% output:
%   m = [u v], projected points in pixel coordinates
% 

% Copyright (C) 2004 Juho Kannala
%
% This software is distributed under the GNU General Public
% Licence (version 2 or later); please refer to the file
% Licence.txt, included with the software, for details.

n=size(X,1);

PLEN=length(p);
if PLEN<23
  p(23)=0;
end

k1=1; k2=p(2); mu=p(3); mv=p(4); u0=p(5); v0=p(6);
k3=p(7); k4=p(8); k5=p(9); 
i1=p(10); i2=p(11); i3=p(12);
j1=p(13); j2=p(14); j3=p(15); 
l1=p(16); l2=p(17); l3=p(18); l4=p(19);
m1=p(20); m2=p(21); m3=p(22); m4=p(23);

Xc=R*X'+t*ones(1,n);
Xc=Xc';

theta=acos(Xc(:,3)./sqrt(Xc(:,1).^2+Xc(:,2).^2+Xc(:,3).^2));

rXc=sqrt(Xc(:,1).^2+Xc(:,2).^2);
% do this to avoid dividing by zero
rzero=find(rXc==0);
rXc(rzero)=1;

cosphi=Xc(:,1)./rXc;
sinphi=Xc(:,2)./rXc;

r=k1*theta+k2*theta.^3+k3*theta.^5+k4*theta.^7+k5*theta.^9;

if PLEN<23
  dt=0;dr=0;
else  %考虑不对称的径向畸变
  cos2phi=2*(cosphi.^2)-1;
  sin2phi=2*cosphi.*sinphi;
  dt=(i1*theta+i2*theta.^3+i3*theta.^5).*...
     (l1*cosphi+l2*sinphi+l3*cos2phi+l4*sin2phi);
  dr=(j1*theta+j2*theta.^3+j3*theta.^5).*...
     (m1*cosphi+m2*sinphi+m3*cos2phi+m4*sin2phi);
end

%ur=[cosphi; sinphi];
%ut=[-sinphi; cosphi];

%rsize=size(r)
%drsize=size(dr)
%dtsize=size(dt)
if PLEN<23
  x=(r).*cosphi;
  y=(r).*sinphi;
else
  x=(r+dr).*cosphi-dt.*sinphi;
  y=(r+dr).*sinphi+dt.*cosphi;
end

u=mu*x+u0;
v=mv*y+v0;

m=[u v];
