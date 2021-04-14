

#1 I assume that Umbrella Descriptor in gap is given as a List of lists with number of vertices, so as [[...], [..]...], rather then {((...))..}, as it is more convinient for programing. 

umbrellaDescriptorToSimplicialSphere:=function(umbrellaDescriptor)
local n, k, m, x_0x_2, x_0x_1, x_1x_2, i, j, pairs, edges, f, pair;

n:=Size(umbrellaDescriptor);#number of vertices
k:=3*(n-2);#number of edges
m:=2*(n-2);#number of faces
x_0x_2:=List([1..m], i->[]); #Vertices in Faces
for i in [1..n] do #constructs vertices in faces
for f in umbrellaDescriptor[i] do
Add(x_0x_2[f], i); 
od;
od; 
x_0x_1:=[]; #Vertices in edges
x_1x_2:=[]; #edges in Faces
for j in [1..m] do
pairs:=Combinations(x_0x_2[j], 2);#Edges of a face
edges:=[];
for pair in pairs do
if (pair in x_0x_1) then
Add(edges, Position(x_0x_1, pair)); #number of the edge
else 
if (Reversed(pair) in x_0x_1) then 
Add(edges, Position(x_0x_1, Reversed(pair)));#number of the edge
else
Add(x_0x_1, pair);#Adds new edge to vertyices in edges
Add(edges, Size(x_0x_1)); #number of the edge
fi;
fi;
od;
Add(x_1x_2, edges); #adds new face in edges in faces
od;

return SimplicialSurfaceByDownwardIncidence( x_0x_1, x_1x_2); #converts incidence decriptor into a surface

end;



