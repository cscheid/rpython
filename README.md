rpython
=======

A fork of http://cran.r-project.org/web/packages/rPython/index.html to
support non-system python deployments on OS X.

This is needed because (for example) Anaconda's python libraries do
not appear to set linker flags correctly. So we hack around it.

You'll need to install this from source so that the installer finds
the distribution that you currently have installed.

usage
=====

    $ git clone ....
    $ cd rpython
	$ R
	> install.packages(".", repos=NULL, type="source")
