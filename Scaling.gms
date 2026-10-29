* Scale bilateral trade equations by their benchmark flow, including tiny
* positive flows. This preserves data and equations while normalizing pivots.
EX.scale(i,z,zj)$EXO(i,z,zj) = EXO(i,z,zj);
IM.scale(i,zj,z)$IMO(i,zj,z) = IMO(i,zj,z);
EQ44.scale(i,z,zj)$EXO(i,z,zj) = EXO(i,z,zj);
EQ48.scale(i,zj,z)$IMO(i,zj,z) = IMO(i,zj,z);
EQ77.scale(i,z,zj)$EXO(i,z,zj) = EXO(i,z,zj);
