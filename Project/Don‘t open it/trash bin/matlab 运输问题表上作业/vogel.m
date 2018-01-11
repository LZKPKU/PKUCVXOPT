function vogel()        %运费最小
clc
clear
format short

price=[0 1 3 2 1 4 3 3 11 3 10
       1 0 1000 3 5 1000 2 1 9 2 8
       3 1000 0 1 1000 2 3 7 4 10 5
       2 3 1 0 1 3 2 2 8 4 6
       1 5 1000 1 0 1 1 4 5 2 7
       4 1000 2 3 1 0 2 1 8 2 4
       3 2 3 2 1 2 0 1 1000 2 6
       3 1 7 2 4 1 1 0 1 4 2
       11 9 4 8 5 8 1000 1 0 2 1
       3 2 10 4 2 2 2 4 2 0 3
       10 8 5 6 7 4 6 2 1 3 0];
prod=[27 24 29 20 20 20 20 20 20 20 20]';
sell=[20 20 20 20 20 20 20 23 26 25 26];

[m,n]=size(price);
A=init(length(prod),length(sell));
[A,prod,sell]=distribute(A,price,prod,sell,m,n);

A
pos=position(A,price)
judge=key(pos,price)
[min1,row1]=min(judge);        %每列中的judge的最小值
[min2,col1]=min(min1);

times=1;
     while min2<0
         fprintf('%s%d%s\n','第',times,'次迭代')
        i=row1(col1);j=col1;
        [result,point1,point2]=bestpath(A,i,j);
        result;
        A=newdis(A,point1,point2)
        pos=position(A,price)
        judge=key(pos,price)
        [min1,row1]=min(judge);        %每列中的judge的最小值
        [min2,col1]=min(min1);
        
        times=times+1;
        if times>100
            break;
        end
     end
     A
        total_cost=cost(A,price)
    function total_cost=cost(A,price)
        [m,n]=size(A);
        for i=1:m
            for j=1:n
                if isnan(A(i,j))
                    A(i,j)=0;
                end
            end
        end
        temp=A.*price;
        total_cost=sum(temp(:));
    function A=newdis(A,point1,point2)
        [p_min,index]=min(point1(:,3));
        point1(:,3)=point1(:,3)-p_min;
        point2(:,3)=point2(:,3)+p_min;

        for k=1:length(point1(:,1))
            A(point1(k,1),point1(k,2))=point1(k,3);
        end
        
        for k=1:length(point2(:,1))
            A(point2(k,1),point2(k,2))=point2(k,3);
        end
        A(point1(index,1),point1(index,2))=nan;

    function [A,prod,sell]=distribute(A,price,prod,sell,m,n)
        m=m+1;
        n=n+1;
        times=0;
       while any(prod~=0)|any(sell~=0)
           times=times+1;
           C=Tmin(price,prod,sell);
                         B1=find(prod~=0);
                         B2=find(sell~=0);
        [max1,x]=max(C(:,n));      %行中的最大差值
        [max2,y]=max(C(m,:));       %列中的最大差值
                if max1>=max2                 %从x行开始进行分配
                                                 %最小运价在t列
                     N=find(sell~=0);
                     temp=price(x,N(1));
                     t=N(1);
                     for i=1:length(N)
                         if temp>price(x,N(i))
                             temp=price(x,N(i));
                             t=N(i);
                         end
                     end

                     if sell(t)>prod(x)
                         A(x,t)=prod(x);
                         sell(t)=sell(t)-prod(x);
                         prod(x)=0;

                     elseif sell(t)==prod(x)
                         A(x,t)=prod(x);
                         prod(x)=0;  
                         sell(t)=0;

                         if length(B1)~=1|length(B2)~=1
                             N=find(isnan(A(x,:)));      %如果是最后一次则不必进行添加基变量
                             A(x,N(1))=0;
                         end
                     else
                         A(x,t)=sell(t);
                         prod(x)=prod(x)-sell(t);  
                         sell(t)=0;
                     end
                else                                 %从y列开始进行分配
                     M=find(prod~=0);
                     temp=price(M(1),y);
                     t=M(1);
                     for i=1:length(M)
                         if temp>price(M(i),y)
                             temp=price(M(i),y);
                             t=M(i);
                         end
                     end
                     if sell(y)>prod(t)
                         A(t,y)=prod(t);
                         sell(y)=sell(y)-prod(t);
                         prod(t)=0;
                     elseif sell(y)==prod(t)
                         A(t,y)=prod(t);
                         prod(t)=0;  
                         sell(y)=0;
                         if length(B1)~=1|length(B2)~=1
                             N=find(isnan(A(t,:)));      %如果是最后一次则不必进行添加基变量
                             A(t,N(1))=0;
                         end
                     else
                         A(t,y)=sell(y);
                         prod(t)=prod(t)-sell(y);  
                         sell(y)=0;
                     end
                end
       end
    function C=Tmin(price,prod,sell)          %计算两最小值的差值，他只负责查找两最小元素的差值
        [m,n]=size(price);
        C=price;   
        N=find(sell~=0);
        M=find(prod~=0);
                for i=1:length(M)
                   if length(N)==1 
                         C(M(i),n+1)=price(M(i),N(1));
                   else
                        if price(M(i),N(1))>price(M(i),N(2))
                            min1=price(M(i),N(2));
                            min2=price(M(i),N(1));
                        else
                            min1=price(M(i),N(1));
                            min2=price(M(i),N(2));
                        end
                                for j=3:length(N)
                                        if price(M(i),N(j))<min2 & price(M(i),N(j))>=min1
                                            min2=price(M(i),N(j));
                                        elseif price(M(i),N(j))<min1
                                            min2=min1;
                                            min1=price(M(i),N(j));
                                        end
                                end
                                C(M(i),n+1)=min2-min1;
                   end
                end

                for j=1:length(N)           %列的差值已经正确
                    if length(M)==1 
                        C(m+1,N(j))=price(M(1),N(j));
                    else
                            if price(M(1),N(j))>price(M(2),N(j))
                                min1=price(M(2),N(j));
                                min2=price(M(1),N(j));
                            else
                                min1=price(M(1),N(j));
                                min2=price(M(2),N(j));
                            end
                                    for i=3:length(M)
                                            if price(M(i),N(j))<min2 & price(M(i),N(j))>=min1
                                                min2=price(M(i),N(j))<min2;
                                            elseif price(M(i),N(j))<min1
                                                min2=min1;
                                                min1=price(M(i),N(j));
                                            end
                                    end
                                    C(m+1,N(j))=min2-min1;
                    end
                end
function A=init(m,n)                %初始化
    for i=1:m
        for j=1:n
            A(i,j)=nan;
        end
    end
function pos=position(A,price)        %判断位势，位势每次迭代后都会变化
    [m,n]=size(A);
    pos=A;
    k=1;
    B=zeros(m+n,m+n);
                B(k,1)=1;
                b(k)=0;
    for i=1:m
        for j=1:n
            if ~isnan(A(i,j))
                k=k+1;
                B(k,i)=1;
                B(k,m+j)=1;
                b(k)=price(i,j);
            end
        end
    end
        b=b';
        x=B\b;
        pos([1:m],n+1)=x([1:m]);
        pos(m+1,[1:n])=x([m+1:m+n]);
function judge=key(pos,price)       %判断检验数
        [m,n]=size(price);
       judge=zeros(m,n);
        for i=1:m
            for j=1:n
                if isnan(pos(i,j))
                    judge(i,j)=price(i,j)-pos(m+1,j)-pos(i,n+1);
                end 
            end
        end
        
                
        
    
                
                
        