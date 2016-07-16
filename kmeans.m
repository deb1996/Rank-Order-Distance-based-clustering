function [Cluster,Codebook] = kmeans(X, K, stopIter)
[R N] = size(X);
if K > N,
    error('K must be less than or equal to the number of vectors N');
end

% Initial centroids
Codebook= X(:, randsample(N, K));
disp(Codebook);
improvedRatio = Inf;
distortion = Inf;
while true
    % Calculate euclidean distances between each sample and each centroid
    d = cveculidean(Codebook, X);
    % Assign each sample to the nearest codeword (centroid)
    %d=sqrt(d);
    %fprintf('distance is ');
    %disp(d);
    [dataNearClusterDist, Cluster] = min(d,[],1);
    % distortion. If centroids are unchanged, distortion is also unchanged.
    % smaller distortion is better
    old_distortion = distortion;
    %fprintf('data near cluster distance');
    %disp(dataNearClusterDist);
    %fprintf('cluster data ');
    %disp(Cluster);
    distortion = mean(dataNearClusterDist);
    %fprintf('the current distortion');
    %disp(distortion);
    % If no more improved, break;
    improvedRatio = 1 - (distortion / old_distortion); 
   fprintf(' improved ratio = %f\n' ,improvedRatio);
    if improvedRatio <= stopIter, break, end;

    % Renew Codebook
    for i=1:K
        % Get the id of samples which were clusterd into cluster i.
        idx = find(Cluster == i);
        %fprintf('id of samples for cluster %d',i);
        %disp(idx);
        % Calculate centroid of each cluter, and replace Codebook
        Codebook(:, i) = mean(X(:, idx),2);
    end
    %fprintf('new codebook is ');
    %disp(Codebook);
end
end

