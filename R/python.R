indent <- function(count, ...) {
  result = paste(..., sep=' ')
  paste(paste(rep(' ', times=count), collapse=''), result, sep='')
}

transform <- function(node, block=0, as.stmt=FALSE, envir=NULL)
{
  if (is.null(envir))
    envir <- parent.frame()

  t <- function(...) {
    transform(..., block=block, envir=envir)
  }
  
  if (is.call(node)) {
    if (identical(node[[1]], quote(`.r`))) {
      t(eval(node[[2]], envir))
    } else if (identical(node[[1]], quote(`{`))) {
      stmts <- lapply(node[-1], function(...) t(..., as.stmt=TRUE))
      paste(stmts, collapse='\n')
    } else if (identical(node[[1]], quote(`<-`))) {
      indent(block, t(node[[2]]), "=", t(node[[3]]))
    } else if (identical(node[[1]], quote(`c`))) {
      paste("[", paste(lapply(node[-1], t), collapse=', '), "]", sep='')
    } else if (identical(node[[1]], quote(`$`))) {
      paste(t(node[[2]]), ".", t(node[[3]]), sep='')
    } else if (identical(node[[1]], quote(`for`))) {
      line1 <- indent(block, "for", t(node[[2]]), "in", t(node[[3]]), ":")
      line2 <- t(node[[4]], block=block+1, as.stmt=TRUE)
      paste(line1, line2, sep='\n')
    } else if (identical(node[[1]], quote(`if`)) && length(node) == 3) {
      line1 <- indent(block, "if", t(node[[2]]), ":")
      line2 <- t(node[[3]], block=block+1, as.stmt=TRUE)
      paste(line1, line2, sep='\n')
    } else if (identical(node[[1]], quote(`if`)) && length(node) == 4) {
      paste("(", t(node[[3]]), "if", t(node[[2]]), "else", t(node[[4]]), ')', sep=' ')
    } else { # if (is.name(node[[1]])) {
      if (as.stmt) {
        indent(block, t(node[[1]]), "(", paste(lapply(node[-1], t), collapse=', '), ")")
      } else {
        paste("(", t(node[[1]]), "(", paste(lapply(node[-1], t), collapse=', '), "))", sep=' ')
      }
    }
  } else if (is.name(node)) {
    as.character(node)
  } else if (is.numeric(node)) {
    if (length(node) == 1) {
      as.character(node)
    } else {
      paste("[", paste(as.character(node), collapse=', '), "]", sep='')
    }
  } else if (is.character(node)) {
    # convenient hack for now
    toJSON(node)
  }
}

