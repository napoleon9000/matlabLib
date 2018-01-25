clear
filename1='PerfectSlabRelaxed.vasp';
filename2='PerfectRelaxedTS.vasp';
%%%%filename='TS_Rigid.vasp';
filename3='NEB_TS.vasp';
filename4='PerfectSlabRelaxedSlipSF.vasp';
filename5='StackingFaultRelaxed.vasp';
filename6='test4.vasp';
filename=char(filename1,filename2,filename3,filename4,filename5,filename6);

%------------------------------
%  Parameters
%constK=9e-2;                                    % nN*A^2*C^-2
%cutoff=11; 

atomCharge=[-5.64/3 1.64 0];                    % atom charge 
atomCharge=[1 0 0];
atomPair1=[1 2 1 2];                            % atom pairs need to be calculated
atomPair2=[1 2 2 1];
atomPair1=[1 ];                            % atom pairs need to be calculated
atomPair2=[1 ];
coordinateNumber=[6 6 3 9];
HistRes=0.05;                                   % resolution
file=1:5;
%file=6;
cutoffLoop=6;
result=zeros(size(file,2),size(cutoffLoop,2),4);
isOpen = matlabpool('size') > 0;
if(~isOpen)
    matlabpool 4
end
%------------------------------
%Outer loop
for m=file
    disp('file:')
    disp(m)
    
    %------------------------------
    % Load atomic position    
    [ coordinate1,atom1,atom2,atom3,a1,b1,c1 ]=loadPOSCAR(filename(m,:));
    coordinate1=InsertAtomInfo(coordinate1,atom1,atom2,atom3);    
    %------------------------------
    % Prepare data
    maxCutoff=max(cutoffLoop);    
    [expdCoordinate,expdA1, expdB1, expdC1]=ExpdCell(coordinate1,a1,b1,c1,maxCutoff);
    expdCoordinate(:,5)=0;
    E11=0;
    E12=0;
    E22=0;
    distance=9999*ones(size(expdCoordinate));
    energy=zeros(size(expdCoordinate));
    disp('Calculating distance');
    for i=1:size(expdCoordinate,1)
        if(mod(i,round(size(expdCoordinate,1)/20))==0)
            disp(i/size(expdCoordinate,1))
        end
        for j=1:size(expdCoordinate,1)
            if(j>i)
                distance(i,j)=AtomDistance(expdCoordinate(i,1:3),expdCoordinate(j,1:3),expdA1,expdB1,expdC1);
                energy(i,j)=AtomicPotentialEnergy(distance(i,j),atomCharge(expdCoordinate(i,4)),atomCharge(expdCoordinate(j,4)));
            end
        end
    end
    h=0;
    parfor n=1:size(cutoffLoop,2)
        Etot=0;
        disp('file:')
        disp(m)
        disp('cutoff:')
        disp(cutoffLoop(n))
        %disp(h/size(cutoffLoop))
        [indexX,indexY]=find(distance<cutoffLoop(n));
        for i=1:size(indexX)
            Etot=Etot+energy(indexX(i),indexY(i));
        end
            
        Etot=Etot/(size(expdCoordinate,1)/(atom1+atom2+atom3));


        result(m,n,1)=Etot;       
%         result(m,h,2)=E11;
%         result(m,h,3)=E22;
%         result(m,h,4)=E12;
       %h=h+1;
    end
end
%%
matlabpool close
%------------------------------
%%
hold on

for i=1:size(cutoffLoop,2)
    for j=size(file,2):-1:1
        result(j,i,1)=result(j,i,1)-result(1,i,1);
    end
    cutoffLoop(i)
    plot(1:5,result(:,i,1))
    pause
end
%%
%plot(cutoffLoop,result(6,:,1))