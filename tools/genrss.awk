#!/usr/bin/gawk

BEGIN {
    print "<?xml version='1.0' encoding='UTF-8' ?> \
           <rss version='2.0' xmlns:atom='http://www.w3.org/2005/Atom'> \
           <channel> \
           <title>Kiky Page RSS</title> \
           <link>https://kikytokamuro.github.io/</link> \
           <description>Kiky Page</description>";
}

{
    match( $0,
        /<a href="(.\/notes\/.*)">(.*)<\/a>.*([0-9]{2}\.[0-9]{2}\.[0-9]{4})$/,
        arr );

    if ( length( arr [1] ) != 0 ) {
        printf "<item> \
    	   <title>%s</title> \
           <link>https://kikytokamuro.github.io/%s</link> \
           <pubDate>%s</pubDate> \
           </item>", arr [2], arr [1], arr [3];
    }
}

END {
    print "</channel> \
           </rss>";
}
