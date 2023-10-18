lista:= [[1,2], [2,3],[3,6], [6,8],[8,7], [7,9],[7,5],[7,4],[4,1],[5,10],[5,2],[5,4],[5,6],[9,4]];
g:=GraphByEdges(lista);
#g:=PathGraph(5);;

chk:=function(L,g)
    local x,y;
    #Print("L::",L,"\n");
    if L=[] then return true; fi;
        x:=Length(L);
        Print("L::",L,"  X:: ",x,"\n");
    for y in [1..x-1] do
        #Print("L en for::",L,"\n");
        if IsEdge(g,[x,y]) and L[x]=L[y] then
            #Print("Return false::",y,"\n");
            return false;
        fi;
    od;

    return true;
end;

Kcoloration:=function(g,k)
    local colors,L; 
    colors:=[1..k]; 
    L:=[];

    if Backtrack(L,colors,chk, Order(g), g) <> fail then 
        Print("L::",L,"\n");
        return true;
    else 
        return false; 
    fi; 

end;
