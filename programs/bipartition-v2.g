L:=[[1,6],[6,7],[7,8],[8,5],[5,6],[5,2],[1,2],[2,3],[3,4],[4,5],
    [9,14],[14,13],[13,12],[12,11],[11,10],[10,9]]; 
g:=GraphByEdges(L); 

Bicoloration:= function(g)
    local coloration, colored,color,x,y; 
    coloration:=[];
    colored:=[]; 
    color := 1;

    colored:= List(ConnectedComponents(g), z->z[1]);
    coloration{colored}:= List(colored, z->color);

    for x in colored do
       color:= 3-coloration[x];
        for y in Adjacency(g,x) do
            if (IsBound(coloration [y])) then #Revisa si ya está coloreado en la pos y
                if coloration[y] <> color then
                    return fail;
                fi;               
            else #si está vacio el espacio, colorea
                coloration[y]:=color; 
                Add(colored,y);   
            fi; 
        od; 
    od;

    return coloration; 
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
