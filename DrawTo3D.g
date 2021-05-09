##################################
norm:=function(v) 
	return Sqrt( v[1]*v[1] + v[2]*v[2] + v[3]*v[3] ); 
end;
distance:=function(p,q)
	return norm(p-q);
end;
normalize:=function(v) 
	return v/norm(v); 
end;
crossProd:=function(v,w) 
	return [ v[2]*w[3]-v[3]*w[2], v[3]*w[1]-v[1]*w[3], v[1]*w[2]-v[2]*w[1] ]; 
end;
atan2:=function(y,x)
	if x > 0. then
		return Atan(y/x);
	fi;
	if x < 0. then
		if y > 0. then
			return Atan(y/x)+4*Atan(1.0);
		fi;
		if y = 0. then
			return 4*Atan(1.0);
		fi;
		return Atan(y/x)-4*Atan(1.0);
	fi;
	if y > 0. then
		return 2*Atan(1.0);
	fi;
	if y < 0. then
		return -2*Atan(1.0);
	fi;
	return 0.;
end;

drawedges:=function(coor,edgetup,stream)
	local res,ed,P1,P2,d,gamma, beta,mid,parametersOfEdge;
	res := [];
	for ed in edgetup do
		P1:=coor[ed[1]];
		P2:=coor[ed[2]];
		# calculate distance
		d := distance(P1,P2);
		# calculate coordiantes of mid of edge
		mid := ( P1 + P2 ) / 2;
		# calculate rotation angles (from y-direction)
		beta := atan2(-1.0*(P2[3]-P1[3]), 1.0*(P2[1]-P1[1]));
		gamma := -Acos(1.0*(P2[2]-P1[2])/d);
		Append(res, [ [mid, d, [ 0., beta, gamma ] ] ]);
	od;
	#printRecord.edges := res;
	#return res;
	for parametersOfEdge in res do
		AppendTo(stream, "\t\tvar edge = Edge(", parametersOfEdge[2], ", 0.01, ", parametersOfEdge[1][1], ", ",
                            parametersOfEdge[1][2], ", ", parametersOfEdge[1][3], ", ", parametersOfEdge[3][1], ", ",
                            parametersOfEdge[3][2], ", ", parametersOfEdge[3][3], ", 0xff0000 );\n");
                        AppendTo(stream, "\t\tobj.add(edge);\n");

	od;

end;
drawvertices:=function(co,stream)
	local g;
#	allpoints.push(new PMPoint(1,1,-1));
	for g in co do 
	AppendTo(stream,"allpoints.push(new PMPoint(",g[1],",",g[2],",",g[3],"));\n");
	od;
 #               points_material0.side = THREE.DoubleSide;
#                points_material0.transparent = true;
#  var points_material0 = new THREE.MeshBasicMaterial( {color: 0xF58137  } );
	AppendTo(stream,"var points_material0 = new THREE.MeshBasicMaterial( {color: 0xF5837}  );\n");
	AppendTo(stream,"points_material0.side = THREE.DoubleSide;\n");
	AppendTo(stream, "points_material0.transparent= true;\n");
#// draw a node as a sphere of radius 0.05
#allpoints[0].makesphere(0.05,points_material0);
#allpoints[0].makelabel(1);
#var points_material1 = new THREE.MeshBasicMaterial( {color: 0xF58137 }$
#points_material1.side = THREE.DoubleSide;
#points_material1.transparent = true;
	for i in [1..Length(co)] do
		AppendTo(stream,"//draw a node as a sphere of radius 0.05\n");		AppendTo(stream,"allpoints[",i-1,"].makesphere(0.05,points_material",i-1,");\n");
		AppendTo(stream,"allpoints[",i-1,"].makelabel(",i,");\n");
		AppendTo(stream,"var points_material",i,"=new THREE.MeshBasicMaterial( {color: 0xF58137} );\n");
		AppendTo(stream,"points_material",i,".side=THREE.DoubleSide;\n");
		AppendTo(stream,"points_material",i,".transparent = true;\n");
	od;


#  // associate points to the 3D object
#        for (index = 0; index < allpoints.length; ++index) {
#            allpoints[index].add(obj);
#        }
AppendTo(stream,"// associate points to the 3D object\n","for (index = 0; index < allpoints.length; ++index) {\n","    allpoints[index].add(obj);\n }");


