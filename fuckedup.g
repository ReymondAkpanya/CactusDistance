C3W2test:=function(L1,L2)
	local s1,s2,t,L;
	L:=[];
	t:=1;
        for s1 in L1 do
                for s2 in L2 do
                        Append(L,C3Wtest(s1,s2));
                od;
	Print(t,"\n");
	t:=t+1;
        od;
        #return IsomorphismRepresentatives(L);
        return L;

end;




C3Wtest:=function(S1,S2)
	local f1,f2,V1,V2,m1,m2,m3,V,L,M1,M2,M3,M4,M5,M6;
	L:=[];
#	Print(Help(S1)," ",Help(S2));
	for f1 in Help(S1) do
		for f2 in Help(S2) do
			V1:=VerticesOfFace(S1,f1);
			V2:=VerticesOfFace(S2,f2);	
			m1:=MapVert(S1,[[V1[1],V2[1]],[V1[2],V2[2]],[V1[3],V2[3]]]);
			m2:=MapVert(S1,[[V1[1],V2[2]],[V1[2],V2[3]],[V1[3],V2[1]]]);
			m3:=MapVert(S1,[[V1[1],V2[3]],[V1[2],V2[1]],[V1[3],V2[2]]]);
#######################			
			m4:=MapVert(S1,[[V1[1],V2[1]],[V1[2],V2[3]],[V1[3],V2[2]]]);
			m5:=MapVert(S1,[[V1[1],V2[3]],[V1[2],V2[2]],[V1[3],V2[1]]]);
			m6:=MapVert(S1,[[V1[1],V2[1]],[V1[2],V2[2]],[V1[3],V2[3]]]);
#######################
			V:=VerticesOfFaces(S2);				
			M1:=symdif(m1,V);
			M2:=symdif(m2,V);
			M3:=symdif(m3,V);
##########################
			M4:=symdif(m4,V);
			M5:=symdif(m5,V);
			M6:=symdif(m6,V);
#############################
			Add(L,SimplicialSurfaceByVerticesInFaces(M1));
			Add(L,SimplicialSurfaceByVerticesInFaces(M2));
			Add(L,SimplicialSurfaceByVerticesInFaces(M3));

######################
			Add(L,SimplicialSurfaceByVerticesInFaces(M4));
			Add(L,SimplicialSurfaceByVerticesInFaces(M5));
			Add(L,SimplicialSurfaceByVerticesInFaces(M6));

#######################
		od;
	od;
	return IsomorphismRepresentatives(L);
	#return L;
end;

newkb:=function(l,file)
	local temp,i,g,sum;
	i:=0;
	sum:=0;
	while 500*(i+1)<Length(l) do
		Print([1+500*i .. (i+1)*500],"\n");
		temp:=List([1+500*i .. (i+1)*500],g->SimplicialSurfaceByVerticesInFaces(l[g]));
		Print(Length(temp)," auf isomorphie untersuchen\n");
		temp:=C3W2test(temp,[T]);
		Print(Length(temp)," neue flaechen\n");
		temp:=IsomorphismRepresentatives(temp);
	write(temp,file);
	i:=i+1;
	sum:=sum+Length(temp);
	Print(sum," endwhile\n");
	od;
	Print([1+500*i .. Length(l)],"\n");
	Print("last","\n");
	temp:=List([1+500*i..Length(l)],g->SimplicialSurfaceByVerticesInFaces(l[g]));
	temp:=C3W2test(temp,[T]);
	temp:=IsomorphismRepresentatives(temp);
	write(temp,file);
end;
fmatrix:=function(S)
	local tempS,n,L,temp,i,j;
	tempS:=SimplicialSurfaceByVerticesInFaces(Set(VerticesOfFaces(S)));
	n:=NumberOfFaces(tempS);
	L:=[];
	for i in [1..n] do 
		temp:=[];
		for j in [1..n] do 
			if j in NeighbourFacesOfFace(tempS,i) then
				Add(temp,1);
			else
				Add(temp,0);
			fi;
		
		od;
		Add(L,temp);
	od;
	return L;
end;
