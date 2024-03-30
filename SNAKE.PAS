PROGRAM SNAKE;

USES CRT, SysUtils;

CONST
    // Keyboard codes
    KeyESQ      = 27;
    KeyUP       = 72;
    KeyRight    = 77;
    KeyDown     = 80;
    KeyLeft     = 75;
    KeyPlus     = 43;
    KeyMinus    = 45;

    // Drawing border
    Horizontal  = '-';
    Vertical    = '|';
    Corner      = '+';

    // Drawing snake
    SnakeChar   = '#';
    EraseChar   = ' ';
    FoodChar    = 'o';

TYPE
    TDirection = (Up, Down, Left, Right);
    TSnake = RECORD
        body:   ARRAY[0..1999, 0..1] OF Integer;
        n:      Integer;
        size:   Integer;
        x, y:   Integer;
        dir:    TDirection;
    END;

PROCEDURE DrawBorder();
VAR
    i: Integer;
BEGIN
    // Horizontal lines
    FOR i := 2 TO WindMaxX - 1 DO
    BEGIN
        crt.gotoxy(i, 1);
        write(Horizontal);
        crt.gotoxy(i, WindMaxY - 1);
        write(Horizontal);
    END;

    // Top corners
    crt.gotoxy(1, 1);
    write(Corner);
    crt.gotoxy(WindMaxX, 1);
    write(Corner);

    // Vertical lines
    FOR i := 2 TO WindMaxY - 2 DO
    BEGIN
        crt.gotoxy(1, i);
        write(Vertical);
        crt.gotoxy(WindMaxX, i);
        write(Vertical);
    END;

    // Bottom corners
    crt.gotoxy(1, WindMaxY - 1);
    write(Corner);
    crt.gotoxy(WindMaxX, WindMaxY - 1);
    write(Corner);
END;

PROCEDURE UpdateSnake(VAR s: TSnake);
VAR
    i: Integer;
BEGIN
    FOR i := 0 TO s.size - 1 DO
    BEGIN
        crt.gotoxy(s.body[i, 0], s.body[i, 1]);
        write(EraseChar);
    END;

    s.body[s.n, 0] := s.x;
    s.body[s.n, 1] := s.y;
    s.n := s.n + 1;
    
    IF s.n = s.size THEN
    BEGIN
        s.n := 0;
    END;

    FOR i := 0 TO s.size - 1 DO
    BEGIN
        crt.gotoxy(s.body[i, 0], s.body[i, 1]);
        write(SnakeChar);
    END;
END;

PROCEDURE CheckFood(VAR s: TSnake; VAR fx: Integer; VAR fy: Integer);
VAR
    BadFood:    Boolean;
    i:          Integer;
BEGIN
    IF (s.x = fx) AND (s.y = fy) THEN
    BEGIN
        BadFood := True;
        WHILE BadFood DO
        BEGIN
            BadFood := False;
            fx := Random(WindMaxX - 4) + 2;
            fy := Random(WindMaxY - 4) + 2;

            FOR i := 1 TO s.size - 1 DO
            BEGIN
                IF (s.body[i, 0] = fx) AND (s.body[i, 1] = fy) THEN BadFood := True;
            END;
        END;

        s.size := s.size + 1;
        
        gotoxy(fx, fy);
        write(FoodChar);
    END;
END;

PROCEDURE GameOver(VAR s: TSnake);
BEGIN
    crt.gotoxy((WindMaxX DIV 2) - 5, WindMaxY DIV 2);
    write('GAME OVER!');
    crt.gotoxy((WindMaxX DIV 2) - 5, (WindMaxY DIV 2) + 1);
    write('SCORE: ', s.size);
    crt.gotoxy(1, WindMaxY);
    halt(0);
END;

PROCEDURE CheckCollision(VAR s: TSnake);
VAR
    i: Integer;
BEGIN
    IF (s.x >= WindMaxX) OR (s.x <= 1) OR (s.y >= WindMaxY - 1) OR (s.y <= 1) THEN GameOver(s);
    FOR i := 1 TO s.size - 1 DO
    BEGIN
        IF (s.body[i, 0] = s.x) AND (s.body[i, 1] = s.y) THEN GameOver(s);
    END;
END;

PROCEDURE CheckKeyboard(VAR s: TSnake; VAR rd: Integer);
VAR
    key:    Char;
    i:      Integer;
BEGIN
    FOR i := 0 TO 1 DO
    BEGIN
        IF crt.keypressed THEN
        BEGIN
            key := crt.readkey;
            IF key = chr(KeyESQ) THEN GameOver(S);
            IF (key = chr(KeyUP)) AND (S.dir <> Down) THEN S.dir := Up;
            IF (key = chr(KeyDown)) AND (S.dir <> Up) THEN S.dir := Down;
            IF (key = chr(KeyRight)) AND (S.dir <> Left) THEN S.dir := Right;
            IF (key = chr(KeyLeft)) AND (S.dir <> Right) THEN S.dir := Left;
            IF (key = chr(KeyPlus)) AND (rd > 20) THEN rd := rd - 10;
            IF (key = chr(KeyMinus)) AND (rd < 100) THEN rd := rd + 10;
        END;
    END;
END;

VAR
    S:              TSnake;
    FoodX, FoodY:   Integer;
    RefreshDelay:   Integer;

BEGIN
    Randomize();
    crt.clrscr();
    
    S.n := 1;
    S.size := 2;
    S.x := 10;
    S.y := 12;
    S.dir := Right;

    FoodX := 30;
    FoodY := 15;

    RefreshDelay := 70;

    DrawBorder();

    crt.gotoxy(FoodX, FoodY);
    write(FoodChar);

    crt.gotoxy(S.x, S.y);

    WHILE True DO
    BEGIN
        CheckCollision(S);
        UpdateSnake(S);
        CheckFood(S, FoodX, FoodY);
        CheckKeyboard(S, RefreshDelay);

        IF S.dir = Up THEN S.y := S.y - 1;
        IF S.dir = Down THEN S.y := S.y + 1;
        IF S.dir = Left THEN S.x := S.x - 1;
        IF S.dir = Right THEN S.x := S.x + 1;

        IF (S.dir = Up) OR (S.dir = Down) THEN
            delay(RefreshDelay + 20)
        ELSE
            delay(RefreshDelay)
    END;
END.
