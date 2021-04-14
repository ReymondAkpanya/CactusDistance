LoadPackage("simpl");
Read("canon.g");
Read("old.g");
Read("VerticesInFacesHelp.g");
Read("BlockTypes.g");
Read("MultitetrahedralEmbedding.g");
Read("alg.g");
Read("Tetdecomp.g");
T:=SimplicialSurfaceByDownwardIncidence([[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]],
					[[4,5,6],[2,3,6],[1,3,5],[1,2,4]]);
O:=Octahedron();
DT:=SimplicialSurfaceByDownwardIncidence([[1,2],[1,3],[1,4],
					[5,2],[5,3],[5,4],
					[2,3],[3,4],[2,4]],
					[[1,2,7],[2,3,8],[1,3,9],,
					[4,5,7],[5,6,8],[4,6,9]]);
CactusSymbolSoFar:=[];
#--------------------------------------------------------------------------
CRemove:=function(L,i)
	local j,l,l2,l3,h,temp1,temp2,temp3,temp4,temp5;
	temp2:=ShallowCopy(L);
	j:=Minimum(List(temp2,g->Position(temp2,g)));
	temp3:=ShallowCopy(temp2);
	Remove(temp3,j);
	temp1:=[];
	while not(temp3=[]) do
		l3:=Minimum(List(temp3,g->Position(temp3,g)));
		l2:=Minimum(List(temp2,g->Position(temp2,g)));
		l:=l3+1-l2;
		Add(temp1,l);
		Remove(temp2,l2);
		Remove(temp3,l3);

	od;
	temp4:=[j];
	for h in temp1 do
		j:=j+h;
		Add(temp4,j);
	od;
	temp5:=[];
	for h in temp4 do
		if not(h=i) then
			temp5[h]:=L[h];
		fi;
	od;
	return temp5;
end;

Iso:=function(SSiso,L)
        local Simp;
        for Simp in L do
                if IsIsomorphic(Simp,SSiso) then
                        return true;
                fi;
        od;
        return false;
end;

try:=function(SStry)
        local V,copyV;
	copyV:=Filtered(ShallowCopy(Vertices(SStry)),V->FaceDegreeOfVertex(SStry,V)=3);
        if not(Iso(SStry,[T,DT])) then
		#Print("not");
                for V in copyV do
			#Print(copyV,"\n");
                        SStry:=RemoveTetra(SStry,V);
                od;
        fi;
        return SStry;
end;
#verticesoffaces 
#kann man flaechen mit 3 wait auch ohne flaechen mit 2-waist erzzeugen
#EdgeTurn als Gruppenoperation
IsCactus:=function(SSiscactus)
	local g;
	while not(SSiscactus=try(SSiscactus)) and Length(Set(Faces(SSiscactus))) >6 do
		SSiscactus:=try(SSiscactus);
	od;
	if not(IsIsomorphic(SSiscactus,T)) and  not(IsIsomorphic(SSiscactus,DT)) then 
		return false;
	else 
		return true;
	fi;
end;
#-------------------------------------
ShallowList:=function(L)
	local g;
	
	return ShallowCopy(List(L,g->ShallowCopy(g)));
end;
#----------------------------------------
P:=function(S,VS)
	if VS in VerticesOfEdges(S) then
		#Print("if");
		return Position(VerticesOfEdges(S),VS);
	else
		#Print("else");
		return Position(VerticesOfEdges(S),[VS[2],VS[1]]);
	fi;
end;

#---------------------------------------------------------------------
EdgeTurn:=function(SSedge,e)

	local EOF,VOE,VOEe,Edg1,Edg2,FOE,VOF, g;
	
	FOE:=FacesOfEdge(SSedge,e);
	if Length( Union(VerticesOfFace(SSedge,FOE[1]),VerticesOfFace(SSedge,FOE[2])))=4 then	
		Edg1:=Filtered(EdgesOfFace(SSedge,FacesOfEdge(SSedge,e)[1]),g->not(g=e));
		Edg2:=Filtered(EdgesOfFace(SSedge,FacesOfEdge(SSedge,e)[2]),g->not(g=e))	;
		VOF:=Union(VerticesOfFace(SSedge,FOE[1]),VerticesOfFace(SSedge,FOE[2]));
		VOE:=ShallowCopy(VerticesOfEdges(SSedge));
		VOEe:=Filtered(VOF,g-> not(g in VerticesOfEdge(SSedge,e)));
		VOE[e]:=VOEe;
		EOF:=ShallowCopy(EdgesOfFaces(SSedge));
		if Length(Intersection(VerticesOfEdge(SSedge,Edg1[1]),VerticesOfEdge(SSedge,Edg2[1])))>0 and 
		IsSubsetSet(VerticesOfEdge(SSedge,e),Intersection(VerticesOfEdge(SSedge,Edg1[1]),VerticesOfEdge(SSedge,Edg2[1]))) then
			EOF[FOE[1]]:=[e,Edg1[1],Edg2[1]];
			EOF[FOE[2]]:=[e,Edg1[2],Edg2[2]];
		else
			EOF[FOE[1]]:=[e,Edg1[2],Edg2[1]];
			EOF[FOE[2]]:=[e,Edg1[1],Edg2[2]];
		fi;
		return SimplicialSurfaceByDownwardIncidence(VOE,EOF);
	fi;
	return SSedge;
end;

#---------------------------------------------------------------------
#CactusDistance:=function(SScactusdistance)
#	local L,t,help1,help2;	
#	help1:=[];
#	L:=CactusDistanceOfSimplicialSurfaceHelp(SScactusdistance,0,[SScactusdistance],[0]);
#	for t in L[1] do
#		if IsCactus(t) then
#			Add(help1,[t,L[2][Position(L[1],t)]]);
#		fi;
#	od;
#return L;
#	return help1;
#end;


#CactusDistanceOfSimplicialSurfaceHelp:=function(SScdhelp,i,L1,L2)
#	local e,g,VOE,tempL;
#	for e in Edges(SScdhelp) do
#		VOE:=VerticesOfEdge(SScdhelp,e);
#		if not(Iso(EdgeTurn(SScdhelp,e),L1)) then
#			SScdhelp:=EdgeTurn(SScdhelp,e);
#			Add(L1,SScdhelp);
#			Add(L2,i+1);
#			tempL:=CactusDistanceOfSimplicialSurfaceHelp(SScdhelp,i+1,L1,L2);
#			for g in tempL[1] do
#				if not(Iso(g,L1)) then
#					Add(L1,g);
#					Add(L2,tempL[Position(L1,g)]);
#				fi;
#			od;
#		fi;
#	od;
#	return [L1,L2];
#end;  
#------------------------------------------------------------------
Tetra:=function(M)
	local ME,MF,V1,V2,V3,V4,copyM;
	copyM:=ShallowCopy(M);
	V1:=Minimum(copyM);
	V4:=Maximum(copyM);
	copyM:=CRemove(copyM,Position(copyM,V1));
	copyM:=CRemove(copyM,Position(copyM,V4));
	V2:=Minimum(copyM);
	V3:=Maximum(copyM);
	ME:=[[V1,V2],[V1,V3],[V1,V4],[V2,V3],[V2,V4],
	[V3,V4]];
	MF:=[[4,5,6],[2,3,6],[1,3,5],[1,2,4]];
	return SimplicialSurfaceByDownwardIncidence(ME,MF);
end;

AddTetraF:=function(SSaddtetraf,F)
	local T1,numbV;
	#VerticesOfFace(S,F);
	numbV:=Maximum(Vertices(SSaddtetraf));
	T1:=Union([numbV+1],ShallowCopy(VerticesOfFace(SSaddtetraf,F)));
	return AddTetra(SSaddtetraf,Tetra(T1));
end;

AddTetra:=function(SSaddtetra,T2)
	local VerticesEdges,EdgesFaces,n,g,L,M;
	VerticesEdges:=ShallowCopy(VerticesOfEdges(SSaddtetra));
	EdgesFaces:=ShallowCopy(EdgesOfFaces(SSaddtetra));
	n:=Length(VerticesEdges);
	L:=[[],[]];
	M:=[];
	for g in VerticesOfEdges(T2) do
		if not(g in VerticesEdges) then
			Add(VerticesEdges,g);
			Add(M,[Position(VerticesOfEdges(T2),g),g]);
		else
			Add(L[1],Position(VerticesOfEdges(SSaddtetra),g));
			Add(L[2],g);
		fi;
	od;
