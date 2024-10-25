function mu_filter(ds)
% Bandpass filter the data to get MU activity
% between 250 and 5250 Hz

%au_in=['/cdrom/',ds,'/',ds,'.raw.au'];
au_in=[ds,'.raw.au'];
au_fout=[ds,'.mu.ft.au'];
au_out=[ds,'.mu.au'];
h=auhead(au_in);
sampling=h.rate;
filter=mtfilt([128./sampling,2500],sampling,2750);
b=filter;
a=[1,zeros(1,length(b)-1)];
aufilter(b,a,au_in,au_fout,'filter=mtfilt([128./sampling,2750])');
ausnip(au_fout,au_out,[length(b)./2-1,-length(b)./2-1,0]);
unix(['rm ',au_fout]);


