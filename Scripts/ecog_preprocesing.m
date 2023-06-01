
%% first create a subject folder, e.g. D29/lexical_dr_2x_within_nodelay/part1/ and place task .edf file there
% create a subject case below and fill in variables
clear;
subj_task = 'D45_008';
trigger_chan_index = [];
mic_chan_index = [];

%TASKS	
% 001	Lexical Delay 
% 002	Lexical No Delay 
% 003	Sentence Rep
% 004	Phoneme Sequencing
% 005	Uniqueness Point
% 006	Neighborhood_Sternberg
% 007	Environmental_Sternberg
% 008	Timit


switch subj_task
    case 'D3_003'
        cd(fullfile(BOX_DIR, "CoganLab", "D_Data", "SentenceRep", "D3"))
        taskstim = 'sentence_rep';
        subj = 'D3';
        edf_filename = 'D3_160910_COGAN_SENTENCEREP.EDF';
        ptb_trialInfo = '160910\mat\trialInfo.mat';
        taskdate = '160910'; %% YYMMDD
        ieeg_prefix = 'D3_Sentence_Rep_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index  % determined by looking at h
        mic_chan_index 
        neural_chan_index 


    case 'D16_003'
        cd(fullfile(BOX_DIR, "CoganLab", "D_Data", "SentenceRep", "D16"))
        taskstim = 'sentence_rep';
        subj = 'D16';
        edf_filename = 'D16 180123 COGAN_SENTENCEREP.EDF';
        ptb_trialInfo = '180123\mat\trialInfo.mat';
        taskdate = '180123'; %% YYMMDD
        ieeg_prefix = 'D16_Sentence_Rep_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index  % determined by looking at h
        mic_chan_index 
        neural_chan_index 

      case 'D20_001'
        cd 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D20\'
        taskstim = 'lexical';
        subj = 'D20';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D20\greg_lexi_within_block_2020.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D20\D20_Block_1_TrialData.mat'; 
        taskdate = '180518';
        ieeg_prefix = 'D20_LexicalDecRepDelay_';
        rec = '001';
        trigger_chan_index = 1;
        mic_chan_index = 3;
        neural_chan_index = [10:129]; 
        
     case 'D22_001'
        cd 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D22\'
        taskstim = 'lexical';
        subj = 'D22';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D22\greg_lexi_withinblock_D22.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D22\D22_Block_1_TrialData.mat';
        taskdate = '180627';
        ieeg_prefix = 'D22_LexicalDecRepDelay_';
        rec = '001';
        trigger_chan_index = 104;
        mic_chan_index = 106;
        neural_chan_index = [2:101];      

     case 'D23_001'
        cd 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D23\'
        taskstim = 'lexical';
        subj = 'D23';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D23\greg_lexi_withinblock_D23.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D23\D23_Block_1_TrialData.mat';
        taskdate = '180713';
        ieeg_prefix = 'D23_LexicalDecRepDelay_';
        rec = '001';
        trigger_chan_index = 125;
        mic_chan_index = 127;
        neural_chan_index = [2:122];      
        
        case 'D24'
        cd 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D24\'
        taskstim = 'lexical';
        subj = 'D24';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D24\greg_lexical_decision_repeat_within_delay_2x_D24.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D24\D24_Block_1_TrialData.mat';
        taskdate = '181027';
        ieeg_prefix = 'D24_LexicalDecRepDelay_';
        rec = '001';
        trigger_chan_index = 56;
        mic_chan_index = 58;
        neural_chan_index = [2:53]; 
        
        case 'D25_001'
        cd 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D25\'
        taskstim = 'lexical';
        subj = 'D25';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D25\greg_lexical_decision_repeat_within_delay_2x_D25.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D25\D25_Block_1_TrialData.mat';
        taskdate = '181212';
        ieeg_prefix = 'D25_LexicalDecRepDelay_';
        rec = '001';
        trigger_chan_index = 120;
        mic_chan_index = 128;
        neural_chan_index = [2:119 122:125];
    
       case 'D25'
        cd 'H:\Box Sync\CoganLab\D_Data\Phoneme_Sequencing\D25\'
        taskstim = 'phoneme';
        subj = 'D25';
        edf_filename = 'H:\Box Sync\CoganLab\ECoG_Task_Data\Cogan_EDF\greg_phoneme_seq_D25.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\ECoG_Task_Data\Cogan_Task_Data\D25\Phoneme Sequencing\D25_20181207T144520\D25_Block_4_TrialData.mat';
        taskdate = '181207';
        ieeg_prefix = 'D35_PhonemeSequencing_';
        rec = '001';
        trigger_chan_index = 120;
        mic_chan_index = 128;
        neural_chan_index = [2:119 122:125];
        
      case 'D26_001_01'
        cd 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D26\'
        taskstim = 'lexical';
        subj = 'D26';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D26\greg_lexical_decision_repeat_within_delay_2x_D26_part1.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D26\D26_Block_1_TrialData.mat';
        taskdate = '190125';
        ieeg_prefix = 'D26_LexicalDecRepDelay_001_';
        rec = '001';
        trigger_chan_index = 64;
        mic_chan_index = 66;
        neural_chan_index = [2:61]; 
        
      case 'D26_001_02'
        cd 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D26\'
        taskstim = 'lexical';
        subj = 'D26';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D26\greg_lexical_decision_repeat_within_delay_2x_D26_part2.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D26\D26_Block_2_TrialData.mat';
        taskdate = '190125';
        ieeg_prefix = 'D26_LexicalDecRepDelay_002_';
        rec = '002';
        trigger_chan_index = 64;
        mic_chan_index = 66;
        neural_chan_index = [2:61];  
 
       case 'D26_001_03'
        cd 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D26\'
        taskstim = 'lexical';
        subj = 'D26';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D26\greg_lexical_decision_repeat_within_delay_2x_D26_part3.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D26\D26_Block_3_TrialData.mat';
        taskdate = '190125';
        ieeg_prefix = 'D26_LexicalDecRepDelay_003_';
        rec = '003';
        trigger_chan_index = 64;
        mic_chan_index = 66;
        neural_chan_index = [2:61];     

  case 'D26_001_04'
        cd 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D26\'
        taskstim = 'lexical';
        subj = 'D26';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D26\greg_lexical_decision_repeat_within_delay_2x_D26_part4.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D26\D26_Block_4_TrialData.mat';
        taskdate = '190125';
        ieeg_prefix = 'D26_LexicalDecRepDelay_004_';
        rec = '004';
        trigger_chan_index = 64;
        mic_chan_index = 66;
        neural_chan_index = [2:61];     
 
 case 'D27_001'
        cd 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D27\'
        taskstim = 'lexical';
        subj = 'D27';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D27\D27 190304 Cogan_LexicalRepeatWithin2XDelay.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D27\D27_Block_1_TrialData.mat';
        taskdate = '190304';
        ieeg_prefix = 'D27_LexicalDecRepDelay_';
        rec = '001';
        trigger_chan_index = 60;
        mic_chan_index = 125;
        neural_chan_index = [2:59,66:121];     

 case 'D27_002'
        cd 'E:\InUnit Preprocessing\D27\Environmental'
        taskstim = 'environmental_sternberg';
        subj = 'D27';
        edf_filename = 'E:\InUnit Preprocessing\D27\Environmental\greg_sternberg_env_D27.edf'; 
        ptb_trialInfo = 'E:\InUnit Preprocessing\D27\Environmental\D27\D27_Block_1_TrialData.mat'; 
        taskdate = '190306';
        ieeg_prefix = 'D27_EnvironmentalSternberg_';
        rec = '001';
        trigger_chan_index = 60;
        mic_chan_index = 125;
        neural_chan_index = [2:59,66:121];     
        
 case 'D28_001'
        cd 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D28\'
        taskstim = 'lexical';
        subj = 'D28';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D28\D28 190303 Cogan_LexicalRepeatWithinDelay2X1.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D28\D28_Block_1_TrialData.mat';
        taskdate = '190303';
        ieeg_prefix = 'D28_LexicalDecRepDelay_001_';
        rec = '001';
        trigger_chan_index = 113;
        mic_chan_index = 114;
        neural_chan_index = [2:109];     

case 'D28_002'
        cd 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D28\'
        taskstim = 'lexical';
        subj = 'D28';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D28\D28 190303 Cogan_LexicalRepeatWithinDelay2X2.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D28\D28_Block_1_TrialData.mat';
        taskdate = '190303';
        ieeg_prefix = 'D28_LexicalDecRepDelay_002_';
        rec = '002';
        trigger_chan_index = 113;
        mic_chan_index = 114;
        neural_chan_index = [2:109]; 
case 'D28_008'
        cd 'E:\inUnitData\Preprocessing_ECoG\D28_008\'
        taskstim = 'timit';
        subj = 'D28';
        edf_filename = 'E:\inUnitData\Preprocessing_ECoG\D28_008\D28 190306 Cogan_TimitQuestions.edf'; 
        ptb_trialInfo = 'E:\inUnitData\Preprocessing_ECoG\D28_008\D28_Block_1_TrialData.mat';
        taskdate = '190306';
        ieeg_prefix = 'D28_timit_';
        rec = '001';
        trigger_chan_index = 113;
        mic_chan_index = 114;
        neural_chan_index = [2:109];

   case 'D29_001'
        cd 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D29'
        taskstim = 'lexical';
        subj = 'D29';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D29\D29 190316 Cogan_LexicalRepeatWithin2XDelay.edf';
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D29\D29_Block_1_TrialData.mat';
        taskdate = '190316'; %% YYMMDD
        ieeg_prefix = 'D29_LexicalDecRepDelay_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index = 152; % determined by looking at h
        mic_chan_index = 154;
        neural_chan_index = [2:121 130:149];
        
    case 'D29_003_1'
        cd H:\matlab\data\D29\sentence_rep\part1
        taskstim = 'sentence_rep';
        subj = 'D29';
        edf_filename = 'h:/matlab/data/D29/sentence_rep/part1/greg_sentence_rep_D29.edf';
        ptb_trialInfo = 'H:\Box Sync\CoganLab\ECoG_Task_Data\Cogan_Task_Data\D29\SentenceRep\D29_20190315T113945\D29_Block_5_TrialData.mat';
        taskdate = '190315'; %% YYMMDD
        ieeg_prefix = 'D29_Sentence_Rep_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index = 152; % determined by looking at h
        mic_chan_index = 154;
        neural_chan_index = [2:121 130:149];
        
    case 'D29_002_1'
        cd H:\matlab\data\D29\lexical_dr_2x_within_nodelay\part1
        taskstim = 'lexical';
        subj = 'D29';
        edf_filename = 'D29 190317 Cogan_LexicalRepeatWithin2XNoDelay_Part1.edf';
        ptb_trialInfo = 'H:\Box Sync\CoganLab\ECoG_Task_Data\Cogan_Task_Data\D29\Lexical\Lexical_DR_NoDelay_Button_2x\D29_20193171417\D29_Block_2_TrialData.mat';
        taskdate = '190317';
        ieeg_prefix = 'D29_Lexical_DR_NoDelay_Button_2x_';
        rec = '001';
        trigger_chan_index = 152;
        mic_chan_index = 154;
        neural_chan_index = [2:121 130:149];
        
    case 'D29_002_2'
        cd H:\matlab\data\D29\lexical_dr_2x_within_nodelay\part2
        taskstim = 'lexical';
        subj = 'D29';
        edf_filename = 'D29 190318 Cogan_LexicalRepeatWithin2XNoDelay_Part2.edf';
        ptb_trialInfo = 'H:\Box Sync\CoganLab\ECoG_Task_Data\Cogan_Task_Data\D29\Lexical\Lexical_DR_NoDelay_Button_2x\D29_2019318140\D29_Block_4_TrialData.mat';
        ieeg_prefix = 'D29_Lexical_DR_NoDelay_Button_2x_';
        taskdate = '190317';
        rec = '002';
        trigger_chan_index = 152;
        mic_chan_index = 154;
        neural_chan_index = [2:121 130:149];
        
    case 'D29_002_3'
        cd H:\matlab\data\D29\tutorial\part1
        taskstim = 'lexical';
        subj = 'D29';
        edf_filename = 'H:\matlab\data\D29\tutorial\part1\D29 190317 Cogan_LexicalRepeatWithin2XNoDelay_Part1.edf';
        ptb_trialInfo = 'H:\Box Sync\CoganLab\ECoG_Task_Data\Cogan_Task_Data\D29\Lexical\Lexical_DR_NoDelay_Button_2x\D29_20193171417\D29_Block_2_TrialData.mat';
        taskdate = '190317';
        ieeg_prefix = 'D29_Lexical_DR_NoDelay_Button_2x_';
        rec = '001';
        trigger_chan_index = 152;
        mic_chan_index = 154;
        neural_chan_index = [2:121 130:149];
   
      case 'D29_003'
        cd 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D29'
        taskstim = 'environmental_sternberg';
        subj = 'D29';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D29\D29 190317 Cogan_SternbergEnvironment.edf'
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D29\D29_Block_1_TrialData.mat'
        taskdate = '190317';
        ieeg_prefix = 'D29_EnvironmentalSternberg_';
        rec = '001';
        trigger_chan_index = 152;
        mic_chan_index = 154;
        neural_chan_index = [2:121 130:149]; 
        
     case 'D29_008'
        cd 'E:\inUnitData\Preprocessing_ECoG\D29_008'
        taskstim = 'timit';
        subj = 'D29';
        edf_filename = 'E:\inUnitData\Preprocessing_ECoG\D29_008\D29 190319Cogan_TimitQuestions.edf'
        ptb_trialInfo = 'E:\inUnitData\Preprocessing_ECoG\D29_008\D29_Block_1_TrialData.mat'
        taskdate = '190319';
        ieeg_prefix = 'D29_timit_';
        rec = '001';
        trigger_chan_index = 152;
        mic_chan_index = 154;
        neural_chan_index = [2:121 130:149];
        
    case 'D30_001'
        cd 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D30'
        taskstim = 'environmental_sternberg';
        subj = 'D30';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D30\D30 Cogan_SternbergEnvironment  190416.edf'
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D30\D30_Block_1_TrialData.mat'
        taskdate = '190416'; %% YYMMDD
        ieeg_prefix = 'D30_EnvironmentalSternberg_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index = 110; % determined by looking at h
        mic_chan_index = 112;
        neural_chan_index = [2:63,66:107];
        
      case 'D31_001'
        cd 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D31'
        taskstim = 'environmental_sternberg';
        subj = 'D31';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D31\D31 Cogan_SternbergEnvironmental 190424.edf'
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D31\D31_Block_1_TrialData.mat'
        taskdate = '190424'; %% YYMMDD
        ieeg_prefix = 'D31_EnvironmentalSternberg_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index = 126; % determined by looking at h
        mic_chan_index = 128;
        neural_chan_index = [2:61,66:125,130:169];
        
       case 'D32'
        cd 'H:\Box Sync\CoganLab\D_Data\D32\'
        taskstim = 'sentence_rep';
        subj = 'D32';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\D32\D32  Cogan_Sentence Rep 190527.edf'
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\D32\D32_Block_5_TrialData.mat';
        taskdate = '190527'; %% YYMMDD
        ieeg_prefix = 'D32_Sentence_Rep_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index = 62; % determined by looking at h
        mic_chan_index = 64;
        neural_chan_index = [2:61,66:127 130:165];
        
        case 'D32_001_01'
        cd 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D32'
        taskstim = 'environmental_sternberg';
        subj = 'D32';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D32\D32 Cogan_SternbergEnvironmental 190527 part1.edf'
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D32\D32_Block_1_TrialData.mat'
        taskdate = '190527'; %% YYMMDD
        ieeg_prefix = 'D32_EnvironmentalSternberg_001_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index = 62; % determined by looking at h
        mic_chan_index = 64;
        neural_chan_index = [2:61,66:127 130:165];  

       case 'D32_001_02'
        cd 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D32'
        taskstim = 'environmental_sternberg';
        subj = 'D32';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D32\D32 Cogan_SternbergEnvironmental 190527 part2.edf'
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D32\D32_Block_1_TrialData.mat'
        taskdate = '190527'; %% YYMMDD
        ieeg_prefix = 'D32_EnvironmentalSternberg_002_'; % Should end in _
        rec = '002'; % if this was part2, then '002'
        trigger_chan_index = 62; % determined by looking at h
        mic_chan_index = 64;
        neural_chan_index = [2:61,66:127 130:165];         
        
       case 'D32_002_01'
        cd 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D32'
        taskstim = 'lexical';
        subj = 'D32';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D32\D32 Cogan_LexicalRepeatWithin2XDelay_Part1 190526.edf'
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D32\D32_Block_1_TrialData.mat';
        taskdate = '190526'; %% YYMMDD
        ieeg_prefix = 'D32_LexicalDecRepDelay_001_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index = 62; % determined by looking at h
        mic_chan_index = 64;
        neural_chan_index = [2:61,66:127 130:165];        

     case 'D32_002_02'
        cd 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D32'
        taskstim = 'lexical';
        subj = 'D32';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D32\D32 Cogan_LexicalRepeatWithin2XDelay_Part2 190526.edf'
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D32\D32_Block_3_TrialData.mat';
        taskdate = '190526'; %% YYMMDD
        ieeg_prefix = 'D32_LexicalDecRepDelay_002_'; % Should end in _
        rec = '002'; % if this was part2, then '002'
        trigger_chan_index = 62; % determined by looking at h
        mic_chan_index = 64;
        neural_chan_index = [2:61,66:127 130:165];                
        
    case 'D33_001'
        cd 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D33\'
        taskstim = 'neighborhood';
        subj = 'D33';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D33\D33 Cogan_NeighborhoodSternberg_Part1 190603.edf';
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D33\D33_Block_1_TrialData.mat';
        taskdate = '190603';
        ieeg_prefix = 'D33_SternbergNeighborhood01_';
        rec = '001';
        trigger_chan_index = 126;
        mic_chan_index = 128;
        neural_chan_index = [2:121 130:123 130:249];
        
    case 'D33_002'
        cd 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D33\'
        taskstim = 'neighborhood';
        subj = 'D33';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D33\D33 Cogan_NeighborhoodSternberg_Part2 190603.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D33\D33_Block_2_Trial_Data.mat';
        taskdate = '190603';
        ieeg_prefix = 'D33_SternbergNeighborhood02_';
        rec = '002';
        trigger_chan_index = 126;
        mic_chan_index = 128;
        neural_chan_index = [2:121 130:123 130:249];     

     case 'D33_003'
        cd 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D33\'
        taskstim = 'neighborhood';
        subj = 'D33';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D33\D33 Cogan_NeighborhoodSternberg_Part2 190603.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D33\D33_Block_3_TrialData.mat';
        taskdate = '190603';
        ieeg_prefix = 'D33_SternbergNeighborhood03_';
        rec = '003';
        trigger_chan_index = 126;
        mic_chan_index = 128;
        neural_chan_index = [2:121 130:123 130:249];
        
    case 'D33_008'
        cd 'E:\inUnitData\Preprocessing_ECoG\D33_008\'
        taskstim = 'timit';
        subj = 'D33';
        edf_filename = 'E:\inUnitData\Preprocessing_ECoG\D33_008\D33 Cogan_TimitQuestions  190602.edf';
        ptb_trialInfo = 'E:\inUnitData\Preprocessing_ECoG\D33_008\D33_Block_3_TrialData.mat';
        taskdate = '190602';
        ieeg_prefix = 'D33_timit_';
        rec = '001';
        trigger_chan_index = 126;
        mic_chan_index = 128;
        neural_chan_index = [2:121 130:123 130:249];
        
      case 'D34'
        cd 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D34\'
        taskstim = 'neighborhood';
        subj = 'D34';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D34\D34 Cogan_SternbergNeighborhood 193007.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D34\D34_Block_1_TrialData.mat';
        taskdate = '190730';
        ieeg_prefix = 'D34_SternbergNeighborhood_';
        rec = '001';
        trigger_chan_index = 188;
        mic_chan_index = 190;
        neural_chan_index = [2:63 66:185];  
        
    case 'D35'
        cd 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D35\'
        taskstim = 'neighborhood';
        subj = 'D35';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D35\D35 Cogan_SternbergNeighborhood 190801 .edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D35\D35_Block_1_TrialData.mat';
        taskdate = '190801';
        ieeg_prefix = 'D35_SternbergNeighborhood_';
        rec = '001';
        trigger_chan_index = 56;
        mic_chan_index = 57;
        neural_chan_index = [2:55 66:123 130:191];

     case 'D35_02'
        cd 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D35'
        taskstim = 'lexical';
        subj = 'D35';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D35\D35 Cogan_LexicalDecision_Delay 190801.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D35\D35_Block_1_TrialData.mat';
        taskdate = '190801';
        ieeg_prefix = 'D35_LexicalDecRepDelay_';
        rec = '001';
        trigger_chan_index = 56;
        mic_chan_index = 57;
        neural_chan_index = [2:55 66:123 130:191];
        
    case 'D35_03' 
        cd 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D35'
        taskstim = 'environmental_sternberg';
        subj = 'D35';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D35\D35 Cogan_SternbergEnvironment 190802.edf'
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D35\D35_Block_1_TrialData.mat'
        taskdate = '190802'; %% YYMMDD
        ieeg_prefix = 'D35_EnvironmentalSternberg_'; % Should end in _
        rec = '001'; % if this was part2, then '002'      
        trigger_chan_index = 56;
        mic_chan_index = 58;
        neural_chan_index = [2:55,66:123,130:191];
        
