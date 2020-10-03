# redmine report

## Install tools

First you need to install [carton](https://metacpan.org/pod/Carton) : 

    cpanm Carton

After your to install [pp](https://metacpan.org/pod/pp) : 

    cpan install PAR::Packer

## Development

Install dependencies : 

    carton install

To run project : 

~~~bash
carton exec -- perl index.pl \
    --token=<your-redmine-token> \
    --url=<redmine-url> \
    --username=<redmine-username>
~~~

## Build

To build project : 

    sh scripts/build.sh

To run binary file : 

    chmod 777 redmine-report

~~~bash
./redmine-report \
    --token=<your-redmine-token> \
    --url=<redmine-url> \
    --username=<redmine-username>
~~~

**NB** : currently open commands run `open <url>`, it works on MacOS only.