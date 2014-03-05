python.eval <- function(python.code)
{
  c <- substitute(python.code)
  cmd <- transform(substitute(`_r_return` <- json$dumps(c), list(c=c)), envir=parent.frame())
  python.exec.string(cmd)

  ret <- .C( "py_get_var", "_r_return", not.found.var = integer(1), resultado = character(1), PACKAGE = "rPython" )

  if( ret$not.found.var )
    stop( "Variable not found" )
        
  fromJSON( ret$resultado )
  
}
