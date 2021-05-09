Read("print.g");
#Read("FG.g");
help:=function(S,f)
	local temp;
	temp:=[f];
	Append(temp,NeighbourFacesOfFace(S,f));
	return temp;
end;
colouring:=function(S)
	local f,nf,red,temp, blue, yellow,visited;
	blue:=[];
	red:=[];
	yellow:=[];
	visited:=[];
	for f in Faces(S) do 
		for nf in help(S,f) do
			if Intersection(blue,NeighbourFacesOfFace(S,nf))=[] and not(nf in visited) then
				Add(blue,nf);
				Add(visited,nf);
			elif Intersection(red,NeighbourFacesOfFace(S,nf))=[] and not(nf in visited) then
				Add(red,nf);
				Add(visited,nf);
			elif Intersection(yellow,NeighbourFacesOfFace(S,nf))=[] and not(nf in visited) then
				Add(yellow,nf);
				Add(visited,nf);
			fi;
		
		od;
	od;
	return [Set(blue),Set(red),Set(yellow)];
end;

CP:=function(S)
	local co,pos,i,dis;
	if IsIsomorphic(S,Tetrahedron()) then
		return [[1,0],[0,1],[-1,0],[0,-1]];
	fi;
	pos:=[];
	co:=colouring(S);
	if not(co[3]=[]) then 
		for i in [1..Length(co[3])] do
			pos[co[3][i]]:=[-(1+Length(co[3]))+2*i,0];
		od;
		dis:=Length(co[3]);
	else 
		dis:=Length(co[2])/2;
	fi;
	for i in [1..Length(co[1])] do 
		pos[co[1][i]]:=[-(1+dis),2*i];
	od;
	for i in [1..Length(co[2])] do
		pos[co[2][i]]:=[(dis+1),2*i];
	od;
	return pos;
end;

VE:=function(S,fp,file)
	local i;
	#fp:=FacePosAdv(S);
#	fp:=CP(S);
	AppendTo(file,"\\begin{scriptsize}\n",
		      "% Define the coordinates of the vertices\n");
	for i in Faces(S) do
#AppendTo(file,"\\coordinate (V",i,") at (",fp[i][1]," , ",fp[i][2],");
		AppendTo(file ,"\\draw [fill=ududff] (",fp[i][1],",",fp[i][2],") circle (6.0pt);\n",
			    "\\draw[color=uuuuuu] (",fp[i][1],",",fp[i][2],") node {$",i,"$};\n");
	od;
	AppendTo(file,"\\end{scriptsize}\n");
end;

DrawS:=function(S, file)
	local n;
	#beg(file,Length(Faces(S)));
	beg1(file,CP(S));
	Ed(S,CP(S),file);
	VE(S,CP(S),file);
	
AppendTo(file,"\\end{tikzpicture}\n",
              "\\end{document}\n");
end;
DrawS1:=function(S, file)
	beg(file,Length(Faces(S)));
	Ed(S,CP(S),file);
	VE(S,CP(S),file);
	
AppendTo(file,"\\end{tikzpicture}\n",
              "\\end{document}\n");
end;
Ed:=function(S,cp,file)
	local e,f,temp,c,g;
#	cp:=CP(S);
	c:=colouring(S);
	AppendTo(file,"%draw edges\n\n");
	for e in Edges(S) do 
		f:=FacesOfEdge(S,e);
		temp:=Filtered(FacesOfEdges(S),g->Set(g)=Set(FacesOfEdge(S,e)));
		if IsInnerEdge(S,e) and Length(temp)=1 then 
	AppendTo(file,"\\draw [line width=2pt,color=uuuuuu] (",
	cp[f[1]][1],",",cp[f[1]][2],")-- (",cp[f[2]][1],",",cp[f[2]][2],");\n");
		elif IsInnerEdge(S,e) and Length(temp)=2 then 
			AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1],",",cp[f[1]][2],") [loop, in=60,out=130,distance=0.4cm] to (",cp[f[2]][1],",",cp[f[2]][2],") ;\n");
			AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1],",",cp[f[1]][2],")[loop, in=300,out=230,distance=0.4cm] to (",cp[f[2]][1],",",cp[f[2]][2],");\n");

		elif IsInnerEdge(S,e) and Length(temp)=3 then  
			AppendTo(file,"\\draw [line width=2pt,color=uuuuuu] (",cp[f[1]][1],",",cp[f[1]][2],")-- (",cp[f[2]][1],",",cp[f[2]][2],");\n");
AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1],",",cp[f[1]][2],") [loop, in=60,out=130,distance=0.4cm] to (",cp[f[2]][1],",",cp[f[2]][2],") ;\n");
AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1],",",cp[f[1]][2],") [loop, in=300,out=230,distance=0.4cm] to (",cp[f[2]][1],",",cp[f[2]][2],") ;\n");
 
