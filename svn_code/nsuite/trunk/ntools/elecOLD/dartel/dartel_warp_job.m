%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 3599 $)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.spatial.preproc.data = '<UNDEFINED>';
matlabbatch{1}.spm.spatial.preproc.output.GM = [0 0 1];
matlabbatch{1}.spm.spatial.preproc.output.WM = [0 0 1];
matlabbatch{1}.spm.spatial.preproc.output.CSF = [0 0 0];
matlabbatch{1}.spm.spatial.preproc.output.biascor = 1;
matlabbatch{1}.spm.spatial.preproc.output.cleanup = 0;
matlabbatch{1}.spm.spatial.preproc.opts.tpm = {
                                               '/home/ccarlson/hugh/spm8/tpm/grey.nii'
                                               '/home/ccarlson/hugh/spm8/tpm/white.nii'
                                               '/home/ccarlson/hugh/spm8/tpm/csf.nii'
                                               };
matlabbatch{1}.spm.spatial.preproc.opts.ngaus = [2
                                                 2
                                                 2
                                                 4];
matlabbatch{1}.spm.spatial.preproc.opts.regtype = 'mni';
matlabbatch{1}.spm.spatial.preproc.opts.warpreg = 1;
matlabbatch{1}.spm.spatial.preproc.opts.warpco = 25;
matlabbatch{1}.spm.spatial.preproc.opts.biasreg = 0.0001;
matlabbatch{1}.spm.spatial.preproc.opts.biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.opts.samp = 3;
matlabbatch{1}.spm.spatial.preproc.opts.msk = {''};
matlabbatch{2}.spm.tools.dartel.initial.matnames(1) = cfg_dep;
matlabbatch{2}.spm.tools.dartel.initial.matnames(1).tname = 'Parameter Files';
matlabbatch{2}.spm.tools.dartel.initial.matnames(1).tgt_spec = {};
matlabbatch{2}.spm.tools.dartel.initial.matnames(1).sname = 'Segment: Norm Params Subj->MNI';
matlabbatch{2}.spm.tools.dartel.initial.matnames(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.tools.dartel.initial.matnames(1).src_output = substruct('()',{1}, '.','snfile', '()',{':'});
matlabbatch{2}.spm.tools.dartel.initial.odir = '<UNDEFINED>';
matlabbatch{2}.spm.tools.dartel.initial.bb = [NaN NaN NaN
                                              NaN NaN NaN];
matlabbatch{2}.spm.tools.dartel.initial.vox = 1.5;
matlabbatch{2}.spm.tools.dartel.initial.image = 0;
matlabbatch{2}.spm.tools.dartel.initial.GM = 1;
matlabbatch{2}.spm.tools.dartel.initial.WM = 1;
matlabbatch{2}.spm.tools.dartel.initial.CSF = 0;
matlabbatch{3}.spm.tools.dartel.warp1.images{1}(1) = cfg_dep;
matlabbatch{3}.spm.tools.dartel.warp1.images{1}(1).tname = 'Images';
matlabbatch{3}.spm.tools.dartel.warp1.images{1}(1).tgt_spec = {};
matlabbatch{3}.spm.tools.dartel.warp1.images{1}(1).sname = 'Initial Import: Imported Tissue (GM)';
matlabbatch{3}.spm.tools.dartel.warp1.images{1}(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.tools.dartel.warp1.images{1}(1).src_output = substruct('.','cfiles', '()',{':', 1});
matlabbatch{3}.spm.tools.dartel.warp1.images{2}(1) = cfg_dep;
matlabbatch{3}.spm.tools.dartel.warp1.images{2}(1).tname = 'Images';
matlabbatch{3}.spm.tools.dartel.warp1.images{2}(1).tgt_spec = {};
matlabbatch{3}.spm.tools.dartel.warp1.images{2}(1).sname = 'Initial Import: Imported Tissue (WM)';
matlabbatch{3}.spm.tools.dartel.warp1.images{2}(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.tools.dartel.warp1.images{2}(1).src_output = substruct('.','cfiles', '()',{':', 2});
matlabbatch{3}.spm.tools.dartel.warp1.settings.rform = 0;
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(1).its = 3;
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(1).rparam = [4 2 1e-06];
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(1).K = 0;
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(1).template = {'/home/ccarlson/hugh/dartel/Template_1.nii'};
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(2).its = 3;
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(2).rparam = [2 1 1e-06];
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(2).K = 0;
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(2).template = {'/home/ccarlson/hugh/dartel/Template_2.nii'};
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(3).its = 3;
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(3).rparam = [1 0.5 1e-06];
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(3).K = 1;
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(3).template = {'/home/ccarlson/hugh/dartel/Template_3.nii'};
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(4).its = 3;
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(4).rparam = [0.5 0.25 1e-06];
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(4).K = 2;
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(4).template = {'/home/ccarlson/hugh/dartel/Template_4.nii'};
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(5).its = 3;
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(5).rparam = [0.25 0.125 1e-06];
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(5).K = 4;
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(5).template = {'/home/ccarlson/hugh/dartel/Template_5.nii'};
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(6).its = 3;
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(6).rparam = [0.25 0.125 1e-06];
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(6).K = 6;
matlabbatch{3}.spm.tools.dartel.warp1.settings.param(6).template = {'/home/ccarlson/hugh/dartel/Template_6.nii'};
matlabbatch{3}.spm.tools.dartel.warp1.settings.optim.lmreg = 0.01;
matlabbatch{3}.spm.tools.dartel.warp1.settings.optim.cyc = 3;
matlabbatch{3}.spm.tools.dartel.warp1.settings.optim.its = 3;
matlabbatch{4}.spm.util.defs.comp{1}.dartel.flowfield(1) = cfg_dep;
matlabbatch{4}.spm.util.defs.comp{1}.dartel.flowfield(1).tname = 'Flow field';
matlabbatch{4}.spm.util.defs.comp{1}.dartel.flowfield(1).tgt_spec = {};
matlabbatch{4}.spm.util.defs.comp{1}.dartel.flowfield(1).sname = 'Run DARTEL (existing Templates): Flow Fields';
matlabbatch{4}.spm.util.defs.comp{1}.dartel.flowfield(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{4}.spm.util.defs.comp{1}.dartel.flowfield(1).src_output = substruct('.','files', '()',{':'});
matlabbatch{4}.spm.util.defs.comp{1}.dartel.times = [1 0];
matlabbatch{4}.spm.util.defs.comp{1}.dartel.K = 6;
matlabbatch{4}.spm.util.defs.comp{2}.id.space = {'/home/ccarlson/hugh/dartel/ch2.img,1'};
matlabbatch{4}.spm.util.defs.ofname = '';
matlabbatch{4}.spm.util.defs.fnames = '<UNDEFINED>';
matlabbatch{4}.spm.util.defs.savedir.savedef = 1;
matlabbatch{4}.spm.util.defs.interp = 0;
