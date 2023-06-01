function [CurrentTask,TaskType] = assignCurrentTask(TD);        
%
%  [CurrentTask,TaskCode] = assignCurrentTask(TD);        
%
global experiment
                        switch TD.TaskCode(TD.currentTrial)
                            case 1
                                CurrentTask = 'Sensors';  TaskType = 10;
                            case 2
                                CurrentTask = 'Touch';  TaskType = 10;
                            case 3
                                CurrentTask = 'Fixate';  TaskType = 10;
                            case 4
                                CurrentTask = 'TouchFix';  TaskType = 10;
                            case 5
                                CurrentTask = 'SuppReach';  TaskType = 10;
                            case 6
                                CurrentTask = 'SuppReachFixate';  TaskType = 10;
                            case 7
                                CurrentTask = 'SuppSaccade';  TaskType = 10;
                            case 8
                                CurrentTask = 'SuppSaccadeTouch';  TaskType = 10;
                            case 9
                                CurrentTask = 'SuppReachSaccade';  TaskType = 10;
                            case 10
                                CurrentTask = 'DelReach';  TaskType = 1;
                            case 11
                                CurrentTask = 'DelReachFix';  TaskType = 3;
                            case 12        
                                CurrentTask = 'DelSaccade';  TaskType = 4;
                            case 13
                                CurrentTask = 'DelSaccadeTouch'; TaskType = 4;
                            case 14
                                CurrentTask = 'DelReachSaccade'; TaskType = 2;
                            case 15
                                CurrentTask = 'MemoryReach';  TaskType = 1;
                            case 16
                                CurrentTask = 'MemoryReachFix';  TaskType = 3;
                            case 17
                                CurrentTask = 'MemorySaccade';  TaskType = 4;
                            case 18
                                CurrentTask = 'MemorySaccadeTouch'; TaskType = 4;
                            case 19
                                CurrentTask = 'MemoryReachSaccade'; TaskType = 2;
                            case 20
                                CurrentTask = 'DelReachthenSaccade'; TaskType = 2;
                            case 21 
                                CurrentTask = 'DelSaccadethenReach'; TaskType = 2;
                            case 22
                                CurrentTask = 'SOA';  TaskType = 6;
                            case 23
                                CurrentTask = 'MemSOA';  TaskType = 6;
                            case 24
                                CurrentTask = 'RaceReach';  TaskType = 7;
                            case 25
                                CurrentTask = 'RaceSaccade';  TaskType = 7;
                            case 26
                                CurrentTask = 'RaceReachSaccade';  TaskType = 7;
                            case 27
                                CurrentTask = 'EyeCalibration';  TaskType = 5;
                            case 28
                                CurrentTask = 'ColorDiscrimination';  TaskType = 8;
                            case 29
                                CurrentTask = 'ColorDiscriminationProximate';  TaskType = 8;
                            case 30
                                CurrentTask = 'DelRaceReach';  TaskType = 7;
                            case 31
                                CurrentTask = 'DelRaceSaccade';  TaskType = 7;
                            case 32
                                CurrentTask = 'DelRaceReachSaccade';  TaskType = 7;
                            case 33
                                CurrentTask = 'MemRaceReach';  TaskType = 7;
                            case 34
                                CurrentTask = 'MemRaceSaccade';  TaskType = 7;
                            case 35
                                CurrentTask = 'MemRaceReachSaccade';  TaskType = 7;
                            case 36
                                CurrentTask = 'ImmediateDoubleStep';  TaskType = 9;
                            case 37
                                CurrentTask = 'PostSaccDoubleStep';  TaskType = 9;
                            case 38
                                CurrentTask = 'PeriReachDoubleStep';  TaskType = 9;
                            case 39
                                CurrentTask = 'PostReachDoubleStep';  TaskType = 9;
                            case 40
                                CurrentTask = 'SaccadeDoubleStep';  TaskType = 9;
                            case 41
                                CurrentTask = 'ImmediateSaccadeDoubleStep';  TaskType = 9;
                            case 42
                                CurrentTask = 'MemPeriReachDoubleStep';  TaskType = 9;
                            otherwise
                                CurrentTask = 'Break';  TaskType = 10;
                            
                        end
                        if(isfield(experiment.acquire.recording.task.types,CurrentTask))
                            experiment.acquire.recording.task.types.(CurrentTask)
                            TaskType = experiment.acquire.recording.task.types.(CurrentTask)
                        else 
                            TaskType = 10;
                        end