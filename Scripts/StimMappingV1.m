% D32
elecs=list_electrodes('D32');
% Stim
grouping_idx=zeros(length(elecs),1);
%5 = difficulty speaking (orange)
%3 = language (yellow)
grouping_idx([63:66])=5; % LMMT 5:8 difficulty speaking, 66 = PROD 124:127 OK
grouping_idx([137:139])=5; %  LPMT 1:3 difficulty speaking, 139 = AUD 132 OK
grouping_idx([129,130])=5; % LPI 9, 10 difficulty speaking 83,84 OK

grouping_idx([149,151:156])=3; % LPST 1:8 language, 149,151 PROD, 152 AUD, 153 PRODD, 99:106 OK
grouping_idx([117,118])=3; % LPIT 9,10 language, PROD PROD 150,151 OK
grouping_idx([73:76])=3; % LMST 3:6 language, 93:96 OK
cfg.elec_size=100;
cfg.show_labels=0;
cfg.hemisphere='l';
plot_subj_grouping(elecs,grouping_idx,cfg);

% HG
%2 = AUD
%1 = PRODD
%4 = PROD
%3 = D
grouping_idx=zeros(length(elecs),1);
%grouping_idx([63:66])=4; % LMMT 5:8 difficulty speaking, 66 = PROD 124:127
grouping_idx([66]) = 2; % Aud superceds Prod
grouping_idx([63:65])=22; % NA
%66 
%64 
%65 
%66 P A
%grouping_idx([137:139])=4; %  LPMT 1:3 difficulty speaking, 139 = AUD 132
grouping_idx([139])=1;
grouping_idx([137:138])=22;
% 137 NA
% 138 NA
% 139 %D ish P
%grouping_idx([129,130])=4; % LPI 9, 10 difficulty speaking 83,84
grouping_idx([129,130])=1;
% 129 %D ish P
% 130 %D ish P
%grouping_idx([149,151:156])=3; % LPST 1:8 language, 149,151 PROD, 152 AUD, 153 PRODD, 99:106
grouping_idx([149])=4;
grouping_idx([151,152,153,154,155,156])=1;
% 149 P 
% 151 D ish P 
% 152 D ish P
% 153 D P
% 154 D ish P
% 155 D P
% 156 D P
%grouping_idx([117,118])=3; % LPIT 9,10 language, PROD PROD 150,151
grouping_idx([117,118])=4;
% 117 P
% 118 Pish
%grouping_idx([73:76])=3; % LMST 3:6 language, 93:96
grouping_idx([73:76])=1;
% 73 D P
% 74 D P
% 75 D P
% 76 D P
cfg.elec_size=100;
cfg.show_labels=0;
cfg.hemisphere='l';
plot_subj_grouping(elecs,grouping_idx,cfg);



% D59
elecs=list_electrodes('D59');
% Stim
grouping_idx=zeros(length(elecs),1);
%5 = difficulty speaking (orange)
%3 = language (yellow)
grouping_idx([84,85])=5; % LMPF 14 15, delay speaking can't say...
grouping_idx([116:120])=3; %LAIP 11:15 expressive vs receptive aphasia
grouping_idx([165:170])=5; % LMMT 1:6 difficulty speaking

cfg.elec_size=100;
cfg.show_labels=0;
cfg.hemisphere='l';
plot_subj_grouping(elecs,grouping_idx,cfg);

% HG
%2 = AUD
%1 = PRODD
%4 = PROD
%3 = D
grouping_idx=zeros(length(elecs),1);
%grouping_idx([84,85])=5; % LMPF 14 15, delay speaking can't say... 66,67
grouping_idx([84])=22;
grouping_idx([85])=1;
% 84 
% 85 DP
%grouping_idx([116:120])=3; %LAIP 11:15 expressive vs receptive aphasia 118:122
grouping_idx([116])=1;
grouping_idx([117:120])=22;
% 116 D P ish
% 117 
% 118 
% 119
% 120
%grouping_idx([165:170])=5; % LMMT 1:6 difficulty speaking 137:141
grouping_idx([165:170])=2;
% 165 A
% 166 A
% 167 A
% 168 A
% 169 A
% 170 A


cfg.elec_size=100;
cfg.show_labels=0;
cfg.hemisphere='l';
plot_subj_grouping(elecs,grouping_idx,cfg);



% D64
elecs=list_electrodes('D64');
% Stim
grouping_idx=zeros(length(elecs),1);
%5 = difficulty speaking (orange)
%3 = language (yellow)
grouping_idx([36,37])=5; % LAST 8,9, receptive language
grouping_idx([121:122])=3; %LAIT 3:4 expressive aphasia
grouping_idx([51,60])=3; % LMMT 1,10 hearing

cfg.elec_size=100;
cfg.show_labels=0;
cfg.hemisphere='l';
plot_subj_grouping(elecs,grouping_idx,cfg);

% HG
%2 = AUD
%1 = PRODD
%4 = PROD
%3 = D
grouping_idx=zeros(length(elecs),1);
%grouping_idx([36,37])=5; % LAST 8,9, receptive language 90,91
grouping_idx([36])=22;
grouping_idx([37])=2;
% 36 
% 37 D P A
%grouping_idx([121:122])=3; %LAIT 3:4 expressive aphasia 152,153
grouping_idx([121:122])=22;
% 121 
% 122
%grouping_idx([51,60])=3; % LMMT 1,10 hearing 126,135
grouping_idx([51])=22;
grouping_idx([60])=1;
% 51
% 60 D P A
cfg.elec_size=100;
cfg.show_labels=0;
cfg.hemisphere='l';
plot_subj_grouping(elecs,grouping_idx,cfg);
