#First version, use set operations and levels
Bicoloration0:=function(g) 
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


#Last version, T(n,m) = O(n+m) 
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


Comparison:= function(g)
    local ini, fin, t1,t2; 

    ini:= NanosecondsSinceEpoch();
    Bicoloration(g);
    fin:=NanosecondsSinceEpoch(); 

    t1 := fin-ini; 

    Print("  Bicoloration: ",t1," ns\n");

    ini:= NanosecondsSinceEpoch();
    Bicoloration0(g);
    fin:=NanosecondsSinceEpoch(); 

    t2 := fin-ini;  
    Print("Bicoloration-0: ",t2," ns\n\n");

    if t1 < t2 then
        Print("  Bicoloration tarda menos tiempo que Bicoloration-0\n");
    elif t1 > t2 then
        Print("  Bicoloration-0 tarda menos tiempo que Bicoloration\n");

    else
        Print("  Tardan el mismo tiempo\n");
    fi;

end; 
#g:=CompleteBipartiteGraph(500,500);