#	EdgesFaces:=CRemove(EdgesFaces,Position(EdgesFaces,Set(L[1])
#				));
	if Intersection(L[2][1],M[1][2])=[] then
		Add(EdgesFaces,[L[1][1],n+2,n+3]);
		Add(EdgesFaces,[L[1][2],n+1,n+2]);
		Add(EdgesFaces,[L[1][3],n+1,n+3]);
	fi;
	if Intersection(L[2][1],M[2][2])=[] then             
                Add(EdgesFaces,[L[1][1],n+1,n+3]);
                Add(EdgesFaces,[L[1][2],n+1,n+2]);
                Add(EdgesFaces,[L[1][3],n+2,n+3]);
	fi;
	if Intersection(L[2][1],M[3][2])=[] then             
                Add(EdgesFaces,[L[1][1],n+2,n+1]);
                Add(EdgesFaces,[L[1][2],n+1,n+3]);
                Add(EdgesFaces,[L[1][3],n+2,n+3]);
	fi;
	EdgesFaces:=CRemove(EdgesFaces,Position(EdgesFaces,Set(L[1])
                               ));
		
	return SimplicialSurfaceByDownwardIncidence(VerticesEdges,EdgesFaces);
end;

#------------------------------------
RemoveTetra:=function(SSremovetetra,V)
	local Ver,NewEdgFac,E1,E2,E3,NewVerEdg,NewVerEdg2,NewVerEdg3,
        NewEdgFac2,F,VF,i,NewEdgFac3,NewEdgFac4,NewEdg5,g,h,l;
	if Length(Set(Faces(SSremovetetra)))<=6 and
	not(IsIsomorphic(SSremovetetra,DT)) then
		return SSremovetetra;
	fi;
        if IsIsomorphic(SSremovetetra,T) then
	         return SSremovetetra;
	fi;
	#Print(EdgesOfFaces(SSremovetetra),"\n",VerticesOfEdges(SSremovetetra),"\n");
	NewEdgFac:=ShallowList(EdgesOfFaces(SSremovetetra));
	NewVerEdg:=ShallowList(EdgesOfFaces(SSremovetetra));
	if FaceDegreeOfVertex(SSremovetetra,V)=3 then
		F:=FacesOfVertex(SSremovetetra,V);
                NewEdgFac:=CRemove(NewEdgFac,Position(NewEdgFac,EdgesOfFace(SSremovetetra,F[1])));
                NewEdgFac:=CRemove(NewEdgFac,Position(NewEdgFac,EdgesOfFace(SSremovetetra,F[2])));
                NewEdgFac:=CRemove(NewEdgFac,Position(NewEdgFac,EdgesOfFace(SSremovetetra,F[3])));
                VF:=Union(VerticesOfFace(SSremovetetra,F[1]),VerticesOfFace(SSremovetetra,F[2]));
                Remove(VF,Position(VF,V));
E1:=Filtered(EdgesOfFace(SSremovetetra,F[1]),g->Set(VerticesOfEdge(SSremovetetra,g)) in [Set([VF[1],VF[2]]),Set([VF[1],VF[3]]),Set([VF[2],VF[3]])])[1];
E2:=Filtered(EdgesOfFace(SSremovetetra,F[2]),g->Set(VerticesOfEdge(SSremovetetra,g)) in [Set([VF[1],VF[2]]),Set([VF[1],VF[3]]),Set([VF[2],VF[3]])])[1];
E3:=Filtered(EdgesOfFace(SSremovetetra,F[3]),g->Set(VerticesOfEdge(SSremovetetra,g)) in [Set([VF[1],VF[2]]),Set([VF[1],VF[3]]),Set([VF[2],VF[3]])])[1];


#E2:=Filtered(EdgesOfFace(S,F[2]),g->VerticesOfEdge(S,g)=P(S,[VF[2],VF[3]]))[1];

#                E2:=P(S,[VF[2],VF[3]]);
 #               E3:=P(S,[VF[1],VF[3]]);
                Add(NewEdgFac,[E1,E2,E3]);
        

	NewVerEdg:=ShallowList(VerticesOfEdges(SSremovetetra));
	for g in EdgesOfVertex(SSremovetetra,V) do
		#NewVerEdg:=CRemove(NewVerEdg,Position(NewVerEdg,g));
		NewVerEdg:=CRemove(NewVerEdg,g);
	od;
	fi;
	return SimplicialSurfaceByDownwardIncidence(NewVerEdg,NewEdgFac);
#else
#return SSremovetetra;
#fi;
end;
#-----------------------------------------------------
AllSimplicialSurfacesWithTwoWaist:=function(n)
	local L,SSallsimp;
	if IsEvenInt(n) and n>1 then
		SSallsimp:=AllSimplicialSurfaces(EulerCharacteristic,2,
		NumberOfFaces,n,IsClosedSurface,true)[1];
		#L:=CactusDistanceOfSimplicialSurfaceHelp(SSallsimp,0,[SSallsimp],[0]);
		L:=EdgeTurnRek(SSallsimp);
		return L[1];
	else
		return false;
	fi;
end;
			
#--------------------------------------------------------
NameFacesAndVertices:=function(SSnamef,L)
	local Vertname,t,Facename,ValueF,x,tempF,tempV,temp1,temp2,g,h,
		newTetra,V,F,temp,temp3,temp4,i;
		V:=Vertices(SSnamef);
		F:=Faces(SSnamef);
		Vertname:=[];
		Facename:=[];
	if IsIsomorphic(SSnamef,T) then
		Vertname:=[[1,V[1]],[2,V[2]],[3,V[3]],[4,V[4]]];
		for F in Faces(SSnamef) do
			temp:=Filtered(Vertname,g->g[2] in VerticesOfFace(SSnamef,F));
			temp:=List(temp,g->g[1]);
			t:=Filtered([1,2,3,4],g->not(g in temp));
			Facename[t[1]]:=[t[1],F];
		od;
		L[1]:=[Facename];
		L[2]:=Vertname;
	else
		tempF:=[];
		for g in L[1] do
			for h in g do
				#temp:=List(g,h->h[2]);
				#tempF:=Union(tempF,temp);
				Add(tempF,h[2]);
			od;
		od;
		tempF:=Set(tempF);
		tempF:=Filtered(Faces(SSnamef),g->not(g in tempF));
	
		tempV:=List(L[2],g->g[2]);
		tempV:=Filtered(Vertices(SSnamef),g->not(g in tempV));

		temp:=[];
		for h in FacesOfVertex(SSnamef,tempV[1]) do
			temp:=Union(temp,ShallowCopy(VerticesOfFace(SSnamef,h)));
		od;
		CRemove(temp,Position(temp,tempV[1]));	
		temp1:=Filtered(L[2],g->g[2] in temp);
		temp2:=List(temp1,g->g[1]);
		t:=Filtered([[1,tempV[1]],[2,tempV[1]],
		[3,tempV[1]],[4,tempV[1]]],g->not(g[1] in temp2));
		Add(L[2],t[1]);
		for g in tempF do
			temp3:=Filtered(L[2],h->h[2] in VerticesOfFace(SSnamef,g));
			temp4:=List(temp3,h->h[1]);
			t:=Filtered([[1,g],[2,g],[3,g],[4,g]],
			h->not(h[1] in temp4));
			Add(Facename,t[1]);
		od;
		Add(L[1],Facename);
	fi;
	if not(IsIsomorphic(SSnamef,T)) then 
	for i in [1..Length(L[1])] do
		L[1][i]:=Filtered(L[1][i],g->g[2] in Faces(SSnamef));	
	od;
	fi;
	#return [tempF,tempV,temp,temp1];
	return L;
end;
########################################################
########################################################
#########################################################
AllSym2:=function(i,L)
	local L1,g,h;
	L1:=[];
	#L:=List(AllSym(i-1),g->ConstructSurfaceBySymbol(g,[1,2,3,4]));
	for g in L do
		for h in Help(g) do 
			Add(L1,AddTetraF(g,h));
		od;
	od;
	return IsomorphismRepresentatives(L1);
end;
############################################################
###########################################################
#----------------------------------------------------------------------
NeighbourVertices:=function(SSneighbour,V)
	local F,temp,g;
	F:=FacesOfVertex(SSneighbour,V);
	temp:=[];
	for g in F do 
		temp:=Union(temp,ShallowCopy(VerticesOfFace(SSneighbour,g)));
	od;
	return Filtered(temp,g->not(g=V));
