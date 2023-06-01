duke;
SNList=[1,3:20];
Subject = struct([]);
Subject(1).Name = 'D1'; Subject(1).Day = '260216'; Subject(1).Fname='D1.edf'; Subject(1).Chans=[2:65];
Subject(3).Name = 'D3'; Subject(3).Day = '100916'; Subject(3).Fname='greg.edf'; Subject(3).Chans=[2:53];
Subject(4).Name = 'D4'; Subject(4).Day=[]; Subject(4).Fname='greg_2004.edf'; Subject(4).Chans=[28:129];
Subject(5).Name = 'D5'; Subject(5).Day=[]; Subject(5).Fname='greg_2005.edf'; Subject(5).Chans=[94:129];
Subject(6).Name = 'D6'; Subject(6).Day=[]; Subject(6).Fname='greg_2006.edf'; Subject(6).Chans=[34:129];
Subject(7).Name = 'D7'; Subject(7).Day = '030117'; Subject(7).Fname='greg_2007.edf'; Subject(7).Chans=[28:129];
Subject(8).Name = 'D8'; Subject(8).Day = '030317'; Subject(8).Fname='greg_2008.edf'; Subject(8).Chans=[20:129];
Subject(9).Name = 'D9'; Subject(9).Day = []; Subject(9).Fname='greg_2009_sess_1.edf'; Subject(9).Chans=[10:129];
Subject(10).Name = 'D10'; Subject(10).Day = [];Subject(10).Fname='greg_lexi.edf'; Subject(10).Chans=[48:129];
Subject(11).Name = 'D11'; Subject(11).Day = [];Subject(11).Fname='greg_lexi.edf'; Subject(11).Chans=[12:129];
Subject(12).Name = 'D12'; Subject(12).Day = '090917';Subject(12).Fname='greg_lexi.edf'; Subject(12).Chans=[20:129];
Subject(13).Name = 'D13'; Subject(13).Day = '071017'; Subject(13).Fname='greg_lexi.edf'; Subject(13).Chans=[2:95];
Subject(14).Name = 'D14'; Subject(14).Day = '101117'; Subject(14).Fname='greg_lexi.edf'; Subject(14).Chans=[10:129];
Subject(15).Name = 'D15'; Subject(15).Day = '171217'; Subject(15).Fname='greg_lexi.edf'; Subject(15).Chans=[10:129];
Subject(16).Name = 'D16'; Subject(16).Day = '200118'; Subject(16).Fname='greg_lexi.edf'; Subject(16).Chans=[89:129];
Subject(17).Name = 'D17'; Subject(17).Day = '180309'; Subject(17).Fname='greg_lexi_2017.edf'; Subject(17).Chans=[16:129];
Subject(18).Name = 'D18'; Subject(18).Day = []; Subject(18).Fname='greg_lexi_long_2018.edf'; Subject(18).Chans=[8:129];
Subject(19).Name = 'D19'; Subject(19).Day = []; Subject(19).Fname='greg_lexical_within_block_2019.edf'; Subject(19).Chans=[54:129];
Subject(20).Name = 'D20'; Subject(20).Day = '180518';Subject(20).Fname='greg_lexi_within_block_2020.edf'; Subject(20).Chans=[10:129];
for iSN=1:length(SNList);
filename=[DUKEDIR '\' Subject(SNList(iSN)).Name '\' Subject(SNList(iSN)).Fname];
[header, data] = edfread(filename, 'machinefmt', 'ieee-le');
Subject(SNList(iSN)).Header=header;
data=data-mean(data(Subject(SNList(iSN)).Chans,:)); % remove grand average?
Subject(SNList(iSN)).Data=mean(sqrt(data.^2),2); % RMS
display(iSN)
end




Gidx=[1,3,5,6,7,10,11,16]; % Grid Index
Sidx=[4,8,9,12,13,14,15,17,18,19,20]; % SEEG index

Gvals=[];
Svals=[];
for iG=1:length(Gidx);
    Gvals=cat(1,Gvals,Subject(Gidx(iG)).Data(Subject(Gidx(iG)).Chans));
end

for iS=1:length(Sidx);
    Svals=cat(1,Svals,Subject(Sidx(iS)).Data(Subject(Sidx(iS)).Chans));
end


actval=mean(Gvals)-mean(Svals);
catval=cat(1,Gvals,Svals);

for iPerm=1:10000;
    sidx=shuffle(1:size(catval,1));
    permvals(iPerm)=mean(catval(sidx(1:length(Gvals))))-mean(catval(sidx(length(Gvals)+1:end)));
end
[m s]=normfit(permvals);
actval_z=(actval-m)./s
