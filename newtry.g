#######################################################
Read("cactus1.g");
UmbDes:=function(Simp)
	local Umbr;
	Umbr:=UmbrellaPathsOfVertices(Simp);
	return List(Umbr,r->FacesAsPerm(r));
end;
CycToList:=function(g,n)
	local L,i;
	L:=[];
	for i in [1..n] do 
		if not(i^g=i) then
			Add(L,i);
		fi;
	od;
	return L;
end;
CycListToList:=function(UB,n)
	local g;
	return List(UB, g->CycToList(g,n));
end; 
FaceTransposition:=function(Simp)
	local L,F,e;
	L:=[];
	for e in Edges(Simp) do
		F:=FacesOfEdge(Simp,e);
		Add(L,(F[1],F[2]));
	od;
	return L;
end;

Ret:=function(Simp)
	local G,U,g;
	G:=Gs(Simp);
	#U:=UmbDes(Simp);
	return List(G, g->EdT(UmbDes(Simp),g));
end;

faith:=function(L)
	local g,i,j;
	for i in [1..Length(L)-1] do
		for j in [1..Length(L)] do
			if Length(Intersection(L[i],L[j]))=4 then
				return false;
			fi;
		od;
	od;
	return true;
end;
Us:=function(U,n)
        local temp,L,m,V,F;
	temp:=[];
        L:=List(U, g->CycToList(g,n));
	m:=Maximum(List(L,g->Maximum(g)));
	temp:=List([1..m],g->[]);
        for V in [1..Length(L)] do
                for F in L[V] do
			Add(temp[F],V);
		od;
        od;
        return SimplicialSurfaceByVerticesInFaces(temp);

end;
UmbToTrans:=function(U,n)
	local L,K,g,i;
	K:=[];
	L:=CycListToList(U,n);
	for g in L do
		Add(K,(g[1],g[Length(g)]) );
		for i in [1..Length(g)-1] do
			Add(K,(g[i],g[i+1]) );
		od;
	od; 
	return Set(K);
end;
#########################################################
EdgeTRH:=function(U,L,n)
	local g,U1;
	for g in UmbToTrans(U,n) do 
		U1:=EdT(U,g);
		if not( ListUmbIso(U1,L,n)) then 
			Add(L,U1);
			L:=EdgeTRH(U1,L,n);
		fi;
	od;
	return L; 
end;
EdgeTR:=function(S)
	local U,g,L,U1;

	U:=UmbDes(S);
	L:=[U];	
	for U1 in Ret(S) do
		L:=EdgeTRH(U1,[U],Length(Faces(S)) );
	od;
	return L;
end;
UmbIso:=function(U1,U2,n)
	local G,L1,L2,g;
#	G:=SymmetricGroup(n);
#	for g in G do 
#		if Set(U2)= Set(List(U1,r->g*r*g^(-1))) then
#			return true;
#		fi;
#	od;
	if Set(List(CycListToList(U1,n),g->Length(g)))=Set(List(CycListToList(U2,n),g->Length(g))) then 
		return true;
	fi;
	return false;
end;
ListUmbIso:=function(U1,L,n)
	local g;
	for g in L do 
		if UmbIso(U1,g,n) then 
			return true;
		fi;
	od;
	return false;
end;
#######################################

############################################
Len:=function(G)
	local l,H;
	l:=0;
	H:=G;
	while Order(H)>1 do
		H:=DerivedSubgroup(H);
		l:=l+1;
	od;
	return l;
end;
mc:=function(M,L)
	local k,i;
	k:=[];
	for i in [1..Length(M)] do
		Add(k,M[i]*L[i]);
	od;
	return k;
end;
EdT:=function(Umb,t)
	local c,i;
	c:=Umb;
	for i in [1..Length(c)] do 
		if not(t*c[i]*t=c[i]) then
			c[i]:=t*c[i];
		fi;
	od;
	return c;
end;

UmbSurf:=function(M)
	local E,F,E1,L,i,j;
	F:=[];
	for j in [1..Length(M[1])] do
		F[j]:=[];
		for i in [1..Length(M)] do
			if M[i][j]=1 then
				Add(F[j],i);
			fi;		
		od; 
	od;
	return SimplicialSurfaceByVerticesInFaces(F);

end;
#################################################
############################################################
##########################################################


New3W:=function(S1,S2)
	local V1,V2,i,i1,i2,j,s1,s2,L;
	L:=[];
	for i in Help(S1) do
	for j in Help(S2) do 
	V1:=ShallowList(VerticesOfFaces(S1));
	V2:=ShallowList(VerticesOfFaces(S2));
	RemoveElmList(V1,i);
	RemoveElmList(V2,j);
	s1:=SimplicialSurfaceByVerticesInFaces(V2);
	s2:=SimplicialSurfaceByVerticesInFaces(V1);
	return [s1,s2];
	for i1 in BoundaryEdges(s1) do
		for i2 in BoundaryEdges(s2) do
			Add(L,JoinBoundaries(s1,[i1,VerticesOfEdge(s1,i1)[1]],
					s2,[i2,VerticesOfEdge(s2,i2)[2]]));
		od;
	od;
	od;
	od;
	return L;
end;
