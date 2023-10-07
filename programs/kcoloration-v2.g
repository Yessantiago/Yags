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
    local L, Adj, ListMaxDegree, I,x, y, mayor,C,tamIn;
    ListMaxDegree:=[]; 
    L:=[];
    I:= []; 
    C:=[]; 
    
    Adj:= Adjacencies(g);

    ListMaxDegree:= VertexMaxDegree(g); #Se ordena los vertices por grados
    Add(L,ListMaxDegree[1]); #Agrega el de mayor grado a la lista L 
    Adj[Last(L)] := []; #Se remueve los adyacentes del vertice que se agrega a L
    
    while Length(L) <> Length(Vertices(g)) do
        
        mayor:= 0; #variable para definir que vertice o vertices tienen el mayor grado  
        for x in Adj do 
            tamIn:= Length(Intersection(L,x)); #Revisa la cantidad de vecinos que hay L           
            if tamIn >= mayor then #Valida si el numero de vecinos es mayor o igual respecto al actual 
                if (tamIn > mayor)then #Si es mayor, se reinician las listas y el mayor es el tam. de la interseccion encontrada
                    I:=[];
                    C:=[];
                    mayor:=tamIn;
                fi;
                Add(I,Position(Adj,x)); #Agrega a I la posicion del vertice con mayores vecinos
            fi;
        od;
        Print("I:: ",I,"\n");
        if Length(I)>0 then #Valida si hay elementos en I
            if Length(I)>1 then #Si hay mas de un elemento, se ordenan
                C:= List(I, x -> Position(ListMaxDegree,x)); #Se toman las posiciones de los elementos de I dada por sus grados 
                SortParallel(C,I); #Ordena I respecto a C
            fi;
            Add(L, I[1]); #Agrega el mayor a L
        fi;

        Adj[Last(L)] := []; #Se limpian las listas
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