end;
#-------------------------------------------------------
ConstructSurfaceBySymbol:=function(CacSym,M)
	local g,h,Cac,Cac1,Cac2,help,L,Pos,LT2,LT3,gl,nvert,T,M1,M2,M3,M4,ME,MF;
	#Cac:=Tetra(M);\	
	#Construct Tetra with Faces M1,M2,M3,M4
	M1:=Minimum(M);
	M4:=Maximum(M);
	Remove(M,Position(M,M1));
	Remove(M,Position(M,M4));
	M2:=Minimum(M);
	M3:=Maximum(M);
	ME:=[[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]];
        MF:=[];
	MF[M4]:=[1,2,4];
	MF[M3]:=[1,3,5];
	MF[M1]:=[4,5,6];
	MF[M2]:=[2,3,6];
	Cac2:=SimplicialSurfaceByDownwardIncidence(ME,MF);
	#Cac1:=SimplicialSurfaceByDownwardIncidence(ME,MF);
	LT2:=[[[1,M1],[2,M2],[3,M3],[4,M4]]];
	LT3:=[[[[1,M1],[2,M2],[3,M3],[4,M4]]],[[1,1],[2,2],[3,3],[4,4]]];
	nvert:=5;
	for gl in CacSym do
		help:=Filtered(LT3[1][gl[1]], h->h[1]=gl[2]);
		Pos:=Position(LT3[1][gl[1]],help[1]);
		Cac2:=AddTetraF(Cac2,LT3[1][gl[1]][Pos][2]);
		LT3:=NameFacesAndVertices(Cac2,LT3);
	od;
	#return [Cac,LT2,Cac1,LT3];
#	return [LT3,Cac2];
	return Cac2;
end;
#----------------------------------------------------------------------
khelp:=function(L,k)
	local L1,i;
	L1:=L;
	for i in [1..Length(L)] do
		Append(L1[i],k);
	od; 
	return L1;
end;
khelp1:=function(L1,L)
	local i,t,t1,j;
	t:=L1;
	t1:=[];
	for i in [1..Length(t)] do
		for j in L do 
			Append(t1,khelp(t,j));
		od;
	od; 
	return t1;
end;
kprod:=function(L,n)
	local temp,t1,j,t,i,k;
	temp:=List(L,g->[g]);
	t:=List(L,g->[]);
	t1:=t;
	for j in [1..n] do
		k:=Length(t1);
		#for j in [1..k] 
		t1:=t;
	od; 
end;
GetSymbolHelp:=function(SSgetsymh)
	local g,CS,SurfList,Numbv,F,V;
	SurfList:=[];
	CS:=[];
	Numbv:=[];
	if IsCactus(SSgetsymh) then
		while(not(SSgetsymh=try(SSgetsymh))) do 
			Add(SurfList,SSgetsymh);
			Add(Numbv,
			Length(Filtered(Vertices(SSgetsymh),
			V->FaceDegreeOfVertex(SSgetsymh,V)=3)));
			SSgetsymh:=try(SSgetsymh);	
		od;
		Add(SurfList,SSgetsymh);
		Add(Numbv,0);
	fi;	
	return [SurfList,CS,Numbv];
end;
#Anderes abspeichern fuer kakteen 
#DrawSurfacetothreed
GetSymbol:=function(SSgetsym)
	local L,helpL,hilf,hilf1,hilf2,hilf3,hilf4,hilf5,
	CS,F,hL,tempSurf,newhelp,tr,it,Surf,t1,t2,t,V,
	SSS,l,V3,VF1,VF2, trip, num,kp,kpfac,g,bool,new,Fac;
	L:=GetSymbolHelp(SSgetsym);
	Surf:=L[1][Length(L[1])];
	#Print(L);
	newhelp:=[];
	CS:=[];
	hL:=[];
	helpL:=[];
	new:=[];
	if IsIsomorphic(Surf,T) then
		F:=Faces(Surf);
		helpL:=NameFacesAndVertices(Surf,[[],[]]);
		new:=[];	
	fi;
	if IsIsomorphic(Surf,DT) then
		#Print("in");
		V:=Vertices(Surf);
		V3:=Filtered(Vertices(Surf),g->FaceDegreeOfVertex(Surf,g)=3);
		VF1:=FacesOfVertex(Surf,V3[1]);
		VF2:=FacesOfVertex(Surf,V3[2]);
		V:=Filtered(Vertices(Surf),g->not(FaceDegreeOfVertex(Surf,g)=3));
		hilf:=[[1,V3[1]],[2,V[1]],[3,V[2]],[4,V[3]],[1,V3[2]]];
		helpL[2]:=hilf;
		hilf4:=[];
		hilf:=[];
		for F in VF1 do
			#hilf1:=VerticesOfFace(Surf,F);
			hilf1:=List(VerticesOfFace(Surf,F),g->Filtered(helpL[2],
			h->h[2]=g));
			hilf2:=List(hilf1,g->g[1][1]);
			#Print("hilf2 ",hilf2,"\n");
			hilf3:=Filtered([1,2,3,4],g->not(g in hilf2));
			Add(hilf4,[hilf3[1],F]);
		od;
		hilf[1]:=hilf4;
		hilf5:=[];
		   for F in VF2 do
                        #hilf1:=VerticesOfFace(Surf,F);
                        hilf1:=List(VerticesOfFace(Surf,F),g->Filtered(helpL[2],
                        h->h[2]=g));
                        hilf2:=List(hilf1,g->g[1][1]);
                        #Print("hilf2 ",hilf2,"\n");
                        hilf3:=Filtered([1,2,3,4],g->not(g in hilf2));
                        Add(hilf5,[hilf3[1],F]);
                od;
		hilf[2]:=hilf5;

		#Print("hilf ",hilf,"\n");
		helpL[1]:=hilf;
		#helpL:=[[[[4,VF1[1]],[2,VF1[2]],[3,VF1[3]]],
		#[[4,VF2[1]],[2,VF2[2]],[3,VF2[3]]]],
		#[[1,V[1]],[2,V[2]],[3,V[3]],[4,V[4]],[5,V[5]]]];
		#Print(VerticesOfFaces(Surf));
		new:=[[1,1]];
		#Print(helpL);
		#return [VF1,hilf2,helpL];
	fi;
#	Print(L[3]);
	#Print(helpL);
	for it in [1..Length( L[3])-1] do
		bool:=false;
		num:=L[3][Length(L[3])-it];
		SSS:=L[1][Length(L[1])-it+1];
		#old Fac:=ShallowCopy(Faces(Surf));
		Fac:=ShallowCopy(Faces(Surf));
		kpfac:=Combinations(Fac,num);
		bool:=false;
		#Print(IsIsomorphic(SSS,DT));
		for trip in kpfac do
			tempSurf:=Surf;
			#Print(IsIsomorphic(tempSurf,DT));
			#Print(trip);
			if not(bool) then
			#Print("aaaaaaaaaaaaaaaaaaaaa");
			for l in [1..num] do
				tempSurf:=AddTetraF(tempSurf,trip[l]);
				#Print(trip ,IsIsomorphic(tempSurf,L[1][Length(L[1])-it]),"\n");
			od;
			fi;
			#Print("beginning ",helpL,"\n");
			#Print(IsIsomorphic(tempSurf,L[1][Length(L[1])-it]));
			if IsIsomorphic(tempSurf,L[1][Length(L[1])-it]) and not(bool) then
				#Print("Iso ", trip, "\n");
				bool:=true;
				for tr in trip do
					t1:=Filtered(helpL[1],g->not(
					Intersection([[1,tr],[2,tr],[3,tr],[4,tr]],g)=[]));
					t2:=Filtered(t1[1],g->tr=g[2]);	
					Add(new,[Position(helpL[1],t1[1]),t2[1][1]]);
					Surf:=AddTetraF(Surf,tr);
					helpL:=NameFacesAndVertices(Surf,helpL);
					#Print(tr," ",helpL,"\n","new ",new,"\n");
				od;
			fi;
		od;
		bool:=false;
	od;
	#return [new, tempSurf];
	return new;

end;
Tetrahedralnumber:=function(SStetnum)
	local tempS,Tetnum;
	tempS:=SStetnum;
	Tetnum:=[];
	if IsCactus(SStetnum) then
		while not(tempS=try(tempS)) and not(IsIsomorphic(tempS,T))  do
			Add(Tetnum,
	Length(Filtered(Vertices(tempS),g->FaceDegreeOfVertex(SStetnum,g)=3)));
			tempS:=try(tempS);
		od;
		if IsIsomorphic(tempS,T) then 
			Add(Tetnum,1);
		fi;
		if IsIsomorphic(tempS,DT) then
			Add(Tetnum,2);
		fi;
	fi;
	return Tetnum;
