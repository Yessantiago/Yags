#lista:=[[1,2],[2,3],[3,4],[4,1],[4,2]];
# lista := [[1,2],[2,3], [3,4], [4,9], [9,5],
# [5,8],[5,6], [6,2], [6,7], [8,7],[7,1], [10,11],
# [11,13],[13,14],[14,15],[15,16], [16,13],[13,12], 
# [12,10],[17,18],[18,19]];


lista:= [[1,2], [2,3],[3,6], [6,8],[8,7], [7,9],[7,5],[7,4],[4,1],[5,10],[5,2],[5,4],[5,6],[9,4]];
g:=GraphByEdges(lista);

#Devuelve el elemento de mayor grado de una lista de una grafica 
VertexMaxDegree := function(g,V) #Cambiar de darle una función g a una lista 
    local ListMaj; 

    ListMaj := List(V, x -> VertexDegree(g,x));
    SortParallel(ListMaj,V); 

    return Last(V);
end; 


FirstOrder:= function(g)
    local V, L, CurrentV, sigMayorG;
    V:= Vertices(g); 
    L:=[];
    
    Add(L,VertexMaxDegree(g, V)); #Agrega el de mayor grado a la lista L 
    Remove(V, Position(V,Last(L))); #Quita el elemento de V que se agrego a L 
    
    while V <> [] do
        CurrentV:= Adjacency(g,Last(L)); #Adyacentes del Vertice actual 
        CurrentV:= Difference(CurrentV, L); #Quita la diferencia
        
        #Si los adyacentes del ultimo elemento en L ya están en L 
        #entonces se toma el último vertice con mayor grado, i.e. 
        #ultimo elemento en V
        if CurrentV = [] then 
            sigMayorG := Last(V);
        else  #Sino, se obtiene el vertice de mayor grado de los
              # adyacentes del último agregado a L 
            sigMayorG := VertexMaxDegree(g, CurrentV);
        fi;         
        
        Add(L,sigMayorG); #Agrega el de mayor grado a la lista L
        Remove(V, Position(V,Last(L))); #Quita el vertice que se acaba de agregar a L 
    od; 

    return L; 
end;

Opts:= function(L, Extra) 

end;

Kcoloration:=function(g,k)
    local colors,v, L, Extra; 
    colors:=[1..k]; 

    L:=FirstOrder(g);
    Print(L,"\n");
    Extra:=[g,FirstOrder(g), colors];
    Backtrack(L,Opts,Chk,Order(g),Extra);
    
end;
