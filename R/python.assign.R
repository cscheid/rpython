#########################################################
# CGB, 20100707, created
#########################################################

python.assign <- function( var.name, value ){

    value <- toJSON( value )

    # Creating the call

    python.command <- c( 
        paste( var.name , "='", value, "'",  sep = " " ),
        paste( var.name , "= json.loads(", var.name, ")", sep = "" )
    )

    python.command <- paste( python.command, collapse = "\n" )

    python.exec( python.command )
    invisible( NULL )
}