end;

Butter:=function(SSbutter,E)
	local temp,F,um,V;
	
	V:=Intersection(VerticesOfEdge(SSbutter,E[1]),VerticesOfEdge(SSbutter,E[2]))[1];
	um:=UmbrellaPathOfVertex(SSbutter,V);
	um:=FacesAsList(um);
	F:=FacesOfEdge(SSbutter,E[1])[1];
	temp:=[F];
	F:=Filtered(um, g->g in NeighbourFacesOfFace(SSbutter,F)
	and  not(E[1] in EdgesOfFace(SSbutter,g)))[1];
	Add(temp,F);
	#Print(um," ",F," ",temp,"\n");
	while not(F in FacesOfEdge(SSbutter,E[2])) and not(F in temp) do
		Add(temp,F);
		F:=Filtered(um, g->g in NeighbourFacesOfFace(SSbutter,F)
		and  not(E[2] in EdgesOfFace(SSbutter,g)))[1];

	od;
	#F:=Filtered( um,g-> g in NeighbourFacesOfFace( S, F ) 
	#and  E[2] in EdgesOfFace( S, g ) and not(E[1] in EdgesOfFace(S,g)))[1];
	#Add(temp,F);
	return temp; 
 
end;
ButterflyInsertion:=function(SSbutterfly,E)
	local VE,EF,temp1,V,nv,ne,um,ef,g,h,f,bool,i,j,temp,ButtVE;
	ne:=Length(Edges(SSbutterfly));
	nv:=Length(Vertices(SSbutterfly));
	VE:=ShallowList(VerticesOfEdges(SSbutterfly));
	EF:=ShallowList(EdgesOfFaces(SSbutterfly));
	V:=Intersection(VE[E[1]],VE[E[2]])[1];
	um:=UmbrellaPathOfVertex(SSbutterfly,V);
	um:=FacesAsList;
	E:=Set(E);
	bool:=false;
	for ef in EF do
		if IsSubset(ef,E) then
			bool:=true;
			f:=Position(EF,ef);
		fi;
	od;
	if bool then 
		for i in [1,2] do
			temp:=[];
				for j in [1,2] do
					if VE[E[i]][j]=V then
						temp[j]:=nv+1;
					else
						temp[j]:=VE[E[i]][j];
					fi;
				od;
				Add(VE,temp);
		od;

		VE[ne+3]:=[V,nv+1];
		for i in [1,2,3] do
			if EF[f][i]=E[1] then
				EF[f][i]:=ne+1;
			fi;
			if EF[f][i]=E[2] then
				EF[f][i]:=ne+2;
			fi;	
		od;
		Add(EF,[E[1],ne+1,ne+3]);
		Add(EF,[E[2],ne+2,ne+3]);
		#return [VE];
		return SimplicialSurfaceByDownwardIncidence(VE,EF);
	else
		#Print("elseeeeeeeeeeeee");
		temp:=[];
		for i in Butter(SSbutterfly,E) do
			temp:=Union(temp,EF[i]);
		od;
		temp1:=Set(temp);
		ButtVE:=Filtered([1..Length(VE)],i->i in temp1 and V in VE[i]);
		for i in E do
                        temp:=[];
                        for j in [1,2] do
				if VE[i][j]=V then
                                        temp[j]:=nv+1;
                                else
                                        temp[j]:=VE[i][j];
                                fi;
                        od;
                        Add(VE,temp);
                od;
		for i in Filtered(ButtVE,g->not(g in E)) do
			for j in [1,2] do
                                if VE[i][j]=V then
                                        VE[i][j]:=nv+1;
                                else
                                        VE[i][j]:=VE[i][j];
                                fi;
                        od;			
		od;
		for i in Butter(SSbutterfly,E) do
			for j in [1,2,3] do
				if EF[i][j] in E then
					#Print("i ",i," j ",j," Eij ",EF[i][j],"\n");
					EF[i][j]:=ne+Position(E,EF[i][j]);
				fi;
			od;
		od;
		Add(VE,[V,nv+1]);
		Add(EF,[E[1],ne+1,ne+3]);
		Add(EF,[E[2],ne+2,ne+3]);
		return SimplicialSurfaceByDownwardIncidence(VE,EF);
	fi;
		
end;


ButterflyEdges:=function(SSbedges)
	local L,g,h;
	L:=[];
	for g in Edges(SSbedges) do
		for h in Edges(SSbedges) do
			if Length(Intersection(VerticesOfEdge(SSbedges,g),
						VerticesOfEdge(SSbedges,h)))=1 then
				Add(L,Set([g,h]));
			fi;
		od;
	od; 

	return Set(L);
end;


EdgeTurnRek:=function(SSedgerek)
	local Simprek,K,L,g;
	SSedgerek:=CanonicalRepresentativeOfPolygonalSurface2(SSedgerek)[1];
	K:=[[SSedgerek],[0]];
	#L:=[];
	K:=EdgeTurnRekHelp(SSedgerek,[[SSedgerek],[0]],0);
	
	return K;
end;
###############################
#################################
EdgeTurnRek1:=function(SSedgerek)
        local Simprek,K,L,g;
        SSedgerek:=CanonicalRepresentativeOfPolygonalSurface2(SSedgerek)[1];
        #K:=[SSedgerek];
        #L:=[];
        K:=EdgeTurnRekHelp1(SSedgerek,[SSedgerek]);

        return K;
end;
helpedge:=function(S)
	local L,o,G,g,h;
	G:=AutomorphismGroupOnEdges(S);
	o:=Orbits(G,Edges(S));
	L:=Filtered(List(o,g->g[1]),h->checkbufl(S,h));
	return Filtered(L, g-> not(3 in
	[FaceDegreesOfVertices(S)[VerticesOfEdge(S,g)[1]],FaceDegreesOfVertices(S)[VerticesOfEdge(S,g)[2]]]));
end;
bufl:=function()
 return SimplicialSurfaceByVerticesInFaces([[1,2,3],[2,3,4]]);
end;
 checkbufl:=function(S,e)
 local sS;
 if not (e in InnerEdges(S)) then Error("not inner");fi;
 sS:=FacesOfEdge(S,e);
 sS:=SubcomplexByFaces(S,sS);
 return IsIsomorphic(bufl(),sS);
end;
no2waist:=function(S)
	local L,g;
	L:=List(VerticesOfEdges(S),g->Set(g));
	if Length(L)=Length(Set(L)) then 
		return true;
	else
		return false;
	fi;
end;
EdgeTurnRekHelp1:=function(SSedgerekh,K)
        local T,g,L;
        for g in helpedge(SSedgerekh) do
               #Print("a","\n"); 
                T:=turnedge(SSedgerekh,g)[1];
                #T:=turnedge(SSedgerekh,g)[1];
                T:=CanonicalRepresentativeOfPolygonalSurface2(T)[1];
                if not(T in K) and no2waist(T) then
                        Add(K,T);
           #             Add(K[2],i+1);
                        K:=EdgeTurnRekHelp1(T,K);
                fi;
#                if T in K[1] and K[2][Position(K[1],T)]>i+1 then
#           K[2][Position(K[1],T)]:=i+1;
#                fi;
        od;
        return K;
end;

#######################################
######################################
EdgeTurnRekHelp:=function(SSedgerekh,K,i)
	local S,g,L;
	for g in Edges(SSedgerekh) do 
		S:=EdgeTurn(SSedgerekh,g);
		#T:=turnedge(SSedgerekh,g)[1];
		S:=CanonicalRepresentativeOfPolygonalSurface2(S)[1];
		if not(S in K[1]) and no2waist(S) then 
			Add(K[1],S);
			Add(K[2],i+1);
			K:=EdgeTurnRekHelp(S,K,i+1);
		fi;
		if S in K[1] and K[2][Position(K[1],S)]>i+1 then 
			K[2][Position(K[1],S)]:=i+1;
		fi;
	od;
	return K;
end;
turnedge:=function(S,e)
 local sS,sB,v,ee;
	sB:=SubcomplexByFaces(S,FacesOfEdge(S,e));
	ee:=Difference(Edges(sB),[e]);
	v:=Intersection(VerticesOfEdge(sB,ee[1]),VerticesOfEdge(S,e))[1];
	sS:=Difference(Faces(S),FacesOfEdge(S,e));
	sS:=SubcomplexByFaces(S,sS);
return JoinBoundaries(sS,[v,ee[1]],sB,[Difference(VerticesOfEdge(sB,ee[1]),[v])[1],ee[1]]);
end;


