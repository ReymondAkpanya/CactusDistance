Read("canon.g");

#-----------------------
	# function tests for an given surface S, whether there is a Two- or
	#Three-Waist by using the pseudoWaistTest (searching for
	# Vertices with FaceDegre 2 or 3)
	#returns true if there are no waists, flase if there are.
	
HasNoWaist:=function(S)
	local g,D;
	D:=FaceDegreesOfVertices(S);
	if 2 in D or 3 in D then
		return false;
	fi;
	return true;
end;
	
	#--------------------------------
	#input: an simplicial surface S
	#output: a set of all (F,f) whereby F is a Face and f is an edge and
	#WanderingHole can be performed with (F,f)
	
H:=function(S)
	local K,g,f,M,F,i,j,VOF,VOE;
	K:=[];
	M:=[];
	for F in Faces(S) do #searches for all pairs (F,f) where F and f share one Vertex
		VOF:=VerticesOfFace(S,F);
		for f in Edges(S) do
			VOE:=VerticesOfEdge(S,f);
			if VOE[1] in VOF and not(VOE[2] in VOF) then
				Add(K,[F,f]);
			fi;
			if VOE[2] in VOF and not(VOE[1] in VOF) then
				Add(K,[F,f]);
			fi;
		od;
	od;
	for g in K do #picking only the pairs where the edge f and the edges of F share one face
		for i in [1,2,3] do
			for j in [1,2] do
				if FacesOfEdge(S,g[2])[j] in
					FacesOfEdge(S,EdgesOfFace(S,g[1])[i]) then
					Add(M,g);
				fi;
			od;
		od;
	od;
	return Set( M);
	end;
	#------------------------------------------------------------------
	#input: a simplicial surface S,List L where by L[1] is a face and L[2} is
	#an edge
	#output : a simplicial surface with an hole where F was placed
	
Hole:=function(S,L)
	S:=CraterCut(S,EdgesOfFace(S,L[1])[1]);
	S:=RipCut(S,EdgesOfFace(S,L[1])[1]);
	S:=SplitCut(S,EdgesOfFace(S,L[1])[1]);
	return S;
end;
	
	#---------------------------------------------------------------------------
	#input: a siplicial surface S , List L wherby L[1] is a face and L[2] is
	#an edge
	# output : retunrs a simplicial surface after letting the hole wander
WanderingHole:=function(S,L)
	local M,temp, g,h,a,rm;
	#Print("Start");
	if(not(IsClosedSurface(S))) then
		return "Surface must be closed";
	fi;
	if not(IsTriangularComplex(S)) then
		return "S must be a triangular Complex";
	fi;
	if Length(Faces(S))<3 then
		return "S must be a triangular Complex";
	fi;
	if not(Length(L)=2) then
		return "List L must consist of a Face and an Edge";
	fi;
	if not(L[1] in Faces(S)) then
		return "L[1] must be a face of S";
	fi;
	if not(L[2] in Edges(S)) then
		return "L[2] must be an edge of S";
	fi;
	if not(L in H(S)) then
		return "[F,f] must be in set H(S)";
	fi;
	#-------------Schritt 1 Loch an der Stelle F
	S:=Hole(S,L);
	
	for g in BoundaryEdges(S) do
		if FacesOfEdge(S,g)[1] in FacesOfEdge(S,L[2]) then
			a:=g;
		fi;
	od;
	S:=RipCut(S,L[2]);
	rm:=[];
	M:=[Edges(S)[Length(Edges(S))],Edges(S)[Length(Edges(S))-1]];
	for g in BoundaryEdges(S) do
		if [a,g] in RipMendableEdgePairs(S) and not( g in M) then
			rm:=[a,g]; fi;
			if [g,a] in RipMendableEdgePairs(S) and not(g in M) then
			rm:=[g,a];
		fi;
	od;
	
	S:=RipMend(S,rm);
	
	S:=SplitMend(S,SplitMendableFlagPairs(S)[1]);
	temp:=true;
	for h in RipMendableEdgePairs(S) do
		if h[1] in EdgesOfFace(S,L[1]) and not(h[2] in EdgesOfFace(S,L[1])) and temp then
			S:=RipMend(S,h);
			temp:=false;
		fi;
	od;
	S:=CraterMend(S,CraterMendableEdgePairs(S)[2]);
	return S;
end;
	
	#----------------------------------------------
	#function needed for WanderRek, returns a List of all simplicial surface
	#surfaces which can be created by performing a wandering hole
	
WanderRekHelp:=function(S,K,i)
	local g,T,a,L;
	for g in H(S) do
		a:=true;
		T:=WanderingHole(S,g);
		T := CanonicalRepresentativeOfPolygonalSurface2(T)[1];
	if not T in K[1] then
	Add(K[1],T);
	Add(K[2],i+1);
	K:=WanderRekHelp(T,K,i+1);
	fi;
	if T in K[1] and  Position(K[2],T)>i+1 then 
		K[2][Position(K[1],T)]:=i+1;
	fi;
	od;
	return K;
	end;
	
	#--------------------------------------
	#returns a list of all surfaces which can be created by performing the
	#wandering hole
	
	WanderRek:=function(S)
	local K,L,g;
	S := CanonicalRepresentativeOfPolygonalSurface2(S)[1];
	K:=[[S],[0]];
	L:=[];
	K:=WanderRekHelp(S,[[S],[0]],0);
	for g in K do
 #collecting only the surfaces which have no waists
	#if HasNoWaist(g) then
	Add(L,g);
	#fi;
	od;
	return L;
	end;


