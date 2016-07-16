function []=plotcluster(no,clustermat)
database=dir('C:\Users\user\Desktop\detectedface\*.pgm');
maximum=max(clustermat(:,100));
    t=1;
    for i=1:no
        col=clustermat(i,100);
            for j=1:col
            count=clustermat(i,j);
            fname=strcat('C:\Users\user\Desktop\detectedface\',database(count).name);
            I=imread(fname);
            subplot(no,maximum,t);
            imshow(I, []);
            t=t+1;
            end
            if(col<maximum)
                p=maximum-col; 
                t=t+p;
            end    
    end
end