#AppendTo(file,"\\path[thick,densely dotted, bend left=50,color=uuuuuu] (",cp[f[1]][1],",",cp[f[1]][2],")-- (",cp[f[2]][1],",",cp[f[2]][2],");\n");
#AppendTo(file,"\\path[thick,densely dotted, bend right=50,color=uuuuuu] (",cp[f[1]][1],",",cp[f[1]][2],")-- (",cp[f[2]][1],",",cp[f[2]][2],");\n");						
#		\draw[-,thick] (3,0) [loop, in=300,out=230,distance=0.2cm] to (4,0) ;



		elif IsBoundaryEdge(S,e) and Length(temp)=1 then
			if f[1] in c[1] then
			AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1],",",cp[f[1]][2],") [loop, in=90,out=90,distance=0.2cm] to (",cp[f[1]][1]-0.7,",",cp[f[1]][2],") ;\n");
AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1]-0.7,",",cp[f[1]][2],") [loop, in=270,out=270,distance=0.2cm] to (",cp[f[1]][1],",",cp[f[1]][2],") ;\n");
			elif f[1] in c[2] then
			AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1]+0.7,",",cp[f[1]][2],") [loop, in=90,out=90,distance=0.2cm] to (",cp[f[1]][1],",",cp[f[1]][2],") ;\n");
AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1],",",cp[f[1]][2],") [loop, in=270,out=270,distance=0.2cm] to (",cp[f[1]][1]+0.7,",",cp[f[1]][2],") ;\n");
			elif f[1] in c[3] then
			AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1],",",cp[f[1]][2]-0.7,") [loop, in=240,out=160,distance=0.2cm] to (",cp[f[1]][1],",",cp[f[1]][2],") ;\n");
AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1]-0.7,",",cp[f[1]][2],") [loop, in=240,out=160,distance=0.2cm] to (",cp[f[1]][1],",",cp[f[1]][2]-0.7,") ;\n");
			fi;				 
		elif IsBoundaryEdge(S,e) and Length(temp)=2 then
			if f[1] in c[1] then 
AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1],",",cp[f[1]][2],") [loop, in=90,out=90,distance=0.2cm] to (",cp[f[1]][1]-0.7,",",cp[f[1]][2]+0.7,") ;\n");
AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1]-0.7,",",cp[f[1]][2]+0.7,") [loop, in=270,out=270,distance=0.2cm] to (",cp[f[1]][1],",",cp[f[1]][2],") ;\n");

AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1],",",cp[f[1]][2],") [loop, in=90,out=90,distance=0.2cm] to (",cp[f[1]][1]-0.7,",",cp[f[1]][2]-0.7,") ;\n");
AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1]-0.7,",",cp[f[1]][2]-0.7,") [loop, in=270,out=270,distance=0.2cm] to (",cp[f[1]][1],",",cp[f[1]][2],") ;\n");
			elif f[1] in c[2] then 
AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1],",",cp[f[1]][2],") [loop, in=90,out=90,distance=0.2cm] to (",cp[f[1]][1]+0.7,",",cp[f[1]][2]+0.7,") ;\n");
AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1]+0.7,",",cp[f[1]][2]+0.7,") [loop, in=270,out=270,distance=0.2cm] to (",cp[f[1]][1],",",cp[f[1]][2],") ;\n");

AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1],",",cp[f[1]][2],") [loop, in=90,out=90,distance=0.2cm] to (",cp[f[1]][1]+0.7,",",cp[f[1]][2]-0.7,") ;\n");
AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1]+0.7,",",cp[f[1]][2]-0.7,") [loop, in=270,out=270,distance=0.2cm] to (",cp[f[1]][1],",",cp[f[1]][2],") ;\n");
			elif f[1] in c[3] then 
AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1],",",cp[f[1]][2],") [loop, in=90,out=90,distance=0.2cm] to (",cp[f[1]][1]-0.7,",",cp[f[1]][2]-0.7,") ;\n");
AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1]-0.7,",",cp[f[1]][2]-0.7,") [loop, in=270,out=270,distance=0.2cm] to (",cp[f[1]][1],",",cp[f[1]][2],") ;\n");

AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1],",",cp[f[1]][2],") [loop, in=90,out=90,distance=0.2cm] to (",cp[f[1]][1]+0.7,",",cp[f[1]][2]-0.7,") ;\n");
AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1]+0.7,",",cp[f[1]][2]-0.7,") [loop, in=270,out=270,distance=0.2cm] to (",cp[f[1]][1],",",cp[f[1]][2],") ;\n");
			fi;
		elif IsBoundaryEdge(S,e) and Length(temp)=3 then 
AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1],",",cp[f[1]][2]+0.7,") [loop, in=0,out=0,distance=0.2cm] to (",cp[f[1]][1],",",cp[f[1]][2],") ;\n");
AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1],",",cp[f[1]][2],") [loop, in=180,out=180,distance=0.2cm] to (",cp[f[1]][1],",",cp[f[1]][2]+0.7,") ;\n");

AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1]-0.7,",",cp[f[1]][2],") [loop, in=270,out=270,distance=0.2cm] to (",cp[f[1]][1],",",cp[f[1]][2],") ;\n");
AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1],",",cp[f[1]][2],") [loop, in=90,out=90,distance=0.2cm] to (",cp[f[1]][1]-0.7,",",cp[f[1]][2],") ;\n");

AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1],",",cp[f[1]][2],") [loop, in=90,out=90,distance=0.2cm] to (",cp[f[1]][1]+0.7,",",cp[f[1]][2],") ;\n");
AppendTo(file,"\\draw[-,thick] (",cp[f[1]][1]+0.7,",",cp[f[1]][2],") [loop, in=270,out=270,distance=0.2cm] to (",cp[f[1]][1],",",cp[f[1]][2],") ;\n");
		fi;
		
	od; 
end;

###############################################################################
CorrectFile:=function(file)
	local temp;
	temp:=SplitString(file,".");
#	if IsReadableFile(file) then
#		Add(temp,"(2)");
#		return JoinStringsWithSeparator(temp,"");
#	fi;
	if "tex"=temp[Length(temp)] and Length(temp)>1 then
		if IsReadableFile(file) then
			Add(temp,"(2)");
			return JoinStringsWithSeparator(temp,"");
		fi;
		return file;
	fi;
	Add(temp,".tex");
	return JoinStringsWithSeparator(temp,"");
end;


minvert:=function(v,L)
	local g,m,L1;
	L1:=List(L,g-> Sqrt((v[1]-g[1])^2+(v[2]-g[2])^2 ) );
	m:=Minimum(L1);
	#if Filtered(L1,g->g<0.01+m)=[m] then
		return L[Position(L1,m)];  
	#else
	#	return Filtered(L1,g->g<0.01+m);
	#fi;
end;




FacPosM:=function(S)
	local sym,surf,i,vert,tempsym,tempsurf,temp,neighbour,newfaces;
	sym:=GetSymbol(S);
	surf:=T;
	i:=1;
	vert:=[[0.,1.6],[-3.,0.],[3.,0.],[0.,5.]];
	while not IsIsomorphic(surf,S) do
		Print("while",i);
		for fac in Faces(surf) do
			tempsym:=List([1..i],g->sym[g]);
			tempsurf:=ConstructSurfaceBySymbol(tempsym,[1,2,3,4]);
			temp:=AddTetraF(surf,fac);
			if not IsIsomorphic(surf,S) and IsIsomorphic(temp,tempsurf) then 
#				if IsIsomorphic(temp,tempsurf) then 
					newfaces:=Difference(Faces(temp),Faces(surf));
					neighbour:=List(newfaces,g-> Intersection(NeighbourFacesOfFace(temp,g),Faces(surf))[1]);
					templist:=List(neighbour,g->
Sqrt((vert[fac][1]/1.-vert[g][1]/1.)^2 +
     (vert[fac][2]/1.-vert[g][2]/1.)^2) );		
					min:=Minimum(templist);		
					for g in [1..3] do
						c:=(1/2.*min)/templist[g];
						if templist[g]=min then 
						
						vert[newfaces[g]]:=vert[fac]+c*(vert[neighbour[g]]-vert[fac]);
						else
						vert[newfaces[g]]:=vert[fac]+9/10.*c*(vert[neighbour[g]]-vert[fac]);
					fi;
					od;	
					surf:=temp; 
					i:=i+1;
					vert:=CRemove(vert,fac);
				Print("aaaaaaaaaaaaaaaaaaaa\n");
			fi;
			if i>Length(sym) then 
				return [surf,vert];
			fi;
		od;
	od;
	return [surf,vert];
end;
DrawM:=function(S,file)
	local temp;
	temp:=FacPosM(S);	
	temp:=verts(temp[1],temp[2]);
	beg1(file,temp[2]);
	Ed(temp[1],temp[2],file);
	VE(temp[1],temp[2],file);
	
AppendTo(file,"\\end{tikzpicture}\n",
              "\\end{document}\n");
end;
verts:=function(S,co)
	local min,ff,temp;
	temp:=[];
	for ff in FacesOfEdges(S) do
		Add(temp,Sqrt( (co[ff[1]][1]-co[ff[2]][1])^2+(co[ff[1]][2]-co[ff[2]][2])^2  ));
	od;
	min:=Minimum(temp);
	if min < 1. then 
		return [S,List(co,g->[Round(1./min*g[1]*1000.)/1000.,Round(1./min*g[2]*1000.)/1000.])];
	else	
		return [S,List(co,g->[Round(g[1]*1000.)/1000.,Round(g[2]*1000.)/1000.])];
	fi;
end;