CactusDistance:=function(SScactus)
	if IsCactus(SScactus) then 
		return 0;
	else
	 Minimum(EdgeTurnRek(SScactus)[2]);
	fi;
	return EdgeTurnRek(SScactus);

end;

CrossProduct:=function(A,B)
	local CP;
	CP:=[A[2]*B[3]-A[3]*B[2],
		A[3]*B[1]-A[1]*B[3],
		A[1]*B[2]-A[2]*B[1]];
	return 1/Sqrt(CP[1]*CP[1]+CP[2]*CP[2]+CP[3]*CP[3])*CP;
end;
N:=function(V)
return Sqrt(V[1]*V[1]+V[2]*V[2]+V[3]*V[3]);
end;
#GetVert:=function(SSgetvert,Lgetvert,A,B,C)
#	local M,MAB,MBC,hl,RA,RC,VV1,VV2,VV3,t,RV,H,i;
	#for i in [1,2,3] do
#		A[i]:=Float(A[i]);
#		B[i]:=Float(B[i]);
#		C[i]:=Float(C[i]);
#	od;
#	MAB:=A+1/2*(B-A);
#	MBC:=B+1/2*(C-B);
#	RA:=A-MBC;
#	RC:=C-MAB;
#	t:=SolutionMat([RA,(-1)*RC],MAB-MBC);
#	M:=MBC+t[1]*RA;	
#	H:=CrossProduct(B-A,C-A);
#	hl:=Sqrt((B-A)*(B-A)-N(M-A)*N(M-A));
#	if M+hl*H in Lgetvert then 
#		return M-hl*H;
#	else
##		return M+hl*H;
#	fi;
#end;


#DrawCactusToJavaFile:=function(SSdraw,html)
#
#	local VC,V,i,help,SSdra,Nd,len,Fd,Vd,height,printRecord,vertvisited,PH;
#	height:=0.;
#	VC:=[];	
##	#SSdra:=SimplicialSurfaceByDownwardIncidence(VerticesOfEdges(SSdraw),Set(EdgesOfFaces(SSdraw)));
#	PH:=GetSymbolHelp(SSdra)[1];
#	if IsIsomorphic(PH[Length(PH)],T) then
#		Vd:=Vertices(PH[Length(PH)]);
#		VC[Vd[1]]:=[0.,0.,0.];
#		VC[Vd[2]]:=[1.,0.,0.];
#		VC[Vd[3]]:=[1/2.,0.,Sqrt(3/4.)];
#		VC[Vd[4]]:=GetVert(PH[Length(PH)],VC,[0.,0.,0.],[1.,0.,0.],[1/2.,0.,Sqrt(3/4.)]);
#	else
#		Vd:=Filtered(Vertices(PH[Length(PH)]),g->not(FaceDegreeOfVertex(PH[Length(PH)],g)=3));
#		VC[Vd[1]]:=[0.,0.,0.];
#		VC[Vd[2]]:=[1.,0.,0.];
#		VC[Vd[3]]:=[1/2.,0.,Sqrt(3/4.)];
#		Vd:=Filtered(Vertices(PH[Length(PH)]),g->FaceDegreeOfVertex(PH[Length(PH)],g)=3);
#		VC[Vd[1]]:=GetVert(PH[Length(PH)],VC,[0.,0.,0.],[1.,0.,0.],[1/2.,0.,Sqrt(3/4.)]);
#		VC[Vd[2]]:=GetVert(PH[Length(PH)],VC,[0.,0.,0.],[1.,0.,0.],[1/2.,0.,Sqrt(3/4.)]);
#	fi;
#	for i in [1..Length(PH)-1] do
#		len:=Length(PH)-i+1;
#		Vd:=Filtered(Vertices(PH[len-1]),g->not(g in Vertices(PH[len])) );
#		for V in Vd do
#			Nd:=NeighbourVertices(PH[len-1],V);
#			VC[V]:=GetVert(PH[len],VC,Nd[1],Nd[2],Nd[3]);
#		od;
#	od; 
#	printRecord:=SetVertexCoordiantes3D(SSdra,VC,rec());
#	DrawSurfaceToJavaScript(SSdra,html,printRecord);
#	return [VC,printRecord];
#end;
#

#DrawCactusToJavaFileByCactusSymbol:=function(CCdraw,html)
#	local SSdra,VC,g,i,t,tem;
#	SSdra:=T;
#	VC:=[];
#	VC[1]:=[0.,0.,0.];
#	VC[2]:=[1.,0.,0.];
#	VC[3]:=[1/2.,0.,Sqrt(3/4.)];
#	VC[4]:=GetVert(SSdra,VC,[0.,0.,0.],[1.,0.,0.],[1/2.,0.,Sqrt(3/4.)]);
#	for i in [1..Length(CCdraw)] do
#		t:=List([1..i],g->CCdraw[g]);
#		SSdra:=ConstructSurfaceBySymbol(t,[1,2,3,4]);
#		tem:=Filtered(Vertices(SSdra),
#		V-#>not(Intersection([Set([i+4,V]),Set([V,i+4])],VerticesOfEdges(SSdra))=[]));
#		VC[i+4]:=GetVert(SSdra,VC,VC[tem[1]],VC[tem[2]],VC[tem[3]]);
#	Print(tem);
#	od;
#	#DrawCactusToJavaFile(SSdraw1,html);
#	Print(VC);
#	return VC;
#end;

Is3WaistFree:=function(Sdj)
	local n,e1,e2,e3,Ed,V1,V2,V3,F1,F2,F3;
	Ed:=Edges(Sdj);
	n:=Length(Ed);
	for e1 in [1..n] do
		for e2 in [e1+1..n] do
			for e3 in [e2+1..n] do
				V1:=VerticesOfEdge(Sdj,e1);
				V2:=VerticesOfEdge(Sdj,e2);
				V3:=VerticesOfEdge(Sdj,e3);
				F1:=FacesOfEdge(Sdj,e1);
				F2:=FacesOfEdge(Sdj,e2);
				F3:=FacesOfEdge(Sdj,e3);
					if Length(Union(V1,V2,V3))=3 and Length(Union(F1,F2,F3))=Length(F1)+Length(F2)+Length(F3) then
					if not(Set(V1)=Set(V2)) and not(Set(V1)=Set(V3)) and not(Set(V2)=Set(V3)) then
						return false;
					fi;
					fi;
			od;
		od;
	od;
	return true;
end;

#Create3Waist:=function(ssw1,ssw2,face,edge)
#	local Vertfix,Edgefix,copy1,copy2,g,temp,Map,h,ES1,ES2,VS1,VS2,Vlen,
#	i,j,Elen,NewE,NewV,tempVE,tempEF,temp1,temp2,F1,F2,SSw1,SSw2;
#	temp1:=EdgesOfFace(ssw1,face[1]);
#	temp2:=EdgesOfFace(ssw2,face[2]);
#	SSw1:=SimplicialSurfaceByDownwardIncidence(VerticesOfEdges(ssw1),Set(EdgesOfFaces(ssw1)));
	#SSw2:=SimplicialSurfaceByDownwardIncidence(VerticesOfEdges(ssw2),Set(EdgesOfFaces(ssw2)));
