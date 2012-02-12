# Firebrand

Firebrand is a demo application for Magpie using EmberJS + EmberREST. It started out as an experiment to see if Magpie could easily handle the REST requirements something like EmberJS required. The answer was yes. It however turned out that it made a sufficiently good demo application to explain the concepts behind Magpie to Matt S. Trout. Based on his feedback the application was revised a bit to better illustrate the principles involved.

There may still be a few bugs in this, but considering we were trying to translate
from Rails to Magpie that's probably expected.

Finally all of the EmberJS/EmberREST code is stolen/based upon [this series of blog posts][1].

## Getting Started

Firebrand is a Dist::Zilla managed application. You'll need to have Dist::Zilla installed to get it up and running. We'll also assume you have `cpanm` installed. If both of those are ready to go simply do the following:

    git clone git://github.com/Tamarou/Firebrand.git
    cd Firebrand
    dzil authordeps | cpanm 
    cpanm http://xrl.us/magpie1120430 # install magpie
    dzil listdeps | cpanm # install everything else 


Once everything is installed simply run `plackup` to start the server.

    plackup

You should have a working application on port 5000 (or whatever your plackup defaulted to).


## Getting Help

You're more than welcome to the `#magpie` channel on `irc.perl.org` and ask questions. 

[1]: http://www.cerebris.com/blog/2012/01/24/beginning-ember-js-on-rails-part-1/
