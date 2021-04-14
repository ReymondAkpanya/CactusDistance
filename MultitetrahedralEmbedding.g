crossp:=function(A,B)
	return [A[2]*B[3]-A[3]*B[2],
		A[3]*B[1]-A[1]*B[3],
		A[1]*B[2]-A[2]*B[1]
];
end;
len:=function(A)
	return Sqrt(A[1]^2+A[2]^2+A[3]^2);
end;
newvert:=function(A,B,C)
	local m,n;
	m:=A+1/3*(B-A)+1/3*(C-A);
	n:=crossp(B-A,C-A);
	n:=1/len(n)*n;
	n:=4/Sqrt(3.)*n;
	return [m+n,m-n];
end;
gleich:=function(x,L)
	local g;
	for g in L do 
		if len(x-g)<0.1 then 
			return true;
		fi;	
	od;
	return false;
end;
CoorMul:=function(S)
	local s,k,l,coor,v,new,sym,g,h;
	sym:=GetSymbol(S);
	l:=[];
	coor:=[[1.,1.,-1.],[-1.,-1.,-1.],[-1.,1.,1.],[1.,-1.,1.]]; 
	s:=T;
	l:=NameFacesAndVertices(T,l);
	for g in sym do
		k:=Filtered(l[1][g[1]],h->h[1]=g[2]);
		v:=VerticesOfFace(s,k[1][2]);
		new:=newvert(coor[v[1]],coor[v[2]],coor[v[3]]);
		if gleich(new[1],coor) then 
			Add(coor,new[2]);
		else
			Add(coor,new[1]);
		fi;
		s:=AddTetraF(s,k[1][2]);
		l:=NameFacesAndVertices(s,l);

	od;
	#Print(VerticesOfFaces(s),"\n");
	return [s,coor]; 
end;

testCoorMul:=function(S)
	local s,k,l,coor,v,new,sym,g,h;
	sym:=GetSymbol(S);
	l:=[];
	coor:=[[1,1,-1],[-1,-1,-1],[-1,1,1],[1,-1,1]]; 
	s:=T;
	l:=NameFacesAndVertices(T,l);
	for g in sym do
		k:=Filtered(l[1][g[1]],h->h[1]=g[2]);
		v:=VerticesOfFace(s,k[1][2]);
		new:=testnewvert(coor[v[1]],coor[v[2]],coor[v[3]]);
		if testgleich(new[1],coor) then 
			Add(coor,new[2]);
		else
			Add(coor,new[1]);
		fi;
		s:=AddTetraF(s,k[1][2]);
		l:=NameFacesAndVertices(s,l);

	od;
	#Print(VerticesOfFaces(s),"\n");
	return coor; 
end;
testnewvert:=function(A,B,C)
	local m,n;
	m:=A+1/3*(B-A)+1/3*(C-A);
	n:=crossp(B-A,C-A);
	n:=1/len(n)*n;
	n:=4/Sqrt(3)*n;
	return [m+n,m-n];
end;
testgleich:=function(x,L)
	local g;
	for g in L do 
		if len(x-g)<1/10 then 
			return true;
		fi;	
	od;
	return false;
end;
U:=function(S,L)
	local sum,h;
	sum:=[];	
	for g in L do
		for h in NeighbourVerticesOfVertex(S,g) do
			Add(sum,Set([g,h]));
		od;
	od;
	return Set(sum);
end;	 
	
IsEmb:=function(S)
	local L,s,c,k,v,vof,g,voe,VOE,sol,A,AB,AC,D,DE;
	L:=CoorMul(S);
	s:=L[1];
	c:=L[2];
	v:=Filtered(Vertices(s),g->FaceDegreeOfVertex(s,g)=3);
	VOF:=Filtered(VerticesOfFaces(s),g->Intersection(g,v)=[]);
	for vof in VOF do
		
		for voe in U(s,v) do		
