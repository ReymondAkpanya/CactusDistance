SurfaceVarianz:=function(S)
	local var,v,m;
	m:=3*Length(Faces(S))/Length(Vertices(S));
	var:=0.;
	for v in FaceDegreesOfVertices(S) do
		var:= var + (1.*(v-m)^2/(Length(Vertices(S))-1));
		
	od;
	return var;
end;
