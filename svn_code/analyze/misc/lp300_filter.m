function lp300_filter(ds)
%Here is the code that low pass filters the data.

%au_in=['/cdrom/',ds,'/',ds,'.raw.au'];
au_in=[ds,'.raw.au'];
au_snout=[ds,'.lp300.sn.au'];
au_fout=[ds,'.lp300.ft.au'];
au_dout=[ds,'.lp300.ds.au'];
h=auhead(au_in);
sampling=h.rate;
filter=mtfilt([4./300.,4,7],0.,sampling);
b=filter;
a=[1,zeros(1,length(b)-1)];
aufilter(b,a,au_in,au_fout,'filter=mtfilt([4./300.,4.,7])');
ausnip(au_fout,au_snout,[length(b)./2,-length(b)./2,0]);
unix(['rm ',au_fout]);
audownsample(au_snout,au_dout,sampling./1000);
unix(['rm ',au_snout]);