#		VOE:=Filtered(VerticesOfEdges(s),g->Intersection(vof,g)=[]);
		#for voe in VOE do
			A:=c[vof[1]];
			AB:=c[vof[2]]-c[vof[1]];
			AC:=c[vof[3]]-c[vof[1]];
			D:=c[voe[1]];
			DE:=c[voe[2]]-c[voe[1]];
			sol:=SolutionMat([RatV(AB),RatV(AC),RatV(-DE)],RatV(D-A));	
			if sol[1]>0 and sol[2]>0 and sol[3]>0 and sol[1]+sol[2]<=1 and sol[3]<1 then 
				
				return false;
			fi;	
		od;
	od;
	return true;
end;
#IsEmb:=function(S)
#	local g,c,L,i,j,sol,nv,P,A,B,C,s;
#	L:=CoorMul(S);
##	s:=L[1];
#	c:=L[2];
#	while not(IsIsomorphic(s,T)) and not(IsIsomorphic(s,DT)) do
#		
#		L:=Filtered(Vertices(s),g->FaceDegreeOfVertex(s,g)=3);		
#		for i in L do
#			nv:=NeighbourVerticesOfVertex(s,i);
#			A:=(c[i]-c[nv[1]]);
#			B:=c[i]-c[nv[2]];
#			C:=c[i]-c[nv[3]];
#
#			for j in Filtered([1..Length(Vertices(s))],g->not(g in L)) do
#				P:=c[j];
#				sol:=SolutionMat([RatV(A),RatV(B),RatV(C)],RatV((P-c[i])));	
#				if sol[1]>0 and sol[1]<1 and sol[2]>0 and sol[2]<1 and sol[3]>0 and sol[3]<1 then 
					#Print("sol=",sol,"\n","c=",c,"\n","nv=",nv,"\n","[i,j]=",[i,j],"\n");
#					return false;
#				fi;
#			od;
#			
#		od;
#		s:=RemoveTetra(s,i);
#	od; 
#	return true;
#end;
RatV:=function(V)
	return [Rat(V[1]),Rat(V[2]),Rat(V[3])];
end;

#IsEmbeddible:=function(S)
#	local s,l,coor,v,Mat,new,sym,g,k,h,tet,temp;
#	sym:=GetSymbol(S);
#	Print(sym,"\n");
#	l:=[];
#	coor:=[[1.,1.,-1.],[-1.,-1.,-1.],[-1.,1.,1.],[1.,-1.,1.]]; 
#	s:=T;
#	l:=NameFacesAndVertices(T,l);
#	tet:=[[1,2,3,4]];
#	for g in sym do
#		Print("------------------------------","\n");
 ###               k:=Filtered(l[1][g[1]],h->h[1]=g[2]);
#		v:=VerticesOfFace(s,k[1][2]);
##		temp:=Union([Length(Vertices(s))],v);
###		Add(tet,temp);
#		Print("coor=",coor,"\n");
#		new:=newvert(coor[v[1]],coor[v[2]],coor[v[3]]);
#		Print("new=",new,"\n");
#		if gleich(new[1],coor) then 
#			Add(coor,new[2]);
#		else
#			Add(coor,new[1]);
#		fi;
##		temp:=Union([Length(Vertices(s))+1],v);
# #               Add(tet,temp);
#
##		s:=AddTetraF(s,k[1][2]);
##		l:=NameFacesAndVertices(s,l);
#		if help(coor,tet,v) = false then
#			P#rint("l=",l,"\n","coor=",coor,"\n","tet=",tet,"\n","Vertex=",v,"\n");		
#			return false;
#		fi;
#		temp:=Union([Length(Vertices(s))+1],v);
 #               Add(tet,temp);
  #              s:=AddTetraF(s,k[1][2]);
   #             l:=NameFacesAndVertices(s,l);
