#Ejemplo: supongamos que queremos encontrar todos los recorridos en un ciclo de 5 vértices 
#que comienzan en el vértice 1 y terminan en el vértice 2 con una longitud de hasta 4 (como máximo 5 vértices). 
#Luego, podemos proceder de la siguiente manera:

g:=CycleGraph(5);

opts:=function(L,g)
    if L=[] then
        return [1];

    else
        return Adjacency(g,L[Length(L)]);

    fi;
end;

chk:=function(L,g) 
    return Length(L)<= 5; #tam maximo
end;

done:=function(L,g) 
    return L[Length(L)]=2; #marca el fin
end;

main:= function(g)
    
    Print("Ejemplo: \n");
    Print(BacktrackBag(opts,chk,done,g));
end;