#	F1:=Position(EdgesOfFaces(SSw1),temp1);
#	F2:=Position(EdgesOfFaces(SSw2),temp2);
##	face:=[F1,F2];
#	Elen:=Maximum(Edges(SSw1));
#	Vlen:=Maximum(Vertices(SSw1));
#	ES1:=CRemove(ShallowList(EdgesOfFaces(SSw1)),face[1]);
#	ES2:=ShallowList(EdgesOfFaces(SSw2));
#	VS1:=ShallowList(VerticesOfEdges(SSw1));
#	VS2:=ShallowList(VerticesOfEdges(SSw2));
#	Vertfix:=VerticesOfFace(SSw2,face[2]);
#	Edgefix:=EdgesOfFace(SSw2,face[2]);
#	temp:=[Filtered(VerticesOfFace(SSw1,face[1]),g->not(g in VerticesOfEdge(SSw1,edge[1])))[1],Filtered(VerticesOfFace(SSw2,face[2]),g->not(g in VerticesOfEdge(SSw2,edge[2])))[1]];
#	Map:=[[edge],[[VerticesOfEdge(SSw1,edge[1])[1],VerticesOfEdge(SSw2,edge[2])[1]],[VerticesOfEdge(SSw1,edge[1])[2],VerticesOfEdge(SSw2,edge[2])[2]],temp]];
#	temp:=[Filtered(EdgesOfFace(SSw1,face[1]),g->not(g=edge[1]) and Map[2][1][1] in VerticesOfEdge(SSw1,g))[1],
#	Filtered(EdgesOfFace(SSw2,face[2]),g->not(g=edge[2]) and Map[2][1][2] in VerticesOfEdge(SSw2,g))[1]];
#	Map[1][2]:=temp;
#	temp:=[Filtered(EdgesOfFace(SSw1,face[1]),g->not(g=edge[1]) and Map[2][2][1] in VerticesOfEdge(SSw1,g))[1],
#	Filtered(EdgesOfFace(SSw2,face[2]),g->not(g=edge[2]) and Map[2][2][2] in VerticesOfEdge(SSw2,g))[1]];
#	Map[1][3]:=temp;
#	tempEF:=ES1;
#	for i in Faces(SSw2) do
#		temp:=[];
#		for j in [1,2,3] do
#			if not(ES2[i][j] in Edgefix) and not(i=face[2]) then
#				ES2[i][j]:=ES2[i][j]+Elen;
#				temp[j]:=ES2[i][j];
#			else
#				if ES2[i][j]=Map[1][1][2] then
#					ES2[i][j]:=Map[1][1][1];
#					temp[j]:=Map[1][1][1];
#				elif ES2[i][j]=Map[1][2][2] then
#					ES2[i][j]:=Map[1][2][1];
#					temp[j]:=Map[1][2][1];
#				elif ES2[i][j]=Map[1][3][2] then
#					ES2[i][j]:=Map[1][3][1];
#					temp[j]:=Map[1][3][1];
##				fi;
#			fi;
#		od;
#		tempEF[i+Maximum(Faces(SSw1))]:=ES2[i];
#	od;
#	tempVE:=VS1;
#	for i in Edges(SSw2) do
#		for j in [1,2] do
#			if not(VS2[i][j] in Vertfix) and not(i in Edgefix) then
#				VS2[i][j]:=VS2[i][j]+Vlen;
#			else
#				if VS2[i][j]=Map[2][1][2] then
#					VS2[i][j]:=Map[2][1][1];
#				elif VS2[i][j]=Map[2][2][2] then
#					VS2[i][j]:=Map[2][2][1];
#				elif VS2[i][j]=Map[2][3][2] then
#					VS2[i][j]:=Map[2][3][1];
#				fi;
#			fi;
#		od;
#		tempVE[i+Maximum(Edges(SSw1))]:=VS2[i];
#	od;
#
#	tempVE:=CRemove(tempVE,Maximum(Edges(SSw1))+Edgefix[1]);
#	tempVE:=CRemove(tempVE,Maximum(Edges(SSw1))+Edgefix[2]);
#	tempVE:=CRemove(tempVE,Maximum(Edges(SSw1))+Edgefix[3]);
#	tempEF:=CRemove(tempEF,Maximum(Faces(SSw1))+face[2]);
#	return SimplicialSurfaceByDownwardIncidence(tempVE,tempEF);
#end;

AllSimplicialSurfacesWith3Waist:=function(i)
	local LS,L3W,g;
	LS:=AllSimplicialSurfaces(i,IsClosedSurface,EulerCharacteristic,2);

	if i=6 then 
		L3W:=EdgeTurnRek(DT)[1];
	else
		L3W:=WanderRek(LS[1])[1];
	fi;
	L3W:=Filtered(L3W,g->not( Is3WaistFree(g)));
	return L3W;
	#return Filtered(L3W,g->VerticesOfEdges(g)=Set(VerticesOfEdges(g)));

end;
ConvertToInt:=function(L)
	local k, g,i,h,z;
	z:=0;
	i:=1;
	for k in L do 
	for g in k do
		for h in g do
			z:=z+i*h;
		i:=i*10;
		od;
	od;
	od;
	return z;
end;
ConvertToSurface:=function(z,p)
	local l,L,L1,x,g;
	l:=(p-4)/2;
	L:=[];
	while z>=1 do
		L1:=[];
		for x in [1..l] do
			#L1[l-x]:=[];
			g:=[];
			#for j in [1,2] do
			g[1]:=(z mod 10);
			z:=(z -(z mod 10))/10;
			g[2]:=(z mod 10);
                        z:=(z -(z mod 10))/10;
	
			#od;
			L1[x]:=g;
		od;
		Add(L,L1);
	od;
	return L;
end;
Is2WaistFree:=function(SSW2)
	if Length(Set(VerticesOfEdges(SSW2)))=Length(VerticesOfEdges(SSW2)) then
		return true;
	else
		return false;
	fi;
end;
Help:=function(SShelp)
	local Orb,Aut,g;
	Aut:=AutomorphismGroupOnFaces(SShelp);
	Orb:=Orbits(Aut,Faces(SShelp));
	return List(Orb,g->g[1]);
end;

#################################################
#######################try
###########
symdif:=function(A,B)
return Difference(Union(A,B),Intersection(A,B));
end;

addtetra:=function(S,f)
	local L1,L2,t;
	t:=Combinations(Union(VerticesOfFace(S,f),[Length(Vertices(S))+1]),3);	
	return SimplicialSurfaceByVerticesInFaces( symdif(VerticesOfFaces(S),t) );
end;

HCactus:=function(i,L)
	local g,h,L1;
	L1:=[];
	for g in L do
		for h in Help(g) do
			Add(L1,addtetra(g,h));
		od;
	od;
	#L1:=Filtered(L1,g->IsEmbeddible(g));

	return IsomorphismRepresentatives(L1);
end;

#HC1:=function(i,L)
#	local L1,g;
#	L1:=HCactus(i,L);
#	return Filtered(L1,g->IsEmbeddible(g));
#end;
#3wh:=function(X,Y)
#	local VX,VY,Vert;
#	VX:=VerticesOfFaces(X);
#	VY:=VerticesOFFaces(Y);
#	for i in Help(X) do 
#		for j in Help(Y) do
#			Remove(VX,i);
#			Remove(VX,j);
#		od;
#	od; 
#	return SimplicialByVerticesInFaces(Vert);	
#end;

Doublengon:=function(n)
	local V,i;
	V:=[[1,2,n+1],[n+2,2,n+1]];
	for i in [2..n] do
		Add(V,[1,i,i+1]);
		Add(V,[n+2,i,i+1]);
	od;
	return SimplicialSurfaceByVerticesInFaces(V);
end;
ComputeCactus:=function(L,k,l)
	local s,h,L1,i;
	L1:=[];
	for i in [k..l] do
		s:=SimplicialSurfaceByVerticesInFaces(L[i]);
		for h in Help(s) do
			Add(L1,addtetra(s,h));
		od;
	od;

	return IsomorphismRepresentatives(L1);

	
end;

newcactusdistance:=function(S)
	local temp,edg,i,comb;
	edg:=Edges(S);
	Print("newS\n");
	if IsCactus(S) then
		return 0;
	fi;
	for i in [1..Length(Edges(S))] do
		Print(i,"\n"); 
		temp:=Combinations(Edges(S),i);
		tempS:=S;
		for comb in temp do 
			tempS:=S;
			for j in comb do 
				tempS:=EdgeTurn(tempS,j);
			od;
			if IsCactus(tempS) then
				return Length(comb);
			fi;
		od; 
	od;
end;

##########################################################################
##########################################################################
EdgeTurnRek2:=function(SSedgerek)
        local Simprek,K,L,g;
        SSedgerek:=CanonicalRepresentativeOfPolygonalSurface2(SSedgerek)[1];
        #K:=[SSedgerek];
        #L:=[];
        K:=EdgeTurnRekHelp2(SSedgerek,[SSedgerek]);

        return K;
end;
EdgeTurnRekHelp2:=function(SSedgerekh,K)
        local T,g,L;
        for g in helpedge(SSedgerekh) do
                T:=turnedge(SSedgerekh,g)[1];
		if not Iso(T,AllSimplicialSpheres(NumberOfFaces(T))) then
                T:=CanonicalRepresentativeOfPolygonalSurface2(T)[1];
                if not(T in K) and no2waist(T) then
                        Add(K,T);
                        K:=EdgeTurnRekHelp2(T,K);
                fi;
		fi;
#                if T in K[1] and K[2][Position(K[1],T)]>i+1 then
#           K[2][Position(K[1],T)]:=i+1;
#                fi;
        od;
        return K;