##
#	od;
#	
#	return true;
#end;
#gr:=function(a)
#	if a[1]<0 or a[2] <0 or a[3] <0 then 
#		return false;
#	elif a[1]>1 or a[2]>1 or a[3]>1 then 
#		return false; 
#	else return true;
#	fi;
#end;
help:=function(c,t,V)
	local i,j,AB,AC,sol,AD,P,PV;
	P:=Length(c);
	Print("This is help","\n");
	for i in t do
		AB:=c[i[2]]-c[i[1]];
		AC:=c[i[3]]-c[i[1]];
		AD:=c[i[3]]-c[i[1]];
		for j in V do
			PV:=c[j]-c[P];
			sol:=SolutionMat([AB,AC,-PV],c[P]-c[i[1]]);	
			if sol=fail or (sol[1]>0. and sol[1]<1. and sol[2]>0. and sol[2]<1.) then 
				 return false;
			fi;
		od;	
	od;
	return true;
end;
#Embhelp:=function(S,c,t,V)
#	local i,f,A,B,C,l,sol;
#	Print("coor=",c,"\n");
#	help(c,t,V)
#	for i in t do 
#		AB:=;
#		AC:=;
#		m:=c[Length(c)]-c[]
#		A:=c[i[2]]-c[i[1]];
#		B:=c[i[3]]-c[i[1]];
#		C:=c[i[4]]-c[i[1]];
#		D:=c[Length(c)]-c[i[1]];
#		sol:=SolutionMat([A,B,C],D);
#		Print("Solve ",[A,B,C],"=",D,"\n");
#		Print("Solution ",sol,"\n");
#		for l in sol do 
#			if 0. > l and  l>1. then 
#				return false;
#			fi;
#		od;
#	od;
#	f:=Filtered(VerticesOfFaces(S),g-> not(c[Length(c)] in g));
#	for g in f do 
#		if (4/Sqrt(3.))*crossp(c[g[1]],c[g[2]])+c[Length(c)]=g[1]+1/3*(g[2]-g[1])+1/3*(g[3]-g[1]) then
#			 return false;
#		elif (4/Sqrt(3.))*crossp(c[g[1]],c[g[2]])+c[Length(c)]=g[1]+1/3*(g[2]-g[1])+1/3*(g[3]-g[1]) then
#			return false;
#		fi;
#	od;
#	return true;	
#end;

ds:=function(S,file)
	local c,s;
	c:=CoorMul(S);
	s:=c[1];
	s:=SimplicialSurfaceByVerticesInFaces(Set(VerticesOfFaces(s)));
	pr:=SetVertexCoordiantes3D(s,c[2],rec());
	DrawSurfaceToJavaScript(s,file,pr);
end;

IsE:=function(S)
	local temp, voe,voeD,voeE,voeDE,sym,vof,vofA,vofB,vofC,vofAC,vofAB,tempS,sol,coordinates,tempvof;
	#sym:=GetSymbol(S);
	#tempS:=ConstructSurfaceBySymbol(sym,[1,2,3,4]);
	tempS:=S;	
	temp:=CoorMul(tempS);	
	coordinates:=temp[2];
	tempS:=temp[1];
	#Print(VerticesOfFaces(tempS),"ise\n");
	for voe in VerticesOfEdges(tempS) do
		tempvof:=Filtered(VerticesOfFaces(tempS),g->Intersection(voe,g)=[]);
		for vof in tempvof do 
			vofA:=coordinates[vof[1]];
			vofB:=coordinates[vof[2]];
			vofC:=coordinates[vof[3]];
			voeD:=coordinates[voe[1]];
			voeE:=coordinates[voe[2]];
			vofAB:=vofB-vofA;
			vofAC:=vofC-vofA;;
			voeDE:=voeE-voeD;;
			sol:=SolutionMat([vofAB,vofAC,-voeDE],voeD-vofA);	
			if not sol=fail then 
				if (sol[1]>0. and sol[1]<1.) and (sol[2]>0. and
 sol[2]<1.) and (sol[3]>0. and sol[3]<1.) and sol[1]+sol[2]<=1. and sol[1]+sol[2]>0. then 
