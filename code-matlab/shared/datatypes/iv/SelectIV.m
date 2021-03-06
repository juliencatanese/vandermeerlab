function iv = SelectIV(cfg_in,iv)
% function iv_out = SelectIV(cfg_in,iv_in)
%
% select IVs based on some usr field
%
% INPUTS:
%
% iv_in: input interval data
%
% CFG OPTIONS:
% cfg.usrlabel = []; % which label to use
% cfg.dcn = '>';
% cfg.threshold = 5;
%
% OUTPUTS:
%
% iv_out: output interval data
%
% MvdM 2014-06-24

cfg.usrlabel = []; % which label to use
cfg.dcn = '>';
cfg.threshold = 5;

ProcessConfig; % should take whatever is in cfg_in and put it into cfg!
mfun = mfilename;

if ~isfield(iv,'usr')
   error('This iv has no usr data.'); 
end

% get data to select on
if length(iv.usr) == 1
    temp_data = iv.usr.data;
else
    idx = strmatch(cfg.usrlabel,iv.usr.label); % NOTE: THIS IS UNTESTED
    
    if ~isempty(idx)
        temp_data = iv.usr(idx).data;
    else
        error('usrlabel not found.');
    end
end

% do the selection
switch cfg.dcn
    case '>'
        keep_idx = temp_data > cfg.threshold;
    case '<'
        keep_idx = temp_data < cfg.threshold;
end

iv.tstart = iv.tstart(keep_idx);
iv.tend = iv.tend(keep_idx);

for iU = 1:length(iv.usr)
   iv.usr(iU).data = iv.usr(iU).data(keep_idx); 
end

% housekeeping
iv.cfg.history.mfun = cat(1,iv.cfg.history.mfun,mfun);
iv.cfg.history.cfg = cat(1,iv.cfg.history.cfg,{cfg});