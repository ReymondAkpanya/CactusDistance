####################################################################
##
##  SimplicialSurface Package
##
##  Copyright 2012-2018
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen Univertiy
##
## Licensed under the GPL 3 or later.
##
#####################################################################

#! @Chapter Tutorial
#! @ChapterLabel Tutorial
#!
#! This chapter deals with the targeted use of the simplicial surfaces
#! package to solve certain problems of interest. So it is a tutorial, which 
#! shows the power of the package by combining the functions to get certain jobs done.
#! It should enable the user to quickly find routines for his tasks 
#! without previous knowledge of the function's names. 
#! It should also help the user to familiarize himself with the package without getting #! bored too much.

#! @Section Parallelelepiped
#! @SectionLabel Parallelelepiped
########
#! @SubSection Two Constructions of the parallelelepiped
#!
#! Problems: 1. Parallelelepiped from a cube 
#!           2. Parallelelepiped from an octahedron and two tetrahedra
#!  
#! Theoretical background:
#! Vertex-faithful surfaces and boolean operations
#######
#! @BeginExampleSession
#! Frequent commands used: 
#! EulerCharacteristic()
#! FacesOfVertices() (local version: FacesOfVertex())
#! IsIsomorphic() 
#! NeighbourVerticesOfVertex() 
#! SimplicialSurfaceByVerticesInFaces() (works for vertex-faithful surfaces only)
#! VertexCounter() (local version: DegreeOfVertex())
#! VerticesOfEdges() (local Version: VerticesOfEdge()) 
#! VerticesOfFaces() (local Version: VerticesOfFace())
#!
#! Less frequent commands used:
#! Cube() 
#!  
#! @EndExampleSession
#!
#! Mathematical details:
#! The parallelepiped is a three dimensional convex figure. It is a polyhedron with 6 
#! faces,
#! where each face is a parallelogram. Given a set of three linear independent
#! vectors in real 3-space, one can see that they define a parallelepiped and
#! also a tetrahedron.
#! In this first exercise we want to use the tetrahedron
#! to triangulate the surface of the parallelepiped. Note: Since we are only interested #! in surfaces, we shall refer to terms like tetrahedron, parallelepiped, octahedron 
#! etc. as the boundary surfaces of these dimensional figures, or even to the 
#! combinatorial devices describing their combinatorial structure.    
#!
#! Construct a parallelepiped out of a cube by
#! cutting off two tetrahedra and thus dividing each cube face into two triangles.
#!
#! @BeginExampleSession
#! gap> PE:=Cube()
#! ^[[0mpolygonal surface (^[[31m8 vertices^[[34m12 edges, ^[[0mand ^[[32m6 
#! faces^[[0m)^[[0m
#! gap> VerticesOfFaces(PE);
#! [ [ 1, 2, 3, 4 ], [ 1, 2, 5, 6 ], [ 2, 3, 6, 7 ], [ 1, 4, 5, 8 ]
#! [ 3, 4, 7, 8 ], [ 5, 6, 7, 8 ] ]
#! @EndExampleSession
#!
#! There are two disjoint tetrahedra containt in this cube with the following property:
#! The tetrahedra's faces subdivide three faces of the cube and the tetrahedra's 
#! vertices are elso vertices of the cube. 
#!
#! @BeginExampleSession
#! gap> VerticesOfFaces(PE);
#! gap>T1:=[1,2,4,5];
#! [ 1, 2, 4, 5 ]
#!
#! gap> VerticesOfFaces(PE);
#! gap>T1:=[3,6,7,8];
#! [ 3, 6, 7, 8 ]                  
#! @EndExampleSession
#!
#! Construct the corresponding tetrahedra
#!
#! @BeginExampleSession
#! gap> Combinations(T1,3);
#! [ [ 1, 2, 4 ], [ 1, 2, 5 ], [ 1, 4, 5 ],[ 2, 4, 5]];
#! gap>T1:=SimplicialSurfaceByVerticesInFaces(last);
#! ^[[0msimplicial surface (^[[31m4 vertices^[[0m, ^[[34m6 edges, ^[[0mand ^[[32m4 
#! faces^[[0m)^[[0m                 
#!
#! gap> Combinations(T2,3);
#! [ [ 3, 6, 7 ], [ 3, 6, 8 ], [ 3, 6, 8 ], [ 6, 7, 8 ] ]
#! gap>T1:=SimplicialSurfaceByVerticesInFaces(last);
#! ^[[0msimplicial surface (^[[31m4 verti$
#! @EndExampleSession
#!
#! Before proceeding to further computations, verify that the two simplcial
#! surfaces constructed are indeed isomorphic to the tetrahedron
#!
#! @BeginExampleSession
#! gap> IsIsomorphic(T1,Tetrahedron());
#! true
#! gap>IsIsomorphic(T2,Tetrahedron());
#! true
#! @EndExampleSession
#!
#! Now use the edges of the tetrahedra T1 and T2 to subdivide the cube's faces. 
#!
#! @BeginExampleSession
#! gap>  VerticesOfFaces(PE);
#! [ [ 1, 2, 3, 4 ], [ 1, 2, 5, 6 ], [ 2, 3, 6, 7 ], [ 1, 4, 5, 8 ], 
#!   [ 3, 4, 7, 8 ], [ 5, 6, 7, 8 ] ]
#! gap> VerticesOfEdges(T1);
#! [ [ 1, 2 ], [ 1, 4 ], [ 1, 5 ], [ 2, 4 ], [ 2, 5 ], [ 4, 5 ] ]
#! gap> VerticesOfEdges(T2);
#! [ [ 3, 6 ], [ 3, 7 ], [ 3, 8 ], [ 6, 7 ], [ 6, 8 ], [ 7, 8 ] ]
#! gap> neEd:=[[ 2, 4 ],[ 2, 5 ],[ 3, 6 ],[ 4, 5 ], [ 3, 8 ],[ 6, 8 ]];
#! [ [ 2, 4 ], [ 2, 5 ], [ 3, 6 ], [ 4, 5 ], [ 3, 8 ], [ 6, 8 ] ]
#! @EndExampleSession
#!
#! Now use the set <K>neEd</K> defined above to subdivide the cube's faces with following function:
#!
#! @BeginExampleSession
#! gap> part:=function(Q,E)
#! > local ne;
#! > ne:=Difference(Q,E);
#! > return [Union(E,[ne[1]]),Union(E,[ne[2]])];
#! > end;
#! function( Q, E ) ... end
#! @EndExampleSession
#!
#! Now construct the parallelepiped by defining the faces represented by their sets of
#! vertices. This works only because the parallelepiped is vertex-faitful.
#!
#! @BeginExampleSession
#! gap> List([1..6],i->part(VerticesOfFaces(PE)[i],neEd[i]));
#! [ [ [ 1, 2, 4 ], [ 2 .. 4 ] ], [ [ 1, 2, 5 ], [ 2, 5, 6 ] ],
#!  [ [ 2, 3, 6 ], [ 3, 6, 7 ] ], [ [ 1, 4, 5 ], [ 4, 5, 8 ] ], 
#!  [ [ 3, 4, 8 ], [ 3, 7, 8 ] ], [ [ 5, 6, 8 ], [ 6 .. 8 ] ] ]
#!
#! gap> Union(last);
#! [ [ 1, 2, 4 ], [ 1, 2, 5 ], [ 1, 4, 5 ], [ 2 .. 4 ], [ 2, 3, 6 ],
#!  [ 2, 5, 6 ], [ 3, 4, 8 ], [ 3, 6, 7 ], [ 3, 7, 8 ], [ 4, 5, 8 ], 
#!  [ 5, 6, 8 ], [ 6 .. 8 ] ]
#!
#! gap> PE:=SimplicialSurfaceByVerticesInFaces(last);
#! ^[[0msimplicial surface (^[[31m8 vertices^[[0m, ^[[34m18 edges, ^[[0mand ^[[32m12 faces^[[0m)^[[0m
#! @EndExampleSession
#!
#! Computing elementary properties of the surface
#!
#! @BeginExampleSession
#! gap> EulerCharacteristic(PE);
#! 2
#! gap> FacesOfVertices(PE);
#! [ [ 1, 2, 3 ], [ 1, 2, 4, 5, 6 ], [ 4, 5, 7, 8, 9 ], [ 1, 3, 4, 7, 10 ],
#!   [ 2, 3, 6, 10, 11 ], [ 5, 6, 8, 11, 12 ], [ 8, 9, 12 ],
#!  [ 7, 9, 10, 11, 12 ] ];
#! gap> VertexCounter(PE);
#! [ [ 3, 2 ], [ 5, 6 ] ]
#! @EndExampleSession
#!
#! Computing the set of vertices connected to a given vertex via an edge with the
#! command <K>NeighbourVerticesOfVertex</K>
#!
#! @BeginExampleSession
#! gap> NeighbourVerticesOfVertex(PE,1);
#! [ 2, 4, 5 ]
#! gap> NeighbourVerticesOfVertex(PE,2);NeighbourVerticesOfVertex(PE,4);
#! [ 1, 3, 4, 5, 6 ]
#! [ 1, 2, 3, 5, 8 ]
#! gap> NeighbourVerticesOfVertex(PE,7);
#! [ 3, 6, 8 ]
#! @EndExamplesession
#! 
#! Constructing the parallelepiped from an octahedron by attaching tetrahedra on two 
#! disjoint faces, whereby the faces of the surfaces are represented by their sets of 
#! vertices
#!  
#! @BeginExampleSession
#! gap> O1:=Octahedron();
#! ^[[0msimplicial surface (^[[31m6 vertices^[[0m, ^[[34m12 edges, ^[[0mand ^[[32m8 faces^[[0m)^[[0m
#! @EndExampleSession
#! 
#! With its sets of vertices in faces
#! @BeginExampleSession
#! gap> VO1:=VerticesOfFaces(O1);
#! [ [ 1, 2, 3 ], [ 2, 5, 6 ], [ 1, 2, 5 ], [ 2, 3, 6 ], [ 1, 4, 5 ],
#!  [ 3, 4, 6 ], [ 1, 3, 4 ], [ 4, 5, 6 ] ]
#! EndExampleSession
#!
#! Determine the faces which are going to be replaced. Therefore searching for two
#! faces which share no common vertex
#!
#! @BeginExampleSession
#! gap> Filtered(VO1,r->Intersection(VO1[1],r)=[]);
#! [ [ 4, 5, 6 ] ]
#! @EndExampleSession
#!
#! Constructing the tetrahedra needed for the construction 
#!
#! First tetrahedra:
#! @BeginExampleSession
#! gap> FT1:=Combinations([1,2,3,7],3);
#! [ [ 1, 2, 3 ], [ 1, 2, 7 ], [ 1, 3, 7 ], [ 2, 3, 7 ] ]
#! @EndExampleSession
#!
#! Second tetrahedra: 
#! @BeginExampleSession
#! gap> FT2:=Combinations([4,5,6,8],3);
#! [ [ 4, 5, 6 ], [ 4, 5, 8 ], [ 4, 6, 8 ], [ 5, 6, 8 ] ]
#! @EndExamplSession
#!
#! @BeginGroup symdif
#! @Description Returns the symmetric difference of the two sets A,B
#! @Returns a set
#! @Arguments A,B
DeclareAttribute( "symdif", IsSet );
#! @EndGroup 
#!
#! @BeginExampleSession
#! gap> symdif:=function(A,B)
#! > return Difference(Union(A,B),Intersection(A,B));
#! > end;
#! function( A, B ) ... end
#! @EndExampleSession
#!
#! Computing the sets of vertices by using the symmetric difference:
#!
#! @BeginExampleSession
#! gap> symdif(VO1,FT1);
#! [ [ 1, 2, 5 ], [ 1, 2, 7 ], [ 1, 3, 4 ], [ 1, 3, 7 ], [ 1, 4, 5 ],
#! [ 2, 3, 6 ], [ 2, 3, 7 ], [ 2, 5, 6 ], [ 3, 4, 6 ], [ 4, 5, 6 ] ]
#! gap> symdif(last,FT2);
#! [ [ 1, 2, 5 ], [ 1, 2, 7 ], [ 1, 3, 4 ], [ 1, 3, 7 ], [ 1, 4, 5 ],
#!  [ 2, 3, 6 ], [ 2, 3, 7 ], [ 2, 5, 6 ], [ 3, 4, 6 ], [ 4, 5, 8 ],
#!  [ 4, 6, 8 ], [ 5, 6, 8 ] ]
#! @EndExampleSession
#!
#! Finally constructing the parallelepiped
#! 
#! @BeginExampleSession
#! gap> PEn:=SimplicialSurfaceByVerticesInFaces(last);
#! ^[[0msimplicial surface (^[[31m8 vertices^[[0m, ^[[34m18 edges, ^[[0mand ^[[32m12 face$
#! @EndExampleSession
#!
#! If the first and second construction were carried out correctly, the constructed 
#! simplicial surfaces must be isomorphic.
#!
#! @BeginExampleSession
#! gap> IsIsomorphic(PE,PEn);
#! true
#! @EndExampleSession


