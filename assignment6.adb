With Ada.Text_IO; Use Ada.Text_IO;  
With Ada.Integer_Text_IO; Use Ada.Integer_Text_IO;

-- Expression type and subtypes
-- number
-- boolean
-- string (symbol)
-- application
-- if
-- binop
-- lambda

-- Value type and subtypes
-- number
-- boolean
-- closure

-- Environment type mapping a [name : string] to a [val : Value]

-- Reads an array from stdin, parses, interprets, and serializes it
procedure TopEval is
begin
  -- read from stdin to get the array, or have standalone tests
  -- with array from stdin, call parse and interp
  put("topeval run");
end TopEval;

-- Parse array to expressions
function Parse (arr) return ExprC is
begin
  -- if it's a number, take it as a number
  if arr'val(0) in Integer then
 	  put("parse int");
  -- it's a string, check all special characters, otherwise take it as an id
  elsif arr'val(0) in string then -- ???
    -- if it's a string "true" or "false", take it as the boolean
    if arr'val(0) = "true" then
      put("parse true");
    elsif arr'val(0) = "false" then
   	  put("parse false");
    -- if it's a reserved word (with, if, func) or symbol (+, -, *, /, eq?, <=)
    if arr'val(0) = "+" then
   	  put("parse +");
    elsif arr'val(0) = "-" then
   	  put("parse -");
    elsif arr'val(0) = "/" then
   	  put("parse /");
    elsif arr'val(0) = "*" then
   	  put("parse *");
    elsif arr'val(0) = "eq?" then
   	  put("parse eq?");
    elsif arr'val(0) = "<=" then
   	  put("parse <=");
    else -- take it as an id
   	  put("parse id");
    end if;
  -- default case error
  else
    -- signal error
    put("parse error");
  end if;
end Parse;

-- Interpret Expressions
function Interp (exprs, env) return Value is
begin
  -- cases with all expression types, evaluating them with the env
  -- if it's a number, take it as a number
  if (exprs'val(0) in Integer) then -- "get" first element, is it an Integer?
  
  -- else, it could be a string boolean, id, if, operation, or function
  elsif (exprs'val(0) in string) then
    -- if it's a string "true" or "false", take it as a boolean
    if (exprs'val(0) = "true") then
      return true;
    elsif (exprs'val(0) = "false") then
      return false;
  
    -- if it's an "if", interp the condition, if true return interp of left side,
    --    else return interp of right 
    elsif (exprs'val(0) = "if") then
      if (Interp(exprs'val(1))) then
        return Interp(exprs'val(1), env);
      else
        return Interp(exprs'val(2), env);
      end if;
    
    -- if it's a binop, return the operation done on interp of left and right
    elsif (exprs'val(0) = "+") then
      return (Interp(exprs'val(1), env) + Interp(exprs'val(2), env));

    elsif (exprs'val(0) = "-") then
      return (Interp(exprs'val(1), env) - Interp(exprs'val(2), env));

    elsif (exprs'val(0) = "/") then
      return (Interp(exprs'val(1), env) / Interp(exprs'val(2), env));

    elsif (exprs'val(0) = "*") then
      return (Interp(exprs'val(1), env) * Interp(exprs'val(2), env));

    elsif (exprs'val(0) = "<=") then
      return (Interp(exprs'val(1), env) <= Interp(exprs'val(2), env));

    elsif (exprs'val(0) = "eq?") then
      return (Interp(exprs'val(1), env) = Interp(exprs'val(2), env));
    
    -- if it's a lambda, return a closure
    elsif (exprs'val(0) = "func") then
      -- return closure type? 
  
    -- if it's any other string, look it up as an id in environment
    -- lookup function

  else 
    -- signal error
  end if;
end Interp;

-- Turn a Value into a string to output
function Serialize (val) return string is
begin
  if val in Integer then
    return val'Image(613); -- somehow this is a conversion of integer to string? http://www.adapower.com/index.php?Command=Class&ClassID=Basics&CID=2
  elsif val in Boolean then
    if val then
      return "true";
    else
      return "false";
    end if;
  elsif val in Value then -- should mean it is closure, because it past Integer and Boolean yet is a correct value
    return "#<procedure>";
  else
    return "error, bad value passed";
  end if;
end Serialize;
