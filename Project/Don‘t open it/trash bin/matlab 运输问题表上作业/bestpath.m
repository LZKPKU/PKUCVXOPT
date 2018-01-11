function [result,point1,point2]=bestpath(A1,i,j)

if nargin==0
    A =[nan nan 5 2;3 nan nan 1;nan 6 nan 3]        %�������Ապϻ�·���㷨
    x=3;y=1;
elseif nargin==3
    A=A1;x=i;y=j;
end
move=[1 0;-1 0;0 1;0 -1];                        %ָ����ƶ������¡��ϡ��ҡ���
[m,n]=size(A);                                   %m��n�ֱ�ΪA������������

R=[];
%------------�еĿ����Ա��
[marks,i,j,row,col,B]=mark(A,x,y);              %��ʼ��������·��
prev=[0 0];                                     %���ڱ�����һ���ƶ�ʱ���ƶ�����
[~,R,~,~,~]=seekPath(B,0,marks,move,R,prev,0,i,j,row,col);  %��ѯ�Ⱥ�·��

[result,result1,point1,point2]=res(A,row,col,R,m,n);                        %��ѯ������ö����Ʊ�ʾ·��
function [isfind,R,times,row,col,prev]=seekPath(A,isfind,marks,move,R,prev,times,i,j,row,col)
  if (i==row &&j==col)                   %�ж��Ƿ��ֻص��������
        times=times+1;
        if times==2                      %��ʱ�ص���㣬���ҽ���
            isfind=1;
            return
        end
  end
  x=i;y=j;
  if isnan(A(i,j))              %�����ݵ�Ϊ����ִ�е��㷨
      next=prev;                %������ݸ�Ϊ����ֻ��ֱ��     
      u=i-prev(1);v=j-prev(2);  %����ǰһ�εķ����ƶ�
      if prev(1)
          mrow=2;
      else
          mrow=1;
      end
      if marks(u+1,v+1,mrow)==1
         [isfind,R,times,row,col]=seekPath(A,isfind,marks,move,R,next,times,u,v,row,col);
         if isfind==1
              R=[R;i j];
              return
         end
      end
  else
        for k=1:4
            if k==1||k==2
                mrow=2;
            else
                mrow=1;
            end
            u=i+move(k,1);
            v=j+move(k,2);
            
            if prev(1)~=move(k,1)||prev(2)~=move(k,2)               %�ж��Ƿ�ԭ·����
                if marks(u+1,v+1,mrow)==1
                    next=[-move(k,1),-move(k,2)];
                    [isfind,R,times,row,col]=seekPath(A,isfind,marks,move,R,next,times,u,v,row,col);
                       if isfind==1
                           R=[R;i j];
                           return
                       end
                end
           end
        end
  end
    function [result,result1,point1,point2]=res(A,row,col,R,m,n)
        [m1,n1]=size(R);
        point=[];
        num=0;
        
        A(row,col)=0;                   %Ϊ���Ժ��¼����
        result=zeros(m,n);              %ֻ��¼ת�۵��ֵ
        result1=zeros(m,n);  
        result2=zeros(m,n); 
 
        result2(row,col)=1;
        
        for i=1:m1
            if ~isnan(A(R(i,1),R(i,2))) 
                result2(R(i,1),R(i,2))=1;
            end
        end
        
        %ֻ�����սǴ��Ľ�㣬
        for i=1:m
            T1=find(result2(i,:)==1);
            if length(T1)>1
                result(i,T1(1))=1;
                result(i,T1(length(T1)))=1;
                
                result1(i,T1(1))=A(i,T1(1));
                result1(i,T1(length(T1)))=A(i,T1(length(T1)));
            end
        end
        for j=1:n
            T2=find(result2(:,j)==1);
            if length(T2)>1
                result(T2(1),j)=1;
                result(T2(length(T2)),j)=1;
                
                result1(T2(1),j)=A(T2(1),j);
                result1(T2(length(T2)),j)=A(T2(length(T2)),j);
            end
        end
        
        for i=1:m1                         %ֻ�����սǴ��Ľ��
            if result(R(i,1),R(i,2))==1
                num=num+1;
                point(num,1)=R(i,1);
                point(num,2)=R(i,2);
                point(num,3)=result1(R(i,1),R(i,2));
            end
        end
        save mydata point
        
        point1=point([1:2:length(point)],:);        %��������
        point2=point([2:2:length(point)],:);        %ż������
                   
function [marks,i,j,row,col,B]=mark(A,x,y)
    fprintf('%s%d%s%d%s\n','���ڽ��в��Ե������ǲ�A(',x,',',y,')')
            A(x,y)=-1;
            B=A;
            [m,n]=size(A);
            
            marks=zeros(m+2,n+2,2);
for p=2:m+1
    T1=find(~isnan(A(p-1,:)));
    if ~isempty(T1)
        if length(T1)==1
            marks(p,T1(1)+1,1)=1;
        else
            for k=T1(1):T1(length(T1))
                marks(p,k+1,1)=1;
            end
        end
    end
end
for q=2:n+1
    T2=find(~isnan(A(:,q-1)));
    if ~isempty(T2)
        if length(T2)==1
            marks(T2(1)+1,q,2)=1;
        else
            for k=T2(1):T2(length(T2))
                marks(k+1,q,2)=1;
            end
        end
    end
end
row=x;col=y;i=x;j=y;
 