%    case 'D35_007'
%         cd 'D:\Preprocessing_ECoG\D35_007'
%         taskstim = 'environment_sternberg';
%         subj = 'D35';
%         edf_filename = 'D:\Preprocessing_ECoG\D35_007\D35 Cogan_SternbergEnvironment 190802.edf';
%         ptb_trialInfo = 'D:\Preprocessing_ECoG\D35_007\D35_Block_1_TrialData.mat';
%         taskdate = '190802';
%         ieeg_prefix = 'D35_SternbergEnvironment_';
%         rec = '001';
%         trigger_chan_index = 56;
%         mic_chan_index = 58;
%         neural_chan_index = [2:55,66:123,130:191];
        
   case 'D36'
        cd 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D36\'
        taskstim = 'neighborhood';
        subj = 'D36';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D36\D36 Cogan_SternbergNeighborhood.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D36\D36_Block_1_TrialData.mat';
        taskdate = '190808';
        ieeg_prefix = 'D36_SternbergNeighborhood_';
        rec = '001';
        trigger_chan_index = 112;
        mic_chan_index = 114;
        neural_chan_index = [2:63 66:111 116:121 130:237]; % 116:121 is EEG
  
  case 'D37'
        cd 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D37\'
        taskstim = 'neighborhood';
        subj = 'D37';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D37\D37 Cogan_SternbergNeighborhood  190913.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D37\D37_Block_1_TrialData.mat';
        taskdate = '190913';
        ieeg_prefix = 'D37_SternbergNeighborhood_';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 61;
        neural_chan_index = [2:61,66:115,130:187,194:205];
        
        
    case 'D37_02'
        cd 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D37'
        taskstim = 'environmental_sternberg';
        subj = 'D37';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D37\D37 Cogan_sternbergEnvironment 190916.edf'
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D37\D37_Block_1_TrialData.mat'
        taskdate = '190916'; %% YYMMDD
        ieeg_prefix = 'D37_EnvironmentalSternberg_'; % Should end in _
        rec = '001'; % if this was part2, then '002'      
        trigger_chan_index = 258;
        mic_chan_index = 61;
        neural_chan_index = [2:61,66:115,130:187,194:205];
 % may have to rerun D37_007 if new edf is uploaded
    case 'D37_007'
        cd 'D:\Preprocessing_ECoG\D37_007'
        taskstim = 'environment_sternberg';
        subj = 'D37';
        edf_filename = 'D:\Preprocessing_ECoG\D37_007\D37 Cogan_SternbergNeighborhood  190913.edf';
        ptb_trialInfo = 'D:\Preprocessing_ECoG\D37_007\D37_Block_1_TrialData.mat';
        taskdate = '190913';
        ieeg_prefix = 'D37_SternbergEnvironment_';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 62;
        neural_chan_index = [2:61,66:115,130:175,178:187,194:205];  
        
     case 'D37_008'
        cd 'E:\inUnitData\Preprocessing_ECoG\D37_008'
        taskstim = 'timit';
        subj = 'D37';
        edf_filename = 'E:\inUnitData\Preprocessing_ECoG\D37_008\D37 Cogan_TimitQuestions 190912.edf';
        ptb_trialInfo = 'E:\inUnitData\Preprocessing_ECoG\D37_008\D37_Block_1_TrialData.mat';
        taskdate = '190912';
        ieeg_prefix = 'D37_timit_';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 62;
        neural_chan_index = [2:61,66:115,130:175,178:187,194:205];      

  case 'D38_006'
        cd 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D38\'
        taskstim = 'neighborhood';
        subj = 'D38';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D38\D38 Cogan_SternbergNeighborhood 190921.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D38\D38_Block_1_TrialData.mat';
        taskdate = '190921';
        ieeg_prefix = 'D38_SternbergNeighborhood_';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 58;
        neural_chan_index = [2:57,66:119,130:183,194:237];

        
  case 'D38_001'
        cd   'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D38'
        taskstim = 'lexical';
        subj = 'D38';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D38\D38 Cogan_LexicalDecision_Delay 190922.edf';
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\LexicalDecRepDelay\D38\D38_Block_1_TrialData.mat';
        taskdate = '190922';
        ieeg_prefix = 'D38_LexicalDecRepDelay_';
        rec = '002';
        trigger_chan_index = 258;
        mic_chan_index = 58;
        neural_chan_index = [2:57,66:119,130:183,194:237];
        
    case 'D38_002'
        cd 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D38'
        taskstim = 'environmental_sternberg';
        subj = 'D38';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D38\D38 Cogan_SternbergEnvironment 190922.edf'
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D38\D38_Block_1_TrialData.mat'
        taskdate = '190922'; %% YYMMDD
        ieeg_prefix = 'D38_EnvironmentalSternberg_'; % Should end in _
        rec = '001'; % if this was part2, then '002'      
        trigger_chan_index = 258;
        mic_chan_index = 58;
        neural_chan_index = [2:57,66:119,130:183,194:237];
        
        
   case 'D38_008'
        cd 'E:\inUnitData\Preprocessing_ECoG\D38_008'
        taskstim = 'timit';
        subj = 'D38';
        edf_filename = 'E:\inUnitData\Preprocessing_ECoG\D38_008\D38 Cogan_TimitQuestions 190921.edf'
        ptb_trialInfo = 'E:\inUnitData\Preprocessing_ECoG\D38_008\D38_Block_1_TrialData.mat'
        taskdate = '190921'; %% YYMMDD
        ieeg_prefix = 'D38_Timit_'; % Should end in _
        rec = '001'; % if this was part2, then '002'      
        trigger_chan_index = 258;
        mic_chan_index = 58;
        neural_chan_index = [2:57,66:119,130:183,194:237];
        
    case 'D39_001'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D39_task001\D39'
        taskstim = 'lexical';
        subj = 'D39';
        edf_filename ='C:\Users\amt80\Documents\65476_PreProcessing_Files\D39_task001\D39\D39 Cogan_LexicalDecision_Delay 191011.edf';
        ptb_trialInfo ='C:\Users\amt80\Documents\65476_PreProcessing_Files\D39_task001\D39\D39_Block_1_TrialData.mat';
        taskdate = '191011';
        ieeg_prefix = 'D39_LexicalDecRepDelay_';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 64;
        neural_chan_index = [2:57,66:127,130:249];
        
    case 'D39_002_01'
        cd 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D39'
        taskstim = 'environmental_sternberg';
        subj = 'D39';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D39\D39 Cogan_SternbergEnvironment_part1 191012.edf'
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D39\D39_Block_1_TrialData.mat'
        taskdate = '191012'; %% YYMMDD
        ieeg_prefix = 'D39_EnvironmentalSternberg_01_'; % Should end in _
        rec = '001'; % if this was part2, then '002'  
        trigger_chan_index = 258;
        mic_chan_index = 64;
        neural_chan_index = [2:57,66:127,130:249];

     case 'D39_002_02'
        cd 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D39'
        taskstim = 'environmental_sternberg';
        subj = 'D39';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D39\D39 Cogan_SternbergEnvironment_part2 191012.edf'
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg\D39\D39_Block_2_TrialData.mat'
        taskdate = '191012'; %% YYMMDD
        ieeg_prefix = 'D39_EnvironmentalSternberg_02_'; % Should end in _
        rec = '002'; % if this was part2, then '002'  
        trigger_chan_index = 258;
        mic_chan_index = 64;
        neural_chan_index = [2:57,66:127,130:249];
        
     case 'D39_006_001'
        cd 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D39\'
        taskstim = 'neighborhood';
        subj = 'D39';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D39\D39 Cogan_SternbergNeighborhood pt 1 191010.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D39\D39_Sternberg_trialInfo.mat';
        taskdate = '191010';
        ieeg_prefix = 'D39_SternbergNeighborhood_01_';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 64;
        neural_chan_index = [2:57,66:127,130:249];   
 
     case 'D39_006_002'
        cd 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D39\'
        taskstim = 'neighborhood';
        subj = 'D39';
        edf_filename = 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D39\D39 Cogan_SternbergNeighborhood pt 2 191010.edf'; 
        ptb_trialInfo = 'H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg\D39\D39_Sternberg_trialInfo.mat';
        taskdate = '191010';
        ieeg_prefix = 'D39_SternbergNeighborhood_02_';
        rec = '002';
        trigger_chan_index = 258;
        mic_chan_index = 64;
        neural_chan_index = [2:57,66:127,130:249];           
    case 'D39_007'
        cd 'D:\Preprocessing_ECoG\D39_007'
        taskstim = 'environment_sternberg';
        subj = 'D39';
        edf_filename = 'D:\Preprocessing_ECoG\D39_007\D39 Cogan_SternbergEnvironment_part1 191012.edf';
        ptb_trialInfo = 'D:\Preprocessing_ECoG\D39_007\D39_Block_1_TrialData.mat';
        taskdate = '191012';
        ieeg_prefix = 'D39_SternbergEnvironment_';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 64;
        neural_chan_index = [2:57,66:127,130:249];  
       
    
    case 'D39_008'
        cd 'E:\inUnitData\Preprocessing_ECoG\D39_008'
        taskstim = 'timit';
        subj = 'D39';
        edf_filename = 'E:\inUnitData\Preprocessing_ECoG\D39_008\D39 Cogan_TimitQuestions 191012.edf';
       % ptb_trialInfo = 'E:\inUnitData\Preprocessing_ECoG\D40_008\D40_Block_4_TrialData.mat';
        taskdate = '191012';
        ieeg_prefix = 'D39_Timit_';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 64;
        neural_chan_index = [2:57,66:249];
        
      case 'D40_008'
        cd 'E:\inUnitData\Preprocessing_ECoG\D40_008'
        taskstim = 'timit';
        subj = 'D40';
        edf_filename = 'E:\inUnitData\Preprocessing_ECoG\D40_008\D40 Cogan_TimitQuestions 191118.edf';
        ptb_trialInfo = 'E:\inUnitData\Preprocessing_ECoG\D40_008\D40_Block_4_TrialData.mat';
        taskdate = '191118';
        ieeg_prefix = 'D40_Timit_';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 61;
        neural_chan_index = [2:59,66:125,130:185,194:207];
        
    case 'D45_004'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D45_task004'
        taskstim = 'phoneme_sequencing';
        subj = 'D45';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D45_task004\D45_PhonemeSequencing.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D45_task004\D45_Block_4_TrialData.mat'; %find Block_4_trialData.mat
        taskdate = '200106';
        ieeg_prefix = 'D45_PhonemeSequence_';
        rec = '001';
        trigger_chan_index = 257;
        mic_chan_index = 61;
        neural_chan_index = [2:59,66:125,130:185,194:207];
        
    case 'D44_001'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D44_task001'
        taskstim = 'lexical';
        subj = 'D44';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D44_task001\D44 200126 COGAN_LEXICALDECISION_DELAY.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D44_task001\D44_Block_2_TrialData.mat'; 
        taskdate = '200106';
        ieeg_prefix = 'D44_LexicalDecisionRepeat_Delay_';
        rec = '001';
        trigger_chan_index = 257;
        mic_chan_index = 57;
        neural_chan_index = [1:54,65:122,129:206];
        
    case 'D42_004'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D42_task004'
        taskstim = 'phoneme_sequencing';
        subj = 'D44';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D42_task004\D42 Cogan_PhonemeSequence 191215.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D42_task004\D42_Block_4_TrialData.mat'; 
        taskdate = '191215';
        ieeg_prefix = 'D42_PhonemeSequence';
        rec = '001';
        trigger_chan_index = 257;
        mic_chan_index = 59;
        neural_chan_index = [2:57,66:121,130:193];
        
    case 'D45_004' % Phoneme Sequencing
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D45_task004'
        taskstim = 'phoneme_sequencing';
        subj = 'D45';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D45_task004\D45 200126 COGAN_PHONEMESEQUENCE.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D45_task004\D45_Block_4_TrialData.mat';
        taskdate = '200126';
        ieeg_prefix = 'D45_PhonemeSequence';
        rec = '001';
        trigger_chan_index = 257;
        mic_chan_index = 59;
        neural_chan_index = [2:56,65:124,129:214];
        
    case 'D42_task006'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D42_task006'
        taskstim = 'neighborhood_sternberg';
        subj = 'D42';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D42_task006\D42 Cogan_SternbergNeighborhood 191212.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D42_task006\D42_Block_1_TrialData.mat';
        taskdate = '191212';
        ieeg_prefix = 'D42_NeighborhoodSternberg';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 59;
        neural_chan_index = [2:57,66:121,130:193];
        
    case 'D42_task005'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D42_task005'
        taskstim = 'uniqueness_point';
        subj = 'D42';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D42_task005\D42 Cogan_UniquenessPoint 191215.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D42_task005\D42_Block_4_TrialData.mat';
        taskdate = '191215';
        ieeg_prefix = 'D42_UniquenessPoint';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 59;
        neural_chan_index = [2:57,66:121,130:193];
        
    case 'D41_task004'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D41_task004'
        taskstim = 'phoneme_sequencing';
        subj = 'D41';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D41_task004\D41 Cogan_PhonemeSequence 191216.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D41_task004\D41_Block_4_TrialData.mat';
        taskdate = '191216';
        ieeg_prefix = 'D41_PhonemeSequencing';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 128;
        neural_chan_index = [2:125,130:255];
        
    case 'D40_004'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D40_task004'
        taskstim = 'phoneme_sequencing';
        subj = 'D40';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D40_task004\D40 Cogan_PhonemeSequence 191118.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D40_task004\D40_Block_4_TrialData.mat';
        taskdate = '191118';
        ieeg_prefix = 'D40_Phoneme_Sequencing_';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 61;
        neural_chan_index = [2:59,66:125,130:185,194:207];
        
    case 'D39_004'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D39_task004'
        taskstim = 'phoneme_sequencing';
        subj = 'D39';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D39_task004\D39 Cogan_PhonemeSequence pt1 191012.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D39_task004\D39_Block_3_TrialData.mat';
        taskdate = '191012';
        ieeg_prefix = 'D39_Phoneme_Sequencing_';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 64;
        neural_chan_index = [2:57,66:127,130:249];
    case 'D39_004'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D39_task004'
        taskstim = 'phoneme_sequencing';
        subj = 'D39';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D39_task004\D39 Cogan_PhonemeSequence pt 2 191012.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D39_task004\D39_Block_4_TrialData.mat';
        taskdate = '191012';
        ieeg_prefix = 'D39_Phoneme_Sequencing_';
        rec = '002';
        trigger_chan_index = 258;
        mic_chan_index = 64;
        neural_chan_index = [2:57,66:127,130:249];
        
    case 'D35_004'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D35_task004'
        taskstim = 'phoneme_sequencing';
        subj = 'D35';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D35_task004\D35 Cogan_PhonemeSequence 190802.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D35_task004\D35_Block_4_TrialData.mat';
        taskdate = '190802'; %% YYMMDD
        ieeg_prefix = 'D35_Phoneme_Sequencing'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index = 56;
        mic_chan_index = 58;
        neural_chan_index = [2:55,66:123,130:191];
        
    case 'D47_004'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D47_task004'
        taskstim = 'phoneme_sequencing';
        subj = 'D47';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D47_task004\D47 200314 COGAN_PhonemeSequencing.edf'; % this is possibly TIMIT
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D47_task004\D47_Block_4_TrialData.mat';
        taskdate = '200314'; %% YYMMDD
        ieeg_prefix = 'D47_Phoneme_Sequencing'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index = 257;
        mic_chan_index = 117;
        neural_chan_index = [1:63,65:112,129:182,193:252];
        
    case 'D31_004'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D31_task004'
        taskstim = 'phoneme_sequencing';
        subj = 'D31';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D31_task004\D31 Cogan_PhonemeSequence 190423.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D31_task004\D31_Block_4_TrialData.mat';
        taskdate = '190423'; %% YYMMDD
        ieeg_prefix = 'D31_Phoneme_Sequencing_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index = 126; % determined by looking at h
        mic_chan_index = 128;
        neural_chan_index = [2:61,66:125,130:169];
        
    case 'D47_006'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D47_task006'
        taskstim = 'neighborhood_sternberg';
        subj = 'D47';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D47_task006\D47 200315 COGAN_STERNBERGNEIGHBORHOOD.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D47_task006\D47_Block_1_TrialData.mat';
        taskdate = '200315'; %% YYMMDD
        ieeg_prefix = 'D47_Neighborhood_Sternberg_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index = 257;
        mic_chan_index = 117;
        neural_chan_index = [1:63,65:112,129:182,193:252];
        
    case 'D29_001'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D29_task004'
        taskstim = 'phoneme_sequencing';
        subj = 'D29';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D29_task004\D29 190318 Cogan_PhonemeSequence.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D29_task004\D29_Block_4_TrialData.mat';
        taskdate = '190318'; %% YYMMDD
        ieeg_prefix = 'D29_Phoneme_Sequencing_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index = 152; % determined by looking at h
        mic_chan_index = 154;
        neural_chan_index = [2:121 130:149];
        
    case 'D28_004'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D28_task004';
        taskstim = 'phoneme_sequence';
        subj = 'D28';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D28_task004\D28 190307 Cogan_PhonemeSequence.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D28_task004\D28_Block_4_TrialData.mat';
        taskdate = '190307';
        ieeg_prefix = 'D28_Phoneme_Sequencing_';
        rec = '001';
        trigger_chan_index = 113;
        mic_chan_index = 114;
        neural_chan_index = [2:109];
        
    case 'D27_004'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D27_task004'
        taskstim = 'phoneme_sequence';
        subj = 'D27';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D27_task004\D27 190306 Cogan_PhonemeSequence .edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D27_task004\D27_Block_4_TrialData.mat';
        taskdate = '190306';
        ieeg_prefix = 'D27_Phoneme_Sequence_';
        rec = '001';
        trigger_chan_index = 60;
        mic_chan_index = 125;
        neural_chan_index = [2:59,66:121];
        
    case 'D31_003'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D31_task003'
        taskstim = 'sentence_rep';
        subj = 'D31';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D31_task003\D31 Cogan_SentenceRep 190424.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D31_task003\D31_Block_5_TrialData.mat';
        taskdate = '190424'; %% YYMMDD
        ieeg_prefix = 'D31_Sentence_Rep_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index = 126; % determined by looking at h
        mic_chan_index = 128;
        neural_chan_index = [2:61,66:125,130:169];
        
    case 'D30_003'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D30_task003'
        taskstim = 'sentence_rep';
        subj = 'D30';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D30_task003\D30 Cogan_SentenceRep_Part1  190412.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D30_task003\D30_Block_2_TrialData.mat';
        taskdate = '190412'; %% YYMMDD
        ieeg_prefix = 'D30_Sentence_Rep_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index = 110; % determined by looking at h
        mic_chan_index = 112;
        neural_chan_index = [2:63,66:107];
        
    case 'D30_003'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D30_task003'
        taskstim = 'sentence_rep';
        subj = 'D30';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D30_task003\D30  Cogan_SentenceRep_Part2  190413.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D30_task003\D30_Block_3_TrialData.mat';
        taskdate = '190413'; %% YYMMDD
        ieeg_prefix = 'D30_Sentence_Rep_'; % Should end in _
        rec = '002'; % if this was part2, then '002'
        trigger_chan_index = 110; % determined by looking at h
        mic_chan_index = 112;
        neural_chan_index = [2:63,66:107];
        
    case 'D29_005'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D29_task005'
        taskstim = 'uniqueness_point';
        subj = 'D29';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D29_task005\D29 190318 Cogan_UniquenessPoint.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D29_task005\D29_Block_4_TrialData.mat';
        taskdate = '190318'; %% YYMMDD
        ieeg_prefix = 'D29_Uniqueness_Point_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index = 152; % determined by looking at h
        mic_chan_index = 154;
        neural_chan_index = [2:121 130:149];
        
    case 'D28_005'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D28_task005'
        taskstim = 'uniqueness_point';
        subj = 'D28';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D28_task005\D28 190311 Cogan_UniquenessPointNoDelay.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D28_task005\D28_Block_4_TrialData.mat';
        taskdate = '190311';
        ieeg_prefix = 'D28_Uniqueness_Point_';
        rec = '001';
        trigger_chan_index = 113;
        mic_chan_index = 114;
        neural_chan_index = [2:109];
    case 'D39_004_pt2'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D39_task004_pt2'
        taskstim = 'phoneme_sequencing';
        subj = 'D39';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D39_task004_pt2\D39 Cogan_PhonemeSequence pt1 191012.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D39_task004_pt2\D39_Block_3_TrialData.mat';
        taskdate = '191012';
        ieeg_prefix = 'D39_Phoneme_Sequencing_';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 64;
        neural_chan_index = [2:57,66:127,130:249];
    case 'D39_004_pt2'
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D39_task004_pt2'
        taskstim = 'phoneme_sequencing';
        subj = 'D39';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D39_task004_pt2\D39 Cogan_PhonemeSequence pt 2 191012.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D39_task004_pt2\D39_Block_4_TrialData.mat';
        taskdate = '191012';
        ieeg_prefix = 'D39_Phoneme_Sequencing_';
        rec = '002';
        trigger_chan_index = 258;
        mic_chan_index = 64;
        neural_chan_index = [2:57,66:127,130:249];
        
        %Anna start here
    case 'D47_001' % Lexical Decision Delay
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D47_task001'
        taskstim = 'lexical_decision';
        subj = 'D47';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D47_task001\D47 200315 COGAN_LEXICALDECISION_DELAY.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D47_task001\D47_Block_1_TrialData.mat';
        taskdate = '200315'; %% YYMMDD
        ieeg_prefix = 'D47_LexDecRep_Delay_'; % Should end in _
        rec = '001'; 
        trigger_chan_index = 257;
        mic_chan_index = 117;
        neural_chan_index = [1:63,65:112,129:182,193:252];
    case 'D47_007' % Environmental Sternberg
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D47_task007'
        taskstim = 'environmental_sternberg';
        subj = 'D47';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D47_task007\.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D47_task007\.mat';
        taskdate = ''; %% YYMMDD
        ieeg_prefix = 'D47_Environmental_Sternberg_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index = 257;
        mic_chan_index = 117;
        neural_chan_index = [1:63,65:112,129:182,193:252];
   
    case 'D45_004' % Phoneme Sequencing
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D45_task004'
        taskstim = 'phoneme_sequencing';
        subj = 'D45';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D45_task004\D45 200126 COGAN_PHONEMESEQUENCE.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D45_task004\D45_Block_4_TrialData.mat';
        taskdate = '200126';
        ieeg_prefix = 'D45_PhonemeSequence';
        rec = '001';
        trigger_chan_index = 257;
        mic_chan_index = 59;
        neural_chan_index = [2:56,65:124,129:214];
    
    case 'D44_001' % Lexical Decision Delay
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D44_task001'
        taskstim = 'lexical';
        subj = 'D44';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D44_task001\D44 200126 COGAN_LEXICALDECISION_DELAY.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D44_task001\trialInfo.mat'; 
        ieeg_prefix = 'D44_LexicalDecisionRepeat_Delay_';
        rec = '001';
        trigger_chan_index = 257;
        mic_chan_index = 57;
        neural_chan_index = [1:54,65:122,129:206];
    case 'D42_001' % Lexical Decision Delay
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D42_task001'
        taskstim = 'lexical';
        subj = 'D42';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D42_task001\D42 Cogan_LexicalDecision_Delay 191213 (1).edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D42_task001\D42_Block_4_TrialData.mat';
        taskdate = '191213';
        ieeg_prefix = 'D42_LexDec_Delay_';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 59;
        neural_chan_index = [2:57,66:121,130:193];
    case 'D42_002' % Lexical Decision No Delay
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D42_task002'
        taskstim = 'lexical';
        subj = 'D42';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D42_task002\D42 Cogan_LexicalDecision_NoDelay 191214.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D42_task002\D42_Block_4_TrialData.mat';
        taskdate = '191214';
        ieeg_prefix = 'D42_LexDec_NoDelay_';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 59;
        neural_chan_index = [2:57,66:121,130:193];
    case 'D42_005' % Uniqueness Point
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D42_task005'
        taskstim = 'uniqueness_point';
        subj = 'D42';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D42_task005\D42 Cogan_UniquenessPoint 191215.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D42_task005\D42_Block_4_TrialData.mat';
        taskdate = '191215';
        ieeg_prefix = 'D42_Uniqueness_Point_';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 59;
        neural_chan_index = [2:57,66:121,130:193];
    case 'D42_006' % Neighborhood Sternberg
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D42_task006'
        taskstim = 'neighborhood_sternberg';
        subj = 'D42';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D42_task006\D42 Cogan_SternbergNeighborhood 191212.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D42_task006\D42_Block__TrialData.mat';
        taskdate = '191212';
        ieeg_prefix = 'D42_Neighborhood_Sternberg_';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 59;
        neural_chan_index = [2:57,66:121,130:193];
    case 'D42_007' % Environmental Sternberg
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D42_task007'
        taskstim = 'environmental_sternberg';
        subj = 'D42';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D42_task007\.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D42_task007\.mat';
        taskdate = '';
        ieeg_prefix = 'D42_Environmental_Sternberg_';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 59;
        neural_chan_index = [2:57,66:121,130:193];
    case 'D41_001' % Lexical Decision Delay
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D41_task001'
        taskstim = 'lexical';
        subj = 'D41';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D41_task001\D41 Cogan_LexicalDecision_Delay 191214.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D41_task001\D41_Block_1_TrialData.mat';
        taskdate = '191214';
        ieeg_prefix = 'D41_Lexical_Decision_Delay_';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 128;
        neural_chan_index = [2:125,130:255];
    case 'D41_006' % Neighborhood Sternberg
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D41_task006'
        taskstim = 'neighborhood_sternberg';
        subj = 'D41';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D41_task006\D41 Cogan_SternbergNeighborhood 191212 .edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D41_task006\D41_Block_4_TrialData.mat';
        taskdate = '191214';
        ieeg_prefix = 'D41_Neighborhood_Sternberg_';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 128;
        neural_chan_index = [2:125,130:255];
    case 'D41_007' % Environmental Sternberg
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D41_task007'
        taskstim = 'environmental_sternberg';
        subj = 'D41';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D41_task007\D41 Cogan_SternbergEnvironment 191215.edf';
        taskdate = '191215';
        ieeg_prefix = 'D41_Environmental_Sternberg_';
        rec = '001';
        trigger_chan_index = 258;
        mic_chan_index = 128;
        neural_chan_index = [2:125,130:255];
    case 'D39_006' % Neighborhood Sternberg
    case 'D35_002' % Lexical Decision No Delay
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D35_task002'
        taskstim = 'uniqueness_point';
        subj = 'D35';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D35_task002\D35 Cogan_LexicalDecision_NoDelay 190803.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D35_task002\D35_Block_4_TrialData.mat';
        taskdate = '190803'; %% YYMMDD
        ieeg_prefix = 'D35_Lexical_DecisionRepeat_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index = 56;
        mic_chan_index = 58;
        neural_chan_index = [2:55,66:123,130:191];
    case 'D35_005' % Uniqueness Point *Need to check trigs
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D35_task005'
        taskstim = 'uniqueness_point';
        subj = 'D35';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D35_task005\D35 Cogan_UniquenessPoint 190806.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D35_task005\D35_Block_4_TrialData.mat';
        taskdate = '190806'; %% YYMMDD
        ieeg_prefix = 'D35_Uniqueness_Point_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index = 56;
        mic_chan_index = 58;
        neural_chan_index = [2:55,66:123,130:191];
    case 'D31_003' % Sentence Rep
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D31_task003'
        taskstim = 'sentence_rep';
        subj = 'D31';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D31_task003\D31 Cogan_SentenceRep 190424.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D31_task003\D31_Block_5_TrialData.mat';
        taskdate = '190424'; %% YYMMDD
        ieeg_prefix = 'D31_Sentence_Rep_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index = 126; % determined by looking at h
        mic_chan_index = 128;
        neural_chan_index = [2:61,66:125,130:169];
    case 'D29_002' % Lexical Decision Repeat No Delay Part 1
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D29_task002'
        taskstim = 'lexical';
        subj = 'D29';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D29_task002\D29 190317 Cogan_LexicalRepeatWithin2XNoDelay_Part1.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D29_task002\D29_Block_2_TrialData.mat';
        taskdate = '190317'; %% YYMMDD
        ieeg_prefix = 'D29_Lexical_DecRep_Pt1_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        trigger_chan_index = 152; % determined by looking at h
        mic_chan_index = 154;
        neural_chan_index = [2:121 130:149];
    case 'D29_002' % lexical Decision Repeat No Delay Part 2
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D29_task002'
        taskstim = 'lexical';
        subj = 'D29';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D29_task002\D29 190318 Cogan_LexicalRepeatWithin2XNoDelay_Part2.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D29_task002\D29_Block_4_TrialData.mat';
        taskdate = '190318'; %% YYMMDD
        ieeg_prefix = 'D29_Lexical_DecRep_Pt2_'; % Should end in _
        rec = '002'; % if this was part2, then '002'
        trigger_chan_index = 152; % determined by looking at h
        mic_chan_index = 154;
        neural_chan_index = [2:121 130:149];
        
    case 'D28_002' % Lexical Decision Repeat No Delay
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D28_task002'
        taskstim = 'lexical';
        subj = 'D28';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D28_task002\D28 190304 Cogan_LexicalRepeatWithin2XNoDelayButton.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D28_task002\D28_Block_4_TrialData.mat';
        taskdate = '190304';
        ieeg_prefix = 'D28_LexicalDecRepNoDelay_';
        rec = '002';
        trigger_chan_index = 113;
        mic_chan_index = 114;
        neural_chan_index = [2:109];
        
    case 'D4_003' % Sentence Rep
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D4_task003'
        taskstim = 'sentence_rep';
        subj = 'D4';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D4_task003\greg_2004.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D4_task003\D4_Block_5_TrialData.mat';
        taskdate = '161017';
        ieeg_prefix = 'D4_SentenceRep_';
        rec = '001';
        trigger_chan_index = 103;
        mic_chan_index = 104;
        neural_chan_index = [28:127];
        
    case 'D27_002' % Lexical Decision Repeat No Delay
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D27_task002'
        taskstim = 'lexical';
        subj = 'D27';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D27_task002\D27 190305 Cogan_Lex RepeatDecisionWithin2X .edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\D27_task002\D27_Block_4_TrialData.mat';
        taskdate = '190305';
        ieeg_prefix = 'D27_Lexical_DecisionRepeat_NoDelay_';
        rec = '001';
        trigger_chan_index = 60;
        mic_chan_index = 125;
        neural_chan_index = [2:59,66:121];
    case 'D6_003' % Sentence Rep
        cd 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D6_task003'
        taskstim = 'sentence_rep';
        subj = 'D6';
        edf_filename = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D6_task003\greg_2006.edf';
        ptb_trialInfo = 'C:\Users\amt80\Documents\65476_PreProcessing_Files\Trigger_and_Trials\D6_task003\D6_Block_3_TrialData.mat';
        taskdate = '161119';
        ieeg_prefix = 'D6_SentenceRep_';
        rec = '001';
        trigger_chan_index = 2;
        mic_chan_index = 4;
        neural_chan_index =[34:129];
        
        %%%%%%%%%%%%%%%%%%%% Palee Start Here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    case 'D49_004' % Task004 PhonemeS PALEE FIRST CASE
        cd 'E:\InUnit Preprocessing\D49\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D49';
        edf_filename = 'E:\InUnit Preprocessing\D49\PhonemeS\D49 200913 Cogan_PhonemeSequence.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D49\PhonemeS\D49_Block_4_TrialData.mat';%trialInfo to reference
        taskdate = '200913';
        ieeg_prefix = 'D49_PhonemeSequencing_';
        rec = '001'; %session number
        trigger_chan_index = 257; %Refer to 'labels' DC1 
        mic_chan_index = 63;
        neural_chan_index =[1:60, 65:126, 129:216]; %Exclude all 'C' channels
        
    case 'D49_006' % Task006 Neighborhood 
        cd 'E:\InUnit Preprocessing\D49\Neighborhood 2'
        taskstim = 'neighborhood_sternberg';
        subj = 'D49';
        edf_filename = 'E:\InUnit Preprocessing\D49\Neighborhood 2\D49 200916 Cogan_SternbergNeighborhood.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Neighborhood 2\D49_Block_1_TrialData.mat';%trialInfo to reference
        taskdate = '200916';
        ieeg_prefix = 'D49_Neighborhood_Sternberg_';
        rec = '001'; %session number
        trigger_chan_index = 257; %Refer to 'labels' DC1 
        mic_chan_index = 63;
        neural_chan_index =[1:60, 65:126, 129:216]; 
        
    case 'D49_008' %Excluded Triggers
        cd 'E:\InUnit Preprocessing\D49\Timit'
        taskstim = 'timit';
        subj = 'D49';
        edf_filename = 'E:\InUnit Preprocessing\D49\Timit\D49 200914 Cogan_TimitQuestions.edf'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '200914';
        ieeg_prefix = 'D49_Timit_';
        rec = '001'; %session number
        %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 63;
        neural_chan_index =[1:60, 65:126, 129:216]; 
        
    case 'D48_004' %PhonemeS Session 1
        cd 'E:\InUnit Preprocessing\D48\PhonemeS\Session 1'
        taskstim = 'phoneme_sequencing';
        subj = 'D48';
        edf_filename = 'E:\InUnit Preprocessing\D48\PhonemeS\Session 1\D48 200906 Cogan_PhonemeSequence_Session1.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D48\PhonemeS\Session 1\D48_Block_3_TrialData.mat';%trialInfo to reference
        taskdate = '200906';
        ieeg_prefix = 'D48_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 63;
        neural_chan_index =[1:60, 65:176]; 
         
    case 'D48_004' %PhonemeS Session 2
        cd 'E:\InUnit Preprocessing\D48\PhonemeS\Session 2'
        taskstim = 'phoneme_sequencing';
        subj = 'D48';
        edf_filename = 'E:\InUnit Preprocessing\D48\PhonemeS\Session 2\D48 200908 Cogan_PhonemeSequence_Session2.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D48\PhonemeS\Session 2\D48_Block_4_TrialData.mat';%trialData to reference
        taskdate = '200908';
        ieeg_prefix = 'D48_PhonemeSequencing_';
        rec = '002'; %session number
        %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 63;
        neural_chan_index =[1:60, 65:176]; 
        
    case 'D48_006' %Neighborhood
        cd 'E:\InUnit Preprocessing\D48\Neighborhood 2'
        taskstim = 'neighborhood_sternberg';
        subj = 'D48';
        edf_filename = 'E:\InUnit Preprocessing\D48\Neighborhood 2\D48 200909 Cogan_SternbergNeighborhood.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D48\Neighborhood 2\D48_Block_1_TrialData';%trialData to reference
        taskdate = '200909';
        ieeg_prefix = 'D48_Neighborhood_Sternberg_';
        rec = '001'; %session number
        %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 63;
        neural_chan_index =[1:60, 65:176]; 
    
    case 'D48_008' 
        cd 'E:\InUnit Preprocessing\D48\playTimit\Session 2'
        taskstim = 'timit';
        subj = 'D48';
        edf_filename = 'E:\InUnit Preprocessing\D48\playTimit\Session 2\D48 200906 Cogan_playTimit_Session2.edf'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D48\playTimit\Session 2\D48_Block_4_TrialData.mat';%trialData to reference
        taskdate = '200906';
        ieeg_prefix = 'D48_playTimit_';
        rec = '002'; %session number
        %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 63;
        neural_chan_index =[1:60, 65:176]; 
        
     case 'D52_004' 
        cd 'E:\InUnit Preprocessing\D52\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D52';
        edf_filename = 'E:\InUnit Preprocessing\D52\PhonemeS\D52 201213 COGAN_PHONEMESEQUENCE.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D52\PhonemeS\D52_Block_4_TrialData.mat';%trialData to reference
        taskdate = '201213';
        ieeg_prefix = 'D52_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 113;
        neural_chan_index =[1:62, 65:108, 129:188, 193:220]; 
      
     case 'D53_004' 
        cd 'E:\InUnit Preprocessing\D53\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D53';
        edf_filename = 'E:\InUnit Preprocessing\D53\PhonemeS\D53 201212 COGAN_PHONEMESEQUENCE.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D53\PhonemeS\D53_Block_4_TrialData.mat';%trialData to reference
        taskdate = '201212';
        ieeg_prefix = 'D53_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 117;
        neural_chan_index =[1:60, 65:114, 129:176]; 
        
    case 'D53_001' % Lexical Delay
        cd 'E:\InUnit Preprocessing\D53\Lexical Delay\'
        taskstim = 'lexical';
        subj = 'D53';
        edf_filename = 'E:\InUnit Preprocessing\D53\Lexical Delay\D53 201212 COGAN_LEXICALDECISION_DELAY.edf';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D53\Lexical Delay\D53_Block_1_TrialData.mat';
        taskdate = '201212';
        ieeg_prefix = 'D53_Lexical_Decision_Delay_';
        rec = '001';
        %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 117;
        neural_chan_index =[1:60, 65:114, 129:176]; 
        
    case 'D53_003' %Sentence Rep
        cd 'E:\InUnit Preprocessing\D53\Sentence Rep\'
        taskstim = 'sentence_rep';
        subj = 'D53';
        edf_filename = 'E:\InUnit Preprocessing\D53\Sentence Rep\D53 201215 COGAN_SENTENCEREP.edf';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D53\Sentence Rep\D53_Block_5_TrialData';
        taskdate = '201215'; %% YYMMDD
        ieeg_prefix = 'D53_Sentence_Rep_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        %%%%%
        trigger_chan_index = 257; % determined by looking at h
        mic_chan_index = 117;
        neural_chan_index = [1:60, 65:114, 129:176];
        
      case 'D53_002' %Lexical No Delay
        cd 'E:\InUnit Preprocessing\D53\Lexical No Delay\'
        taskstim = 'lexical';
        subj = 'D53';
        edf_filename = 'E:\InUnit Preprocessing\D53\Lexical No Delay\D53 201214 COGAN_LEXICALDECISION_NODELAY.edf';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D53\Lexical No Delay\D53_Block_4_TrialData.mat';
        taskdate = '201214'; %% YYMMDD
        ieeg_prefix = 'D53_Lexical_DecisionRepeat_NoDelay_'; % Should end in _
        rec = '001'; % session number
        %%%%%
        trigger_chan_index = 257; % determined by looking at labels
        mic_chan_index = 117;
        neural_chan_index = [1:60, 65:114, 129:176];
        
      case 'D53_005' %Uniqueness Point
        cd 'E:\InUnit Preprocessing\D53\Uniqueness Point\'
        taskstim = 'uniqueness_point';
        subj = 'D53';
        edf_filename = 'E:\InUnit Preprocessing\D53\Uniqueness Point\D53 201214 COGAN_UNIQUENESSPOINT.edf';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D53\Uniqueness Point\D53_Block_4_TrialData.mat';
        taskdate = '201214'; %% YYMMDD
        ieeg_prefix = 'D53_UniquenessPoint_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        %%%%%
        trigger_chan_index = 257; % determined by looking at labels
        mic_chan_index = 117;
        neural_chan_index = [1:60, 65:114, 129:176];
        
     case 'D53_007' %Environmental
        cd 'E:\InUnit Preprocessing\D53\Environmental'
        taskstim = 'environmental_sternberg';
        subj = 'D53';
        edf_filename = 'E:\InUnit Preprocessing\D53\Environmental\D53 201213 COGAN_STERNBERGENVIRONMENT.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D53\Environmental\D53_Block_1_TrialData.mat';%trialData to reference
        taskdate = '201213';%% YYMMDD
        ieeg_prefix = 'D53_environmentalsternberg_';
        rec = '001';
        %%%%%
        trigger_chan_index = 257; % determined by looking at labels
        mic_chan_index = 117;
        neural_chan_index = [1:60, 65:114, 129:176];
        
    case 'D53_006' %Neighborhood 
        cd 'E:\InUnit Preprocessing\D53\Neighborhood'
        taskstim = 'neighborhood_sternberg';
        subj = 'D53';
        edf_filename = 'E:\InUnit Preprocessing\D53\Neighborhood\D53 201212 COGAN_STERNBERGNEIGHBORHOOD.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D53\Neighborhood\D53_Block_1_TrialData.mat';%trialData to reference
        taskdate = '201212';
        ieeg_prefix = 'D53_Neighborhood_Sternberg_';
        rec = '001'; %session number
        %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 63;
        neural_chan_index =[1:60, 65:114, 129:176]; 
        
    case 'D53_008' %Timit
        cd 'E:\InUnit Preprocessing\D53\Timit'
        taskstim = 'timit';
        subj = 'D53';
        edf_filename = 'E:\InUnit Preprocessing\D53\Timit\D53 201213 COGAN_TIMITQUESTIONS (1).edf'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D53\Timit\';%trialData to reference
        taskdate = '201213';
        ieeg_prefix = 'D53_Timit_';
        rec = '001'; %session number
        %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 63;
        neural_chan_index = [1:60, 65:114, 129:176];
        
     case 'D26_002' %Lexical No Delay
        cd 'E:\InUnit Preprocessing\D26\Lexical No Delay\'
        taskstim = 'lexical';
        subj = 'D26';
        edf_filename = 'E:\InUnit Preprocessing\D26\Lexical No Delay\greg_lexical_decision_repeat_within_no_delay_2x_D26.edf';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D26\Lexical No Delay\D26_nodelay_trialdata.mat';
        taskdate = '190127'; %% YYMMDD
        ieeg_prefix = 'D26_Lexical_DecisionRepeat_NoDelay_'; % Should end in _
        rec = '001'; % session number
        %%%%%
        trigger_chan_index = 64; % determined by looking at labels
        mic_chan_index = 66;
        neural_chan_index = [2:61];
        
      case 'D24_002' %Lexical No Delay
        cd 'E:\InUnit Preprocessing\D24\Lexical No Delay\'
        taskstim = 'lexical';
        subj = 'D24';
        edf_filename = 'E:\InUnit Preprocessing\D24\Lexical No Delay\greg_lexical_decision_repeat_within_no_delay_2x_D24.edf';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D24\Lexical No Delay\D24_nodelay_trialdata.mat';
        taskdate = '181028'; %% YYMMDD
        ieeg_prefix = 'D26_Lexical_DecisionRepeat_NoDelay_'; % Should end in _
        rec = '001'; % session number
        %%%%%
        trigger_chan_index = 56; % determined by looking at labels
        mic_chan_index = 58;
        neural_chan_index = [2:53];
                           
    case 'D54_001' % Lexical Delay
        cd 'E:\InUnit Preprocessing\D54\Lexical Delay\'
        taskstim = 'lexical';
        subj = 'D54';
        edf_filename = 'E:\InUnit Preprocessing\D54\Lexical Delay\D54 210127 COGAN_LEXICALDECISION_DELAY.edf';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D54\Lexical Delay\D54_Block_1_TrialData.mat';
        taskdate = '210127';
        ieeg_prefix = 'D54_Lexical_Decision_Delay_';
        rec = '001';
        %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 60;
        neural_chan_index =[1:56, 65:118, 129:184, 193:226]; 
        
      case 'D54_004' 
        cd 'E:\InUnit Preprocessing\D54\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D54';
        edf_filename = 'E:\InUnit Preprocessing\D54\PhonemeS\D54 210127 COGAN_PHONEMESEQUENCES.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D54\PhonemeS\D54_Block_4_TrialData.mat';%trialData to reference
        taskdate = '210127';
        ieeg_prefix = 'D54_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 60;
        neural_chan_index =[1:56, 65:118, 129:184, 193:226]; 
        
      case 'D54_005'
        cd 'E:\InUnit Preprocessing\D54\Uniqueness Point'
        taskstim = 'uniqueness_point';
        subj = 'D54';
        edf_filename = 'E:\InUnit Preprocessing\D54\Uniqueness Point\D54 210129 COGAN_UNIQUENESSPOINT.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D54\Uniqueness Point\D54_Block_4_TrialData.mat'; %trialData to reference
        taskdate = '210129'; %% YYMMDD
        ieeg_prefix = 'D54_Uniqueness_Point_'; % Should end in _
        rec = '001'; % session number
        %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 60;
        neural_chan_index =[1:56, 65:118, 129:184, 193:226]; 
   
      case 'D54_006' %Neighborhood 
        cd 'E:\InUnit Preprocessing\D54\Neighborhood'
        taskstim = 'neighborhood_sternberg';
        subj = 'D54';
        edf_filename = 'E:\InUnit Preprocessing\D54\Neighborhood\D54 210128 COGAN_STERNBERGNEIGHBORHOOD.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D54\Neighborhood\D54_Block_1_TrialData.mat';%trialData to reference
        taskdate = '210128';
        ieeg_prefix = 'D54_Neighborhood_Sternberg_';
        rec = '001'; %session number
        %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 60;
        neural_chan_index =[1:56, 65:118, 129:184, 193:226]; 
        
     case 'D54_002' %Lexical No Delay
        cd 'E:\InUnit Preprocessing\D54\Lexical No Delay\'
        taskstim = 'lexical';
        subj = 'D54';
        edf_filename = 'E:\InUnit Preprocessing\D54\Lexical No Delay\D54 210201 COGAN_LEXICALDECISION_NODELAY 2.edf';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D54\Lexical No Delay\D54_Block_4_TrialData.mat';
        taskdate = '210201'; %% YYMMDD
        ieeg_prefix = 'D54_Lexical_DecisionRepeat_NoDelay_'; % Should end in _
        rec = '001'; % session number
        %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 60;
        neural_chan_index =[1:56, 65:118, 129:184, 193:226]; 
        
    case 'D54_008' %Timit
        cd 'E:\InUnit Preprocessing\D54\Timit'
        taskstim = 'timit';
        subj = 'D54';
        edf_filename = 'E:\InUnit Preprocessing\D54\Timit\D54 20127 COGAN_TIMITQUESTIONS.edf'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D53\Timit\';%trialData to reference
        taskdate = '210127';
        ieeg_prefix = 'D54_Timit_';
        rec = '001'; %session number
        %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 60;
        neural_chan_index =[1:56, 65:118, 129:184, 193:226];
        
      case 'D54_003' %Sentence Rep
        cd 'E:\InUnit Preprocessing\D54\Sentence Rep\Session 2'
        taskstim = 'sentence_rep';
        subj = 'D54';
        edf_filename = 'E:\InUnit Preprocessing\D54\Sentence Rep\Session 2\D54 210128 COGAN_SENTENCEREP_SESSION2.edf';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D54\Sentence Rep\Session 2\D54_Block_2_TrialData.mat';
        taskdate = '210128'; %% YYMMDD
        ieeg_prefix = 'D54_Sentence_Rep_'; % Should end in _
        rec = '002'; % if this was part2, then '002'
        %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 60;
        neural_chan_index =[1:56, 65:118, 129:184, 193:226];
        
      case 'D55_004' 
        cd 'E:\InUnit Preprocessing\D55\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D55';
        edf_filename = 'E:\InUnit Preprocessing\D55\PhonemeS\D55 210227 COGAN_PHONEMESEQUENCE.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D55\PhonemeS\D55_Block_4_TrialData.mat';%trialData to reference
        taskdate = '210227';
        ieeg_prefix = 'D55_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 258;
        neural_chan_index =[1:60, 65:124, 129:184, 193:206]; 
        
      case 'D55_006' %Neighborhood 
        cd 'E:\InUnit Preprocessing\D55\Neighborhood'
        taskstim = 'neighborhood_sternberg';
        subj = 'D55';
        edf_filename = 'E:\InUnit Preprocessing\D55\Neighborhood\D55 210228 COGAN_STERNBERGNEIGHBORHOOD.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D55\Neighborhood\D55_Block_1_TrialData.mat';%trialData to reference
        taskdate = '210228';
        ieeg_prefix = 'D55_Neighborhood_Sternberg_';
        rec = '001'; %session number
        %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 258;
        neural_chan_index =[1:60, 65:124, 129:184, 193:206]; 
        
     case 'D55_007' %Environmental
        cd 'E:\InUnit Preprocessing\D55\Environmental'
        taskstim = 'environmental_sternberg';
        subj = 'D55';
        edf_filename = 'E:\InUnit Preprocessing\D55\Environmental\D55 210301 COGAN_STERNBERGENVIRONMENT.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D55\Environmental\D55_Block_1_TrialData.mat';%trialData to reference
        taskdate = '210301';%% YYMMDD
        ieeg_prefix = 'D55_environmentalsternberg_';
        rec = '001';
         %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 258;
        neural_chan_index =[1:60, 65:124, 129:184, 193:206]; 
        
      case 'D55_001' % Lexical Delay
        cd 'E:\InUnit Preprocessing\D55\Lexical Delay\'
        taskstim = 'lexical';
        subj = 'D55';
        edf_filename = 'E:\InUnit Preprocessing\D55\Lexical Delay\D55 210301 COGAN_LEXICALDECISION_DELAY.edf';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D55\Lexical Delay\D55_Block_1_TrialData.mat';
        taskdate = '210301';
        ieeg_prefix = 'D55_Lexical_Decision_Delay_';
        rec = '001'
           %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 258;
        neural_chan_index =[1:60, 65:124, 129:184, 193:206]; 
               
      case 'D55_008' %Timit
        cd 'E:\InUnit Preprocessing\D55\Timit'
        taskstim = 'timit';
        subj = 'D55';
        edf_filename = 'E:\InUnit Preprocessing\D55\Timit\D55 210228 COGAN_TIMITQUESTIONS.edf'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D53\Timit\';%trialData to reference
        taskdate = '210228';
        ieeg_prefix = 'D55_Timit_';
        rec = '001'; %session number
         %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 258;
        neural_chan_index =[1:60, 65:124, 129:184, 193:206]; 
        
      case 'D56_004' %PhonemeS
        cd 'E:\InUnit Preprocessing\D56\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D56';
        edf_filename = 'E:\InUnit Preprocessing\D56\PhonemeS\D56 210313 COGAN_PHONEMESEQUENCE.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D56\PhonemeS\D56_Block_4_TrialData.mat';%trialData to reference
        taskdate = '210313';
        ieeg_prefix = 'D56_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 258;
        neural_chan_index =[1:62, 65:120, 129:138];
        
       case 'D56_008' %Timit
        cd 'E:\InUnit Preprocessing\D56\Timit'
        taskstim = 'timit';
        subj = 'D56';
        edf_filename = 'E:\InUnit Preprocessing\D56\Timit\D56 210313 COGAN_TIMITQUESTIONS.edf'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D53\Timit\';%trialData to reference
        taskdate = '210313';
        ieeg_prefix = 'D56_Timit_';
        rec = '001'; %session number
        %%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 258;
        neural_chan_index =[1:62, 65:120, 129:138];
        
        
     case 'D47_008' %Timit
        cd 'E:\InUnit Preprocessing\D47\Timit'
        taskstim = 'timit';
        subj = 'D47';
        edf_filename = 'E:\InUnit Preprocessing\D47\Timit\D47 200314 COGAN_TIMITQUESTIONS.edf'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D47\Timit\D47_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '200314';
        ieeg_prefix = 'D47_Timit_';
        rec = '001'; %session number
        %%%%%
        trigger_chan_index = 257;
        mic_chan_index = 117;
        neural_chan_index = [1:63,65:112,129:182,193:252];
        
     case 'D46_008' %Timit
        cd 'E:\InUnit Preprocessing\D46\Timit'
        taskstim = 'timit';
        subj = 'D46';
        edf_filename = 'E:\InUnit Preprocessing\D46\Timit\D46 200307 COGAN_TIMITQUESTIONS.edf'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D47\Timit\D47_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '200307';
        ieeg_prefix = 'D46_Timit_';
        rec = '001'; %session num.
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 117;
        neural_chan_index = [1:55,65:124,129:170];
        
      case 'D28_007'
        cd 'E:\InUnit Preprocessing\D28\Environmental'
        taskstim = 'environmental_sternberg';
        subj = 'D28';
        edf_filename = 'E:\InUnit Preprocessing\D28\Environmental\D28 190307 Cogan_SternbergEnvironment.edf'; 
        ptb_trialInfo = 'E:\InUnit Preprocessing\D28\Environmental\D28_Block_1_TrialData.mat'; 
        taskdate = '190307';
        ieeg_prefix = 'D28_EnvironmentalSternberg_';
        rec = '001';
        %%%%%%%
        trigger_chan_index = 113;
        mic_chan_index = 114;
        neural_chan_index = [2:109];
        
      case 'D54_007' %Environmental
        cd 'E:\InUnit Preprocessing\D54\Environmental'
        taskstim = 'environmental_sternberg';
        subj = 'D54';
        edf_filename = 'E:\InUnit Preprocessing\D54\Environmental\D54 210129 COGAN_STERNBERGENVIRONMENT.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D54\Environmental\D54_Block_1_TrialData.mat';%trialData to reference
        taskdate = '210129';%% YYMMDD
        ieeg_prefix = 'D54_environmentalsternberg_';
        rec = '001';
        %%%%%%%
        trigger_chan_index = 257; 
        mic_chan_index = 60;
        neural_chan_index =[1:56, 65:118, 129:184, 193:226];
        
       case 'D58_004' %PhonemeS
        cd 'E:\InUnit Preprocessing\D58\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D58';
        edf_filename = 'E:\InUnit Preprocessing\D58\PhonemeS\D58 210530 COGAN_PHONEMESEQUENCE.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D58\PhonemeS\D58_Block_4_TrialData.mat';%trialData to reference
        taskdate = '210530';
        ieeg_prefix = 'D58_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 117;
        neural_chan_index = [1:62,65:126,129:184, 193:256 ];
        
      case 'D57_004' %PhonemeS
        cd 'E:\InUnit Preprocessing\D57\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D57';
        edf_filename = 'E:\InUnit Preprocessing\D57\PhonemeS\D57 210529 COGAN_PHONEME SEQUENCE.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D57\PhonemeS\D57_Block_4_TrialData.mat';%trialData to reference
        taskdate = '210529';
        ieeg_prefix = 'D57PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:60, 65:124, 129:186  ];
        
      case 'D57_008' 
        cd 'E:\InUnit Preprocessing\D57\Timit'
        taskstim = 'timit';
        subj = 'D57';
        edf_filename = 'E:\InUnit Preprocessing\D57\Timit\D57 210530 COGAN_TIMITQUESTIONS.edf'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '210530';
        ieeg_prefix = 'D57_Timit_';
        rec = '001'; %session number
         %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:60, 65:124, 129:186 ];
        
      case 'D57_006' %Neighborhood 
        cd 'E:\InUnit Preprocessing\D57\Neighborhood'
        taskstim = 'neighborhood_sternberg';
        subj = 'D57';
        edf_filename = 'E:\InUnit Preprocessing\D57\Neighborhood\D57 210530 COGAN_STERNBERGNEIGHBORHOOD.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D57\Neighborhood\D57_Block_1_TrialData.mat';%trialData to reference
        taskdate = '210530';
        ieeg_prefix = 'D57_Neighborhood_Sternberg_';
        rec = '001'; %session number
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:60, 65:124, 129:186 ];
        
      case 'D57_001' % Lexical Delay
        cd 'E:\InUnit Preprocessing\D57\Lexical Delay\'
        taskstim = 'lexical';
        subj = 'D57';
        edf_filename = 'E:\InUnit Preprocessing\D57\Lexical Delay\D57 210531 COGAN_LEXICALDECISIONMAKING.edf';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D57\Lexical Delay\D57_Block_1_TrialData.mat';
        taskdate = '210531';
        ieeg_prefix = 'D57_Lexical_Decision_Delay_';
        rec = '001';
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:60, 65:124, 129:186 ];
        
     case 'D57_003' %Sentence Rep
        cd 'E:\InUnit Preprocessing\D57\Sentence Rep'
        taskstim = 'sentence_rep';
        subj = 'D57';
        edf_filename = 'E:\InUnit Preprocessing\D57\Sentence Rep\D57 210601 COGAN_SENTENCEREP.edf';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D57\Sentence Rep\D57_Block_5_TrialData.mat';
        taskdate = '210601'; %% YYMMDD
        ieeg_prefix = 'D57_Sentence_Rep_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:60, 65:124, 129:186 ];
        
      case 'D57_007' %Environmental
        cd 'E:\InUnit Preprocessing\D57\Environmental'
        taskstim = 'environmental_sternberg';
        subj = 'D57';
        edf_filename = 'E:\InUnit Preprocessing\D57\Environmental\D57 210604 COGAN_STERNBERGENVIRONMENT.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D57\Environmental\D57_Block_1_TrialData.mat';%trialData to reference
        taskdate = '210604';%% YYMMDD
        ieeg_prefix = 'D57_environmentalsternberg_';
        rec = '001';
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:60, 65:124, 129:186];
        
    case 'D57_005'
        cd 'E:\InUnit Preprocessing\D57\Uniqueness Point'
        taskstim = 'uniqueness_point';
        subj = 'D57';
        edf_filename = 'E:\InUnit Preprocessing\D57\Uniqueness Point\D57 210605 COGAN_UNIQUENESSPOINT.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D57\Uniqueness Point\D57_Block_4_TrialData.mat'; %trialData to reference
        taskdate = '210605'; %% YYMMDD
        ieeg_prefix = 'D57_Uniqueness_Point_'; % Should end in _
        rec = '001'; % session number
         %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:60, 65:124, 129:186];
        
    case 'D57_002' %Lexical No Delay
        cd 'E:\InUnit Preprocessing\D57\Lexical No Delay\'
        taskstim = 'lexical';
        subj = 'D57';
        edf_filename = 'E:\InUnit Preprocessing\D57\Lexical No Delay\D57 210607 COGAN_LEXICALDECISION_NODELAY.edf';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D57\Lexical No Delay\D57_Block_4_TrialData.mat';
        taskdate = '210607'; %% YYMMDD
        ieeg_prefix = 'D57_Lexical_NoDelay_'; % Should end in _
        rec = '001'; % session number
        %%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:60, 65:124, 129:186];
        
      case 'D58_008' 
        cd 'E:\InUnit Preprocessing\D58\Timit'
        taskstim = 'timit';
        subj = 'D58';
        edf_filename = 'E:\InUnit Preprocessing\D58\Timit\D58 210531 COGAN_TIMITQUESTIONS.edf'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '210531';
        ieeg_prefix = 'D58_Timit_';
        rec = '001'; %session number
         %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 117;
        neural_chan_index = [1:62,65:126,129:184, 193:256 ];
        
     case 'D59_005'
        cd 'E:\InUnit Preprocessing\D59\Uniqueness Point'
        taskstim = 'uniqueness_point';
        subj = 'D59';
        edf_filename = 'E:\InUnit Preprocessing\D59\Uniqueness Point\D59 210720 COGAN_UNIQUENESSPOINT.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D59\Uniqueness Point\D59_Block_4_TrialData.mat'; %trialData to reference
        taskdate = '210720'; %% YYMMDD
        ieeg_prefix = 'D59Uniqueness_Point_'; % Should end in _
        rec = '001'; % session number
         %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:52, 65:122 129:186 193:208];
        
        
      case 'D59_006' %Neighborhood 
        cd 'E:\InUnit Preprocessing\D59\Neighborhood'
        taskstim = 'neighborhood_sternberg';
        subj = 'D59';
        edf_filename = 'E:\InUnit Preprocessing\D59\Neighborhood\D59 210716 COGAN_STERNBERGNEIGHBORHOOD.edf'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D59\Neighborhood\D59_Block_1_TrialData.mat';%trialData to reference
        taskdate = '210716';
        ieeg_prefix = 'D59_Neighborhood_Sternberg_';
        rec = '001'; %session number
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:52, 65:122 129:186 193:208];
        
        
      case 'D59_004' %PhonemeS
        cd 'E:\InUnit Preprocessing\D59\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D59';
        edf_filename = 'E:\InUnit Preprocessing\D59\PhonemeS\D59 210716 COGAN_PHONEMESEQUENCE.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D59\PhonemeS\D59_Block_4_TrialData.mat';%trialData to reference
        taskdate = '210716';
        ieeg_prefix = 'D59_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:52, 65:122 129:186 193:208];
      
        
      case 'D59_003' %Sentence Rep
        cd 'C:\Users\ae166\Box\CoganLab\D_Data\SentenceRep\D59'
        taskstim = 'sentence_rep';
        subj = 'D59';
        edf_filename = 'D59 210717 COGAN_SENTENCEREP.edf';
        ptb_trialInfo = 'D59_Block_5_TrialData.mat';
        taskdate = '210717'; %% YYMMDD
        ieeg_prefix = 'D59_Sentence_Rep_'; % Should end in _
        rec = '001'; % if this was part2, then '002'
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:52, 65:122 129:186 193:208];
        
      
      case 'D59_001' % Lexical Delay
        cd 'E:\InUnit Preprocessing\D59\Lexical Delay\'
        taskstim = 'lexical';
        subj = 'D59';
        edf_filename = 'E:\InUnit Preprocessing\D59\Lexical Delay\D59 210717 COGAN_LEXICALDECISION_DELAY.edf';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D59\Lexical Delay\D59_Block_1_TrialData.mat';
        taskdate = '210717';
        ieeg_prefix = 'D59_Lexical_Delay_';
        rec = '001';
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:52, 65:122 129:186 193:208];
        
        
      case 'D60_003' %Sentence Rep
        cd 'E:\InUnit Preprocessing\D60\Sentence Rep'
        taskstim = 'sentence_rep';
        subj = 'D60';
        edf_filename = 'E:\InUnit Preprocessing\D60\Sentence Rep\D60 210725 COGAN_SENTENCEREP.EDF';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D60\Sentence Rep\D60_Block_5_TrialData.mat';
        taskdate = '210725'; %% YYMMDD
        ieeg_prefix = 'D60_Sentence_Rep_'; % Should end in _
        rec = '001'; 
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:118, 129:184 193:254];
        
     case 'D60_004' %PhonemeS
        cd 'E:\InUnit Preprocessing\D60\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D60';
        edf_filename = 'E:\InUnit Preprocessing\D60\PhonemeS\D60 210724 COGAN_PHONEMESEQUENCE.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D60\PhonemeS\D60_Block_4_TrialData.mat';%trialData to reference
        taskdate = '210724';
        ieeg_prefix = 'D60_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:118, 129:184 193:254];
        
     case 'D60_008' 
        cd 'E:\InUnit Preprocessing\D60\Timit'
        taskstim = 'timit';
        subj = 'D60';
        edf_filename = 'E:\InUnit Preprocessing\D60\Timit\D60 210724 COGAN_TIMITQUESTIONS.edf'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '210724';
        ieeg_prefix = 'D60_Timit_';
        rec = '001'; %session number
         %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:118, 129:184 193:254];
        
     case 'D59_008' 
        cd 'E:\InUnit Preprocessing\D59\Timit 2'
        taskstim = 'timit';
        subj = 'D59';
        edf_filename = 'E:\InUnit Preprocessing\D59\Timit 2\D59 210716 COGAN_TIMITQUESTIONS.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '210716';
        ieeg_prefix = 'D59_Timit_';
        rec = '001'; %session number
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:52, 65:122 129:186 193:208];
        
     case 'D61_003' %Sentence Rep
        cd 'E:\InUnit Preprocessing\D61\Sentence Rep'
        taskstim = 'sentence_rep';
        subj = 'D61';
        edf_filename = 'E:\InUnit Preprocessing\D61\Sentence Rep\D61 210830 COGAN_SENTENCEREP.EDF';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D61\Sentence Rep\D61_Block_5_TrialData.mat';
        taskdate = '210830'; %% YYMMDD
        ieeg_prefix = 'D61_Sentence_Rep_'; % Should end in _
        rec = '001'; 
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:42, 65:254];   
        
        
     case 'D61_004' %PhonemeS
        cd 'E:\InUnit Preprocessing\D61\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D61';
        edf_filename = 'E:\InUnit Preprocessing\D61\PhonemeS\D61 210828 COGAN_PHONEMESEQUENCE.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D61\PhonemeS\D61_Block_4_TrialData.mat';%trialData to reference
        taskdate = '210828';
        ieeg_prefix = 'D61_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:42, 65:254];  
        
      case 'D61_006' %Neighborhood 
        cd 'E:\InUnit Preprocessing\D61\Neighborhood'
        taskstim = 'neighborhood_sternberg';
        subj = 'D61';
        edf_filename = 'E:\InUnit Preprocessing\D61\Neighborhood\D61 210829 COGAN_NEIGHBORHOOD.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D61\Neighborhood\D61_Block_1_TrialData.mat';%trialData to reference
        taskdate = '210829';
        ieeg_prefix = 'D61_Neighborhood_Sternberg_';
        rec = '001'; %session number
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:42, 65:254]; 
        
      case 'D61_008' %Timit
        cd 'E:\InUnit Preprocessing\D61\Timit'
        taskstim = 'timit';
        subj = 'D61';
        edf_filename = 'E:\InUnit Preprocessing\D61\Timit\D61 210828 COGAN_TIMITQUESTIONS.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '210828';
        ieeg_prefix = 'D61_Timit_';
        rec = '001'; %session number
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:42, 65:254 ]; 
        
     case 'D63_001' % Lexical Delay
        cd 'E:\InUnit Preprocessing\D63\Lexical Delay\'
        taskstim = 'lexical';
        subj = 'D63';
        edf_filename = 'E:\InUnit Preprocessing\D63\Lexical Delay\D63 210919 COGAN_LEXICALDELAY.EDF';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D63\Lexical Delay\D63_Block_1_TrialData.mat';
        taskdate = '210919';
        ieeg_prefix = 'D63_Lexical_Delay_';
        rec = '001';
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:126];
        
     case 'D63_002' % Lexical No Delay
        cd 'E:\InUnit Preprocessing\D63\Lexical No Delay\'
        taskstim = 'lexical';
        subj = 'D63';
        edf_filename = 'E:\InUnit Preprocessing\D63\Lexical No Delay\D63 210921 COGAN_LEXICALNODELAY.EDF';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D63\Lexical No Delay\D63_Block_4_TrialData.mat';
        taskdate = '210921';
        ieeg_prefix = 'D63_Lexical_No_Delay_';
        rec = '001';
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:126];
        
     case 'D45_004' %PhonemeS %Redone for ieeg.dat file
        cd 'E:\InUnit Preprocessing\D45\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D45';
        edf_filename = 'E:\InUnit Preprocessing\D45\PhonemeS\D45_200126 COGAN_PHONEMESEQUENCING.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D45\PhonemeS\D45_Block_4_TrialData.mat';%trialData to reference
        taskdate = '200126';
        ieeg_prefix = 'D45_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 61;
        neural_chan_index = [1:56, 65:124, 129:214];
        
      case 'D63_006' %Neighborhood 
        cd 'E:\InUnit Preprocessing\D63\Neighborhood'
        taskstim = 'neighborhood_sternberg';
        subj = 'D63';
        edf_filename = 'E:\InUnit Preprocessing\D63\Neighborhood\D63 210919 COGAN_NEIGHBORHOOD.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D63\Neighborhood\D63_Block_1_TrialData.mat';%trialData to reference
        taskdate = '210919';
        ieeg_prefix = 'D63_Neighborhood_Sternberg_';
        rec = '001'; %session number
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:126 129:250];
        
      case 'D63_005' %Uniqueness
        cd 'E:\InUnit Preprocessing\D63\Uniqueness Point'
        taskstim = 'uniqueness_point';
        subj = 'D63';
        edf_filename = 'E:\InUnit Preprocessing\D63\Uniqueness Point\D63 210920 COGAN_UNIQUENESSPOINT.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D63\Uniqueness Point\D63_Block_4_TrialData.mat'; %trialData to reference
        taskdate = '210920'; %% YYMMDD
        ieeg_prefix = 'D63_Uniqueness_Point_'; % Should end in _
        rec = '001'; % session number
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:126 129:250];
        
      case 'D63_004' %PhonemeS
        cd 'E:\InUnit Preprocessing\D63\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D63';
        edf_filename = 'E:\InUnit Preprocessing\D63\PhonemeS\D63 210918 COGAN_PHONEMESEQUENCE.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D63\PhonemeS\D63_Block_4_TrialData.mat';%trialData to reference
        taskdate = '210918';
        ieeg_prefix = 'D63_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:126 129:250];
        
     case 'D63_007' %Environmental
        cd 'E:\InUnit Preprocessing\D63\Environmental'
        taskstim = 'environmental_sternberg';
        subj = 'D63';
        edf_filename = 'E:\InUnit Preprocessing\D63\Environmental\D63 210922 COGAN_ENVIRONMENTAL.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D63\Environmental\D63_Block_1_TrialData.mat';%trialData to reference
        taskdate = '210922';%% YYMMDD
        ieeg_prefix = 'D63_environmentalsternberg_';
        rec = '001';
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:126 129:250];
        
      case 'D63_008' %Timit
        cd 'E:\InUnit Preprocessing\D63\Timit'
        taskstim = 'timit';
        subj = 'D63';
        edf_filename = 'E:\InUnit Preprocessing\D63\Timit\D63 210918 COGAN_TIMIT.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '210918';
        ieeg_prefix = 'D63_Timit_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:126 129:250];
        
        
      case 'D63_009' %Global Local
        cd 'E:\InUnit Preprocessing\Global Local\D63'
        taskstim = 'GL';
        subj = 'D63';
        edf_filename = 'E:\InUnit Preprocessing\Global Local\D63\D63 210921 COGAN_GLOBALLOCAL.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '210921';
        ieeg_prefix = 'D63_GlobalLocal_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:126 129:250];
        
     case 'D59_009' %Global Local
        cd 'E:\InUnit Preprocessing\Global Local\D59'
        taskstim = 'GL';
        subj = 'D59';
        edf_filename = 'E:\InUnit Preprocessing\Global Local\D59\D59 210721 COGAN_GLOBALLOCAL.edf'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '210721';
        ieeg_prefix = 'D59_GlobalLocal_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:52, 65:122 129:186 193:208];
        
        
     case 'D57_009' %Global Local
        cd 'E:\InUnit Preprocessing\Global Local\D57'
        taskstim = 'GL';
        subj = 'D57';
        edf_filename = 'E:\InUnit Preprocessing\Global Local\D57\D57 210603 COGAN_GLOBALLOCAL.edf'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '210603';
        ieeg_prefix = 'D57_GlobalLocal_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:60, 65:124, 129:186  ];
        
      case 'D65_009' %Global Local
        cd 'D:\InUnit Preprocessing\D65\Global Local'
        taskstim = 'GL';
        subj = 'D65';
        edf_filename = 'D:\InUnit Preprocessing\D65\Global Local\D65 211122 COGAN_GLOBALLOCAL.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '211122';
        ieeg_prefix = 'D65_GlobalLocal_';
        rec = '001'; %session number
        %%%%%%%% 
        trigger_chan_index = 249;
        mic_chan_index = 258;
        neural_chan_index = [1:62 65:124 129:170 185:240];
        
        
     case 'D64_004' %PhonemeS
        cd 'E:\InUnit Preprocessing\D64\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D64';
        edf_filename = 'E:\InUnit Preprocessing\D64\PhonemeS\D64 211106 COGAN_PHONEMESEQUENCING.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D64\PhonemeS\D64_Block_4_TrialData.mat';%trialData to reference
        taskdate = '211106';
        ieeg_prefix = 'D64_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:50, 65:182 193:204 ];
        
     case 'D64_003' %Sentence Rep
        cd 'E:\InUnit Preprocessing\D64\Sentence Rep'
        taskstim = 'sentence_rep';
        subj = 'D64';
        edf_filename = 'E:\InUnit Preprocessing\D64\Sentence Rep\D64 211108 COGAN_SENTENCEREP.EDF';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D64\Sentence Rep\D64_Block_5_TrialData.mat';
        taskdate = '211108'; %% YYMMDD
        ieeg_prefix = 'D64_Sentence_Rep_'; % Should end in _
        rec = '001'; 
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:50, 65:182 193:204 ];
        
       case 'D64_006' %Neighborhood 
        cd 'E:\InUnit Preprocessing\D64\Neighborhood'
        taskstim = 'neighborhood_sternberg';
        subj = 'D64';
        edf_filename = 'E:\InUnit Preprocessing\D64\Neighborhood\D64 211107 COGAN_NEIGHBORHOOD.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D64\Neighborhood\D64_Block_1_TrialData.mat';%trialData to reference
        taskdate = '211107';
        ieeg_prefix = 'D64_Neighborhood_Sternberg_';
        rec = '001'; %session number
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 256;
        neural_chan_index = [1:50, 65:182 193:204 ];
        
       case 'D64_007' %Environmental
        cd 'E:\InUnit Preprocessing\D64\Environmental'
        taskstim = 'environmental_sternberg';
        subj = 'D64';
        edf_filename = 'E:\InUnit Preprocessing\D64\Environmental\D64 211108 COGAN_ENVIRONMENTAL.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D64\Environmental\D64_Block_1_TrialData.mat';%trialData to reference
        taskdate = '211108';%% YYMMDD
        ieeg_prefix = 'D64_environmentalsternberg_';
        rec = '001';
        %%%%%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 256;
        neural_chan_index = [1:50, 65:182 193:204 ];
        
     case 'D64_008' %Timit
        cd 'E:\InUnit Preprocessing\D64\Timit'
        taskstim = 'timit';
        subj = 'D64';
        edf_filename = 'E:\InUnit Preprocessing\D64\Timit\D64 211107 COGAN_TIMIT.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '211107';
        ieeg_prefix = 'D64_Timit_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 256;
        neural_chan_index = [1:50, 65:182 193:204 ];
        
        
     case 'D65_001' % Lexical Delay
        cd 'D:\InUnit Preprocessing\D65\Lexical Delay\'
        taskstim = 'lexical';
        subj = 'D65';
        edf_filename = 'D:\InUnit Preprocessing\D65\Lexical Delay\D65 211120 COGAN_LEXICALDELAY.EDF';
        ptb_trialInfo = 'D:\InUnit Preprocessing\D65\Lexical Delay\D65_Block_1_TrialData.mat';
        taskdate = '211120';
        ieeg_prefix = 'D65_Lexical_Delay_';
        rec = '001';
        %%%%%%%% 
         trigger_chan_index = 249;
        mic_chan_index = 258;
        neural_chan_index = [1:62 65:124 129:170 185:240];
        
      case 'D65_004' %PhonemeS
        cd 'D:\InUnit Preprocessing\D65\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D65';
        edf_filename = 'D:\InUnit Preprocessing\D65\PhonemeS\D65 211120 COGAN_PHONEMESEQUENCING.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit Preprocessing\D65\PhonemeS\D65_Block_4_TrialData.mat';%trialData to reference
        taskdate = '211120';
        ieeg_prefix = 'D65_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%%%% 
        trigger_chan_index = 249;
        mic_chan_index = 258;
        neural_chan_index = [1:62 65:124 129:170 185:240];
        
    case 'D65_008' %Timit- missing triggers
        cd 'E:\InUnit Preprocessing\D65\Timit'
        taskstim = 'timit';
        subj = 'D65';
        edf_filename = 'E:\InUnit Preprocessing\D65\Timit\D65 211120 COGAN_TIMIT.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '211120';
        ieeg_prefix = 'D65_Timit_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:62 65:124 129:178 193:248];
        
     case 'D65_006' %Neighborhood 
        cd 'D:\InUnit Preprocessing\D65\Neighborhood'
        taskstim = 'neighborhood_sternberg';
        subj = 'D65';
        edf_filename = 'D:\InUnit Preprocessing\D65\Neighborhood\D65 211121 COGAN_NEIGHBORHOOD.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit Preprocessing\D65\Neighborhood\D65_Block_1_TrialData.mat';%trialData to reference
        taskdate = '211121';
        ieeg_prefix = 'D65_Neighborhood_Sternberg_';
        rec = '001'; %session number
        %%%%%%%% 
        trigger_chan_index = 249;
        mic_chan_index = 258;
        neural_chan_index = [1:62 65:124 129:170 185:240];
        
     case 'D65_002' % Lexical No Delay
        cd 'D:\InUnit Preprocessing\D65\Lexical No Delay\'
        taskstim = 'lexical';
        subj = 'D65';
        edf_filename = 'D:\InUnit Preprocessing\D65\Lexical No Delay\D65 211123 COGAN_LEXICALNODELAY.EDF';
        ptb_trialInfo = 'D:\InUnit Preprocessing\D65\Lexical No Delay\D65_Block_4_TrialData.mat';
        taskdate = '211123';
        ieeg_prefix = 'D65_Lexical_No_Delay_';
        rec = '001';
        %%%%%%%% 
        trigger_chan_index = 249;
        mic_chan_index = 258;
        neural_chan_index = [1:62 65:124 129:170 185:240];
        
       case 'D65_005' %Uniqueness
        cd 'D:\InUnit Preprocessing\D65\Uniqueness Point'
        taskstim = 'uniqueness_point';
        subj = 'D65';
        edf_filename = 'D:\InUnit Preprocessing\D65\Uniqueness Point\D65 211121 COGAN_UNIQUENESSPOINT.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit Preprocessing\D65\Uniqueness Point\D65_Block_4_TrialData.mat'; %trialData to reference
        taskdate = '211121'; %% YYMMDD
        ieeg_prefix = 'D65_Uniqueness_Point_'; % Should end in _
        rec = '001'; % session number
        %%%%%%%% 
        trigger_chan_index = 249;
        mic_chan_index = 258;
        neural_chan_index = [1:62 65:124 129:170 185:240];
        
      case 'D65_003' %Sentence Rep
        cd 'D:\InUnit Preprocessing\D65\Sentence Rep'
        taskstim = 'sentence_rep';
        subj = 'D65';
        edf_filename = 'D:\InUnit Preprocessing\D65\Sentence Rep\D65 211121 COGAN_SENTENCEREP.EDF';
        ptb_trialInfo = 'D:\InUnit Preprocessing\D65\Sentence Rep\D65_Block_5_TrialData.mat';
        taskdate = '211121'; %% YYMMDD
        ieeg_prefix = 'D65_Sentence_Rep_'; % Should end in _
        rec = '001'; 
        %%%%%%%% 
        trigger_chan_index = 249;
        mic_chan_index = 258;
        neural_chan_index = [1:62 65:124 129:170 185:240];
        
    case 'D65_007' %Environmental_1- missing triggers
        cd 'E:\InUnit Preprocessing\D65\Environmental\1'
        taskstim = 'environmental_sternberg';
        subj = 'D65';
        edf_filename = 'E:\InUnit Preprocessing\D65\Environmental\1\D65 211122 COGAN_ENVIRONMENTAL_1.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D65\Environmental\1\D65_Block_1_TrialData.mat';%trialData to reference
        taskdate = '211122';%% YYMMDD
        ieeg_prefix = 'D65_environmentalsternberg_';
        rec = '001';
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:62 65:124 129:178 193:248];
        
      case 'D65_007' %Environmental_2
        cd 'E:\InUnit Preprocessing\D65\Environmental\2'
        taskstim = 'environmental_sternberg';
        subj = 'D65';
        edf_filename = 'E:\InUnit Preprocessing\D65\Environmental\2\D65 211122 COGAN_ENVIRONMENTAL_2.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D65\Environmental\2\D65_Block_1_TrialData.mat';%trialData to reference
        taskdate = '211122';%% YYMMDD
        ieeg_prefix = 'D65_environmentalsternberg_';
        rec = '002';
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:62 65:124 129:178 193:248];
        
      case 'D63_003' %Sentence Rep_1
        cd 'E:\InUnit Preprocessing\D63\Sentence Rep\1'
        taskstim = 'sentence_rep';
        subj = 'D63';
        edf_filename = 'E:\InUnit Preprocessing\D63\Sentence Rep\1\D63 210918 COGAN_SENTENCREP_1.EDF';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D63\Sentence Rep\1\D63_Block_2_TrialData.mat';
        taskdate = '210918'; %% YYMMDD
        ieeg_prefix = 'D63_Sentence_Rep_'; % Should end in _
        rec = '001'; 
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:126 129:250];
        
      case 'D63_003' %Sentence Rep_2
        cd 'E:\InUnit Preprocessing\D63\Sentence Rep\2'
        taskstim = 'sentence_rep';
        subj = 'D63';
        edf_filename = 'E:\InUnit Preprocessing\D63\Sentence Rep\2\D63 210919 COGAN_SENTENCEREP_2.EDF';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D63\Sentence Rep\2\D63_Block_3_TrialData.mat';
        taskdate = '210919'; %% YYMMDD
        ieeg_prefix = 'D63_Sentence_Rep_'; % Should end in _
        rec = '002'; 
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:126 129:250];
        
     case 'D66_004' %PhonemeS
        cd 'E:\InUnit Preprocessing\D66\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D66';
        edf_filename = 'E:\InUnit Preprocessing\D66\PhonemeS\D66 211211 COGAN_PHONEMESEQUENCING .EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D66\PhonemeS\D66_Block_4_TrialData.mat';%trialData to reference
        taskdate = '211211';
        ieeg_prefix = 'D66_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:58, 65:114 129:190 193:204];
        
      case 'D66_008' %Timit
        cd 'E:\InUnit Preprocessing\D66\Timit'
        taskstim = 'timit';
        subj = 'D66';
        edf_filename = 'E:\InUnit Preprocessing\D66\Timit\D66 211211 COGAN_TIMIT.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '211211';
        ieeg_prefix = 'D66_Timit_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:58, 65:114 129:190 193:204];
        
      case 'D66_006' %Neighborhood 
        cd 'E:\InUnit Preprocessing\D66\Neighborhood'
        taskstim = 'neighborhood_sternberg';
        subj = 'D66';
        edf_filename = 'E:\InUnit Preprocessing\D66\Neighborhood\D66 211213 COGAN_NEIGHBORHOOD.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D66\Neighborhood\D66_Block_1_TrialData.mat';%trialData to reference
        taskdate = '211213';
        ieeg_prefix = 'D66_Neighborhood_Sternberg_';
        rec = '001'; %session number
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:58, 65:114 129:190 193:204];
        
      case 'D66_003' %Sentence Rep
        cd 'E:\InUnit Preprocessing\D66\Sentence Rep'
        taskstim = 'sentence_rep';
        subj = 'D66';
        edf_filename = 'E:\InUnit Preprocessing\D66\Sentence Rep\D66 211214 COGAN_SENTENCEREP.EDF';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D66\Sentence Rep\D66_Block_5_TrialData.mat';
        taskdate = '211214'; %% YYMMDD
        ieeg_prefix = 'D66_Sentence_Rep_'; % Should end in _
        rec = '001'; 
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:58, 65:114 129:190 193:204];
        
      case 'D66_001' % Lexical Delay_1
        cd 'E:\InUnit Preprocessing\D66\Lexical Delay\1\'
        taskstim = 'lexical';
        subj = 'D66';
        edf_filename = 'E:\InUnit Preprocessing\D66\Lexical Delay\1\D66 211212 COGAN_LEXICALDELAY_1.EDF';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D66\Lexical Delay\1\D66_Block_1_TrialData.mat';
        taskdate = '211212';
        ieeg_prefix = 'D66_Lexical_Delay_';
        rec = '001';
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:58, 65:114 129:190 193:204];
        
      case 'D66_001' % Lexical Delay_2
        cd 'E:\InUnit Preprocessing\D66\Lexical Delay\2\'
        taskstim = 'lexical';
        subj = 'D66';
        edf_filename = 'E:\InUnit Preprocessing\D66\Lexical Delay\2\D66 211213 COGAN_LEXICAL DELAY_2.EDF';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D66\Lexical Delay\2\D66_Block_3_TrialData.mat';
        taskdate = '211213';
        ieeg_prefix = 'D66_Lexical_Delay_';
        rec = '002';
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:58, 65:114 129:190 193:204];
        
      case 'D67_004' %PhonemeS
        cd 'E:\InUnit Preprocessing\D67\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D67';
        edf_filename = 'E:\InUnit Preprocessing\D67\PhonemeS\D67 220112 COGAN_PHONEMESEQUENCE.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D67\PhonemeS\D67_Block_4_TrialData.mat';%trialData to reference
        taskdate = '220112';
        ieeg_prefix = 'D67_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 129;
        mic_chan_index = 130;
        neural_chan_index = [1:72];
        
        
      case 'D68_004' %PhonemeS
        cd 'E:\InUnit Preprocessing\D68\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D68';
        edf_filename = 'E:\InUnit Preprocessing\D68\PhonemeS\D68 220129 COGAN_PHONEMESEQUENCE.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D68\PhonemeS\D68_Block_4_TrialData.mat';%trialData to reference
        taskdate = '220129';
        ieeg_prefix = 'D68_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:122, 129:152];
        
       case 'D68_006' %Neighborhood 
        cd 'E:\InUnit Preprocessing\D68\Neighborhood'
        taskstim = 'neighborhood_sternberg';
        subj = 'D68';
        edf_filename = 'E:\InUnit Preprocessing\D68\Neighborhood\D68 220201 COGAN_NEIGHBORHOOD.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D68\Neighborhood\D68_Block_1_TrialData.mat';%trialData to reference
        taskdate = '220201';
        ieeg_prefix = 'D68_Neighborhood_Sternberg_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:122, 129:152];
        
      case 'D68_001' % Lexical Delay
        cd 'E:\InUnit Preprocessing\D68\Lexical Delay\'
        taskstim = 'lexical';
        subj = 'D68';
        edf_filename = 'E:\InUnit Preprocessing\D68\Lexical Delay\D68 220131 COGAN_LEXICALDELAY.EDF';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D68\Lexical Delay\D68_Block_1_TrialData.mat';
        taskdate = '220131';
        ieeg_prefix = 'D68_Lexical_Delay_';
        rec = '001';
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:122, 129:152];
        
        
      case 'D68_008' %Timit
        cd 'E:\InUnit Preprocessing\D68\Timit'
        taskstim = 'timit';
        subj = 'D68';
        edf_filename = 'E:\InUnit Preprocessing\D68\Timit\D68 220131 COGAN_TIMIT.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '220131';
        ieeg_prefix = 'D68_Timit_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:122, 129:152];
        
      case 'D69_004' %PhonemeS
        cd 'E:\InUnit Preprocessing\D69\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D69';
        edf_filename = 'E:\InUnit Preprocessing\D69\PhonemeS\D69 220206 COGAN_PHONEMESEQUENCING.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D69\PhonemeS\D69_Block_4_TrialData.mat';%trialData to reference
        taskdate = '220206';
        ieeg_prefix = 'D69_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:120, 129:148];
        
       case 'D69_008' %Timit
        cd 'E:\InUnit Preprocessing\D69\Timit'
        taskstim = 'timit';
        subj = 'D69';
        edf_filename = 'E:\InUnit Preprocessing\D69\Timit\D69 220206 COGAN_TIMIT.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '220206';
        ieeg_prefix = 'D69_Timit_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:120, 129:148];
        
      case 'D69_001' % Lexical Delay
        cd 'E:\InUnit Preprocessing\D69\Lexical Delay\'
        taskstim = 'lexical';
        subj = 'D69';
        edf_filename = 'E:\InUnit Preprocessing\D69\Lexical Delay\D69 220206 COGAN_LEXICALDELAY.EDF';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D69\Lexical Delay\D69_Block_1_TrialData.mat';
        taskdate = '220206';
        ieeg_prefix = 'D69_Lexical_Delay_';
        rec = '001';
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:120, 129:148];
        
      case 'D69_006' %Neighborhood 
        cd 'E:\InUnit Preprocessing\D69\Neighborhood'
        taskstim = 'neighborhood_sternberg';
        subj = 'D69';
        edf_filename = 'E:\InUnit Preprocessing\D69\Neighborhood\D69 220207 COGAN_NEIGHBORHOOD.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D69\Neighborhood\D69_Block_1_TrialData.mat';%trialData to reference
        taskdate = '220207';
        ieeg_prefix = 'D69_Neighborhood_Sternberg_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:120, 129:148];
        
      case 'D69_003' %Sentence Rep
        cd 'E:\InUnit Preprocessing\D69\Sentence Rep'
        taskstim = 'sentence_rep';
        subj = 'D69';
        edf_filename = 'E:\InUnit Preprocessing\D69\Sentence Rep\D69 220207 COGAN_SENTENCEREP.EDF';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D69\Sentence Rep\D69_Block_5_TrialData.mat';
        taskdate = '220207'; %% YYMMDD
        ieeg_prefix = 'D69_Sentence_Rep_'; % Should end in _
        rec = '001'; 
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:120, 129:148];
        
      case 'D69_007' %Environmental
        cd 'E:\InUnit Preprocessing\D69\Environmental'
        taskstim = 'environmental_sternberg';
        subj = 'D69';
        edf_filename = 'E:\InUnit Preprocessing\D69\Environmental\D69 220208 COGAN_ENVIRONMENTAL.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D69\Environmental\D69_Block_1_TrialData.mat';%trialData to reference
        taskdate = '220208';%% YYMMDD
        ieeg_prefix = 'D69_environmentalsternberg_';
        rec = '001';
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:120, 129:148];
        
      case 'D69_002' % Lexical No Delay
        cd 'E:\InUnit Preprocessing\D69\Lexical No Delay\'
        taskstim = 'lexical';
        subj = 'D69';
        edf_filename = 'E:\InUnit Preprocessing\D69\Lexical No Delay\D69 220209 COGAN_LEXICALNODELAY.EDF';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D69\Lexical No Delay\D69_Block_4_TrialData.mat';
        taskdate = '220209';
        ieeg_prefix = 'D69_Lexical_No_Delay_';
        rec = '001';
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:120, 129:148];
       
      case 'D69_005' %Uniqueness
        cd 'E:\InUnit Preprocessing\D69\Uniqueness Point'
        taskstim = 'uniqueness_point';
        subj = 'D69';
        edf_filename = 'E:\InUnit Preprocessing\D69\Uniqueness Point\D69 220209 COGAN_UNIQUENESSPOINT.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D69\Uniqueness Point\D69_Block_4_TrialData.mat'; %trialData to reference
        taskdate = '220209'; %% YYMMDD
        ieeg_prefix = 'D69_Uniqueness_Point_'; % Should end in _
        rec = '001'; % session number
        %%%%%%%% 
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:120, 129:148];
        
       case 'D69_009' %Global Local
        cd 'E:\InUnit Preprocessing\D69\Global Local'
        taskstim = 'GL';
        subj = 'D69';
        edf_filename = 'E:\InUnit Preprocessing\D69\Global Local\D69 220209 COGAN_GLOBALLOCAL.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '220209';
        ieeg_prefix = 'D69_GlobalLocal_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:120, 129:148];
        
      case 'D70_004' %PhonemeS
        cd 'E:\InUnit Preprocessing\D70\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D70';
        edf_filename = 'E:\InUnit Preprocessing\D70\PhonemeS\D70 220320 COGAN_PHONEMESEQUENCING.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D70\PhonemeS\D70_Block_4_TrialData.mat';%trialData to reference
        taskdate = '220320';
        ieeg_prefix = 'D70_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:116, 129:184, 193:222];
        
       
    case 'D70_003' %Sentence Rep
        cd 'E:\InUnit Preprocessing\D70\Sentence Rep'
        taskstim = 'sentence_rep';
        subj = 'D70';
        edf_filename = 'E:\InUnit Preprocessing\D70\Sentence Rep\D70 220321 COGAN_SENTENCEREP.EDF';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D70\Sentence Rep\D70_Block_5_TrialData.mat';
        taskdate = '220321'; %% YYMMDD
        ieeg_prefix = 'D70_Sentence_Rep_'; % Should end in _
        rec = '001'; 
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:116, 129:184, 193:222];
        
      case 'D70_001' % Lexical Delay
        cd 'E:\InUnit Preprocessing\D70\Lexical Delay\'
        taskstim = 'lexical';
        subj = 'D70';
        edf_filename = 'E:\InUnit Preprocessing\D70\Lexical Delay\D70 220322 COGAN_LEXICALDELAY.EDF';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D70\Lexical Delay\D70_Block_1_TrialData.mat';
        taskdate = '220322';
        ieeg_prefix = 'D70_Lexical_Delay_';
        rec = '001';
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:116, 129:184, 193:222];
                
      case 'D70_006' %Neighborhood 
        cd 'E:\InUnit Preprocessing\D70\Neighborhood'
        taskstim = 'neighborhood_sternberg';
        subj = 'D70';
        edf_filename = 'E:\InUnit Preprocessing\D70\Neighborhood\D70 220322 COGAN_NEIGHBORHOOD.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D70\Neighborhood\D70_Block_1_TrialData.mat';%trialData to reference
        taskdate = '220322';
        ieeg_prefix = 'D70_Neighborhood_Sternberg_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:116, 129:184, 193:222];
        
      case 'D70_008' %Timit
        cd 'E:\InUnit Preprocessing\D70\Timit'
        taskstim = 'timit';
        subj = 'D70';
        edf_filename = 'E:\InUnit Preprocessing\D70\Timit\D70 220321 COGAN_TIMIT.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '220321';
        ieeg_prefix = 'D70_Timit_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:116, 129:184, 193:222];


      case 'D71_004' %PhonemeS
        cd 'E:\InUnit Preprocessing\D71\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D71';
        edf_filename = 'E:\InUnit Preprocessing\D71\PhonemeS\D71 220423 COGAN_PHONEMESEQUENCE.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D71\PhonemeS\D71_Block_4_TrialData.mat';%trialData to reference
        taskdate = '220423';
        ieeg_prefix = 'D71_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:60, 65:118, 129:176];

      case 'D71_008' %Timit
        cd 'E:\InUnit Preprocessing\D71\Timit'
        taskstim = 'timit';
        subj = 'D71';
        edf_filename = 'E:\InUnit Preprocessing\D71\Timit\D71 220423 COGAN_TIMIT.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '220423';
        ieeg_prefix = 'D71_Timit_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:60, 65:118, 129:176];

      case 'D71_003' %Sentence Rep
        cd 'E:\InUnit Preprocessing\D71\Sentence Rep'
        taskstim = 'sentence_rep';
        subj = 'D71';
        edf_filename = 'E:\InUnit Preprocessing\D71\Sentence Rep\D71 220424 COGAN_SENTENCEREP.EDF';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D71\Sentence Rep\D71_Block_5_TrialData.mat';
        taskdate = '220424'; %% YYMMDD
        ieeg_prefix = 'D71_Sentence_Rep_'; % Should end in _
        rec = '001'; 
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:60, 65:118, 129:176];
        
      case 'D71_006' %Neighborhood 
        cd 'E:\InUnit Preprocessing\D71\Neighborhood'
        taskstim = 'neighborhood_sternberg';
        subj = 'D71';
        edf_filename = 'E:\InUnit Preprocessing\D71\Neighborhood\D71 220424 COGAN_NEIGHBORHOOD.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D71\Neighborhood\D71_Block_1_TrialData.mat';%trialData to reference
        taskdate = '220424';
        ieeg_prefix = 'D71_Neighborhood_Sternberg_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:60, 65:118, 129:176];

       case 'D71_007' %Environmental
        cd 'E:\InUnit Preprocessing\D71\Environmental'
        taskstim = 'environmental_sternberg';
        subj = 'D71';
        edf_filename = 'E:\InUnit Preprocessing\D71\Environmental\D71 220425 COGAN_ENVIRONMENTAL.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D71\Environmental\D71_Block_1_TrialData.mat';%trialData to reference
        taskdate = '220425';%% YYMMDD
        ieeg_prefix = 'D71_environmentalsternberg_';
        rec = '001';
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:60, 65:118, 129:176];

      case 'D71_001' % Lexical Delay
        cd 'E:\InUnit Preprocessing\D71\Lexical Delay\'
        taskstim = 'lexical';
        subj = 'D71';
        edf_filename = 'E:\InUnit Preprocessing\D71\Lexical Delay\D71 220425 COGAN_LEXICALDELAY.EDF';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D71\Lexical Delay\D71_Block_1_TrialData.mat';
        taskdate = '220425';
        ieeg_prefix = 'D71_Lexical_Delay_';
        rec = '001';
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:60, 65:118, 129:176];

      case 'D71_005' %Uniqueness
        cd 'E:\InUnit Preprocessing\D71\Uniqueness Point'
        taskstim = 'uniqueness_point';
        subj = 'D71';
        edf_filename = 'E:\InUnit Preprocessing\D71\Uniqueness Point\D71 220426 COGAN_UNIQUENESSPOINT.EDF'; %EDF to reference
        ptb_trialInfo = 'E:\InUnit Preprocessing\D71\Uniqueness Point\D71_Block_4_TrialData.mat'; %trialData to reference
        taskdate = '220426'; %% YYMMDD
        ieeg_prefix = 'D71_Uniqueness_Point_'; % Should end in _
        rec = '001'; % session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:60, 65:118, 129:176];

      case 'D71_002' % Lexical No Delay
        cd 'E:\InUnit Preprocessing\D71\Lexical No Delay\'
        taskstim = 'lexical';
        subj = 'D71';
        edf_filename = 'E:\InUnit Preprocessing\D71\Lexical No Delay\D71 220427 COGAN_LEXICALNODELAY.EDF';
        ptb_trialInfo = 'E:\InUnit Preprocessing\D71\Lexical No Delay\D71_Block_4_TrialData.mat';
        taskdate = '220427';  %% YYMMDD
        ieeg_prefix = 'D71_Lexical_No_Delay_';
        rec = '001';
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:60, 65:118, 129:176];

      case 'D71_009' %Global Local
        cd 'E:\InUnit Preprocessing\D71\Global Local'
        taskstim = 'GL';
        subj = 'D71';
        edf_filename = 'E:\InUnit Preprocessing\D71\Global Local\D69 220209 COGAN_GLOBALLOCAL.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '220209';
        ieeg_prefix = 'D71_GlobalLocal_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:60, 65:118, 129:176];

      case 'D71_009' %Global Local
        cd 'E:\InUnit Preprocessing\Global Local\D71'
        taskstim = 'GL';
        subj = 'D71';
        edf_filename = 'E:\InUnit Preprocessing\Global Local\D71\D71 220426 COGAN_GLOBALLOCAL.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '220426';
        ieeg_prefix = 'D71_GlobalLocal_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:60, 65:118, 129:176];

      case 'D72_004' %PhonemeS_1
        cd 'D:\InUnit Preprocessing\D72\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D72';
        edf_filename = 'D:\InUnit Preprocessing\D72\PhonemeS\D72 220612 COGAN_PHONEMESEQUENCING_1.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit Preprocessing\D72\PhonemeS\D72_Block_TrialData_1.mat';%trialData to reference
        taskdate = '220612';
        ieeg_prefix = 'D72_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:92, 97:122 129:184 193:236];

     case 'D72_004' %PhonemeS_2
        cd 'D:\InUnit Preprocessing\D72\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D72';
        edf_filename = 'D:\InUnit Preprocessing\D72\PhonemeS\D72 220612 COGAN_PHONEMESEQUENCING_2.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit Preprocessing\D72\PhonemeS\D72_Block_TrialData_2.mat';%trialData to reference
        taskdate = '220612';
        ieeg_prefix = 'D72_PhonemeSequencing_';
        rec = '002'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:92, 97:122 129:184 193:236];

      case 'D72_006' %Neighborhood 
        cd 'D:\InUnit Preprocessing\D72\Neighborhood'
        taskstim = 'neighborhood_sternberg';
        subj = 'D72';
        edf_filename = 'D:\InUnit Preprocessing\D72\Neighborhood\D72 220613 COGAN_NEIGHBORHOOD.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit Preprocessing\D72\Neighborhood\D72_Block_1_TrialData.mat';%trialData to reference
        taskdate = '220613';
        ieeg_prefix = 'D72_Neighborhood_Sternberg_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:92, 97:122 129:184 193:236];

      case 'D72_008' %Timit_1
        cd 'D:\InUnit Preprocessing\D72\Timit'
        taskstim = 'timit';
        subj = 'D72';
        edf_filename = 'D:\InUnit Preprocessing\D72\Timit\D72 220612 COGAN_TIMIT_1.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '220612';
        ieeg_prefix = 'D72_Timit_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:92, 97:122 129:184 193:236];

      case 'D72_008' %Timit_2
        cd 'D:\InUnit Preprocessing\D72\Timit'
        taskstim = 'timit';
        subj = 'D72';
        edf_filename = 'D:\InUnit Preprocessing\D72\Timit\D72 220613 COGAN_TIMIT_2.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '220613';
        ieeg_prefix = 'D72_Timit_';
        rec = '002'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:92, 97:122 129:184 193:236];

      case 'D72_003' %Sentence Rep_1
        cd 'D:\InUnit Preprocessing\D72\Sentence Rep'
        taskstim = 'sentence_rep';
        subj = 'D72';
        edf_filename = 'D:\InUnit Preprocessing\D72\Sentence Rep\D72 220614 COGAN_SENTENCEREP_1.EDF';
        %ptb_trialInfo = 'D:\InUnit Preprocessing\D72\Sentence Rep\D72_Block_TrialData_1.mat';
        taskdate = '220614'; %% YYMMDD
        ieeg_prefix = 'D72_Sentence_Rep_'; % Should end in _
        rec = '001'; 
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:92, 97:122 129:184 193:236];

      case 'D72_003' %Sentence Rep_2
        cd 'D:\InUnit Preprocessing\D72\Sentence Rep'
        taskstim = 'sentence_rep';
        subj = 'D72';
        edf_filename = 'D:\InUnit Preprocessing\D72\Sentence Rep\D72 220615 COGAN_SENTENCEREP_2.EDF';
        %ptb_trialInfo = 'D:\InUnit Preprocessing\D72\Sentence Rep\D72_Block_TrialData_2.mat';
        taskdate = '220615'; %% YYMMDD
        ieeg_prefix = 'D72_Sentence_Rep_'; % Should end in _
        rec = '002'; 
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:92, 97:122 129:184 193:236];

      case 'D73_004' %PhonemeS
        cd 'D:\InUnit Preprocessing\D73\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D73';
        edf_filename = 'D:\InUnit Preprocessing\D73\PhonemeS\D73 220625 COGAN_PHONEMESEQUENCING.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit Preprocessing\D73\PhonemeS\D73_Block_4_TrialData.mat';%trialData to reference
        taskdate = '220625';
        ieeg_prefix = 'D73_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:118 129:188 193:222];

      case 'D73_008' %Timit
        cd 'D:\InUnit Preprocessing\D73\Timit'
        taskstim = 'timit';
        subj = 'D73';
        edf_filename = 'D:\InUnit Preprocessing\D73\Timit\D73 220625 COGAN_TIMIT.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '220625';
        ieeg_prefix = 'D73_Timit_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:118 129:188 193:222];

    case 'D73_003' %Sentence Rep
        cd 'D:\InUnit Preprocessing\D73\Sentence Rep'
        taskstim = 'sentence_rep';
        subj = 'D73';
        edf_filename = 'D:\InUnit Preprocessing\D73\Sentence Rep\D73 220626 COGAN_SENTENCEREP.EDF';
        ptb_trialInfo = 'D:\InUnit Preprocessing\D73\Sentence Rep\D73_Block_5_TrialData.mat';
        taskdate = '220626'; %% YYMMDD
        ieeg_prefix = 'D73_Sentence_Rep_'; % Should end in _
        rec = '001'; 
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:118 129:188 193:222];

      case 'D73_006' %Neighborhood 
        cd 'D:\InUnit Preprocessing\D73\Neighborhood'
        taskstim = 'neighborhood_sternberg';
        subj = 'D73';
        edf_filename = 'D:\InUnit Preprocessing\D73\Neighborhood\D73 220626 COGAN_NEIGHBORHOOD.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit Preprocessing\D73\Neighborhood\D73_Block_1_TrialData.mat';%trialData to reference
        taskdate = '220626';
        ieeg_prefix = 'D73_Neighborhood_Sternberg_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:118 129:188 193:222];

      case 'D73_007' %Environmental
        cd 'D:\InUnit Preprocessing\D73\Environmental'
        taskstim = 'environmental_sternberg';
        subj = 'D73';
        edf_filename = 'D:\InUnit Preprocessing\D73\Environmental\D73 220627 COGAN_ENVIRONMENTAL.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit Preprocessing\D73\Environmental\D73_Block_1_TrialData.mat';%trialData to reference
        taskdate = '220627';%% YYMMDD
        ieeg_prefix = 'D73_environmentalsternberg_';
        rec = '001';
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:56, 65:118 129:188 193:222];


      case 'D75_004' %PhonemeS
        cd 'D:\InUnit Preprocessing\D75\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D75';
        edf_filename = 'D:\InUnit Preprocessing\D75\PhonemeS\D75 220827 COGAN_PHONEMESEQUENCING.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit Preprocessing\D75\PhonemeS\D75_Block_4_TrialData.mat';%trialData to reference
        taskdate = '220827';
        ieeg_prefix = 'D75_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:118 129:177 193:240];

      case 'D75_008' %Timit
        cd 'D:\InUnit Preprocessing\D75\Timit'
        taskstim = 'timit';
        subj = 'D75';
        edf_filename = 'D:\InUnit Preprocessing\D75\Timit\D75 220828 COGAN_TIMIT.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '220828';
        ieeg_prefix = 'D75_Timit_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:118 129:177 193:240];

      case 'D76_004' %PhonemeS
        cd 'D:\InUnit Preprocessing\D76\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D76';
        edf_filename = 'D:\InUnit Preprocessing\D76\PhonemeS\D76 221010 COGAN_PHONEMESEQUENCING.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit Preprocessing\D76\PhonemeS\D76_Block_4_TrialData.mat';%trialData to reference
        taskdate = '221010';
        ieeg_prefix = 'D76_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:60, 65:109 129:184, 193:244];

      case 'D77_004' %PhonemeS
        cd 'D:\InUnit Preprocessing\D77\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D77';
        edf_filename = 'D:\InUnit Preprocessing\D77\PhonemeS\D77 221013 COGAN_PHONEMESEQUENCING.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit Preprocessing\D77\PhonemeS\D77_Block_4_TrialData.mat';%trialData to reference
        taskdate = '221013';
        ieeg_prefix = 'D77_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:59, 65:120, 129:170];

       case 'D77_008' %Timit
        cd 'D:\InUnit Preprocessing\D77\Timit'
        taskstim = 'timit';
        subj = 'D77';
        edf_filename = 'D:\InUnit Preprocessing\D77\Timit\D77 221013 COGAN_TIMIT.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '221013';
        ieeg_prefix = 'D77_Timit_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:59, 65:120, 129:170];

      case 'D77_006' %Neighborhood 
        cd 'D:\InUnit Preprocessing\D77\Neighborhood'
        taskstim = 'neighborhood_sternberg';
        subj = 'D77';
        edf_filename = 'D:\InUnit Preprocessing\D77\Neighborhood\D77 221014 COGAN_NEIGHBORHOOD.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit Preprocessing\D77\Neighborhood\D77_Block_1_TrialData.mat';%trialData to reference
        taskdate = '221014';
        ieeg_prefix = 'D77_Neighborhood_Sternberg_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:59, 65:120, 129:170];

      case 'D77_007' %Environmental
        cd 'D:\InUnit Preprocessing\D77\Environmental'
        taskstim = 'environmental_sternberg';
        subj = 'D77';
        edf_filename = 'D:\InUnit Preprocessing\D77\Environmental\D77 221016 COGAN_ENVIRONMENTAL.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit Preprocessing\D77\Environmental\D77_Block_1_TrialData.mat';%trialData to reference
        taskdate = '221016';%% YYMMDD
        ieeg_prefix = 'D77_environmentalsternberg_';
        rec = '001';
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:59, 65:120, 129:170];

      case 'D77_001' % Lexical Delay
        cd 'D:\InUnit Preprocessing\D77\Lexical Delay\'
        taskstim = 'lexical';
        subj = 'D77';
        edf_filename = 'D:\InUnit Preprocessing\D77\Lexical Delay\D77 221015 COGAN_LEXICALDELAY.EDF';
        ptb_trialInfo = 'D:\InUnit Preprocessing\D77\Lexical Delay\D77_Block_1_TrialData.mat';
        taskdate = '221015';
        ieeg_prefix = 'D77_Lexical_Delay_';
        rec = '001';
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:59, 65:120, 129:170];

      case 'D77_002' % Lexical No Delay
        cd 'D:\InUnit Preprocessing\D77\Lexical No Delay\'
        taskstim = 'lexical';
        subj = 'D77';
        edf_filename = 'D:\InUnit Preprocessing\D77\Lexical No Delay\D77 221016 COGAN_LEXICALNODELAY.EDF';
        ptb_trialInfo = 'D:\InUnit Preprocessing\D77\Lexical No Delay\D77_Block_4_TrialData.mat';
        taskdate = '221016';  %% YYMMDD
        ieeg_prefix = 'D77_Lexical_No_Delay_';
        rec = '001';
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:59, 65:120, 129:170];

      case 'D77_009' %Global Local
        cd 'D:\InUnit Preprocessing\D77\GL'
        taskstim = 'GL';
        subj = 'D77';
        edf_filename = 'D:\InUnit Preprocessing\D77\GL\D77 221014 COGAN_GLOBALLOCAL.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '221014';
        ieeg_prefix = 'D77_GlobalLocal_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:59, 65:120, 129:170];

      case 'D79_004' %PhonemeS
        cd 'D:\InUnit Preprocessing\D79\PhonemeS'
        taskstim = 'phoneme_sequencing';
        subj = 'D79';
        edf_filename = 'D:\InUnit Preprocessing\D79\PhonemeS\D79 221120 COGAN_PHONEMESEQUENCING.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit Preprocessing\D79\PhonemeS\D79_Block_4_TrialData.mat';%trialData to reference
        taskdate = '221120';
        ieeg_prefix = 'D79_PhonemeSequencing_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:54, 65:126, 129:256];

       case 'D79_006' %Neighborhood 
        cd 'D:\InUnit Preprocessing\D79\Neighborhood'
        taskstim = 'neighborhood_sternberg';
        subj = 'D79';
        edf_filename = 'D:\InUnit Preprocessing\D79\Neighborhood\D79 221121 COGAN_NEIGHBORHOOD.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit Preprocessing\D79\Neighborhood\D79_Block_1_TrialData.mat';%trialData to reference
        taskdate = '221121';
        ieeg_prefix = 'D79_Neighborhood_Sternberg_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:54, 65:126, 129:256];

       case 'D79_008' %Timit
        cd 'D:\InUnit Preprocessing\D79\Timit'
        taskstim = 'timit';
        subj = 'D79';
        edf_filename = 'D:\InUnit Preprocessing\D79\Timit\D79 221120 COGAN_TIMIT.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '221120';
        ieeg_prefix = 'D79_Timit_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:54, 65:126, 129:256];

    case 'D79_001' % Lexical Delay Session 1
        cd 'D:\InUnit Preprocessing\D79\Lexical Delay\'
        taskstim = 'lexical';
        subj = 'D79';
        edf_filename = 'D:\InUnit Preprocessing\D79\Lexical Delay\D79 221122 COGAN_LEXICALDELAY.EDF';
        ptb_trialInfo = 'D:\InUnit Preprocessing\D79\Lexical Delay\D79_Block_1_TrialData.mat';
        taskdate = '221122';
        ieeg_prefix = 'D79_Lexical_Delay_';
        rec = '001';
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:54, 65:126, 129:256];

      case 'D79_001' % Lexical Delay Session 2
        cd 'D:\InUnit Preprocessing\D79\Lexical Delay\'
        taskstim = 'lexical';
        subj = 'D79';
        edf_filename = 'D:\InUnit Preprocessing\D79\Lexical Delay\D79 221122 COGAN_LEXICALDELAY.EDF';
        ptb_trialInfo = 'D:\InUnit Preprocessing\D79\Lexical Delay\D79_Block_2_TrialData.mat';
        taskdate = '221122';
        ieeg_prefix = 'D79_Lexical_Delay_';
        rec = '002';
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:54, 65:126, 129:256];

      case 'D79_008_2' %Timit
        cd 'D:\InUnit Preprocessing\D79\Timit_2'
        taskstim = 'timit';
        subj = 'D79';
        edf_filename = 'D:\InUnit Preprocessing\D79\Timit_2\D79 221120 COGAN_TIMIT.EDF'; %EDF to reference
        %ptb_trialInfo = 'E:\InUnit Preprocessing\D49\Timit\D49_Block_1_XXXXX.mat';%trialInfo to reference
        taskdate = '221120';
        ieeg_prefix = 'D79_Timit_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:54, 65:126, 129:256];

    case 'D72_004' %Phoneme Sequencing
        cd 'C:\Users\zjb12\OneDrive - Duke University\Desktop\InUnit PreProc\D72'
        taskstim = 'Phoneme_sequencing';
        subj = 'D72'
        edf_filename = 'C:\Users\zjb12\OneDrive - Duke University\Desktop\InUnit PreProc\D72\D72 220612 COGAN_PHONEMESEQUENCING_1.edf'; %EDF to reference
        ptb_trialInfo = 'C:\Users\zjb12\OneDrive - Duke University\Desktop\InUnit PreProc\D72\D72_Block_1_TrialData'; %trialData to reference
        taskdate = '220612';
        ieeg_prefix = 'D72_Phoneme_Sequencing_';
        rec = '001'; %session number
        %%%%%
        
    case 'D79_004' % Phoneme Sequencing Session 1
        cd 'D:\InUnit Preproc'\D79\PhonemeS\
        taskstim = 'Phoneme_Sequencing';
        subj = 'D79';
        edf_filename = 'D:\InUnit Preproc\D79\PhonemeS\D79 221120 COGAN_PHONEMESEQUENCING.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit PreProc\D79\PhonemeS\All blocks\D79_Block_4_TrialData'; %trialData to reference
        taskdate = '221120';
        ieeg_prefix = 'D79_Phoneme_Sequencing_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:54, 65:126, 129:256];

        case 'D77_004' % Phoneme Sequencing Session 1
        cd 'D:\InUnit Preproc'\D77\PhonemeS\
        taskstim = 'Phoneme_Sequencing';
        subj = 'D79';
        edf_filename = 'D:\InUnit Preproc\D79\PhonemeS\D79 221120 COGAN_PHONEMESEQUENCING.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit PreProc\D79\PhonemeS\All blocks\D79_Block_4_TrialData'; %trialData to reference
        taskdate = '221120';
        ieeg_prefix = 'D79_Phoneme_Sequencing_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:54, 65:126, 129:256];
       
    case 'D79_001' % Lexical Delay
        cd 'D:\InUnit PreProc\D79\Lexical Delay'
        taskstim = 'Lexical_Delay';
        subj = 'D79';
        edf_filename = 'D:\InUnit Preproc\D79\Lexical Delay\D79 221122 COGAN_LEXICALDELAY.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit PreProc\D79\Lexical Delay\All Blocks\D79_Block_1_TrialData'; %trialData to reference
        taskdate = '221122';
        ieeg_prefix = 'D79_Lexical_Delay_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:244];

   case 'D80_001' % Lexical Delay
        cd 'D:\InUnit PreProc\D80\Lexical Delay'
        taskstim = 'Lexical_Delay';
        subj = 'D80';
        edf_filename = 'D:\InUnit Preproc\D80\Lexical Delay\D80 230115 COGAN_LEXICALDELAY.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit PreProc\D80\Lexical Delay\All Blocks\D80_Block_1_TrialData'; %trialData to reference
        taskdate = '230115';
        ieeg_prefix = 'D80_Lexical_Delay_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:127, 129:248];     
    
    case 'D80_004' % Phoneme Sequencing
        cd 'D:\InUnit PreProc\D80\Phoneme Seq'
        taskstim = 'Phoneme Sequencing';
        subj = 'D80';
        edf_filename = 'D:\InUnit Preproc\D80\Phoneme Seq\D80 230113 COGAN_PHONEMESEQUENCING.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit PreProc\D80\Phoneme Seq\All Blocks\D80_Block_4_TrialData'; %trialData to reference
        taskdate = '230113';
        ieeg_prefix = 'D80_Phoneme_Sequencing_';
        rec = '004'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:127, 129:248];  

    case 'D80_006' %Neighborhood
        cd 'D:\InUnit PreProc\D80\Neighborhood'
        taskstim = 'Neighborhood Sternberg';
        subj = 'D80';
        edf_filename = 'D:\InUnit Preproc\D80\Neighborhood\D80 230114 COGAN_NEIGHBORHOOD.EDF'; %EDF to reference
        ptb_trialInfo = 'D:\InUnit PreProc\D80\Neighborhood\All Blocks\D80_Block_1_TrialData'; %trialData to reference
        taskdate = '230114';
        ieeg_prefix = 'D80_Neighborhood_';
        rec = '001'; %session number
        %%%%%%%%
        trigger_chan_index = 257;
        mic_chan_index = 258;
        neural_chan_index = [1:127, 129:248];
