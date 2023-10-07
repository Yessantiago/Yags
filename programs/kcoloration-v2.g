lista:= [[1,2], [2,3],[3,6], [6,8],[8,7], [7,9],[7,5],[7,4],[4,1],[5,10],[5,2],[5,4],[5,6],[9,4]];
g:=GraphByEdges(lista);

#Devuelve una lista ordenada de mayor grado a menor grado de una grafica
VertexMaxDegree := function(g) 
    local ListOrd,V; 
    V:= Vertices(g);

    ListOrd := List(V, x -> VertexDegree(g,x));
    SortParallel(ListOrd,V); 
    ListOrd:= Reversed(V);
    
    return ListOrd;
end; 


FirstOrder:= function(g)
    local L, Adj, ListMaxDegree, I,x, y, mayor,C,B;
    C:=[]; 
    B:=[];
    L:=[];
    ListMaxDegree:=[]; 
    I:= []; 
    #Lista de adyecentes de la grafica
    Adj:= Adjacencies(g);

    ListMaxDegree:= VertexMaxDegree(g); #Se ordena una sola vez
    Add(L,ListMaxDegree[1]); #Agrega el de mayor grado a la lista L 
    Adj[Last(L)] := [];
    
    while Length(L) <> Length(Vertices(g)) do
        for x in Adj do #x es la sublista de los adyacentes
            Add(I, Length(Intersection(L,x)));
        od;

        mayor:= 0;  
        for y in I do 
            if mayor < y then 
                mayor:= y; 
            fi; 
        od;
    
        #Si mayor <> 0 entonces encontrar sus posiciones en L 
        B:= Positions(I, mayor);        
        if mayor <> 0 and Length(B)>0 then 
            if Length(B)>1 then
                for x in B do
                    Add(C, Position(ListMaxDegree,x));
                od;
                SortParallel(C,B);
            fi; 

            Add(L, B[1]);
        fi;
        Adj[Last(L)] := [];
        C:=[];
        I:=[];
    od;

    return L; 

end;


Opts:= function(L, Extra) 

end;

Chk:= function(Extra)

end;

Kcoloration:=function(g,k)
    local colors,v, L, Extra; 
    colors:=[1..k]; 

    L:=FirstOrder(g);
    Print(L,"\n");
    Extra:=[g,FirstOrder(g), colors];
    Backtrack(L,Opts,Chk,Order(g),Extra);
    
end;
