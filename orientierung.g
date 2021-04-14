

#Using the Umbrella Descriptor we can find a simplicial surface with face graph K_3,3

#Use the function SurfaceFromUmbrella from Sheet 2

SurfaceFromUmbrella([[1,2,3,4,5,6],[3,2,5,4,1,6],[5,2,1,4,3,6]]);

s:=SimplicialSurfaceByDownwardIncidence([[1,3],[1,2],[2,3],[1,3],[1,2],[2,3],[1,3],[1,2],[2,3]],

[[1,2,3],[4,5,6],[7,8,9],[1,6,8],[2,4,9],[3,5,7]]);

#This surface is closed, connected and orientable with 3 Vertices








#return the faces that share an edge with face in s

FacesOfFace:=function(s,face)

local edges,faces,e;

edges:=EdgesOfFace(s, face);

faces:=[];

for e in edges do

e:=FacesOfEdge(s,e);

if Size(e)=2 then

Add(faces,e[Position(e,face) mod 2 +1]);

fi;

od;

return faces;

end;;

#given the orientation of f1 in s give a coherent orientation for f2

GetCoherentOrientation:=function(s,f1,f2,f1Orientation)

local vertices, commonvertices, v1, v2, v3,v;

vertices:=VerticesOfFace(s,f2);

commonvertices:=Intersection(vertices,f1Orientation);

if Size(commonvertices)=3 then

v3:=commonvertices[3];

fi;

for v in vertices do

if not v in commonvertices then

v3:=v;

fi;

od;

v1:=commonvertices[1];

v2:=commonvertices[2];

if Position(f1Orientation,v1) mod 3+1=Position(f1Orientation,v2) then

return [v2,v1,v3];

else

return [v1,v2,v3];

fi;

end;;

#check if the edge e is given two coherrent orientations by the orientation the faces

#of s saved in orientationOfFaces

IsCoherrentOrientation:=function(s,e,orientationOfFaces)

local vertices, faces,f1Orientation,f2Orientation,f1,f2,v1,v2;

vertices:=VerticesOfEdge(s,e);

v1:=vertices[1];

v2:=vertices[2];

faces:=FacesOfEdge(s,e);

if Size(faces)=2 then

f1Orientation:=orientationOfFaces[faces[1]];

f2Orientation:=orientationOfFaces[faces[2]];

f1:=Position(f1Orientation,v1) mod 3+1=Position(f1Orientation,v2);

f2:=Position(f2Orientation,v1) mod 3+1=Position(f2Orientation,v2);

if f1=f2 then

return false;

fi;

fi;

return true;

end;;

#Input connected SimplicialSurface s

#Check whether s is orientable by building up a spanning tree of the face graph

#(for an orientable subsurface) and adding missing edges until we get s

#if no möbius strip is found s is orientable and the function returns true

#else if an added edge leads to a möbius strip corresponding to a circle

#in the modified face graph we return the edge and false

#for non connected surfaces use the function Connected components or alternatively build

#a forrest instead of a tree

MyIsOrientable:=function(s)

local faces, spanningTreeNodes, spanningTreeEdges, face, nextFaces,

faceNeighbours, orientationOfFaces,pos,f;

faces:=Reversed(Faces(s));

spanningTreeNodes:=[];

spanningTreeEdges:=[];

face:=Remove(faces);

nextFaces:=[];

Add(spanningTreeNodes,face);

faceNeighbours:=FacesOfFace(s, face);

orientationOfFaces:=[];

orientationOfFaces[face]:=VerticesOfFace(s, face);

for f in faceNeighbours do

if not f in spanningTreeNodes then

Add(spanningTreeNodes,f);

Add(spanningTreeEdges,[]);

Add(nextFaces,f);

pos:=Position(spanningTreeNodes,face);

Add(spanningTreeEdges[pos],f);

Add(nextFaces,f);

orientationOfFaces[f]:=GetCoherentOrientation(s,face,f,orientationOfFaces[face]);

fi;

od;

while nextFaces<>[] do

face:=Remove(nextFaces);

faceNeighbours:=FacesOfFace(s, face);

for f in faceNeighbours do

if not f in spanningTreeNodes then

Add(spanningTreeNodes,f);

Add(spanningTreeEdges,[]);

Add(nextFaces,f);

pos:=Position(spanningTreeNodes,face);

Add(spanningTreeEdges[pos],f);

Add(nextFaces,f);

orientationOfFaces[f]:=GetCoherentOrientation(s,face,f,orientationOfFaces[face]);

fi;

od;

od;

for e in Edges(s) do

if not IsCoherrentOrientation(s,e,orientationOfFaces) then

# return the edge e that fails the orientability

# cut along such edges e to obtain an orientable flattening

return [e,false];

# alternatively one can return the non-orientable subsurface (MöbiusStrip)

# via the command SubsurfaceByFaces();

#by finding a closed edge face-path containing e

fi;

od;

return true;

end;;


