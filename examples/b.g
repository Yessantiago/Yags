
orden:= function()
    local A, B, x, C;

    C:=[];
    A:=[ 5, 7, 4, 6, 2, 9, 8, 3, 1, 10 ];
    B:=[2,4,6,7,10];
    #¿como encuentro las posiciones?

    for x in B do
        Add(C, Position(A,x));
    od;

    Print("Posiciones de elemento de B en A:: ",C,"\n");
    SortParallel(C,B);

    Print("Lista ordenada B de acuerdo a A:: ",B,"\n");
end;