end;
MapVert:=function(S,image)
	local vert,v,V,l,L,n;
	n:=Maximum(Vertices(S));
	L:=[];
	for V in VerticesOfFaces(S) do
		l:=[]; 
		for v in V do 
			if v=image[1][1] then 
				Add(l,image[1][2]);
			elif v=image[2][1] then 
				Add(l,image[2][2]);
			elif v=image[3][1] then 
				Add(l,image[3][2]);
			else 
				Add(l,25+v);
			fi;
					
		od;
		Add(L,Set(l));
	od;
	return L;	 
end;

C3W:=function(S1,S2)
	local f1,f2,V1,V2,m1,m2,m3,V,L,M1,M2,M3;
	L:=[];
#	Print(Help(S1)," ",Help(S2));
	for f1 in Help(S1) do
		for f2 in Help(S2) do
			V1:=VerticesOfFace(S1,f1);
			V2:=VerticesOfFace(S2,f2);	
			m1:=MapVert(S1,[[V1[1],V2[1]],[V1[2],V2[2]],[V1[3],V2[3]]]);
			m2:=MapVert(S1,[[V1[1],V2[2]],[V1[2],V2[3]],[V1[3],V2[1]]]);
			m3:=MapVert(S1,[[V1[1],V2[3]],[V1[2],V2[1]],[V1[3],V2[2]]]);
			V:=VerticesOfFaces(S2);				
			M1:=symdif(m1,V);
			M2:=symdif(m2,V);
			M3:=symdif(m3,V);
			Add(L,SimplicialSurfaceByVerticesInFaces(M1));
			Add(L,SimplicialSurfaceByVerticesInFaces(M2));
			Add(L,SimplicialSurfaceByVerticesInFaces(M3));
		od;
	od;
	return IsomorphismRepresentatives(L);
	#return L;
end;

C3W1:=function(i,j)
	local L1,L2,s1,s2,L;
	L:=[];
	L1:=AllSimplicialSpheres(i);
	L2:=AllSimplicialSpheres(j);
	for s1 in L1 do
		for s2 in L2 do
			Append(L,C3W(s1,s2));
		od;
	od;
	#return IsomorphismRepresentatives(L);
	return L;
end;
correctvert:=function(S)
	local L,l,f,g,h,new,temp,v;
	temp:=[];
	new:=[];
	v:=List(Vertices(S),g->[g,Position(Vertices(S),g)]);
	for g in VerticesOfFaces(S) do
		temp:=[];
		for h in g do 
			Add(temp,Filtered(v,f -> f[1]=h)[1][2]);
		od;
		Add(new, temp);
	od;
	return new;
	
end;
Findtuple:=function(t)
	local i;
	for i in [1..Length(VerticesInFacesHelp)] do 
		if Set(VerticesInFacesHelp[i])=Set(t) then 
			return i;
		fi;
	od;
end;
correctvert1:=function(S)
	local L,l,f,g,h,new,temp,v;
	temp:=[];
	new:=[];
	v:=List(Vertices(S),g->[g,Position(Vertices(S),g)]);
	for g in VerticesOfFaces(S) do
		temp:=[];
		for h in g do 
			Add(temp,Filtered(v,f -> f[1]=h)[1][2]);
		od;
		Add(new, Findtuple(temp));
	od;
	return new;
	
end;
C3W2:=function(L1,L2)
	local s1,s2,t;
	L:=[];
 #       L1:=AllSimplicialSpheres(i);
#        L2:=AllSimplicialSpheres(j);
	t:=1;
        for s1 in L1 do
                for s2 in L2 do
                        Append(L,C3W(s1,s2));
                od;
	Print(t,"\n");
	t:=t+1;
        od;
        #return IsomorphismRepresentatives(L);
        return L;

end;
write:=function(L,file)
	local s;
#	AppendTo(file,"L:=[","\n");
	for s in L do
#		if not( Position(L,s)=Length(L)) then
		AppendTo(file,correctvert(s),",","\n");

	od;
#		AppendTo(file,VerticesOfFaces(s),"];","\n");
end;
writeagain:=function(L,file)
	local g,h,temp;
	for g in L do 
		temp:=[];
		for h in g do 
			Add(temp,Position(VerticesInFacesHelp,h));
		od;
		AppendTo(file,temp,",","\n");
	od;
end;
Compute3W:=function(L,k,l)
	local s,h,L1,i;
	L1:=[];
	for i in [k..l] do
		#s:=SimplicialSurfaceByVerticesInFaces(L[i]);
		for h in Help(L[i]) do
			Add(L1,addtetra(L[i],h));
		od;
	od;
	Print("nur noch iso\n");
	return L1;

	
end;


Comp3Waist:=function(k,list)
	local g,h,L,l;
	l:=[];
	L:=[];
	for g in AllSimplicialSpheres(k) do
		for h in list do
			Append(L,C3W(g,h));		
		od;
	od;
	return L;
end;


Compare:=function(L,VC,file)
	local sum,g,t,temp,h,tempL,L1,sum1;
	tempL:=[];
	t:=1;
	L1:=L;
	sum:=0;
	sum1:=0;
	#templ:=[];
	for g in VC do
		Print("t=",t,"\n");
		#if not Set(VCCostum(g)) in templ then
		tempL:=Filtered(L1,h->Set(VCCostum(h))=Set(g));
		Difference(L1,tempL);
		Print("tempL ist ",Length(tempL),"\n");
		temp:=List(tempL,g->SimplicialSurfaceByVerticesInFaces(g));		
		temp:=IsomorphismRepresentatives(temp);
		write(temp,file);
		Print(sum," ",sum1, " t=",t," Laenge=",Length(temp),"\n");		
		sum:=sum+Length(temp);
		sum1:=sum1+Length(tempL);
		#fi;
		t:=t+1;
	od;  
	return t;
end;
Compare2:=function(L,VL,VC,file)
	local sum,g,t,temp,h,tempL,L1,sum1;
	tempL:=[];
	t:=1;
	L1:=[1..Length(L)];
	sum:=0;
	sum1:=0;
	Print(Length(L)," ",Length(VL)," ",Length(L1),"\n");
	#templ:=[];
	for g in VC do
		Print("t=",t,"\n");
		tempL:=Filtered(L1,h->Set(VL[h])=Set(g));
		Print("nur noch ",Length(L1)," betrachten","\n");
		#Difference(L1,tempL);
		L1:=Filtered(L1,g ->not g in tempL);
		Print("tempL ist ",Length(tempL),"\n");
		tempL:=List(tempL,h->L[h]);
		temp:=List(tempL,g->SimplicialSurfaceByVerticesInFaces(List(g,h->VerticesInFacesHelp[h])));		
		temp:=IsomorphismRepresentatives(temp);
		write(temp,file);
		Print(sum," ",sum1, " t=",t," Laenge=",Length(temp),"\n");		
		sum:=sum+Length(temp);
		sum1:=sum1+Length(tempL);
		#fi;
		t:=t+1;
	od;  
	return t;
end;

VCCostum:=function(L)
	local temp,vert,g,h,vc,tempL;
	vert:=Union(L);
	vc:=List([1..Maximum(vert)],g->0);
	for g in L do 
		for h in g do
			vc[h]:=vc[h]+1;
		od;
	od;
	tempL:=[];
	for g in Set(vc) do 
		temp:=Filtered(vc,h->h=g);
		Add(tempL,[g,Length(temp)]);
	od;	
	return Filtered(tempL,g->not g[1]=0) ; 	
end;



keinbock:=function(l,file)
	local i,temp;
	for i in [1..Length(l)] do
		Print("i=",i,"\n");
		temp:=SimplicialSurfaceByVerticesInFaces(l[i]);
		write(C3W(temp,T),file);
		i:=i+1;
	od;
end;
kb:=function(l,file)
	local temp,i,g,sum;
	i:=0;
	sum:=0;
	while 500*(i+1)<Length(l) do
		Print([1+500*i .. (i+1)*500],"\n");
		temp:=List([1+500*i .. (i+1)*500],g->SimplicialSurfaceByVerticesInFaces(l[g]));
		Print(Length(temp)," auf isomorphie untersuchen\n");
		temp:=C3W2(temp,[T]);
		Print(Length(temp)," neue flaechen\n");
		temp:=IsomorphismRepresentatives(temp);
	write(temp,file);
	i:=i+1;
	sum:=sum+Length(temp);
	Print(sum," endwhile\n");
	od;
	Print([1+500*i .. Length(l)],"\n");
	Print("last","\n");
	temp:=List([1+500*i..Length(l)],g->SimplicialSurfaceByVerticesInFaces(g));
	temp:=C3W2(temp,[T]);
	temp:=IsomorphismRepresentatives(temp);
	write(temp,file);
