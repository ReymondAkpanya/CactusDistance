AlgorithmCactus:=function(S)
	local V,tempS,cacdis,g,mindeg,edges,tempmindeg,tempV,vertices,tempfacdeg,edg,tempedg,visited;
	cacdis:=0;
	visited:=[];
	tempS:=S;
	while not IsIsomorphic(tempS,T) and not IsIsomorphic(tempS,DT) do
		Print("beginfirstwhlie\n");
		mindeg:=Minimum(FaceDegreesOfVertices(tempS));
		V:=Position(FaceDegreesOfVertices(tempS),mindeg);
		edges:=Filtered(EdgesOfVertex(tempS,V),g-> IsTurnableEdge(tempS,g));
		vertices:=List(edges,g->VerticesOfEdge(tempS,g));
		vertices:=Union(vertices);
		vertices:=Difference(vertices,[V]);
		while FaceDegreeOfVertex(tempS,V)<>3 do
			Print("beginsecomdwhlie\n");
			tempfacdeg:=List(vertices,g->FaceDegreeOfVertex(tempS,g));
			tempmindeg:=Minimum(tempfacdeg);			
			tempV:=Filtered(vertices,g->FaceDegreeOfVertex(tempS,g)=tempmindeg)[1];
edg:=Filtered(edges,g->Set(VerticesOfEdge(tempS,g))=Set([tempV,V]))[1];
			if edg in visited then 
				cacdis:=cacdis+2;
			else			
				cacdis:=cacdis+1;	
			fi;	
			Print(edg,"\n");		
			tempS:=EdgeTurn(tempS,edg);
			edges:=Difference(edges,[edg]);
			vertices:=Difference(vertices,[tempV]);
		od;
		tempedg:=Union(List(FacesOfVertex(tempS,V),g->EdgesOfFace(tempS,g) ) );
		tempedg:=Difference(tempedg,EdgesOfVertex(tempS,V));
		Append(visited,tempedg);
		tempS:=RemoveTetra(tempS,V);

	od;  
	return cacdis;
end;

Schranke:=function(S)
	local g,tempV;
	tempV:=[];
	vert:=VerticesOfEdges(S);
	Print(vert,"\n");
	for v in vert do
		Print(v);
		temp:=Filtered(vert,g->Length(Intersection(v,g))=1);
		Print(temp,"\n");
		temp:=Filtered(temp,g->not Union(g,v) in VerticesOfFaces(S));
		temp:=List(temp,g->Difference(Union(g,v),Intersection(v,g)));
		Append(tempV,temp);
	od;
	tempV:=Set(tempV);
	Print(tempV,"\n");
	tempV:=List(tempV,v->AbsoluteValue(NumberOfFaces(S)/2-FaceDegreeOfVertex(S,v[1]))
+AbsoluteValue(NumberOfFaces(S)/2-FaceDegreeOfVertex(S,v[2])));
	return Minimum(tempV)+1;
end;








