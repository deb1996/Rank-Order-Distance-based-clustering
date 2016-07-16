function [class,type,clustermat,no]=dbscandistance(rank_order,k,Eps) % x = dataset, k = no. of %points within the radius & Eps as the radius

[m,n]=size(rank_order);

if nargin<3 || isempty(Eps)
   [Eps]=epsilon(x,k);
end

%x = [[1:m]' x];
%[m,n] = size(x);
type = zeros(1,m);
no = 1;
touched = zeros(m,1);
clustermat=zeros(m,100);
for i = 1:m
    if touched(i) == 0;
       %ob = x(i,:);
       %D = dist(ob(2:n),x(:,2:n));
       %fprintf('point considered %d',i);
       D=rank_order(:,i);
       d1(1,:)=D(:,1);
       ind = find(d1<=Eps);
        %disp(ind);
       if length(ind)>1 && length(ind)<k+1      
          type(i) = 0;
          class(i) = 0;
       end
       if length(ind)==1
          type(i) = -1;
          class(i) = -1; 
          touched(i) = 1;
       end

       if length(ind)>= k+1
           j=1;
          type(i) = 1;
          class(ind) = ones(length(ind),1)*max(no);
                  
           while ~isempty(ind)
               a=find(clustermat(no,:)==ind(1));
               if(isempty(a))
                clustermat(no,j)=ind(1);
                 j=j+1;
               end
                %ob = x(ind(1),:);%there is a x
                ob=ind(1);
                D =rank_order(:,ind(1));
                d2(1,:)=D(:,1);
                touched(ob) = 1;
                ind(1) = [];
                i1 = find(d2<=(Eps/7));
                %disp(i1);
                if length(i1)>1
                   class(i1) = no;
                   if length(i1) >= k+1;
                      type(ob) = 1;
                   else
                      type(ob) = 0;
                   end
                    
                   for i = 1:length(i1)
                       if touched(i1(i)) == 0
                           clustermat(no,j)=i1(i);
                           j=j+1;
                          touched(i1(i)) = 1;
                          ind = [ind i1(i)];
                          %disp(ind);
                          fprintf('\n');
                          class(i1(i)) = no;
                       end                   
                   end
                end
                %disp(ind);
          end
          %fprintf('the points in cluster %d',no);
          %disp(clustermat(no,1:(j-1)));
         clustermat(no,100)=j-1;
         disp(j-1);
          no = no+1;
       end
   end
end

i1 = find(class == 0);
class(i1) = -1;
type(i1) = -1;



function [Eps] = epsilon(x,k) % Analytical calculation of rad if %not given

[m,n] = size(x);

Eps = ((prod(max(x)-min(x))*k*gamma(.5*n+1))/(m*sqrt(pi.^n))).^(1/n);



function [D] = dist(i,x) %Distance Calculation

[m,n] = size(x);
D = sqrt(sum((((ones(m,1)*i)-x).^2)'));

if n == 1
   D = abs((ones(m,1)*i-x))';
end
