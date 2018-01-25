atomCharge=[-5.64/3 1.64 4];  
atomPair1=[1 2 3 1 1 2 2 3 3];
atomPair2=[1 2 3 2 3 3 1 1 2]; 
bondsRatio=[    0.3452    0.0447    0.0377    0.2553    0.2321    0.0851];
Length=[8.3043    8.7695    8.4013    8.2872    8.2164    8.2849
    8.2926    8.8495    8.3968    8.3000    8.1990    8.2901
    8.3737    8.6090    8.4901    8.2536    8.2840    8.2500
    8.3082    8.7835    8.4199    8.2857    8.2148    8.3000
    8.3373    8.5500    8.4500    8.2064    8.2446    8.2144];
%%
E=zeros(size(Length));

for i=1:size(Length,2)
        E(:,i)=(atomCharge(atomPair1(i))*atomCharge(atomPair2(i))./Length(:,i)')';
        
end
%%

for i=1:size(Length,1)
    weightedE(i)=sum(E(i,:).*bondsRatio);
end
weightedE

for i=1:size(Length,2)  % 6 different kinds of interactions
    subplot(size(Length,2),1,i)

    plot(Length(:,i))
end
