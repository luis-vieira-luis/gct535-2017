function out=psola(in,m,alpha,beta)
% The following code is borrowed from the original MATLAB code provided
% with the DAFX book (2nd Edition).
%
% psola.m
% Authors: G. De Poli, U. Z?lzer, P. Dutilleux
%     in    input signal
%     m     pitch marks
%     alpha time stretching factor
%     beta  pitch shifting factor
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------

P = diff(m);   %compute pitch periods

if m(1)<=P(1), %remove first pitch mark
    m=m(2:length(m));
    P=P(2:length(P));
end

if m(length(m))+P(length(P))>length(in) %remove last pitch mark
    m=m(1:length(m)-1);
else
    P=[P P(length(P))];
end

Lout=ceil(length(in)*alpha);
out=zeros(1,Lout); %output signal

tk = P(1)+1;       %output pitch mark

while round(tk)<Lout
    [minimum i] = min( abs(alpha*m - tk) ); %find analysis segment
    pit=P(i);
    if m(i)+pit > length(in)
        in = [in; zeros(m(i)+pit - length(in),1)];
    end
    st=m(i)-pit;
    en=m(i)+pit;
    gr = in(st:en) .* hanning(2*pit+1);
    iniGr=round(tk)-pit;
    endGr=round(tk)+pit;
    if endGr>Lout, break; end
    out(iniGr:endGr) = out(iniGr:endGr)+gr'; %overlap new segment
    tk=tk+pit/beta;
end