end

load(ptb_trialInfo);
trialInfoAll = []; 
trialInfoAll = [trialInfoAll trialInfo];
trialInfo = trialInfoAll;
save('trialInfo', 'trialInfo');
%if there are multiple files, also save as trialInfo1, trialInfo2, etc.
%then run combine_trialInfo


%% for first subject task, determine neural_chan_index, trigger_chan_index, and mic_chan_index
% once these are determined for a subject, they are the same across tasks
h = edfread_fast(edf_filename);
labels = h.label;
% examine labels variable and determine the indices of neural channels
% (e.g. exclude ones that start with C, EKG, Event, TRIG, OSAT, PR, Pleth,
% etc.
% fill in the above case information for neural_chan()
% see case D29_002_1 for an example on how to skip channels

%% extract trigger channel and mic channel from edf and save as trigger.mat and mic.mat
if strcmp(h.label(end),'EDFAnnotations')
[~,d] = edfread_fast(edf_filename,1:length(h.label)-1);
else
    [~,d] = edfread_fast(edf_filename);
end
%[~,d] = edfread(edf_filename, 'machinefmt', 'ieee-le'); % use if you get a
%memory error for edfread_fast;
if ~isempty(trigger_chan_index)
    trigger = d(trigger_chan_index,:);
    save('trigger', 'trigger');
    %save('trigger2', 'trigger');
    %if there are multiple files, also save as trigger1, trigger2, etc.

end

if ~isempty(trigger_chan_index)
    mic = d(mic_chan_index,:);
    save('mic', 'mic');
    %save('mic2', 'mic');
    %if there are multiple files, also save as mic1, mic2, etc.

end

%% make *.ieeg.dat file
filename=[ieeg_prefix taskdate '.ieeg.dat'];
fid=fopen(filename,'w');
fwrite(fid,d(neural_chan_index,:),'float');
fclose(fid);
write_experiment_file;
% manually copy IEEG into [taskdate]/[rec]/
% manually copy experiment.mat into mat



%% manually copy maketrigtimes.m into subject folder and edit / run it to generate trigTimes.mat
% see trigger_walker.m if you have a noisy trigger channel and need to
% estimate / interpolate / extrapolate an auditory Onset																	  												

%% for subjects D26 and newer, audio onset is 0.0234 samples after each trigger
load trigTimes.mat;
%load trigTimes2.mat; %(for multiple files)
trigTimes_audioAligned = trigTimes + ceil(.0234 * h.frequency(1));
save('trigTimes_audioAligned', 'trigTimes_audioAligned');

%% (optional) run view_stim_wavs_on_neural_mic.m to visualize the alignment between microphone and stimulus waves


%% create a generic Trials.mat (for NON-Sternberg tasks)

% For phoneme sequencing, Lexical Delay, and Sentence Rep

% copy Trials.mat to [taskdate]/mat
% copy trialInfo.mat to [taskdate]/mat
load trialInfo4.mat;
load trigTimes_audioAligned.mat;
if iscell(trialInfo)
    trialInfo = cell2mat(trialInfo);
end
assert(length(trialInfo)==length(trigTimes_audioAligned));
h = edfread_fast(edf_filename);
Trials = struct();
for A=1:numel(trialInfo) % change to number of trials
    Trials(A).Subject=subj;
    Trials(A).Trial=A;
    Trials(A).Rec=rec;
    Trials(A).Day=taskdate;
    Trials(A).FilenamePrefix=[ieeg_prefix taskdate];
    Trials(A).Start = floor(trigTimes(A) * 30000 / h.frequency(1));
    Trials(A).Auditory=floor(trigTimes_audioAligned(A) * 30000 / h.frequency(1))+floor((trialInfo(A).audioStart-trialInfo(A).cueStart)* 30000);
    Trials(A).Go=Trials(A).Start-floor( ...
        (trialInfo(A).cueStart- ...
        trialInfo(A).goStart)* 30000);
    Trials(A).StartCode=1;
    Trials(A).AuditoryCode=26;
    Trials(A).GoCode=51;
    Trials(A).Noisy=0;
    Trials(A).NoResponse=0;
end

save('Trials.mat', 'Trials');
%save('Trials2.mat','Trials');
%if there are multiple files, also save as Trials1, Trials2, etc.

%% create a generic Trials.mat 

% for Lexical Decision NO DELAY and UNIQUENESS POINT Task

% copy Trials.mat to [taskdate]/mat
% copy trialInfo.mat to [taskdate]/mat
load trialInfo.mat;
load trigTimes_audioAligned.mat;
if iscell(trialInfo)
    trialInfo = cell2mat(trialInfo);
end
assert(length(trialInfo)==length(trigTimes_audioAligned));
h = edfread_fast(edf_filename);
Trials = struct();
for A=1:numel(trialInfo) % change to number of trials
    Trials(A).Subject=subj;
    Trials(A).Trial=A;
    Trials(A).Rec=rec;
    Trials(A).Day=taskdate;
    Trials(A).FilenamePrefix=[ieeg_prefix taskdate];
    Trials(A).Start = floor(trigTimes_audioAligned(A) * 30000 / h.frequency(1));
    Trials(A).Auditory=Trials(A).Start+floor((trialInfo(A).stimulusAlignedTrigger-trialInfo(A).cueStart)* 30000);
    %Trials(A).Go=Trials(A).Start-floor((trialInfo(A).cueStart-trialInfo(A).goStart)* 30000);
    Trials(A).StartCode=1;
    Trials(A).AuditoryCode=26;
    Trials(A).GoCode=51;
    Trials(A).Noisy=0;
    Trials(A).NoResponse=0;
end
save('Trials.mat', 'Trials');
%save('Trials1.mat','Trials');
%if there are multiple files, also save as Trials1, Trials2, etc.




%% create a generic Trials.mat 

% for TIMIT tasks

% copy Trials.mat to [taskdate]/mat
% copy trialInfo.mat to [taskdate]/mat
load trialInfo.mat;
load trigTimes_audioAligned.mat;
if iscell(trialInfo)
    trialInfo = cell2mat(trialInfo);
end
assert(length(trialInfo)==length(trigTimes_audioAligned));
h = edfread_fast(edf_filename);
Trials = struct();
for A=1:numel(trialInfo) % change to number of trials
    Trials(A).Subject=subj;
    Trials(A).Trial=A;
    Trials(A).Rec=rec;
    Trials(A).Day=taskdate;
    Trials(A).FilenamePrefix=[ieeg_prefix taskdate];
    Trials(A).Start = floor(trigTimes_audioAligned(A) * 30000 / h.frequency(1));
    Trials(A).Auditory=Trials(A).Start+floor((trialInfo(A).audioAlignedTrigger-trialInfo(A).audioStart)* 30000);
    %Trials(A).Go=Trials(A).Start-floor((trialInfo(A).cueStart-trialInfo(A).goStart)* 30000)
    Trials(A).StartCode=1;
    Trials(A).AuditoryCode=26;
    %Trials(A).GoCode=51;
    Trials(A).Noisy=0;
    Trials(A).NoResponse=0;
end

save('Trials.mat', 'Trials');
%save('Trials2.mat','Trials');
%if there are multiple files, also save as Trials1, Trials2, etc.

%% create a generic Trials.mat 

% for Neighborhood Sternberg task

% STERNBERG task is unique, each trial there are more than one Auditory stimulus played, so we need a different method for creating Trials.mat
% copy Trials.mat to [taskdate]/mat
% copy trialInfo.mat to [taskdate]/mat
load trialInfo.mat;
load trigTimes_audioAligned.mat; % contains times (in samples) for both stim list and probe
if iscell(trialInfo)
    trialInfo = cell2mat(trialInfo);
end
% % Sternberg task: this is meant to check the correct number of triggers (including the list
% % size (i.e. 3, 5, 7, 9) and the probe)
for iTrials=1:length(trialInfo);
    lengthVals(iTrials)=length(trialInfo(iTrials).stimulusAudioStart);
end;
triggerNumIdeal=sum(lengthVals)+length(trialInfo); % should be equivalent to the number of elements in trigTimes
% 
% %triggerNumIdeal is the number of triggers that you SHOULD have

% 
% h = edfread_fast(edf_filename);
Trials = struct();
i = 1; % i keeps track of where we are in trigTimes_audioAligned array
for A=1:numel(trialInfo) % change to number of trials
    %Trials(A).FirstStimAuditory = tt(i)*30000/h.frequency(1);
    Trials(A).FirstStimAuditory = trigTimes_audioAligned(i)*30000/h.frequency(1);
    % pull as many trigTimes as there are stimuli played during this trial
  % Trials(A).StimAuditory=[]; %zeros(2,1);
    for s = 1:numel(trialInfo(A).stimulusSounds_name)
      %  Trials(A).StimAuditory(1,s) = tt(i)*30000/h.frequency(1); % convert to 30k sampling
        Trials(A).StimAuditory(s) = trigTimes(i)*30000/h.frequency(1); % convert to 30k sampling
        
        i = i + 1;
    end
    Trials(A).Auditory=Trials(A).FirstStimAuditory;
     Trials(A).Start=Trials(A).FirstStimAuditory;
    % the next trigTime is the probe
%	Trials(A).ProbeAuditory = tt(i)*30000/h.frequency(1);
	Trials(A).ProbeAuditory = trigTimes_audioAligned(i)*30000/h.frequency(1);
    Trials(A).Go=Trials(A).ProbeAuditory;
    
    i = i + 1;
    
    Trials(A).Subject=subj;
    Trials(A).Trial=A;
    Trials(A).Rec=rec;
    Trials(A).Day=taskdate;
    Trials(A).FilenamePrefix=[ieeg_prefix taskdate];
        Trials(A).StartCode=1;
    Trials(A).AuditoryCode=1;
    Trials(A).GoCode=26;
    Trials(A).Noisy=0;
    Trials(A).NoResponse=0;
end
% 
 save('Trials.mat', 'Trials');
%save('Trials1.mat','Trials');
% if there are multiple edf files, also save as Trials1.mat,
% Trials2.mat, etc.

%% create a generic Trials.mat 

% for Environmental Sternberg task

% STERNBERG task is unique, each trial there are more than one Auditory stimulus played, so we need a different method for creating Trials.mat
% copy Trials.mat to [taskdate]/mat
% copy trialInfo.mat to [taskdate]/mat
load trialInfo.mat;
load trigTimes_audioAligned.mat; % contains times (in samples) for both stim list and probe
if iscell(trialInfo)
    trialInfo = cell2mat(trialInfo);
end
% % Sternberg task: this is meant to check the correct number of triggers (including the list
% % size (i.e. 3, 5, 7, 9) and the probe)
for iTrials=1:length(trialInfo);
    lengthVals(iTrials)=length(trialInfo{iTrials}.stimulusAudioStart);
end;
triggerNumIdeal=sum(lengthVals)+length(trialInfo); % should be equivalent to the number of elements in trigTimes
% 
% %triggerNumIdeal is the number of triggers that you SHOULD have


% ENVIRONMENTAL, D30+ 
% Note: triggers seem to be getting first audio stim and probe only for
% some reason, so this code is based on that.
h = edfread_fast(edf_filename);
Trials = struct();
audTrigsIdx=1:2:length(trigTimes_audioAligned);
probeTrigsIdx=2:2:length(trigTimes_audioAligned);
i = 1; % i keeps track of where we are in trigTimes_audioAligned array
for A=1:numel(trialInfo) % change to number of trials
    %Trials(A).FirstStimAuditory = tt(i)*30000/h.frequency(1);
    Trials(A).FirstStimAuditory = trigTimes(audTrigsIdx(A))*30000/h.frequency(1);
    % pull as many trigTimes as there are stimuli played during this trial
  % Trials(A).StimAuditory=[]; %zeros(2,1);
    for s = 1:numel(trialInfo(A).stimulusSounds_name)
        if s==1
            Trials(A).StimAuditory(1,s)=Trials(A).FirstStimAuditory;
        else
            Trials(A).StimAuditory(s) = Trials(A).FirstStimAuditory+floor(30000*(trialInfo(A).stimulusAlignedTrigger(s)-trialInfo(A).stimulusAlignedTrigger(1)));   %  Trials(A).StimAuditory(1,s) = tt(i)*30000/h.frequency(1); % convert to 30k sampling
        end
            % convert to 30k sampling
        
        i = i + 1;
    end
    
    % the next trigTime is the probe
%	Trials(A).ProbeAuditory = tt(i)*30000/h.frequency(1);
	Trials(A).ProbeAuditory = trigTimes(probeTrigsIdx(A))*30000/h.frequency(1);
    
   % i = i + 1;
    
    Trials(A).Subject=subj;
    Trials(A).Trial=A+32; % If in a second trials file, make sure that this number is equal to the size of the first trials.mat file
    Trials(A).Rec=rec;
    Trials(A).Day=taskdate;
    Trials(A).FilenamePrefix=[ieeg_prefix taskdate];
    Trials(A).Start = floor(trigTimes_audioAligned(A) * 30000 / h.frequency(1));    
    Trials(A).Auditory=Trials(A).FirstStimAuditory;
    Trials(A).Go=Trials(A).ProbeAuditory;
    Trials(A).StartCode=1;
    Trials(A).AuditoryCode=1;
    Trials(A).GoCode=26;
    Trials(A).Noisy=0;
    Trials(A).NoResponse=0;
end

save('Trials.mat', 'Trials');



%% if subject task has multiple parts, fix trialInfo block column
% some trialInfo parts might have the wrong block number. Examine trialInfo
% for each part and determine what the block numbers SHOULD be. Use
% fix_trialInfo_blocks(filename, blocks_should_be) to create a new
% trialInfo with the correct block information.
%
% e.g.
% fix_trialInfo_blocks('trialInfo.mat', [1 2]) will ensure blocks are
% numbered 1 and 2
% fix_trialInfo_blocks('trialInfo.mat', [3 4]) will ensure blocks are
% numbered 3 and 4

%% if subject task has multiple parts, combine Trials.mat
% Assuming you have multiple Trials files (i.e. Trials1.mat,
% Trials2.mat,etc.), copy them into the 001 directory and then run the
% following code from the 001 directory:

%%RUN this to combine%%%
% for TRIALS.MAT
nTrials=2; % Set this to be the number of trials files you have (e.g. 2)

for iTrialsT=1:nTrials;
    load(strcat('Trials',num2str(iTrialsT),'.mat'))
    TrialsC{iTrialsT}=Trials;
    trialsS{iTrialsT}=length(Trials);
end
Trials=[];
for iS=1:size(TrialsC,2)
    Trials=cat(2,Trials,TrialsC{iS});
end
save('Trials.mat','Trials')


% for TRIALINFO.MAT
nTrials=2; % Set this to be the number of trials files you have (e.g. 2)

for iTrialsT=1:nTrials;
    load(strcat('trialInfo',num2str(iTrialsT),'.mat'))
    trialInfoC{iTrialsT}=trialInfo;
    trialInfoS{iTrialsT}=length(trialInfo);
end
trialInfo=[];
for iS=1:size(trialInfoC,2)
    trialInfo=cat(2,trialInfo,trialInfoC{iS});
end
save('trialInfo.mat','trialInfo')        
% 
% % change directory to subject directory (with subfolders part1, part2, etc) and run the following to merge part1 Trials.mat, part2 Trials.mat, etc.
% % it will save Trials.mat. Examine the structure then move it to
% % part1/[taskdate]/mat/
% 
% p = 1;
% Trials = [];
% while 1
%     if exist(sprintf('part%d', p), 'dir')
%         t = load(fullfile(sprintf('part%d', p), 'Trials.mat'));
%         Trials = cat(2, Trials, t.Trials);
%         p = p + 1;
%     else
%         break;
%     end
% end
% 
% if ~isempty(Trials)
%     for i = 1:numel(Trials)
%         Trials(i).Trial = i;
%     end
%     
%     save('Trials.mat', 'Trials');
% end

%% if subject has multiple parts, 
%run combine_trialInfo
% change directory to subject directory (with subfolders part1, part2, etc) and run the following to merge part1 trialInfo.mat, part2 trialInfo.mat, etc.
% it will save trialInfo.mat. Examine the structure then move it to
% part1/[taskdate]/mat/

p = 1;
trialInfo = [];
while 1
    if exist(sprintf('part%d', p), 'dir')
        t = load(fullfile(sprintf('part%d', p), 'trialInfo.mat'));
        trialInfo = cat(2, trialInfo, t.trialInfo);
        p = p + 1;
    else
        break;
    end
end

if ~isempty(trialInfo)
    save('trialInfo.mat', 'trialInfo');
end

%% if subject has multiple parts, manually copy or move '002', '003', etc. into part1/[taskdate]

%% update Trials.mat with response coding
% copy the following files to part1/ folder from the Box Sync\CoganLab\ECoG_Task_Data\response_coding\response_coding_results
%     allblocks.wav
%     cue_events.txt
%     D*_task*.txt => rename to response_coding.txt after copying
% first change task to the part1/ in the switch case above(if multiple parts)
% run add_response_coding_to_Trials.m
% a new Trials.mat file will be created in part1/
% examine this Trials.mat and then copy it to part1/[taskdate]/mat/