end;
##########################
Multigraph:=function(S)
	local g,v,co,surf,l1,l2,l3,pos,i,j,temp4,temp3,temp,vof,temp1,temp2;
	co:=CoorMul(S);
	surf:=co[1];
	pos:=co[2];
	temp4:=[];
	temp:=[];
	temp2:=[];
	temp:=Combinations(Vertices(surf),3);
	temp:=Filtered(temp,g->not g in VerticesOfFaces(surf));
	temp:=Filtered(temp,g->[g[1],g[2]] in VerticesOfEdges(surf));
	temp:=Filtered(temp,g->[g[2],g[3]] in VerticesOfEdges(surf));
	temp:=Filtered(temp,g->[g[1],g[3]] in VerticesOfEdges(surf));
	temp1:=List(temp,g->Intersection(NeighbourVerticesOfVertex(surf,g[1]),
	NeighbourVerticesOfVertex(surf,g[2]),
	NeighbourVerticesOfVertex(surf,g[3]))
	);
	for i in [1..Length(temp)] do 
		if Length(temp1[i])=1 then 
			Add(temp2,Union(temp[i],temp1[i]));
			Print("a\n");
		else
			Add(temp2,Union(temp[i],[temp1[i][1]]));
			Add(temp2,Union(temp[i],[temp1[i][2]]));
			Print("b\n");
		fi;
	od;
	temp2:=Set(temp2);
	temp3:=List(temp2,g->1/4.*(pos[g[1]]+pos[g[2]]+pos[g[3]]+pos[g[4]]));
	for i in [1..Length(temp2)] do
		for j in [i+1..Length(temp2)] do
			if i<>j and Length(Intersection(temp2[i],temp2[j]))=3 then 
				Add(temp4,[i,j]);
			fi;	
		od;
	od;
	return [surf,temp2,temp3,Set(temp4)];
end;

DrawGraphOfMultitetraederToJavascript:=function(S,file)
	local inp,temp,templine;
	inp:=InputTextFile("print3dbegin");
	out:=OutputTextFile(file,true);
	SetPrintFormattingStatus(out,false);
	AppendTo(out,ReadAll(inp));
	CloseStream(inp);
	#CloseStream(out);
	temp:=Multigraph(S);
	AppendTo(out,"\n");
###########################
#### draw vertices and edges
	drawvertices(temp[3],out);
	AppendTo(out,"\n");
	drawedges(temp[3],temp[4],out);
	AppendTo(out,"\n");
#############################
	inp:=InputTextFile("print3dend");
	#out:=OutputTextFile(file,true)
	#SetPrintFormattingStatus(out,false);
	AppendTo(out,ReadAll(inp));
	CloseStream(inp);
	CloseStream(out);


end;
#Multigraph:=function(S)
#	local g,v,co,surf,l1,l2,l3,pos,temp,vof;
#	co:=CoorMul(S);
#	surf:=co[1];
#	pos:=co[2];
#	temp:=[];
#	for voe in VerticesOfEdges(surf) do
#		tempvert:=Filtered(Vertices(surf),g->		
#		Length(Set(
#		[Sqrt((pos[voe[1]][1]-pos[g][1])^2+(pos[voe[1]][2]-pos[g][2])^2+(#pos[voe[1]][3]-pos[g][3])^2),
#		Sqrt((pos[voe[2]][1]-pos[g][1])^2+(pos[voe[2]][2]-pos[g][2])^2+(#pos[voe[2]][3]-pos[g][3])^2)]))=1);
##	for vert in tempvert do
#		Print(voe," ",temp,"\n");
#		vof:=Union(voe,[vert]);	
#		Print(vof,"\n");	
#		v:=Filtered(Vertices(surf),g->		
#		Length(Set(
#		[Sqrt((pos[vof[1]][1]-pos[g][1])^2+(pos[vof[1]][2]-pos[g][2])^2+(#pos[vof[1]][3]-pos[g][3])^2),
#		Sqrt((pos[vof[2]][1]-pos[g][1])^2+(pos[vof[2]][2]-pos[g][2])^2+(#pos[vof[2]][3]-pos[g][3])^2),
#		Sqrt((pos[vof[3]][1]-pos[g][1])^2+(pos[vof[3]][2]-pos[g][2])^2+(#pos[vof[3]][3]-pos[g][3])^2)]))=1);
#		Print(v,"\n");
#		if Length(v)=2 then 
#			Add(temp,Union(vof,[v[1]]));
#			Add(temp,Union(vof,[v[2]]));
#		else
#			Add(temp,Union(vof,v));
#		fi;
#	od;
#
#	od;	
#	return Set(temp);
#end;
