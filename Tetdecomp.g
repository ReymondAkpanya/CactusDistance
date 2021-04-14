IsTetrahedrialDecomposition:=function(S,D)
	local V,Diff,v;
	V:=VerticesOfFaces(S);
        Diff:=Difference(Combinations(Vertices(S),3),V);
	for v in V do
		if not( Length(Filtered(D,g-> IsSubset(g,v)))=1 ) then 
			return [false,v];
		fi;
	od;
	if IsSubset([0,2],Set(List(Diff,r->Length(Filtered(D,g->IsSubset(g,r)))))) then 
		return [true,0];
	fi;
	return [false,List(Diff,r->[r,Filtered(D,g->IsSubset(g,r))])];
end;

bv:=function(S,e)
	return Union(VerticesOfFace(S,FacesOfEdge(S,e)[1]),VerticesOfFace(S,FacesOfEdge(S,e)[2])); 
end;
