L:=[[1,6],[6,7],[7,8],[8,5],[5,6],[5,2],[1,2],[2,3],[3,4],[4,5],
      [9,14],[14,13],[13,12],[12,11],[11,10],[10,9]]; 

g:=GraphByEdges(L);

Bicoloration:=function(g) 
   local color,coloring,Level0,Level1,Level2;
   coloring:=[];
   color := 1; 

   Level0:= List(ConnectedComponents(g), z -> z[1]);
   coloring{Level0} := List(Level0, z->color); 
   Level1:= Union(Adjacencies(g){Level0});
 
   while Level1 <> [] do 
      color := 3 -color;
      Level2:= Difference(Union(Adjacencies(g){Level1}),Level0);

      if (Intersection(Level1,Level2)<>[]) then 
         return fail; 
      fi; 

      coloring{Level1} := List(Level1, z->color);
      Level0:=Level1; 
      Level1:= Level2; 
   od; 

   return coloring;
end;

Bipartition := function(g)
   local colo;
   colo:=Bicoloration(g);

   if colo <> fail then 
      return [Positions(colo,1),Positions(colo,2)];
   else 
      return fail;
   fi; 
end;

IsBipartite:= function(g)
   local answer;
   answer:=Bicoloration(g);

   if answer <> fail then 
      return true;
   else 
      return false;
   fi; 
end;

