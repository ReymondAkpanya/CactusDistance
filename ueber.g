MinimalCover:=function(S)
	local fac,Aut,VertDeg3,g,ueb;
	Aut:=AutomorphismGroupOnFaces(S);
	VertDeg3:=Filtered(Vertices(S),g->FaceDegreeOfVertex(S,g)=3);
	fac:=Filtered(Faces(S),g->not(Intersection(VerticesOfFace(S,g),VertDeg3)=[]));
	ueb:=Combinations(fac,Length(VertDeg3));
	ueb:=Filtered(ueb,g->
Length(List(g,h->Intersection(VerticesOfFace(S,h),VertDeg3)[1]))
=Length(Set(List(g,h->Intersection(VerticesOfFace(S,h),VertDeg3)[1])))
);
	return List(Orbits(Aut,ueb,OnSets),g->g[1]);
end;

ueber:=function(S)
	local fac,Aut,mu,n,l,VertDeg3,temp,g,com,beg,ueb,UEB,limit;
	UEB:=[];
	mu:=MinimalCover(S);
	n:=Length(mu[1]);
	#Print(n,"\n");
	if NumberOfFaces(S)+2*n<=28 then
		beg:=Maximum((24-2*n-NumberOfFaces(S))/2,0);
		limit:=Maximum((28-NumberOfFaces(S)-2*n)/2,0);
		Aut:=AutomorphismGroupOnFaces(S);
		VertDeg3:=Filtered(Vertices(S),g->FaceDegreeOfVertex(S,g)=3);
		for l in [beg..limit] do
			com:=Combinations(Faces(S),l);
			temp:=Cartesian(mu,com);
			ueb:=List(temp,g->Union(g[1],g[2]));
			ueb:=List(ueb,g->Set(g));
			ueb:=Filtered(ueb,g->Length(g)=n+l);
			Append(UEB,List(Orbits(Aut,ueb,OnSets),g->g[1]));
		od;
	fi;
	return UEB;
end;

HasChildren:=function(S)
	local v;
	v:=Filtered(Vertices(S),g->FaceDegreeOfVertex(S,g)=3);
	if NumberOfFaces(S)+2*Length(v)<28 then
		return true;
	else
		return false;
	fi;
end;

cchelp:=function(s,L)
	local g,s1,h,L1;
	L1:=[];
	Print("hier\n");
	for g in L do 
		s1:=s;
		for h in g do 
			s1:=addtetra(s1,h);
		od;
		Add(L1,s1);
	od;
	return L1;
end;
ComputeChildren:=function(L)
	local s,L1,u,g;
	L1:=Filtered(L,g->HasChildren(g));
		#if HasChildren(s) then
		#	u:=ueber(s);	 
		#fi;
	#od; 
	return Union(List(L1,g->cchelp(g,ueber(g))));
end;


HasChildren2:=function(S)
        local v;
        v:=Filtered(Vertices(S),g->FaceDegreeOfVertex(S,g)=3);
        if NumberOfFaces(S)+2*Length(v)<=28  then
                return true;
        else
                return false;
        fi;
end;

Schreib:=function(L)
	local l;
	for l in L do 
		if NumberOfFaces(l)=24 then 
			AppendTo("Cactus24Faces.g",VerticesOfFaces(l),",","\n");
		elif NumberOfFaces(l)=26 then 
			AppendTo("Cactus26Faces.g",VerticesOfFaces(l),",","\n");
	        elif NumberOfFaces(l)=28 then 
		        AppendTo("Cactus28Faces.g",VerticesOfFaces(l),",","\n");
		fi;
	od;
	
end;


