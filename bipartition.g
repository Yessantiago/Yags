#LoadPackage("yags"); Read("bipartition.g");

lista := [[1,2],[2,3], [3,4], [4,9], [9,5],
[5,8],[5,6], [6,2], [6,7], [8,7],[7,1], [10,11],
[11,13],[13,14],[14,15],[15,16], [16,13],[13,12], 
[12,10],[17,18],[18,19]];

listaf := [[1,2],[2,3], [3,4], [4,9], [9,5],
[5,8],[5,6], [6,2], [6,7], [8,7],[7,1], [10,11],
[11,13],[13,14],[14,15],[15,16], [16,13],[13,12], 
[12,10],[17,18],[18,19],[1,6]];

lista2:= [[1,2],[1,3],[1,4],[4,3],[3,2]];


g:=GraphByEdges(lista);

Bicoloration:=function(g) 
   local color,ccr,CurrentVertices,AdjCurrent,NewAdj,coloring, aux;
   color:=[];
   NewAdj:= [];

   ccr:=ConnectedComponents(g);
   CurrentVertices:= List(ccr, z -> z[1]);
   
   #Colorea el primer vertice de cada elemento conexo. 
   color{CurrentVertices} := List(CurrentVertices, z->1); 
   #Print("color = ",color," \n"); 

   #Se crea lista nueva con los adyacentes
   AdjCurrent:= Concatenation(Adjacencies(g){CurrentVertices});

   #Print("CurrentVertices = ", CurrentVertices,"\n"); 
   #Print("AdjCurrent = ",AdjCurrent,"\n\n");
   
   coloring := 1; #Color actual 

   #Print("Entra a While \n"); 

   while AdjCurrent <> [] do #Mientras AdjCurrent no este vacía
      coloring := 3 -coloring;
      Print("coloreando color: ", coloring,"\n\n"); 
      
      NewAdj:= Concatenation(Adjacencies(g){AdjCurrent});

      #Interseccion de CurrentVertices y Adj para validar 
      if (Intersection(AdjCurrent,NewAdj)<>[]) then
         #Print("fail \n"); 
         return fail; 
      fi; 
#      Print("Antes de actualizar variables \n");
#      Print("CurrentVertices = ", CurrentVertices,"\n"); 
#      Print("AdjCurrent = ",AdjCurrent,"\n");
#      Print("NewAdj = ",NewAdj,"\n\n");
      
      #Coloreando adyacentes actuales
      color{AdjCurrent} := List(AdjCurrent, z->coloring);
   
#      Print("colorea AdjCurrent= ",color,"\n\n");       
#      Print("Variables actualizadas \n");

      #Actualizar variables
      aux:=AdjCurrent; 
      AdjCurrent:= Difference(NewAdj,CurrentVertices); 
      CurrentVertices:=aux;
      
      
#     Print("CurrentVertices = ", CurrentVertices,"\n"); 
#     Print("AdjCurrent = ",AdjCurrent,"\n");
#      Print("Fin del ciclo\n\n");
   od; 
end;

Bicoloration:=function(g) 
   local color,coloring,Level0,Level1,Level2;
   
   coloring:=[];
   color := 1; #Color actual 
   Level0:=ConnectedComponents(g);
   Level0:= List(Level0, z -> z[1]);
   
   #Colorea el primer vertice de cada componente conexa.   
   coloring{Level0} := List(Level0, z->color); 
   #Se crea lista nueva con los adyacentes
   Level1:= Union(Adjacencies(g){Level0});
 
   while Level1 <> [] do 
      color := 3 -color;
      Level2:= Difference(Union(Adjacencies(g){Level1}),Level0);
      Print(Level0,"\n");
      Print(Level1,"\n");
      Print(Level2,"\n");
      #Interseccion de Level0 y Adj para validar 
      if (Intersection(Level1,Level2)<>[]) then 
         return fail; 
      fi; 
      #Coloreando adyacentes actuales
      coloring{Level1} := List(Level1, z->color);
      Print(coloring,"***\n");
      #Actualizar variables
      Level0:=Level1; 
      Level1:= Level2; 
   od; 

   return coloring;
end;

#Bicoloration(g);


Bipartition := function(g)
    local colo;
    colo:=Bicoloration(g);
    return [Positions(colo,1),Positions(colo,2)];
end;


