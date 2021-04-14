IsVertexTransitive:=function(S)
	local AutGrOnVer;
	AutGrOnVer:=AutomorphismGroupOnVertices(S);
	return IsTransitive(AutGrOnVer,Vertices(S) );
end;

IsEdgeTransitive:=function(S)
        local AutGrOnEdg;
        AutGrOnEdg:=AutomorphismGroupOnEdges(S);
        return IsTransitive(AutGrOnEdg,Edges(S) );
end;

IsFaceTransitive:=function(S)
        local AutGrOnFac;
        AutGrOnFac:=AutomorphismGroupOnFaces(S);
        return IsTransitive(AutGrOnFac,Faces(S) );
end;

