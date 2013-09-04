function [feat] = load_feature(dataset_name, feature, imgset, c, batch_id)

if(~exist('dataset_name', 'var') || isempty(dataset_name))
    dataset_name = '';
end
cache_folder = [c.cache '/' dataset_name '/'];
p = c.feature_config.(feature);

if(isfield(p, 'dictionary_size'))
    feature_file = sprintf(p.([imgset '_file']), cache_folder, p.dictionary_size);
else
    feature_file = sprintf(p.([imgset '_file']), cache_folder);
end

tmp = load(feature_file);
if(isempty(tmp.feat))
    batch_files = tmp.batch_files;
    if(~exist('batch_id', 'var') || isempty(batch_id))
        batch_id = 1:length(batch_files);
    end
    
    feat = cell(length(batch_id), 1);
    for i=1:length(batch_id)
      vprintf(c.verbosity, 1, 'Loading batch %d of %d', i, length(batch_id));
      tmp = load(batch_files{batch_id(i)});
      feat{i} = tmp.poolfeat;
    end
    feat = cell2mat(feat);
else
    feat = tmp.feat;
end