end;

BBH1:=function(S)
	local g,temp,h,comb,VOF,e1,e2,e3,b,f,tempS;
	VOF:=ShallowCopy(VerticesOfFaces(S));
	comb:=Combinations(Vertices(S),3);
	comb:=Filtered(comb,g->not Filtered(VOF,h->Length(Intersection(g,h))>1)=[]);
	comb:=Difference(comb,VOF);
	g:=Filtered(comb,g->IsSubset(NeighbourVerticesOfVertex(S,g[1]),[g[2],g[3]]) and 
			IsSubset(NeighbourVerticesOfVertex(S,g[2]),[g[1],g[3]]));
	#Print("g=",g,"\n","comb=",comb,"\n");
	if g=[] then 
		return S;
	else
		g:=g[1];
		e1:=Position(VerticesOfEdges(S),Set([g[1],g[2]]));
		#e2:=Position(VerticesOfEdges(S),Set([g[3],g[2]]));
		#e3:=Position(VerticesOfEdges(S),Set([g[1],g[3]]));	 
		tempS:=CraterCut(S,e1);
	#	Print("VOF ",VerticesOfFaces(tempS),"\n");
		b:=BoundaryVertices(tempS);
		temp:=Cartesian(EdgesOfVertex(tempS,b[1]),EdgesOfVertex(tempS,b[2]));
		e2:=Filtered(temp,h->Intersection(VerticesOfEdge(tempS,h[1]),VerticesOfEdge(tempS,h[2]))=Difference(g,b));
	#	Print(e2,"\n");
		tempS:=RipCut(tempS,e2[1][1]);
	#	Print("VOF ",VerticesOfFaces(tempS),"\n");
		e3:=SplitCuttableEdges(tempS)[1];
	#	Print(SplitCuttableEdges(tempS),"\n");		
		tempS:=SplitCut(tempS,e3);
	#	Print("VOF ",VerticesOfFaces(tempS),"\n");		
		b:=BoundaryVertices(tempS);			
	f:=Union([b[1]],Filtered(b,h-> h in NeighbourVerticesOfVertex(tempS,b[1])) );
		VOF:=ShallowCopy(VerticesOfFaces(tempS));		
		Add(VOF,f);
		Add(VOF,Difference(b,f));
		return SimplicialSurfaceByVerticesInFaces(Set(VOF));
	fi;	
end;

BBH2:=function(S)
	local temps,tempS;
	tempS:=S;
	#temps:=BBH1(tempS);
	while not IsIsomorphic(tempS,BBH1(tempS)) do 
	#	Print("begin while\n");	
		tempS:=BBH1(tempS);
	od;
	return tempS;
end;

BlockTyp:=function(S)
	local L;
	sum:=1;
	S1:=BBH2(S);
	tempFac:=[Faces(S1)[1]];
	Fac:=ShallowCopy(Faces(S1));
	L:=[];
	while Fac<>[] do 
	#Print("blocktyp \n");
		temp:=List(tempFac,g->NeighbourFacesOfFace(S1,g));
		temp:=Union(temp);		
		if Difference(temp,tempFac)<>[] then
			Append(tempFac,temp);
			sum:=sum+Length(temp);
			
		else
			Add(L,sum);
			Fac:=Difference(Fac,tempFac);	
			if Length(Fac)>0 then 	
				tempFac:=[Fac[1]];
			fi;
			sum:=1;		
		fi; 
	od;
	temp:=List([4,8,10,12,14,16,18,20,22,24,26,28],g->[g,0]);
	for g in L do 
		t:=Filtered(temp,h->h[1]=g)[1];
		temp[Position(temp,t)][2]:=temp[Position(temp,t)][2]+1;
	od; 
	temp:=Filtered(temp,g->g[2]<>0);
	return temp;
end;

Divide:=function(L)
	local g,err,s;
	temp:=List([1..33],g->Concatenation("ThisisHelpfile",String(g),".g"));	
	err:=[];
	j:=1;
	for g in L do 
		s:=SimplicialSurfaceByVerticesInFaces(g);
		i:=Filtered(BlockTypes,h->Set(h)=Set(BlockTyp(s)));
		if Length(i)=1 then 
			write([s],temp[i]);
			Print("Bisher ",Length(err)," fehler","\n");
		else 
			Add(err,s); 
		fi;
		Print("bisher ",j,"bearbeitet\n");
		j:=j+1;
	od;
	
	return temp; 
end;

tempemb:=function(L1,L2,VL2,file)
local g,vof,nvof,temp1,temp2,tempL,t,v,lenV,maybeemb,nL2,h;
	nL2:=[1..Length(L2)];
	i:=0;
	j:=1;
	for nvof in L1 do
		maybeemb:=true;
		Print(j,"\n");
		temp:=List(nvof,n->VerticesInFacesHelp[n]);
		lenV:=Maximum(Union(temp));
		v:=Filtered([1..lenV],v->Length(Filtered(temp,vof->v in vof))=3)[1];
		
		#for v in vert do 
		t:=Filtered(temp,vof->v in vof);
		temp1:=Difference(temp,t);
		t:=Difference(Union(t),[v]);
		Add(temp1,t);	
		tempL:=Filtered(nL2,h->Set(VL2[h])=Set(VCCostum(temp1)));
		#Difference(L1,tempL);
		Print("tempL ist ",Length(tempL),"\n");
		tempL:=List(tempL,g->L2[g]);
		tempL:=List(tempL,g->List(g,h->VerticesInFacesHelp[h]));
		Add(tempL,temp1);
		tempL:=List(tempL,g->SimplicialSurfaceByVerticesInFaces(g));		
		temp2:=IsomorphismRepresentatives(tempL);
		Print(Length(temp2)," und ",Length(tempL),"\n");
		if  Length(temp2)=Length(tempL) then 
			maybeemb:=false;
		fi;
			
		#od;
		if maybeemb then 
			AppendTo(file,nvof,",","\n");
			Print("sum= ",i,"\n");
			i:=i+1;
		fi;
		j:=j+1;
	od;
end;


tempemb1:=function(L1,L2,VL2,file)
local g,vof,nvof,temp1,temp2,tempL,t,v,lenV,maybeemb,nL2,h;
	nL2:=[1..Length(L2)];
	i:=0;
	j:=1;
	for nvof in L1 do
		maybeemb:=true;
		Print(j,"\n");
		temp:=List(nvof,n->VerticesInFacesHelp[n]);
		lenV:=Maximum(Union(temp));
		v:=Filtered([1..lenV],v->Length(Filtered(temp,vof->v in vof))=3)[1];
		
		#for v in vert do 
		t:=Filtered(temp,vof->v in vof);
		temp1:=Difference(temp,t);
		t:=Difference(Union(t),[v]);
		Add(temp1,t);	
		tempL:=Filtered(nL2,h->Set(VL2[h])=Set(VCCostum(temp1)));
		#Difference(L1,tempL);
		Print("tempL ist ",Length(tempL),"\n");
		tempL:=List(tempL,g->L2[g]);
		tempL:=List(tempL,g->List(g,h->VerticesInFacesHelp[h]));
		Add(tempL,temp1);
		tempL:=List(tempL,g->SimplicialSurfaceByVerticesInFaces(g));		
		temp2:=IsomorphismRepresentatives(tempL);
		Print(Length(temp2)," und ",Length(tempL),"\n");
		if  Length(temp2)=Length(tempL) then 
			maybeemb:=false;
		else
			tempS:=SimplicialSurfaceByVerticesInFaces(temp);
			if IsE1(tempS,v) then
				AppendTo(file,nvof,",","\n");
				Print("sum= ",i,"\n");
				i:=i+1;
 			fi;
				
		fi;	
		j:=j+1;
	od;
end;



IsTurnableEdge:=function(S,e)
	local g,voe;
	voe:=VerticesOfEdge(S,e);
	for g in Edges(S) do
		if g <> e and Set(VerticesOfEdge(S,g))=Set(voe)  then
			return false;
		fi;
	od;
	return true;
end;


testeigenvalue:=function(S)
	local sum, g,temp,Coor;
	Coor:=testCoorMul(S);
	#Coor:=Coor[2];
	sum:=0;
	temp:=[];
	for g in Coor do 
		sum:=sum+g;
	od;
	for g in [1..Length(Coor)] do 
		temp[g]:=Coor[g]-sum;
	od;
	temp:=temp*TransposedMat(temp);
	return [temp, Eigenvalues(Rationals,temp),Length(Eigenvectors(Rationals,temp))];
end;

