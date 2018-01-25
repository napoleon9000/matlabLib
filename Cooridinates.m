clear
clc

Bulk_Ca=[-7.57071313 10.32001082 4.68811333];
Bulk_O=[-6.80461138 8.93412875 6.59342317
        -5.48921492 11.53418286 5.58169083
        -7.39468074 12.72331294 5.58169083
        -9.15226557 10.39921209 6.59342317
        -5.41103833 9.04596735 3.72490814
        -7.39468074 7.98859973 3.68621317
        -6.88278798 11.42234426 2.63578587
        -9.74233494 9.45368307  3.68621317
        -9.66415834 11.70018078 3.72490814
        ];

FullRelaxed_Ca=[-24.04953999 4.85766958 4.90152512];
FullRelaxed_O=[-23.36161484 3.75533613 6.95385257
               -21.88986519 6.13171304 5.86473030
               -23.87350761 7.18908067 5.90342527
               -25.63109244 5.35218152 6.91515761
               -21.96804179 3.64349753 4.00794761
               -23.87350761 2.45436745 4.00794761
               -23.28343824 6.24355164 2.99621527
               -26.14298521 4.05121283 4.04664257
               -26.22116181  6.29771054 4.00794761
               ];
 FixXY_Ca=[4.96180543 5.05107388 4.99431837];
 FixXY_O=[5.54710011 3.97347288 7.00058170
          7.08873245 6.32508696 5.95753187
          5.10494486 7.38252539 5.99619763
          3.26127403 5.54556595 7.00790323
          7.01113728 3.83690741 4.10069742
          5.10474600 2.64783486 4.10069742
          5.65817338 6.43701527 3.08899763
          2.80612326 4.24465978 4.13942714
          2.70848300 6.49108554 4.10069742
 ];
vBulk_O=Bulk_O-ones(9,1)*Bulk_Ca;
vRelax_O=FullRelaxed_O-ones(9,1)*FullRelaxed_Ca;
vFix_O=FixXY_O-ones(9,1)*FixXY_Ca;
DivRelax=vRelax_O-vBulk_O;
DivFix=vFix_O-vBulk_O;
sum(sqrt(sum(DivRelax.*DivRelax,2)))
sum(sqrt(sum(DivFix.*DivFix,2)))