#				Print(voe," ",vof,"\n");
#				Print(sol,"\n");
				 return false;
				fi;
			fi;
		od;	
	od;
	return true;

end;

writeemb:=function(L1,file)
	local t,temp,g,h;
	t:=1;
	sum:=0;
	for g in L1 do
		Print(t,"\n");
		temp:=List(g,h -> VerticesInFacesHelp[h]);
		if IsE(SimplicialSurfaceByVerticesInFaces(temp)) then 
			AppendTo(file,g,",","\n"); 
			Print("IsEmb\n");
			sum:=sum+1;	
			Print("summe ",sum,"\n");	
		fi;
		t:=t+1;
	od;

end;
IsE:=function(S)
	local temp, voe,voeD,voeE,voeDE,sym,vof,vofA,vofB,vofC,vofAC,vofAB,tempS,sol,coordinates,tempvof;
	#sym:=GetSymbol(S);
	#tempS:=ConstructSurfaceBySymbol(sym,[1,2,3,4]);
	tempS:=S;	
	temp:=CoorMul(tempS);	
	coordinates:=temp[2];
	tempS:=temp[1];
	#Print(VerticesOfFaces(tempS),"ise\n");
	for voe in VerticesOfEdges(tempS) do
		tempvof:=Filtered(VerticesOfFaces(tempS),g->Intersection(voe,g)=[]);
		for vof in tempvof do 
			vofA:=coordinates[vof[1]];
			vofB:=coordinates[vof[2]];
			vofC:=coordinates[vof[3]];
			voeD:=coordinates[voe[1]];
			voeE:=coordinates[voe[2]];
			vofAB:=vofB-vofA;
			vofAC:=vofC-vofA;;
			voeDE:=voeE-voeD;;
			sol:=SolutionMat([vofAB,vofAC,-voeDE],voeD-vofA);	
			if not sol=fail then 
				if (sol[1]>0. and sol[1]<1.) and (sol[2]>0. and
 sol[2]<1.) and (sol[3]>0. and sol[3]<1.) and sol[1]+sol[2]<=1. and sol[1]+sol[2]>0. then 
#				Print(voe," ",vof,"\n");
#				Print(sol,"\n");
				 return false;
				fi;
			fi;
		od;	
	od;
	return true;

end;



########################
########################
########################
########################

IsE1:=function(S,V)
	local temp, voe,voeD,voeE,voeDE,sym,VOE,vof,vofA,vofB,vofC,vofAC,vofAB,tempS,sol,coordinates,tempvof;
	#sym:=GetSymbol(S);
	#tempS:=ConstructSurfaceBySymbol(sym,[1,2,3,4]);
	tempS:=S;	
	temp:=CoorMul(tempS);	
	coordinates:=temp[2];
	tempS:=temp[1];
	VOE:=Filtered(VerticesOfEdges(tempS),g->V in g);
	
	for voe in VOE do
		tempvof:=Filtered(VerticesOfFaces(tempS),g->Intersection(voe,g)=[]);
		for vof in tempvof do 
			vofA:=coordinates[vof[1]];
			vofB:=coordinates[vof[2]];
			vofC:=coordinates[vof[3]];
			voeD:=coordinates[voe[1]];
			voeE:=coordinates[voe[2]];
			vofAB:=vofB-vofA;
			vofAC:=vofC-vofA;;
			voeDE:=voeE-voeD;;
			sol:=SolutionMat([vofAB,vofAC,-voeDE],voeD-vofA);	
			if not sol=fail then 
				if (sol[1]>0. and sol[1]<1.) and (sol[2]>0. and
 sol[2]<1.) and (sol[3]>0. and sol[3]<1.) and sol[1]+sol[2]<=1. and sol[1]+sol[2]>0. then 
#				Print(voe," ",vof,"\n");
#				Print(sol,"\n");
				 return false;
				fi;
			fi;
		od;	
	od;
	return true;

end;

